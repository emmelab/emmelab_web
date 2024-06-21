varying vec2 vUv;

varying vec3 worldNormal;
varying vec3 eyeVector;

void main()	{

  vUv = uv;

  vec4 worldPos = vec4( position, 1.0 );
  
  vec4 mvPosition = viewMatrix * worldPos;

  gl_Position = projectionMatrix * mvPosition;

  vec3 transformedNormal = normalMatrix * normal;
  worldNormal = normalize(transformedNormal);

  eyeVector = normalize(worldPos.xyz - cameraPosition);
}