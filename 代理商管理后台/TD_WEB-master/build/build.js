var ora = require('ora')
var rm = require('rimraf')
var path = require('path')
var chalk = require('chalk')
var webpack = require('webpack')
var webpackConfig = require('./webpack.prod')
const fs = require('fs');
const packageJson = require('../package.json');


var spinner = ora('building for production...')
spinner.start()

rm(path.resolve('dist'), err => {
  if (err) throw err
  webpack(webpackConfig, function (err, stats) {
    spinner.stop()
    if (err) throw err

    process.stdout.write(stats.toString({
      colors: true,
      modules: false,
      children: false,
      chunks: false,
      chunkModules: false
    }) + '\n\n')
    fs.writeFile(path.resolve('dist', 'version.json'), JSON.stringify({ version: packageJson.version }, null, 2), (err) => {
      if (err) throw err;
      console.log('version.json has been saved!');
      console.log(chalk.cyan('  Build complete.\n'))
      console.log(chalk.yellow(
        '  Tip: built files are meant to be served over an HTTP server.\n' +
        '  Opening index.html over file:// won\'t work.\n'
      ))
    });
  })
})
