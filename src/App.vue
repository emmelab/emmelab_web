<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import NavBar from './components/NavBar.vue'
import Footer from './components/Footer.vue'

</script>

<template>
  <header>
    <NavBar />
  </header>

  <RouterView />

  <Footer />
</template>

<style>
body, html {
  scrollbar-width: thin;
}
</style>
