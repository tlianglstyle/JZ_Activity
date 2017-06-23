require('./check-versions')()
var config = require('../config')
if (!process.env.NODE_ENV) process.env.NODE_ENV = JSON.parse(config.dev.env.NODE_ENV)
var path = require('path')
var express = require('express')
var webpack = require('webpack')
var opn = require('opn')
var proxyMiddleware = require('http-proxy-middleware')
var webpackConfig = require('./webpack.dev.conf')

// default port where dev server listens for incoming traffic
var port = process.env.PORT || config.dev.port

// Define HTTP proxies to your custom API backend
// https://github.com/chimurai/http-proxy-middleware
var proxyTable = config.dev.proxyTable

var app = express()
var compiler = webpack(webpackConfig)


var devMiddleware = require('webpack-dev-middleware')(compiler, {
  publicPath: webpackConfig.output.publicPath,
  stats: {
    colors: true,
    chunks: false
  }
})

var hotMiddleware = require('webpack-hot-middleware')(compiler)
// force page reload when html-webpack-plugin template changes
compiler.plugin('compilation', function (compilation) {
  compilation.plugin('html-webpack-plugin-after-emit', function (data, cb) {
    hotMiddleware.publish({ action: 'reload' })
    cb()
  })
})

// proxy api requests
Object.keys(proxyTable).forEach(function (context) {
  var options = proxyTable[context]
  if (typeof options === 'string') {
    options = { target: options }
  }
  app.use(proxyMiddleware(context, options))
})

// handle fallback for HTML5 history API
app.use(require('connect-history-api-fallback')())

// serve webpack bundle output
app.use(devMiddleware)

// enable hot-reload and state-preserving
// compilation error display
app.use(hotMiddleware)

// serve pure static assets
var staticPath = path.posix.join(config.dev.assetsPublicPath, config.dev.assetsSubDirectory)
app.use(staticPath, express.static('./'))

module.exports = function() {
  var bodyParser = require('body-parser');
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({ extended: false }));
  app.listen(port, function (err) {
    if (err) {
      console.log(err)
      return
    }
    var uri = 'http://localhost:' + port
    console.log('Listening at ' + uri + '\n')

    // when env is testing, don't need open it
    if (process.env.NODE_ENV !== 'testing') {
      //opn(uri)
    }
  });
  app.use('/server' , require('../server/main'));

  var server = express()
  server.listen(8999, function (err) {
    var uri = 'http://localhost:' + 8999
    console.log('Listening at ' + uri + '\n')
  });
  server.engine('.html', require('ejs').__express);
  server.set('view engine', 'html');
  server.set('views', path.join(__dirname, '../server/'));
  server.use('/static', express.static('./'))
  server.get('/preview/:ActivityName/:pageName', function(req, res, next) {
      var activityName = req.params.ActivityName;
      var pageName = req.params.pageName;
      
      res.locals.activity = activityName + '-' + pageName;
      //include module
      res.locals.module = function(moduleName){
        //pageName 为 pc & mobile 时使用,否则自行请自行使用locals.pc & locals.mobile
        return '../../../'+pageName+'/views/modules/'+moduleName+'.html';
      };
      res.locals.pc = function(moduleName){
        return '../../../pc/views/modules/'+moduleName+'.html';
      };
      res.locals.mobile = function(moduleName){
        return '../../../mobile/views/modules/'+moduleName+'.html';
      };
      //include resoures
      res.locals.R = function(resourceUrl,isCtx){
        return '//localhost:8888/static/server/custom/output' + '/' + activityName + '/' + pageName + resourceUrl;
      };
      res.locals.images = function(resourceUrl){
        return res.locals.R('/images/' + resourceUrl);
      };
      res.locals.css = function(resourceUrl){
        return "<link rel=\"stylesheet\" href=\"" + res.locals.R('/css/' + resourceUrl,true) + "\" />";
        //return res.locals.R('/css/' + resourceUrl);
      };
      res.locals.js = function(resourceUrl){
        return "<script src=\"" + res.locals.R('/js/' + resourceUrl,true) + "\"></script>";
        //return res.locals.R('/js/' + resourceUrl);
      };
        res.render('custom/output/' + activityName+'/'+pageName);
    });
}()
