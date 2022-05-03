vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

// Task G.c - Blinn-Phong per-fragment shading
// per-fragment interpolated values from the vertex shader
varying vec3 fN;
varying vec3 fE;
varying vec3 fL;

varying vec3 fL2; // Directional towards origin

uniform mat4 ModelView;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess;

// Light 1
uniform vec4 LightPosition;
uniform vec3 LightColor;
uniform float LightBrightness;

// Task I.c - Light 2
uniform vec4 LightPosition2;
uniform vec3 LightColor2;
uniform float LightBrightness2;

void main()
{
    // Task G.d - Normalize the input lighting vectors
    vec3 N = normalize(fN);
    vec3 E = normalize(fE);
    vec3 L = normalize(fL);
    vec3 L2 = normalize(fL2);

    vec3 H = normalize( L + E );
    vec3 H2 = normalize( L2 + E ); // Halfway for light 2

    // Compute terms in the illumination equation
    vec3 ambient = (LightColor * LightBrightness) * AmbientProduct; // Light 1 ambient
    vec3 ambient2 = (LightColor2 * LightBrightness2) * AmbientProduct; // Light 2 ambient

    float Kd = max(dot(L, N), 0.0);
    vec3 diffuse = Kd * (LightColor * LightBrightness) * DiffuseProduct; // Light 1 diffuse
    float Kd2 = max(dot(L2, N), 0.0);
    vec3 diffuse2 = Kd2 * (LightColor2 * LightBrightness2) * DiffuseProduct; // Light 2 diffuse

    float Ks = pow(max(dot(N, H), 0.0), Shininess);
    vec3 specular = Ks * LightBrightness * SpecularProduct; // Light 1 specular
    float Ks2 = pow(max(dot(N, H2), 0.0), Shininess);
    vec3 specular2 = Ks2 * LightBrightness2 * SpecularProduct; // Light 2 specular

    if (dot(L, N) < 0.0) {
        specular = vec3(0.0, 0.0, 0.0);
    }

    if (dot(L2, N) < 0.0) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    
    // Task F - Light reduces with distance (Gourand Shading or per-vertex)
    float lightDistance = 0.1 * length(fL);
    color.rgb = globalAmbient + ((ambient + diffuse) / lightDistance) + ambient2 + diffuse2; // ambient and diffuse added for second light (no dropoff as directional)
    color.a = 1.0;
    
    // Task H - Specular Highlights (seperated from color)
    gl_FragColor = color * texture2D( texture, texCoord * 2.0 ) + vec4(specular / lightDistance + specular2, 1.0);
}
