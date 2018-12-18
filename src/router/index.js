import Vue from 'vue'
import Router from 'vue-router'
import index from '@/pages/index/index'
import login from '@/pages/user/login'
import register from '@/pages/user/register'
import reset from '@/pages/user/reset'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: '首页',
      component: index
    },
    {
      path: '/login',
      name: '登录',
      component: login
    },
    {
      path: '/register',
      name: '注册',
      component: register
    },
    {
      path: '/reset',
      name: '修改密码',
      component: reset
    }
  ]
})
