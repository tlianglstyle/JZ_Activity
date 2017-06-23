import Vue from 'vue'
import App from './App'
import ElementUI from 'element-ui'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import routes from './routes'
import '../theme/index.css'
import './assets/font-awesome-4.7/css/font-awesome.css'
import './styles/global.less'
import './styles/element-style.less'
import './styles/theme.less'
import store from './vuex/store'
import filters from './filters'
Vue.use(ElementUI)
Vue.use(VueRouter)
Vue.use(VueResource)
const isProd = process.env.NODE_ENV === 'production'
let root = '';//接口服务器根目录
let uploadActivityUrl ='';//活动文件打包上传
let uploadActivityImagesUrl ='';//创建活动代码时所需图片上传
if (isProd) {
  root = '//bbs.jzjz.com'
  Vue.http.options.root = '//bbs.jzjz.com/api'//http请求根目录
  uploadActivityUrl = '//bbs.jzjz.com/api/activity/upload'
  uploadActivityImagesUrl = '//localhost:3000/api/activity/uploadimages'
  Vue.config.devtools = false
  Vue.config.silent = true
} else {
  root = '//localhost:8888'
  Vue.http.options.root = '//localhost:8888/server'
  uploadActivityUrl = '//localhost:8888/server/activity/upload'
  uploadActivityImagesUrl = '//localhost:8888/server/activity/uploadimages'
}

Vue.http.options.emulateJSON = true
Vue.globalOptions = {
  root: root,
  uploadActivityUrl : uploadActivityUrl,
  uploadActivityImagesUrl:uploadActivityImagesUrl
}

Object.keys(filters).forEach(k => {
  Vue.filter(k, filters[k])
})

Vue.mixin({
  computed: {
    mix_headers () {
      return {}
    }
  },
  methods: {
    $post (url, data, options) {
      return this.$http.post(url, data, {headers: this.mix_headers, ...options})
    },
    $put (url, data, options) {
      return this.$http.put(url, data, {headers: this.mix_headers, ...options})
    },
    $get (url, data, options) {
      console.log(url);
      return this.$http.get(`${url}?${this.$serialize(data)}`, {headers: this.mix_headers, ...options})
    },
    $delete (url, data, options) {
      return this.$http.delete(`${url}?${this.$serialize(data)}`, {headers: this.mix_headers, ...options})
    },
    $serialize (data = {}) {
      let dataStr = ''
      Object.keys(data).forEach(k => {
        let value = data[k]
        if (value !== null && value !== undefined && value !== '') {
          dataStr += `${k}=${value}&`
        }
      })
      return dataStr.substr(0, dataStr.length - 1)
    }
  }
})

const router = new VueRouter({ routes })

router.beforeEach((to, from, next) => {
    next()
})

const statusMap = {
  0: 'Cannot connect to server',
  404: 'request does not exist',
  500: 'server exception'
}

Vue.http.interceptors.push((request, next) => {
  next(response => {
    if (response.ok) {
      let result = response.data
      if (!result) return response
      if (result.success === false) {
        ElementUI.Message.error(result.msg)
        response.ok = false
      } else if (result.success) {
        response.data = result.data
      }
    } else {
      let status = response.status
      switch (status) {
        case 401:
          ElementUI.Message.error('login expired, please re-login')
          router.replace({name: 'login', query: {redirect: app.$route.fullPath}})
          break
        case 402:
          router.replace({name: 'init'})
          break
        default:
          ElementUI.Message.error(statusMap[status] || response.body)
          break
      }
    }
  })
})

/* eslint-disable no-new */
const app = new Vue({
  el: '#app',
  router,
  store: store,
  template: '<App/>',
  components: { App }
})
