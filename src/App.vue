<script setup lang="ts">
import { RouterView } from 'vue-router'
import NavBar from '@/components/NavBar.vue'
import Footer from '@/components/Footer.vue'
import BackgroundShader from '@/components/BackgroundShader.vue';

</script>

<template>
  <BackgroundShader />
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
html { scroll-behavior: smooth; }
</style>
