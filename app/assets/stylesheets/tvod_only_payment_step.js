import React, {StyleSheet, Dimensions, PixelRatio} from "react-native";
const {width, height, scale} = Dimensions.get("window"),
    vw = width / 100,
    vh = height / 100,
    vmin = Math.min(vw, vh),
    vmax = Math.max(vw, vh);

export default StyleSheet.create({
    "body": {
        "fontFamily": "Arial,Helvetica, sans-serif"
    },
    "ul": {
        "listStyle": "none",
        "paddingTop": 0,
        "paddingRight": 0,
        "paddingBottom": 0,
        "paddingLeft": 0,
        "marginTop": 0,
        "marginRight": 0,
        "marginBottom": 0,
        "marginLeft": 0
    },
    "h2": {
        "marginTop": 0,
        "marginRight": 0,
        "marginBottom": 0,
        "marginLeft": 0,
        "fontSize": 20,
        "fontWeight": "bold"
    },
    "h3": {
        "marginTop": 0,
        "marginRight": 0,
        "marginBottom": 0,
        "marginLeft": 0,
        "fontSize": 16,
        "fontWeight": "normal"
    },
    "label": {
        "fontFamily": "Arial,Helvetica, sans-serif",
        "fontWeight": "bold",
        "fontSize": 26
    },
    "step": {
        "height": "auto",
        "marginTop": 0,
        "marginRight": "auto",
        "marginBottom": 0,
        "marginLeft": "auto",
        "paddingTop": 45,
        "paddingRight": 60,
        "paddingBottom": 20,
        "paddingLeft": 55,
        "background": "#fff"
    },
    "logo-page": {
        "width": 129,
        "height": 71,
        "marginBottom": 25,
        "backgroundImage": "url(step3/logo.png)",
        "display": "inline-block"
    },
    "log-out": {
        "fontFamily": "Arial,Helvetica, sans-serif",
        "fontSize": 19,
        "marginTop": 50,
        "fontWeight": "bold",
        "display": "inline-block",
        "float": "right",
        "color": "#5da50e"
    },
    "main-block": {
        "width": "calc(100% - 80px)",
        "paddingTop": 40,
        "paddingRight": 40,
        "paddingBottom": 80,
        "paddingLeft": 40,
        "backgroundColor": "#f3f3f3"
    },
    "main-block main-caption": {
        "marginBottom": 20,
        "fontWeight": "normal",
        "display": "block",
        "color": "#000",
        "fontFamily": "Arial,Helvetica, sans-serif",
        "fontSize": 26
    },
    "main-block main-text": {
        "marginBottom": 25,
        "fontWeight": "bold",
        "display": "block",
        "color": "#000",
        "fontFamily": "Arial,Helvetica, sans-serif",
        "fontSize": 19
    },
    "main-list": {
        "marginBottom": 20
    },
    "main-list li": {
        "fontFamily": "Arial,Helvetica, sans-serif",
        "fontSize": 19,
        "fontWeight": "normal",
        "color": "#000",
        "marginBottom": 5
    },
    "lock-block": {
        "height": 45,
        "display": "block"
    },
    "lock-img": {
        "width": 29,
        "height": 41,
        "backgroundImage": "url(step3/lock.png)",
        "display": "inline-block",
        "float": "right"
    },
    "secure": {
        "marginRight": 15,
        "display": "inline-block",
        "float": "right"
    },
    "secure server": {
        "display": "block",
        "fontSize": 20,
        "color": "#000"
    },
    "secure plus": {
        "color": "#0a4df8",
        "display": "block",
        "fontSize": 15,
        "fontWeight": "normal",
        "float": "right"
    },
    "button-role": {
        "width": "calc(100% - 100px)",
        "height": 20,
        "lineHeight": 24,
        "paddingTop": 20,
        "paddingRight": 50,
        "paddingBottom": 20,
        "paddingLeft": 50,
        "backgroundColor": "#fff",
        "backgroundImage": "url(step3/arrow.png)",
        "backgroundPosition": "20px center",
        "backgroundRepeat": "no-repeat",
        "border": "2px solid #c2c2c2",
        "marginBottom": 20,
        "fontSize": 28
    },
    "button-rolevirement": {
        "height": 35,
        "lineHeight": 35,
        "paddingTop": 12,
        "paddingRight": 50,
        "paddingBottom": 12,
        "paddingLeft": 50
    },
    "button-role img": {
        "verticalAlign": "bottom",
        "marginLeft": 25
    },
    "phone-number": {
        "marginTop": 25,
        "display": "block",
        "fontSize": 19,
        "fontWeight": "normal",
        "color": "#837f7f"
    },
    "conditions-d-utilisation": {
        "marginTop": 25,
        "display": "block",
        "fontSize": 19,
        "fontWeight": "normal",
        "color": "#837f7f",
        "textDecoration": "underline"
    },
    "accordion h1 a": {
        "color": "black",
        "fontFamily": "Arial,Helvetica, sans-serif",
        "fontSize": 19,
        "fontWeight": "normal"
    },
    "accordion section": {
        "WebkitTransition": "all 0.5s ease-in-out",
        "MozTransition": "all 0.5s ease-in-out",
        "MsTransition": "all 0.5s ease-in-out",
        "transition": "all 0.5s ease-in-out",
        "overflow": "hidden",
        "height": 220,
        "border": "2px solid #c2c2c2",
        "marginBottom": 20
    },
    "accordion pointer": {
        "WebkitTransition": "all 0.5s ease-in-out",
        "MozTransition": "all 0.5s ease-in-out",
        "MsTransition": "all 0.5s ease-in-out",
        "transition": "all 0.5s ease-in-out",
        "paddingTop": 0,
        "paddingRight": 0,
        "paddingBottom": 0,
        "paddingLeft": 0,
        "marginTop": 25,
        "marginRight": 0,
        "marginBottom": 0,
        "marginLeft": 25,
        "lineHeight": 20,
        "width": 13,
        "position": "absolute"
    },
    "accordion h1": {
        "WebkitTransition": "all 0.5s ease-in-out",
        "MozTransition": "all 0.5s ease-in-out",
        "MsTransition": "all 0.5s ease-in-out",
        "transition": "all 0.5s ease-in-out",
        "lineHeight": 1.2,
        "fontSize": 28,
        "backgroundColor": "#fff",
        "marginTop": 0,
        "marginRight": 0,
        "marginBottom": 0,
        "marginLeft": 0,
        "paddingTop": 20,
        "paddingRight": 50,
        "paddingBottom": 20,
        "paddingLeft": 50
    },
    "accordion p": {
        "WebkitTransition": "all 0.5s ease-in-out",
        "MozTransition": "all 0.5s ease-in-out",
        "MsTransition": "all 0.5s ease-in-out",
        "transition": "all 0.5s ease-in-out",
        "paddingTop": 0,
        "paddingRight": 10,
        "paddingBottom": 0,
        "paddingLeft": 10,
        "color": "black"
    },
    "accordion": {
        "marginBottom": 30
    },
    "accordion sectionac_hidden p:not(pointer)": {
        "color": "#fff"
    },
    "accordion sectionac_hidden": {
        "height": 75
    },
    "accordion section:not(ac_hidden) h1": {
        "backgroundColor": "#fff"
    },
    "accordion section:not(ac_hidden) pointer": {
        "display": "block",
        "WebkitTransform": "rotate(90deg)",
        "MozTransform": "rotate(90deg)",
        "OTransform": "rotate(90deg)",
        "transform": "rotate(90deg)",
        "paddingTop": 0,
        "paddingRight": 0,
        "paddingBottom": 0,
        "paddingLeft": 0
    },
    "button-connenct": {
        "height": 40,
        "marginTop": 20,
        "marginRight": 0,
        "marginBottom": 35,
        "marginLeft": 0,
        "paddingTop": 0,
        "paddingRight": 40,
        "paddingBottom": 0,
        "paddingLeft": 40,
        "borderRadius": 5,
        "backgroundColor": "#76c71e",
        "border": 0,
        "color": "#fff",
        "fontSize": 17,
        "fontWeight": "bold",
        "float": "right",
        "cursor": "pointer"
    },
    "header": {
        "display": "none"
    },
    "footer": {
        "display": "none"
    },
    "secure_payment_link": {
        "color": "#0000CD"
    },
    "flash_message": {
        "display": "none"
    },
    "wrap": {
        "display": "none"
    }
});