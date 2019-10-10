//= require rails-ujs
//= require_tree .


import Vue from 'vue'
import App from '../app.vue'

Vue.prototype.$sleep = (time) => new Promise((r) => setTimeout(r, time));

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(App)
  }).$mount()
  document.body.appendChild(app.$el)
})
