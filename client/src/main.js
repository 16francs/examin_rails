// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import 'es6-promise/auto'
import App from './App'
import { routes } from './routes'
import store from './store'

Vue.use(VueRouter)

const router = new new VueRouter({
  routes
})

Vue.config.productionTip = process.env.NODE_ENV === 'production'

/* eslint-disable no-new */
new Vue({
  el: '#app',
  routes,
  store,
  render: h => h(App)
})
