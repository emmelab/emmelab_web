<script setup lang="ts"></script>

<template>

<div class="navbar bg-base-100">
  <div class="flex-1">
    <RouterLink to="/" class="btn btn-ghost text-xl">
        <img src="@/assets/marca.svg">
    </RouterLink>
  </div>
  <div class="flex-none">
    <ul class="menu menu-horizontal px-1">
      <li><RouterLink to="/about">¿Quiénes somos?</RouterLink></li>
      <li><RouterLink to="/">Contacto</RouterLink></li>
    </ul>
  </div>
</div>

</template>

<style scoped>
    img {
        /* width: 48px; */
        max-height: 100%;
    }
    .navbar {
        position: fixed;
        z-index: 5;
    }
</style>