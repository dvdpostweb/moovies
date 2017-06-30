'use strict';
var path = require('path');
var webpack = require('webpack');
var StatsPlugin = require('stats-webpack-plugin');
var devServerPort = 3808;
var production = process.env.NODE_ENV === 'production';
var config = {
  entry: {
    'application': './webpack/application.js',
      'orangesmsconfirm': './webpack/promotions/orangesmsconfirm.js',
      'orangelogin': './webpack/orange/login.js',
      'orangeregister': './webpack/orange/register.js',
      'credit_card_tvod': './webpack/payment_methods/credit_card_tvod.js',
      'redirect_to_ogone': './webpack/payment_methods/redirect_to_ogone.js',
      'components': './webpack/components/components.js',
      'step3': './webpack/steps/step3.js',
      'streaming': './webpack/streaming_product/streaming.js'
  },

  output: {
    path: path.join(__dirname, '..', 'public', 'webpack'),
    publicPath: '/webpack/',

    filename: production ? '[name]-[chunkhash].js' : '[name].js'
  },

  resolve: {
    root: path.join(__dirname, '..', 'webpack')
  },

  plugins: [
    new StatsPlugin('manifest.json', {
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
      compressor: { warnings: false },
      sourceMap: false
    }),
    new webpack.DefinePlugin({
      'process.env': { NODE_ENV: JSON.stringify('production') }
    }),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.OccurenceOrderPlugin()
  );
} else {
  config.devServer = {
    port: devServerPort,
    headers: { 'Access-Control-Allow-Origin': '*' }
  };
  config.output.publicPath = '//localhost:' + devServerPort + '/webpack/';
  config.devtool = 'cheap-module-eval-source-map';
}

module.exports = config;
