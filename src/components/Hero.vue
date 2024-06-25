<script lang="ts" setup>
  import isMobile from 'is-mobile';
  import { ref } from 'vue';
  const ismobile = ref(isMobile())
</script>

<template>
   <div class="hero min-h-screen"><!-- bg-base-200 -->
      <div class="hero-content text-center">
        <div class="max-w-md">
          <h1 :class="`font-bold ${ismobile ? 'text-5xl' : 'text-7xl'}`" class="font-bold">emmelab</h1>
          <p :class="`${ismobile ? 'text-base' : 'text-lg'} py-6`">Laboratorio de investigación y experimentación multimedial formado por docentes y estudiantes de la Facultad de Artes de la UNLP</p>
          <a href="#proyectos"><button class="btn btn-primary">¿Qué hacemos?</button></a>
        </div>
      </div>
    </div>
</template>

<style scoped>

</style>