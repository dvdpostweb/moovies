var coreJS = require('core-js');
var zoneJS = require('zone.js');
var reflectMetadata = require('reflect-metadata');
var ng = {
    core: require("@angular/core"),
    common: require("@angular/common"),
    compiler: require("@angular/compiler"),
    forms: require("@angular/forms"),
    platformBrowser: require("@angular/platform-browser"),
    platformBrowserDynamic: require("@angular/platform-browser-dynamic"),
    router: require("@angular/router")
};


var AngularTestComponent = ng.core.Component({
    selector: "plush-angular-test",
    template: require("./AngularTestComponent.html")
}).Class({
    constructor: function () {
        this.name = null;
    }
});

var AngularTestAppModule = ng.core.NgModule({
    imports: [ ng.platformBrowser.BrowserModule, ng.forms.FormsModule ],
    declarations: [ AngularTestComponent ],
    bootstrap: [ AngularTestComponent ]
}).Class({
    constructor: function() {}
});

document.addEventListener('DOMContentLoaded', function() {
    var shouldBootstrap = document.getElementById("angular-test");
    if (shouldBootstrap) {
        ng.platformBrowserDynamic.
        platformBrowserDynamic().
        bootstrapModule(AngularTestAppModule);
    }
});