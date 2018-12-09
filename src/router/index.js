import Vue from 'vue'
import Router from 'vue-router'
import index from '@/pages/index/index'
import login from '@/pages/user/login'
import register from '@/pages/user/register'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'index',
      component: index
    },
    {
      path: '/login',
      name: 'login',
      component: login
    },
    {
      path: '/register',
      name: 'register',
      component: register
    }
  ]
})
