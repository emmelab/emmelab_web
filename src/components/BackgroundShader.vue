<script lang="js" setup>
import { onMounted } from 'vue';
import isMobile from 'is-mobile';

// init();
onMounted(() => {
    init()
})

async function loadShader(url) {
    const response = await fetch(url);
    const shaderTxt = await response.text();
    return shaderTxt;
}

async function init() {

    let loadedShaders = {vsText: '', fsText: ''}
    
    loadedShaders.vsText = await loadShader('/glsl/vertex.glsl')
    loadedShaders.fsText = await loadShader('/glsl/frag.glsl')

	runDemo(null, loadedShaders);
}

function runDemo(loadErrors, loadedShaders) {
	// Attach callbacks
  window.addEventListener('resize', OnResizeWindow)

	var canvas = document.getElementById('cnv');
	var gl = canvas?.getContext('webgl');
	if (!gl) {
		console.log('Webgl context not available - falling back on experimental');
		gl = canvas.getContext('experimental-webgl');
	}
	if (!gl) {
		console.error('Cannot get WebGL context - browser does not support WebGL');
		return;
	}

	// Create shader program
	var vs = gl.createShader(gl.VERTEX_SHADER);
	gl.shaderSource(vs, loadedShaders.vsText);
	gl.compileShader(vs);
	if (!gl.getShaderParameter(vs, gl.COMPILE_STATUS)) {
		console.error(
			'Vertex shader compile error:',
			gl.getShaderInfoLog(vs)
		);
	}

	var fs = gl.createShader(gl.FRAGMENT_SHADER);
	gl.shaderSource(fs, loadedShaders.fsText);
	gl.compileShader(fs);
	if (!gl.getShaderParameter(fs, gl.COMPILE_STATUS)) {
		console.error(
			'Fragment shader compile error:',
			gl.getShaderInfoLog(fs)
		);
	}

	var program = gl.createProgram();
	gl.attachShader(program, vs);
	gl.attachShader(program, fs);
	gl.linkProgram(program);
	if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
		console.error(
			'Shader program link error:',
			gl.getShaderInfoLog(program)
		);
	}

	gl.validateProgram(program);
	if (!gl.getProgramParameter(program, gl.VALIDATE_STATUS)) {
		console.error(
			'Shader program validate error:',
			gl.getShaderInfoLog(program)
		);
	}

	gl.useProgram(program);

	// Get uniform locations
	var uniforms = {
		u_resolution: gl.getUniformLocation(program, 'u_resolution'),
		u_time: gl.getUniformLocation(program, 'u_time'),  
	};

	// Set CPU-side variables for all of our shader variables
	var vpDimensions = [canvas.clientWidth, canvas.clientHeight];
	// var time = window.performance.now()/1000.0;

	// Create buffers
	var vertexBuffer = gl.createBuffer();
	var vertices = [
		-1, 1,
		-1, -1,
		1, -1,
		
		-1, 1,
		1, 1,
		1, -1
	];
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);

	var vPosAttrib = gl.getAttribLocation(program, 'position');
	gl.vertexAttribPointer(
		vPosAttrib,
		2, gl.FLOAT,
		gl.FALSE,
		2 * Float32Array.BYTES_PER_ELEMENT,
		0
	);
	gl.enableVertexAttribArray(vPosAttrib);

  gl.uniform2fv(uniforms.u_resolution, vpDimensions);
  gl.uniform3fv(uniforms.uLight, [0.1, 0.2, 2.0])
  gl.uniform1f(uniforms.uShininess, 2.0);
  gl.uniform1f(uniforms.uDiffuseness, 0.72);

  const randomSeed = Math.random() * 100;
  
  var loop = function () {
	  // Draw
	  gl.clearColor(0.0, 0.0, 0.0, 1.0);
	  gl.clear(gl.DEPTH_BUFFER_BIT | gl.COLOR_BUFFER_BIT);
	  
	  gl.uniform1f(uniforms.u_time, randomSeed + window.performance.now()/1000.0);
	  
	  gl.drawArrays(gl.TRIANGLES, 0, 6);
	  
	  if(isMobile({tablet:true})) return	
	  requestAnimationFrame(loop);
	};
	requestAnimationFrame(loop);

	OnResizeWindow();

	//
	// Event Listeners
	//
	function OnResizeWindow() {
		if (!canvas) {
			return;
		}

		// This maybe not a good idear, just do it for convenient.
		// See more at https://webglfundamentals.org/webgl/lessons/webgl-anti-patterns.html
		canvas.width = window.innerWidth;
		canvas.height = window.outerHeight;

		vpDimensions = [canvas.clientWidth, canvas.clientHeight];

		gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
		if(isMobile({tablet:true})) loop()
	}
}
</script>

<template>
    <canvas id="cnv"></canvas>
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