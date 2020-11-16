import Vue from 'vue'
import Router from 'vue-router'
import Login from './components/Login'
import Terminal from './components/Terminal'
import Profile from './components/Profile'
import firebase from 'firebase'

Vue.use(Router);

let router = new Router({
        mode: 'history',

        routes: [
            {
                path: '*',
                redirect: '/profile'
            },
            {
                path: '/profile',
                name: 'Profile',
                component: Profile,
                meta: {
                    requiresAuth: true
                }
            },
            {
                path: '/login',
                name: 'Login',
                component: Login,
                meta: {
                    requiresAuth: false
                }

            },
            {
                path: '/terminal',
                name: 'Terminal',
                component: Terminal,
                meta: {
                    requiresAuth: true
                }

            }
        ]

    },

);


router.beforeEach((to, from, next) => {
    const requiresAuth = to.matched.some((x) => x.meta.requiresAuth);
    const currentUser = firebase.auth().currentUser;
  
    if (requiresAuth && !currentUser) {
      next("/login");
    } else if (requiresAuth && currentUser) {
      next();
    } else {
      next();
    }
  });

export default router
