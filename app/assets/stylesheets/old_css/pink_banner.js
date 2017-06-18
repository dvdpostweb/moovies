import React, {StyleSheet, Dimensions, PixelRatio} from "react-native";
const {width, height, scale} = Dimensions.get("window"),
    vw = width / 100,
    vh = height / 100,
    vmin = Math.min(vw, vh),
    vmax = Math.max(vw, vh);

export default StyleSheet.create({
    "pinkBanner": {
        "overflow": "hidden",
        "position": "relative",
        "minHeight": 54,
        "width": 970,
        "marginTop": 0,
        "marginRight": "auto",
        "marginBottom": 0,
        "marginLeft": "auto",
        "fontFamily": "'Helvetica','Open Sans Condensed', sans-serif !important"
    },
    "pinkBanner _toggleImage1_": {
        "display": "none !important"
    },
    "pinkBanner _toggleSpan1_": {
        "display": "none !important"
    },
    "pinkBanner pinkBannerTop": {
        "position": "relative",
        "width": "100%",
        "zIndex": 1,
        "height": 54,
        "background": "#C36EC3",
        "display": "table",
        "WebkitTransition": "all 0.6s linear",
        "MozTransition": "all 0.6s linear",
        "OTransition": "all 0.6s linear",
        "transition": "all 0.6s linear"
    },
    "pinkBanner pinkBannerTop_open_": {
        "height": 30
    },
    "pinkBanner pinkBannerTop_open_ _toggleImage1_": {
        "display": "inline-block !important"
    },
    "pinkBanner pinkBannerTop_open_ _toggleSpan1_": {
        "display": "inline-block !important"
    },
    "pinkBanner pinkBannerTop_open_ _toggleImage2_": {
        "display": "none !important"
    },
    "pinkBanner pinkBannerTop_open_ _toggleSpan2_": {
        "display": "none !important"
    },
    "pinkBanner pinkBannerTop_open_ > div:nth-child(2)": {
        "opacity": 0
    },
    "pinkBanner pinkBannerTop_open_ > div:last-child": {
        "opacity": 0
    },
    "pinkBanner pinkBannerTop_open_ > div": {
        "WebkitTransition": "all 0.2s linear",
        "MozTransition": "all 0.2s linear",
        "OTransition": "all 0.2s linear",
        "transition": "all 0.2s linear"
    },
    "pinkBanner pinkBannerTop > div": {
        "display": "table-cell",
        "verticalAlign": "middle",
        "wordWrap": "break-word",
        "WebkitTransition": "all 0.2s linear",
        "MozTransition": "all 0.2s linear",
        "OTransition": "all 0.2s linear",
        "transition": "all 0.2s linear"
    },
    "pinkBanner pinkBannerTop > div:first-child": {
        "width": "29%",
        "fontSize": 12
    },
    "pinkBanner pinkBannerTop > div:first-child img_toggleImage1_": {
        "width": 11,
        "height": 5,
        "marginLeft": 30,
        "marginRight": 7,
        "display": "inline-block",
        "verticalAlign": "middle"
    },
    "pinkBanner pinkBannerTop > div:first-child img_toggleImage2_": {
        "width": 18,
        "height": 22,
        "marginLeft": 30,
        "marginRight": 7,
        "display": "inline-block",
        "verticalAlign": "middle"
    },
    "pinkBanner pinkBannerTop > div:first-child a": {
        "color": "#181e25"
    },
    "pinkBanner pinkBannerTop > div:nth-child(2)": {
        "width": "40%",
        "textAlign": "center"
    },
    "pinkBanner pinkBannerTop > div:last-child": {
        "width": "30%",
        "textAlign": "right",
        "fontSize": 12,
        "color": "white"
    },
    "pinkBanner pinkBannerTop > div:last-child img": {
        "width": 33,
        "height": 34,
        "marginRight": 16,
        "marginLeft": 10,
        "display": "inline-block",
        "verticalAlign": "middle"
    },
    "pinkBanner pinkBannerTop > div:last-child > div": {
        "display": "inline-block",
        "verticalAlign": "middle",
        "textAlign": "left"
    },
    "pinkBanner pinkBannerTop > div:last-child > div a": {
        "color": "white !important"
    },
    "pinkBanner h2": {
        "marginTop": 0,
        "marginRight": 0,
        "marginBottom": 0,
        "marginLeft": 0,
        "paddingTop": 0,
        "paddingRight": 0,
        "paddingBottom": 0,
        "paddingLeft": 0,
        "display": "inline-block",
        "color": "black",
        "fontSize": 18,
        "lineHeight": 18,
        "fontWeight": "500"
    },
    "pinkBanner h2 a": {
        "color": "black",
        "fontWeight": "normal"
    },
    "pinkBanner h2 a:hover": {
        "color": "black",
        "fontWeight": "normal"
    },
    "pinkBanner h2 a:focus": {
        "color": "black",
        "fontWeight": "normal"
    },
    "pinkBanner h2 a:active": {
        "color": "black",
        "fontWeight": "normal"
    },
    "pinkBanner pinkBannerInlineBlock": {
        "display": "inline-block"
    },
    "pinkBanner pinkBannerOpen": {
        "display": "table",
        "width": "100%",
        "paddingTop": 10,
        "paddingBottom": 25,
        "WebkitTransition": "all 0.6s linear",
        "MozTransition": "all 0.6s linear",
        "OTransition": "all 0.6s linear",
        "transition": "all 0.6s linear",
        "marginTop": -250
    },
    "pinkBanner pinkBannerOpen_open_": {
        "marginTop": 0,
        "WebkitTransition": "all 0.6s linear",
        "MozTransition": "all 0.6s linear",
        "OTransition": "all 0.6s linear",
        "transition": "all 0.6s linear"
    },
    "pinkBanner pinkBannerOpen > div": {
        "display": "table-cell",
        "verticalAlign": "middle",
        "wordWrap": "break-word",
        "width": "50%"
    },
    "pinkBanner pinkBannerOpen > div:first-child": {
        "paddingLeft": 30,
        "borderRight": "2px solid #eaeaea"
    },
    "pinkBanner pinkBannerOpen > div:first-child ul": {
        "marginTop": 0,
        "marginRight": 0,
        "marginBottom": 0,
        "marginLeft": 0,
        "paddingTop": 0,
        "paddingRight": 0,
        "paddingBottom": 0,
        "paddingLeft": 0
    },
    "pinkBanner pinkBannerOpen > div:first-child ul li": {
        "listStyle": "none",
        "color": "black",
        "fontSize": 15,
        "lineHeight": "auto",
        "marginBottom": 8
    },
    "pinkBanner pinkBannerOpen > div:first-child ul:first-child": {
        "marginBottom": 55
    },
    "pinkBanner pinkBannerOpen > div:last-child": {
        "paddingLeft": 30,
        "fontSize": 13
    },
    "pinkBanner pinkBannerOpen > div:last-child table": {
        "marginBottom": 30
    },
    "pinkBanner pinkBannerOpen > div:last-child table td": {
        "paddingTop": 5,
        "paddingBottom": 5,
        "wordWrap": "break-word"
    },
    "pinkBanner pinkBannerOpen > div:last-child _inputContainer": {
        "marginTop": 7,
        "clear": "both"
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type='submit']": {
        "fontSize": 14,
        "color": "white",
        "border": "1px solid #34adac",
        "background": "#34adac",
        "outline": "none",
        "WebkitBorderRadius": 6,
        "MozBorderRadius": 6,
        "borderRadius": 6,
        "lineHeight": 20,
        "WebkitTransition": "all 0.2s linear",
        "MozTransition": "all 0.2s linear",
        "OTransition": "all 0.2s linear",
        "transition": "all 0.2s linear",
        "cursor": "pointer"
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type='submit']:hover": {
        "background": "#288685"
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type='submit']_redBackground_": {
        "background": "#eb212e"
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type='submit']_redBackground_:hover": {
        "background": "#c7121e"
    },
    "pinkBanner pinkBannerOpen > div:last-child mt44": {
        "marginTop": 44
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type=\"text\"]": {
        "width": "230px !important",
        "outline": "none",
        "border": "2px solid #c3c3c3",
        "paddingTop": 0,
        "paddingRight": 0,
        "paddingBottom": 0,
        "paddingLeft": 5,
        "marginTop": 0,
        "marginRight": 0,
        "marginBottom": 0,
        "marginLeft": 0,
        "lineHeight": 22,
        "fontSize": 13
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type=\"text\"]::-webkit-input-placeholder": {
        "fontSize": 13,
        "color": "#817e7e"
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type=\"text\"]:-moz-placeholder": {
        "fontSize": 13,
        "color": "#817e7e"
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type=\"text\"]::-moz-placeholder": {
        "fontSize": 13,
        "color": "#817e7e"
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type=\"text\"]:-ms-input-placeholder": {
        "fontSize": 13,
        "color": "#817e7e"
    },
    "pinkBanner pinkBannerOpen > div:last-child input[type=\"text\"]::placeholder": {
        "fontSize": 13,
        "color": "#817e7e"
    },
    "pinkBanner pinkBannerOpen > div:last-child img": {
        "width": 47,
        "height": 47,
        "float": "left",
        "marginRight": 6,
        "marginTop": 1
    },
    "pinkBanner pinkBannerOpen > div:last-child img + label": {
        "display": "inline",
        "verticalAlign": "middle",
        "fontSize": 13,
        "lineHeight": 13
    },
    "pinkBanner _blueColor_": {
        "color": "#48a9a8"
    },
    "pinkBanner _greenColor_": {
        "color": "#60b13a"
    },
    "pinkBanner _underline_": {
        "textDecoration": "underline"
    },
    "pinkBanner _bold_": {
        "fontWeight": "bold"
    },
    "pinkBanner _redColor_": {
        "color": "#eb212e"
    },
    "pinkBanner _normal_": {
        "fontWeight": "normal"
    },
    "pinkBanner _hidden_": {
        "display": "none"
    },
    "pinkBanner _errorMessage_": {
        "color": "#eb212e",
        "marginTop": 4
    }
});