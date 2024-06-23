<script lang="ts" setup>
    import { ref } from 'vue';
    import Card from './Card.vue';
    import json from '@/assets/proyectos.json'
    
    const query = ref('')
    const arr = ref(json.sort((a, b) => {return b['año-inicio'] - a['año-inicio']}))

    const filter = () => {
        arr.value = json.filter(el => {
            if(!query.value) return true;
            return (
                el.nombre   .toLowerCase().includes(query.value.toLowerCase()) ||
                el.notas    .toLowerCase().includes(query.value.toLowerCase()) ||
                el.tipo     .toLowerCase().includes(query.value.toLowerCase()) ||
                el.fecha    .toLowerCase().includes(query.value.toLowerCase()) ||
                el['año-inicio'] == Number.parseInt(query.value.toLowerCase())
            )
        }) 
    }

</script>

<template>
    <section class="wrapper bg-base-200" id="proyectos">
        <label class="input input-bordered flex items-center gap-2">
            <input v-model="query" @input="filter" type="text" class="grow" placeholder="Buscar" />
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="w-4 h-4 opacity-70"><path fill-rule="evenodd" d="M9.965 11.026a5 5 0 1 1 1.06-1.06l2.755 2.754a.75.75 0 1 1-1.06 1.06l-2.755-2.754ZM10.5 7a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0Z" clip-rule="evenodd" /></svg>
        </label>
        <div class="container">
            <Card 
                v-for="item in arr" 
                :nombre="item.nombre"
                :tag="item.tipo"
                :year="item['año-inicio']"
                :descripcion="item.notas"
                :enlace="item['url-externa']"
                :media="item.media"
            />
        </div>
    </section>
</template>

<style scoped>
    .wrapper {
        width: 100%;
        padding: 24px;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 24px;
        flex-direction: column;

        scroll-margin-top: 4rem;
    }
    .container {
        width: 100%;
        gap: 24px;
        display: flex;
        flex-wrap: wrap;
        flex-direction: row;
        justify-content: space-around
    }
</style>