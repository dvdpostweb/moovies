window.PromoImageNormal = React.createClass({
    render: function () {
        var image = {
            backgroundImage: 'url(' + this.props.image + ')'
        }
        return (
            <div className="container white-bck">
                <div href={this.props.image} className="promo-image rwd-bck display-block" style={image}>
                    <div className="promo-image-overlay">
                        <div className="promo-image-overlay-inner white bold">
                            <span>{this.props.text}</span>
                            <button>{this.props.btn}</button>
                        </div>
                    </div>
                </div>
            </div>
        )
    }
});