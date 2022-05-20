vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

// Part B2: Texture Scaling
uniform float texScale;

// Part G2: Light per Fragment
varying vec3 pos;
varying vec3 N;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess;

// Part I4: Light 2
uniform vec4 LightPosition1, LightPosition2;
uniform vec3 LightRGB1, LightRGB2;
uniform float LightBrightness1, LightBrightness2;

void main()
{
    // Part G3: Light per Fragment
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition1.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 E = normalize( -pos );   // Direction to the eye/camera

    vec3 L1 = normalize( Lvec );   // Direction to the light source
    vec3 H1 = normalize( L1 + E );  // Halfway vector

    // Compute terms in the illumination equation
    vec3 ambient1 = AmbientProduct * LightRGB1 * LightBrightness1;

    float Kd1 = max( dot(L1, N), 0.0 );
    vec3  diffuse1 = Kd1 * DiffuseProduct * LightRGB1 * LightBrightness1;

    float Ks1 = pow( max(dot(N, H1), 0.0), Shininess );
    vec3 specular1 = Ks1 * SpecularProduct * LightRGB1 * LightBrightness1;
    
    if (dot(L1, N) < 0.0 ) {
	    specular1 = vec3(0.0, 0.0, 0.0);
    } 

    // Part I5: Light 2
    vec3 L2 = normalize( LightPosition2.xyz );   // Direction to the light source
    vec3 H2 = normalize( L2 + E );  // Halfway vector
    
    // Compute terms in the illumination equation
    vec3 ambient2 = AmbientProduct * LightRGB2 * LightBrightness2;

    float Kd2 = max( dot(L2, N), 0.0 );
    vec3  diffuse2 = Kd2 * DiffuseProduct * LightRGB2 * LightBrightness2;

    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    vec3 specular2 = Ks2 * SpecularProduct * LightRGB2 * LightBrightness2;
    
    if (dot(L2, N) < 0.0 ) {
	    specular2 = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    // Light Reduction, values from https://learnopengl.com/Lighting/Light-casters when distance = 20
    float Kc, Kl, Kq, dist, attenuation;
    Kc = 1.0;
    Kl = 0.22;
    Kq = 0.20;
    dist = length(Lvec);
    attenuation = 1.0 / (Kc + Kl * dist + Kq * pow(dist, 2.0));

    // Part H1: Specualar Separation
    // Part I6: Light 2
    color.rgb = globalAmbient + (ambient1 + diffuse1) * attenuation
                   + ambient2 + diffuse2;
    color.a = 1.0;

    // Part H2: Specualar Separation
    // Part I7: Light 2
    // Texture Scaling
    gl_FragColor = color * texture2D( texture, texCoord * texScale )
                      + vec4(specular1 * attenuation + specular2, 1.0);
}
