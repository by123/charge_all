const express = require('express');
const path = require('path');
const proxy = require('http-proxy-middleware');
const app = express();
const port = 8083; // 服务端口号

app.use( proxy('/api/', {
  target: 'https://www.weikeyingxiao.com',
  pathRewrite: {'^/api': '/'},
  changeOrigin: true
}));

app.use(express.static(path.join(__dirname, 'dist')));
module.exports = app.listen(port, (err) => {
  if (err) {
    console.log(err)
    return
  }
  console.log('Listening at http://localhost:' + port + '\n')
});
