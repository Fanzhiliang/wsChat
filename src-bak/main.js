// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import "babel-polyfill"
import store from './store'
//如果用移动端使用rem单位
import isMobile from './assets/js/rem.js'
import E from 'wangeditor'
import {UA,getStyle} from './assets/js/utils.js'
import Tip from './assets/js/Tip.js'
import loading from './assets/js/loading.js'

Vue.config.productionTip = false

Vue.prototype.$isMobile = isMobile;
Vue.prototype.$E = E;
Vue.prototype.$UA = UA;
Vue.prototype.$Tip = Tip;

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  components: { App },
  template: '<App/>'
})
