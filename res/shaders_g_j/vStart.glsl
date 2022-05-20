attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;

// Part G1: Light per Fragment
varying vec3 position;
varying vec3 normal;

uniform mat4 ModelView;
uniform mat4 Projection;

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;

    // Part G2: Light per Fragment
    position = pos;
    normal = vNormal;
}
