// Example webpack configuration with asset fingerprinting in production.
'use strict';

var path = require('path');
var webpack = require('webpack');
var StatsPlugin = require('stats-webpack-plugin');

// must match config.webpack.dev_server.port
var devServerPort = 3808;

// set NODE_ENV=production on the environment to add asset fingerprints
var production = process.env.NODE_ENV === 'production';

var config = {
    entry: {
        'application': './webpack/application.js',
        'filters': './webpack/filters.js',
        'angular_test': './webpack/angular_test/angular_test.js',
        'orange_login': './webpack/orange/login.js',
        'orange_register': './webpack/orange/register.js',
        'orange_step3': './webpack/orange/step3.js',
        'orange_ppv': './webpack/orange/ppv.js',
        'orange_account': './webpack/orange/account.js',
        'promotion_playstation': './webpack/promotions/promotion_playstation.js',
        'promotion_orange_mobistar': './webpack/promotions/promotion_orange_mobistar.js',
        'promotion_orange_sms_confirm': './webpack/promotions/promotion_orange_sms_confirm.js',
        'promotion_bnppf': './webpack/promotions/promotion_bnppf.js',
        'analytic_movie_detail_page': './webpack/analytics/movie_detail_page.js',
        'devise_change_password': './webpack/devise/change_password.js',
        'info_alacarte': './webpack/info/alacarte.js'
    },

    module: {
        loaders: [
            {
                test: /\.html/,
                loader: 'raw'
            }
        ]
    },

    output: {
        // Build assets directly in to public/webpack/, let webpack know
        // that all webpacked assets start with webpack/

        // must match config.webpack.output_dir
        path: path.join(__dirname, '..', 'public', 'webpack'),
        publicPath: '/webpack/',

        filename: production ? '[name]-[chunkhash].js' : '[name].js'
    },

    resolve: {
        root: path.join(__dirname, '..', 'webpack')
    },

    plugins: [
        // must match config.webpack.manifest_filename
        new StatsPlugin('manifest.json', {
            // We only need assetsByChunkName
            chunkModules: false,
            source: false,
            chunks: false,
            modules: false,
            assets: true
        })]
};

if (production) {
    config.plugins.push(
        new webpack.NoErrorsPlugin(),
        new webpack.optimize.UglifyJsPlugin({
            compressor: {warnings: false},
            sourceMap: false
        }),
        new webpack.DefinePlugin({
            'process.env': {NODE_ENV: JSON.stringify('production')}
        }),
        new webpack.optimize.DedupePlugin(),
        new webpack.optimize.OccurenceOrderPlugin()
    );
} else {
    config.devServer = {
        port: devServerPort,
        headers: {'Access-Control-Allow-Origin': '*'},
        disableHostCheck: true
    };
    config.output.publicPath = '//localhost:' + devServerPort + '/webpack/';
    // Source maps
    config.devtool = 'cheap-module-eval-source-map';
}

module.exports = config;
