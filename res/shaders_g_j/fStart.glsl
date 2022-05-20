vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

// Part B2: Texture Scaling
uniform float texScale;

// Part G3: Light per Fragment
varying vec3 position;
varying vec3 normal;

uniform mat4 ModelView;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float Shininess;

// Part I4: Light 2
uniform vec4 LightPosition1, LightPosition2;
uniform vec3 LightRGB1, LightRGB2;
uniform float LightBrightness1, LightBrightness2;

// Part J34: Add 3rd Light
uniform vec4 LightPosition3;
uniform vec4 LightDirection3;
uniform vec3 LightRGB3;
uniform float LightBrightness3;
uniform float LightCutOff;

void main()
{
    // Part G4: Light per Fragment
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition1.xyz - position;

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 E = normalize( -position );   // Direction to the eye/camera

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
    vec3 Lvec2 = LightPosition2.xyz - position;

    vec3 L2 = normalize( Lvec2 );   // Direction to the light source
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

    // Part J34: Add 3rd Light
    vec3 Lvec3 = LightPosition3.xyz - position;

    vec3 L3 = normalize( Lvec3 );   // Direction to the light source
    vec3 H3 = normalize( L3 + E );  // Halfway vector
    vec3 S3 = normalize( LightDirection3.xyz ); // Direction from spotlight
    
    vec3 ambient3, diffuse3, specular3;
    
    float theta = dot(L3, S3);
    if (theta > LightCutOff){
        // Compute terms in the illumination equation
        ambient3 = AmbientProduct * LightRGB3 * LightBrightness3;

        float Kd3 = max( dot(L3, N), 0.0 );
        diffuse3 = Kd3 * DiffuseProduct * LightRGB3 * LightBrightness3;

        float Ks3 = pow( max(dot(N, H3), 0.0), Shininess );
        specular3 = Ks3 * SpecularProduct * LightRGB3 * LightBrightness3;
        
        if (dot(L3, N) < 0.0 ) {
            specular3 = vec3(0.0, 0.0, 0.0);
        }
    } else {
        ambient3 = vec3(0.0, 0.0, 0.0);
        diffuse3 = vec3(0.0, 0.0, 0.0);
        specular3 = vec3(0.0, 0.0, 0.0);
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

    // Testing spotlight
    // ambient1 = vec3(0.0, 0.0, 0.0);
    // diffuse1 = vec3(0.0, 0.0, 0.0);
    // specular1 = vec3(0.0, 0.0, 0.0);
    // ambient2 = vec3(0.0, 0.0, 0.0);
    // diffuse2 = vec3(0.0, 0.0, 0.0);
    // specular2 = vec3(0.0, 0.0, 0.0);

    // Part H1: Specualar Separation
    // Part I6: Light 2
    // Part J35: Add 3rd Light
    color.rgb = globalAmbient + (ambient1 + diffuse1) * attenuation
                   + ambient2 + diffuse2
                   + ambient3 + diffuse3;
    color.a = 1.0;

    // Part H2: Specualar Separation
    // Part I7: Light 2
    // Part J36: Add 3rd Light
    // Texture Scaling
    gl_FragColor = color * texture2D( texture, texCoord * texScale )
                      + vec4(specular1 * attenuation
                      + specular2
                      + specular3, 1.0);
}
