attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;

// Part G1: Light per Fragment
varying vec3 pos;
varying vec3 N;

uniform mat4 ModelView;
uniform mat4 Projection;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    pos = (ModelView * vpos).xyz;

    // Part G2: Light per Fragment
    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
