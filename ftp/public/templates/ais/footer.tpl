
                </div><!-- /.main-content -->
                {if !$inShoppingCart && $secondarySidebar->hasChildren()}
                    <div class="col-md-3 pull-md-left sidebar sidebar-secondary">
                        {include file="$template/includes/sidebar.tpl" sidebar=$secondarySidebar}
                    </div>
                {/if}
            <div class="clearfix"></div>
        </div>
    </div>
</section>

<section id="footer" class="footer">
    <div class="container">
        <div class="footer__cards">
            <div class="footer__card">
                <img src="/templates/ais/img/partners/logo-applepay.png" alt="ApplePay">
            </div>
            <div class="footer__card">
                <img src="/templates/ais/img/partners/logo-mtbank.png" alt="mtbank">
            </div>
            <div class="footer__card">
                <img src="/templates/ais/img/partners/logo-union.png" alt="union">
            </div>
            <div class="footer__card">
                <img src="/templates/ais/img/partners/logo-visa.png" alt="visa">
            </div>
            <div class="footer__card">
                <img src="/templates/ais/img/partners/logo-mastercard.png" alt="mastercard">
            </div>
            <div class="footer__card">
                <img src="/templates/ais/img/partners/logo-mastercard-securecode.png" alt="mastercard">
            </div>
            <div class="footer__card">
                <img src="/templates/ais/img/partners/logo-belkart.png" alt="belkart">
            </div>
            <div class="footer__card">
                <img src="/templates/ais/img/partners/logo-raschet.png" alt="raschet">
            </div>
            <div class="footer__card">
                <img src="/templates/ais/img/partners/logo-bePaid.png" alt="bePaid">
            </div>
        </div>
        <ul class="footer__bottomMenu">
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/">{$LANG.footermenuhome}</a>
            </li>
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/domains/">{$LANG.footermenudomainreg}</a>
            </li>
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/tariffs/hosting/">{$LANG.footermenuhostingsites}</a>
            </li>
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/tariffs/virtual-server/">{$LANG.footermenuvirtualservers}</a>
            </li>
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/tariffs/dedicated-server/">{$LANG.footermenudedicatedservers}</a>
            </li>
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/site-constructor/">{$LANG.footermenuwebsitebuilder}</a>
            </li>
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/about/news/">{$LANG.footermenunews}</a>
            </li>
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/about/faq/">{$LANG.footermenufaq}</a>
            </li>
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/about/contacts/">{$LANG.footermenucontacts}</a>
            </li>
            <li class="footer__bottomMenu__item">
                <a href="https://www.hostfly.by/about/who-are-we/">{$LANG.footermenuabout}</a>
            </li>
        </ul>
        <div class="social">
            <div class="social__item">
                <a href="https://vk.com/hostfly_by" target="_blank" class="social__link">
                    <i class="fab fa-vk"></i>
                </a>
            </div>
            <div class="social__item">
                <a href="https://www.facebook.com/hostfly.by" target="_blank" class="social__link">
                    <i class="fab fa-facebook-f"></i>
                </a>
            </div>
            <div class="social__item">
                <a href="https://www.instagram.com/hostfly.by" target="_blank" class="social__link">
                    <i class="fab fa-instagram"></i>
                </a>
            </div>
            <div class="social__item">
                <a href="https://ok.ru/group/54715347370078" target="_blank" class="social__link">
                    <i class="fab fa-odnoklassniki"></i>
                </a>
            </div>
            <div class="social__item">
                <a href="https://twitter.com/hostfly_by" target="_blank" class="social__link">
                    <i class="fab fa-twitter"></i>
                </a>
            </div>
            <div class="social__item social__item--reviews">
                <a href="https://ru.hostings.info/hostfly-by.html" target="_blank" class="social__link">
                    <img src="/templates/ais/img/review.png" alt="Icon">
                </a>
            </div>
        </div>
        <p class="footer__copyright">
            © {date('Y')} {$LANG.footercopyright}
        </p>
    </div>
</section>

<div class="modal system-modal fade" id="modalAjax" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content panel panel-primary">
            <div class="modal-header panel-heading">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">&times;</span>
                    <span class="sr-only">Close</span>
                </button>
                <h4 class="modal-title">Title</h4>
            </div>
            <div class="modal-body panel-body">
                Loading...
            </div>
            <div class="modal-footer panel-footer">
                <div class="pull-left loader">
                    <i class="fas fa-circle-notch fa-spin"></i> Loading...
                </div>
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    Close
                </button>
                <button type="button" class="btn btn-primary modal-submit">
                    Submit
                </button>
            </div>
        </div>
    </div>
</div>


{$footeroutput}
</body>
</html>
