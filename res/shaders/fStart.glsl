varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

// Part B2: Texture Scaling
uniform float texScale;

void main()
{
    // Part B3: Texture Scaling
    gl_FragColor = color * texture2D( texture, texCoord * texScale );
}
