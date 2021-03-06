attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition1;
uniform vec3 LightRGB1;
uniform float LightBrightness1;
uniform float Shininess;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;


    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition1.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct * LightRGB1 * LightBrightness1;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct * LightRGB1 * LightBrightness1;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct * LightRGB1 * LightBrightness1;
    
    if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    // Part F: Light Reduction, values from https://learnopengl.com/Lighting/Light-casters when distance = 20
    float Kc, Kl, Kq, dist, attenuation;
    Kc = 1.0;
    Kl = 0.22;
    Kq = 0.20;
    dist = length(Lvec);
    attenuation = 1.0 / (Kc + Kl * dist + Kq * pow(dist, 2.0));
    color.rgb = globalAmbient + (ambient + diffuse + specular) * attenuation;
    color.a = 1.0;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
