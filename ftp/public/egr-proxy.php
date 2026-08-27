<?php
/**
 * API прокси для получения данных из ЕГР Беларуси
 * Обход CORS при обращении к https://egr.gov.by/api/v2/egr/
 * Делает несколько запросов к API ЕГР и возвращает полный набор данных
 */

header('Content-Type: application/json; charset=utf-8');

// Получаем параметры запроса
$unp = isset($_REQUEST['unp']) ? trim($_REQUEST['unp']) : '';
$type = isset($_REQUEST['type']) ? trim($_REQUEST['type']) : 'org'; // org, ip

// Валидация УНП (должен быть 9 цифр)
if (!preg_match('/^\d{9}$/', $unp)) {
    echo json_encode([
        'result' => 'error',
        'message' => 'Wrong parameters (1)'
        //'message' => 'Некорректный УНП. Должен содержать 9 цифр.'
    ]);
    exit;
}

// Валидация типа регистранта
if (!in_array($type, ['org', 'ip'])) {
    echo json_encode([
        'result' => 'error',
        'message' => 'Wrong parameters (2)'
        //'message' => 'Некорректный тип регистранта. Допустимые значения: org, ip.'
    ]);
    exit;
}

/**
 * Запись ошибки в лог-файл
 * @param string $message Сообщение об ошибке
 * @param array $context Дополнительный контекст (опционально)
 */
function logError($message, $context = []) {
    $logFile = __DIR__ . '/egr.log';
    $timestamp = date('Y-m-d H:i:s');
    $contextStr = !empty($context) ? ' | ' . json_encode($context, JSON_UNESCAPED_UNICODE) : '';
    $logMessage = "[{$timestamp}] {$message}{$contextStr}" . PHP_EOL;
    file_put_contents($logFile, $logMessage, FILE_APPEND);
}

/**
 * Выполнение запроса к API ЕГР
 * @param string $apiUrl URL API
 * @return array|null Данные ответа или null при ошибке
 */
function fetchEGRData($apiUrl) {
    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL => $apiUrl,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 10,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_HTTPHEADER => [
            'Accept: application/json',
            'Content-Type: application/json'
        ]
    ]);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);
    curl_close($ch);

    // Проверяем ошибки cURL
    if ($curlError) {
        $errorMsg = 'Ошибка соединения с ЕГР: ' . $curlError;
        logError($errorMsg, ['url' => $apiUrl]);
        return ['error' => $errorMsg];
    }

    // 204 No Content - данные не найдены
    if ($httpCode === 204) {
        return ['error' => 'not_found'];
    }

    // Другие HTTP ошибки
    if ($httpCode !== 200) {
        $errorMsg = 'ЕГР вернул ошибку. HTTP код: ' . $httpCode;
        logError($errorMsg, ['url' => $apiUrl, 'response' => substr($response, 0, 500)]);
        return ['error' => $errorMsg];
    }

    // Декодируем JSON
    $data = json_decode($response, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        $errorMsg = 'Ошибка декодирования ответа ЕГР: ' . json_last_error_msg();
        logError($errorMsg, ['url' => $apiUrl, 'response' => substr($response, 0, 500)]);
        return ['error' => 'Ошибка декодирования ответа ЕГР'];
    }

    if (!is_array($data) || empty($data)) {
        return ['error' => 'Данные не найдены'];
    }

    return $data;
}

/**
 * Поиск активной записи в массиве данных ЕГР
 * @param array $data Массив записей
 * @return array|null Активная запись или первая запись, если активной нет
 */
function findActiveRecord($data) {
    // Ищем активную запись (cact = '+')
    foreach ($data as $item) {
        if (isset($item['cact']) && $item['cact'] === '+') {
            return $item;
        }
    }
    // Если активной записи нет, берём первую
    return $data[0] ?? null;
}

// Шаг 1: Получаем базовую информацию (статус + регистрационные данные)
$baseInfoApiUrl = 'https://egr.gov.by/api/v2/egr/getBaseInfoByRegNum/' . $unp;
$baseInfoData = fetchEGRData($baseInfoApiUrl);

// Проверяем ошибки запроса
if (isset($baseInfoData['error'])) {
    if ($baseInfoData['error'] === 'not_found') {
        echo json_encode([
            'result' => 'error',
            'errorType' => 'not_found',
            'message' => 'Такой УНП отсутствует в ЕГР'
        ]);
    } else {
        echo json_encode([
            'result' => 'error',
            'message' => $baseInfoData['error']
        ]);
    }
    exit;
}

