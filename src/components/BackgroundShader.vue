<script lang="ts" setup>
import * as THREE from 'three';
import { onMounted } from 'vue';

let camera:THREE.OrthographicCamera, scene:THREE.Scene, renderer:THREE.WebGLRenderer;

let uniforms:any;

let timer = 60000;
const timeout = timer;

// init();
onMounted(() => {
    init()
})

async function loadShader(url:string) {
    const response = await fetch(url);
    const shaderTxt = await response.text();
    return shaderTxt;
}

async function init() {

    const container = document.getElementById( 'cnv' );

    camera = new THREE.OrthographicCamera( - 1, 1, 1, - 1, 0, 1 );

    scene = new THREE.Scene();

    const geometry = new THREE.PlaneGeometry( 2, 2 );

    uniforms = {
        u_resolution: {
            value: new THREE.Vector2(window.innerWidth, window.outerHeight)
        },
        uShininess: { value: 2.0 },
        uDiffuseness: { value: 0.72 },
        uLight: {
            value: new THREE.Vector3(0.1, 0.2, 2.0),
        },
        u_time: { value: 1.0 },
    };

    const material = new THREE.ShaderMaterial( {
        uniforms: uniforms,
        vertexShader: await loadShader('/glsl/vertex.glsl'),
        fragmentShader: await loadShader('/glsl/frag.glsl')
    } );

    const mesh = new THREE.Mesh( geometry, material );
    scene.add( mesh );

    renderer = new THREE.WebGLRenderer();
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize( window.innerWidth, window.innerHeight );
    container?.appendChild( renderer.domElement );

    window.addEventListener( 'resize', onWindowResize );

    animate();
}

function onWindowResize() {

    renderer.setSize( window.innerWidth, window.outerHeight );

}

//

function animate() {

    requestAnimationFrame( animate );

    uniforms[ 'u_time' ].value = performance.now() / 1000;

    renderer.render( scene, camera );
}
</script>

<template>
    <div id="cnv">

    </div>
</template>

<style scoped>
    #cnv {
        position: fixed;
        width: 100vw;
        height: 100vh;
        height: 100lvh;
        z-index: -1;
    }
</style>