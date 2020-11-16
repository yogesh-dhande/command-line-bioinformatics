<template>
    <b-navbar toggleable="lg" type="dark" variant="dark">
        <b-navbar-brand to="terminal">Command Line Bioinformatics</b-navbar-brand>
        <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
        <b-collapse id="nav-collapse" is-nav>
            <b-navbar-nav class="ml-auto">
                <b-nav-item to="terminal">Terminal</b-nav-item>
                <b-nav-item to="profile">Profile</b-nav-item>
                <b-nav-item @click="logout">Logout</b-nav-item>
            </b-navbar-nav>
        </b-collapse>
    </b-navbar>
</template>

<script>
    const fb = require('../firebaseConfig.js')

    export default {
        methods: {
            logout() {
                fb.auth.signOut().then(() => {
                    this.$store.dispatch('clearData')
                    this.$router.push('/login')
                }).catch(err => {
                    console.log(err)
                })
            }
        }
    }
</script>