// Находим активную запись
$baseInfoRecord = findActiveRecord($baseInfoData);

if (!$baseInfoRecord) {
    echo json_encode([
        'result' => 'error',
        'message' => 'Активная запись не найдена'
    ]);
    exit;
}

// Проверяем статус (ТОЛЬКО getBaseInfoByRegNum содержит nsi00219->vnsostk)
$status = $baseInfoRecord['nsi00219']['vnsostk'] ?? '';
if ($status !== 'Действующий') {
    echo json_encode([
        'result' => 'error',
        'errorType' => 'inactive',
        'message' => 'Лицо с таким УНП не является действующим'
    ]);
    exit;
}

// Извлекаем регистрационные данные
$dfrom = $baseInfoRecord['dfrom'] ?? '';
$regDate = '';
if ($dfrom) {
    try {
        $dateObj = new DateTime($dfrom);
        $regDate = $dateObj->format('d.m.Y');
    } catch (Exception $e) {
        $regDate = '';
    }
}

$regInfo = [
    'ngrn' => $baseInfoRecord['ngrn'] ?? '',                   // Номер в ЕГР
    'dfrom' => $regDate,                                       // Дата регистрации (dd.mm.yyyy)
    'vnuzp' => $baseInfoRecord['nsi00212CRT']['vnuzp'] ?? ''   // Орган регистрации
];

// Шаг 2: Получаем название/ФИО
if ($type === 'ip') {
    $nameApiUrl = 'https://egr.gov.by/api/v2/egr/getIPFIOByRegNum/' . $unp;
} else {
    $nameApiUrl = 'https://egr.gov.by/api/v2/egr/getJurNamesByRegNum/' . $unp;
}

$nameData = fetchEGRData($nameApiUrl);

// Если не удалось получить название/ФИО - не критично, продолжаем
$nameRecord = null;
if (!isset($nameData['error'])) {
    $nameRecord = findActiveRecord($nameData);
}

// Шаг 3: Получаем юридический адрес (только для организаций)
$addressRecord = null;
if ($type === 'org') {
    $addressApiUrl = 'https://egr.gov.by/api/v2/egr/getAddressByRegNum/' . $unp;
    $addressData = fetchEGRData($addressApiUrl);
    
    if (!isset($addressData['error'])) {
        $addressRecord = findActiveRecord($addressData);
    }
}

// Формируем итоговый ответ в зависимости от типа
if ($type === 'ip') {
    // Для ИП - возвращаем ФИО + регистрационные данные
    echo json_encode([
        'result' => 'success',
        'type' => 'ip',
        'data' => array_merge([
            'vfio' => $nameRecord['vfio'] ?? ''   // ФИО предпринимателя
        ], $regInfo)
    ]);
} else {
    // Для юр.лиц - возвращаем наименования + адрес + регистрационные данные
    $orgData = [
        'vn' => $nameRecord['vn'] ?? '',       // Краткое наименование
        'vnaim' => $nameRecord['vnaim'] ?? '', // Полное наименование
        'vfn' => $nameRecord['vfn'] ?? ''      // Фирменное наименование
    ];
    
    // Добавляем адресные данные
    if ($addressRecord) {
        $orgData['vnstranp'] = $addressRecord['nsi00201']['vnstranp'] ?? '';        // Страна
        $orgData['vregion'] = $addressRecord['vregion'] ?? '';                      // Область (опционально)
        $orgData['vdistrict'] = $addressRecord['vdistrict'] ?? '';                  // Район (опционально)
        $orgData['vntnpk'] = $addressRecord['nsi00239']['vntnpk'] ?? '';            // Тип нас. пункта
        $orgData['vnp'] = $addressRecord['vnp'] ?? '';                              // Населенный пункт
        $orgData['vntulk'] = $addressRecord['nsi00226']['vntulk'] ?? '';            // Тип улицы
        $orgData['vulitsa'] = $addressRecord['vulitsa'] ?? '';                      // Улица
        $orgData['vdom'] = $addressRecord['vdom'] ?? '';                            // Дом
        $orgData['vntpomk'] = $addressRecord['nsi00227']['vntpomk'] ?? '';          // Тип помещения
        $orgData['vpom'] = $addressRecord['vpom'] ?? '';                            // Помещение
    }
    
    echo json_encode([
        'result' => 'success',
        'type' => 'org',
        'data' => array_merge($orgData, $regInfo)
    ]);
}
