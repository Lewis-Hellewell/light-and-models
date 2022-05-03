attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

// Task G.a - Blinn-Phong per-fragment shading
varying vec4 position;
varying vec3 normal;
varying vec2 texCoord;
varying vec4 color;

varying vec3 fN;
varying vec3 fE;
varying vec3 fL;

varying vec3 fL2;

uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform vec4 LightPosition2;

/* Gourand or per-vertex shading
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess; */

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;

    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;

    // Task I.c - vector to the origin from light 2 
    vec3 Lvec2 = LightPosition2.xyz;

    /* Gourand Shading
    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    
    // Task F - Light reduces with distance (Gourand Shading or per-vertex)
    float lightDistance = 0.1 * length(Lvec);
    color.rgb = globalAmbient + ((ambient + diffuse + specular) / lightDistance);
    color.a = 1.0;
    */


    // Task G.b - Blinn-Phong per-fragment shading
    fE = -pos;
    fL = Lvec;
    fN = (ModelView*vec4(vNormal, 0.0)).xyz;
    fL2 = Lvec2;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
