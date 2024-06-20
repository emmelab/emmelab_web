<script lang="ts" setup>
    import { ref } from 'vue';

    defineProps({
        nombre: String,
        tag: String,
        year: Number,
        descripcion: String,
        enlace: String,
        media: String,
    })

    const hue = ref((Math.random() * 360))
</script>

<template>
    <div class="card w-96 bg-base-100 shadow-xl">
        <figure>
            <div :style="{
                // backgroundImage: `linear-gradient(0deg, hsla(${hue},100%,50%,1) 0%, hsla(${(90 - hue)%360},100%,50%,1) 100%)`,
                backgroundImage: media ? 
                    `url(/${media}/index.jpg)` : 
                    `linear-gradient(0deg, hsla(${hue},80%,45%,1) 0%, hsla(${(90 + hue)%360},85%,55%,1) 100%)`,
                backgroundSize: 'cover',
                backgroundPosition: 'center'
            }"></div>
        </figure>
        <div class="card-body">
            <h2 class="card-title">
            {{nombre}}
            </h2>
            <p>{{descripcion}}</p>
            <div class="card-actions justify-end">
                <div class="badge badge-outline badge-secondary">{{year}}</div>
                <div class="badge badge-outline badge-primary">{{tag}}</div>
                <a v-if="enlace" :href="enlace" class="badge badge-info"> enlace externo </a>
            </div>
        </div>
    </div>
</template>

<style scoped>
    figure {
        aspect-ratio: 16/9;
    }
    figure div {
        width: 100%;
        height: 100%;
    }
</style>