window.SliderSlide = React.createClass({
    render: function() {
        return (
            <div>
                <a href="index.html#" className="popper"><img src={'http://www.dvdpost.be/images/'} className="img-responsive"/>
                    <span class="hd position-absolute black white-bck radius2 bold italic">HD</span>
                </a>
                <div className="synopsys-content">
                    <div className="position-relative pull-left">
                        <h4 className="dark-gray mart20 marb0 bold text-center uppercase f25">FARGO(2014)</h4>
                        <div className="block100 slide-score green text-center mart5 f20" data-score="3"></div>
                        <div className="block100 slide-price f20 line-height-10 dark-gray text-center bold">2.99€</div>
                        <div className="block100 slide-discount text-center mart5">ou 1.99€ via
                            <a href="http://plush-rwd.tritacke.org/fr/information/alacarte" className="dark-gray underline">abonnement</a>
                        </div>
                        <div className="block100 slide-content mart15 text-center">
                            <a href="index.html#" className="btn btn-green-gradient bold padlr25 white f17"><i className="fa fa-play marr5"></i> Regarder</a>
                        </div>
                        <div className="block100 slide-content mart15">
                            Oldman est un commissaire-priseur amidonné et bacillophobe, qui vit dans une somptueuse propriété aux murs garnis de portraits de femme. Appelé par une
                            mystérieuse voix à gérer le contenu d'une maison, il tente de découvrir qui est la propriétaire des biens...
                        </div>
                        <div className="block100 slide-buttons mart15">
                            <a href="index.html#" className="btn white pull-left dark-gray-bck btn-trailer" data-src="https://www.youtube.com/watch?v=gKs8DzjPDMU" data-toggle="modal" data-target="#trailer-modal">
                                <i class="fa fa-film marr5"></i>Trailer
                            </a>
                            <a href="index.html#" class="btn gray-bck pull-right btn-selection"><i className="fa fa-plus marr5"></i>Selection</a>
                        </div>
                        <div className="block100 slide-footer green-bck padtb15 mart10 text-center">
                            <a href="http://plush-rwd.tritacke.org/fr/information/alacarte" className="underline f18 dark-gray">Abonnez-vous</a>
                            <p className="block100 mart5 text-center dark-gray f15">
                                et regardez ce film pour seulement <strong>1.99€</strong>
                            </p>
                        </div>
                        <a href="index.html#" class="synopsys-adaptive-close"></a>
                    </div>
                </div>
                <a href="index.html#" class="position-absolute white-bck pad10 radius2 synopsys-adaptive-open f17 green uppercase no-underline"><i className="fa fa-search-plus f25 marr5"></i>Details
                </a>
            </div>
        )
    }
})