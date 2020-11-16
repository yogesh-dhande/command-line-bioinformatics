import Vue from 'vue'
import App from './App.vue'
import router from './router'
const fb = require('./firebaseConfig.js');
import BootstrapVue from 'bootstrap-vue';
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faSeedling, faCat } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

import {buildStore} from './store.js'

Vue.config.productionTip = false;

Vue.use(BootstrapVue);
library.add(faSeedling, faCat);
Vue.component('font-awesome-icon', FontAwesomeIcon);

let app;
fb.auth.onAuthStateChanged(() => {
  const store = buildStore()
  if (!app) {
    app = new Vue({
      el: '#app',
      router,
      store,
      render: h => h(App)
    })
  }
});
