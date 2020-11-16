import Vue from "vue";
import Vuex from "vuex";

const fb = require("./firebaseConfig.js");

Vue.use(Vuex);

export function buildStore() {

  let store = new Vuex.Store({
    state: {
      session: null,
      currentUser: null,
      userProfile: {},
    },
    actions: {
      clearData({ commit }) {
        commit("setCurrentUser", null);
        commit("setUserProfile", {});
        commit("setPosts", null);
        commit("setHiddenPosts", null);
      },
      fetchUserProfile({ commit, state }) {
        fb.usersCollection
          .doc(state.currentUser.uid)
          .get()
          .then((res) => {
            commit("setUserProfile", res.data());
          })
          .catch((err) => {
            console.log(err);
          });
      },
      updateProfile({ state }, data) {
        let name = data.name;
        let title = data.title;

        fb.usersCollection
          .doc(state.currentUser.uid)
          .update({ name, title })
          .then(() => {
            // eslint-disable-line no-unused-vars
            // update all posts by user to reflect new name
            fb.postsCollection
              .where("userId", "==", state.currentUser.uid)
              .get()
              .then((docs) => {
                docs.forEach((doc) => {
                  fb.postsCollection.doc(doc.id).update({
                    userName: name,
                  });
                });
              });
            // update all comments by user to reflect new name
            fb.commentsCollection
              .where("userId", "==", state.currentUser.uid)
              .get()
              .then((docs) => {
                docs.forEach((doc) => {
                  fb.commentsCollection.doc(doc.id).update({
                    userName: name,
                  });
                });
              });
          })
          .catch((err) => {
            console.log(err);
          });
      },
    },
    mutations: {

      setCurrentUser(state, val) {
        state.currentUser = val;
      },
      setUserProfile(state, val) {
        state.userProfile = val;
      },
    }
})

  return store;
}
