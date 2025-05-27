#version 330

// Input
in vec2 texcoord;

// Uniform properties
uniform sampler2D texture_1;
uniform sampler2D texture_2;
uniform int tex;
// TODO(student): Declare various other uniforms

// Output
layout(location = 0) out vec4 out_color;


void main()
{
    // TODO(student): Calculate the out_color using the texture2D() function.
    vec4 color = texture2D(texture_1, texcoord);
    if (color[3] < 0.5f) {
        discard;
    }

    if (tex == 1) {
        vec4 color2 = texture2D(texture_2, texcoord);
        vec3 col = mix(vec3(color.xyz), vec3(color2.xyz), 0.5f);
        out_color = vec4(col, 1);
    } else {
        out_color = color;
    }

}
