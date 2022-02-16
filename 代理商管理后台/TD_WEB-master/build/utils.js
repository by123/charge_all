const path = require('path');
const fs  = require('fs');
const autoprefixer = require('autoprefixer');
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const lessToJs = require('less-vars-to-js');
const themeVariables = lessToJs(fs.readFileSync(path.resolve('./src/styles/theme.less'), 'utf8'));

// __dirname是指当前这个文件所在的目录，而不是根目录位置
// ./ 是指node server运行根路径
exports.resolve = function(dir) {
  return path.join(__dirname, '..', dir);
};

exports.styleLoaders = function (options={}) {
  let output = ['css', 'less', 'scss', 'stylus'].reduce((arr, extension) => {
    return arr.concat({
      test: new RegExp('\\.' + extension + '$'),
      use: composeLoaders(options, extension),
    });
  },[]);
  return output;
};

function composeLoaders(options, preCss) {
  const loaders = [{
      loader: 'css-loader',
      options: {
        minimize: options.minimize,
        sourceMap: options.sourceMap,
        modules: false,
      }
    },
    {
      loader: 'postcss-loader',
      options: {
        plugins: () => [
          autoprefixer({
            browsers: [
              '>1%',
              'last 4 versions',
              'Firefox ESR',
              'not ie < 9', // React doesn't support IE8 anyway
            ],
            cascade: false
          }),
        ]
      }
    },
  ];

  if (preCss != 'css') {
    if (preCss === 'scss') {
      preCss = 'sass';
    }
    loaders.push({
      loader: preCss + '-loader',
      options: {
        modifyVars: themeVariables
      }
    });
  }

  if (options.extract) {
    return ExtractTextPlugin.extract({
      use: loaders,
      fallback: 'style-loader',
    })
  } else {
    return ['style-loader'].concat(loaders);
  }
}
