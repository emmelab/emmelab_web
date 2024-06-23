//NAAN

precision lowp float;

uniform float u_time;
uniform vec2 u_resolution;

uniform float uShininess;
uniform float uDiffuseness;
uniform vec3 uLight;

varying vec3 worldNormal;
varying vec3 eyeVector;

#define PI  3.14159265359
#define TWO_PI 6.28318530718

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Quintic interpolation curve
    vec2 u = f*f*f*(f*(f*6.-15.)+10.);
     u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float fbm (in vec2 st) {
  // Initial values
  float value = 0.0;
  float amplitude = .5;
  float frequency = 0.;
  //
  // Loop of octaves
  for (int i = 0; i < 7; i++) {
      value += amplitude * abs(noise(st) * 2.0 - 1.0);
      st *= 2.;
      amplitude *= .5;
  }
  return value;
}

vec3 sat(vec3 rgb, float adjustment) {
  const vec3 W = vec3(0.2125, 0.7154, 0.0721);
  vec3 intensity = vec3(dot(rgb, W));
  return mix(intensity, rgb, adjustment);
}

float specular(vec3 light, float shininess, float diffuseness, vec3 normal) {
  vec3 lightVector = normalize(-light);
  vec3 halfVector = normalize(eyeVector + lightVector);

  float NdotL = dot(normal, lightVector);
  float NdotH =  dot(normal, halfVector);
  float kDiffuse = max(0.0, NdotL);
  float NdotH2 = NdotH * NdotH;

  float kSpecular = pow(NdotH2, shininess);
  return  kSpecular + kDiffuse * diffuseness;
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution;

  uv *= 2.0;
  uv -= 1.0;

  // vec2 p = vec2(0.0) - uv;
  
  float n  = 1.0 - fbm(u_time * 0.01 + uv * 3.0);
  n  = (1.0 - fbm(cos(u_time) * 0.01 - 5.0 + n * uv * 5.0));

  n = smoothstep(0.2, 0.5, n);
  n = 1.0 - n;

  // vec3 luz = vec3( 
  //   cos(u_time * 0.25 + uv.x * PI * 0.5) * 0.5 + 0.5,
  //   n + 0.5,
  //   sin(u_time * 0.25 + uv.y * PI * 0.5) * 0.5 + 0.5
  // );
  
  // luz+= 0.1;
  
  vec3 color = vec3( 
    n//, 
    // noise( n * 1.01 + uv * 2.0 - 0.05),
    // noise( n * 0.78 + uv * 2.0 + 0.32)
  );
  
  
  vec3 normal = worldNormal;
  normal += color * 0.75;
  
  // float specularLight = specular(uLight, uShininess, uDiffuseness, normal);
  // // color = vec3(specularLight);
  // luz = sat(luz, 1.5);
  // color = luz + specularLight;

  color.r *= n * cos(u_time * 0.5 + uv.x * PI ) * 0.5 + 0.5;
  color.g *= n * sin(u_time * 0.5 + uv.y * PI + 0.0001) * 0.5 + 0.5;
  color.b *= cos(u_time * 0.1) * 1.02;
  color = color + vec3(35.0 / 255.0, 37.0 / 255.0, 48.0 / 255.0);
  
  gl_FragColor = vec4(color, 1.0);
}