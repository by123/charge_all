const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const merge = require('webpack-merge');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const utils = require('./utils');
const baseWebpackConfig = require('./webpack.base');
process.env.NODE_ENV = 'production';

module.exports = config = merge(baseWebpackConfig, {

  output: {
    filename: 'static/js/[name]-[chunkhash].js',
    chunkFilename: 'static/js/[id]-[name]-[chunkhash].js',
    path: path.resolve('dist'),
    publicPath: '/'
  },

  devtool: 'source-map',

  module: {
    rules: utils.styleLoaders({
      sourceMap: true,
      minimize: false,
      extract: true,
    }),
  },


  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      sourceMap: false,
      comments: false
    }),
    new CopyWebpackPlugin([
      {
        from: path.resolve('static'),
        to: path.resolve('dist/static'),
      },
      // {
      //   from: path.resolve('favicon.ico'),
      //   to: path.resolve('dist/favicon.ico'),
      // },
    ]),
    // new webpack.optimize.CommonsChunkPlugin({
    //   name: 'vendor',
    //   minChunks: function (module, count) {
    //     // 所有通过 node_modules 依赖的模块都提取到vendor.js
    //     return module.context && module.context.indexOf('node_modules') !== -1;
    //   }
    // }),
    new webpack.optimize.CommonsChunkPlugin({
      name: 'manifest',
      chunks: ['vendor']
    }),
    new ExtractTextPlugin('static/css/[name]-[contenthash].css'),
  ]
});
