vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

// Part B2: Texture Scaling
uniform float texScale;

// Part G3: Light per Fragment
varying vec3 pos;
varying vec3 N;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec4 LightPosition;
uniform float Shininess;

void main()
{
    // Part G4: Light per Fragment
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

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

    // Part F: Light Reduction, values from https://learnopengl.com/Lighting/Light-casters when distance = 20
    float Kc, Kl, Kq, dist, attenuation;
    Kc = 1.0;
    Kl = 0.22;
    Kq = 0.20;
    dist = length(Lvec);
    attenuation = 1.0 / (Kc + Kl * dist + Kq * pow(dist, 2.0));
    color.rgb = globalAmbient + (ambient + diffuse) * attenuation + specular;
    color.a = 1.0;


    // Part B3: Texture Scaling
    gl_FragColor = color * texture2D( texture, texCoord * texScale );
}
