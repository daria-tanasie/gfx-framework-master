#version 330

// Input
in vec3 world_position;
in vec3 world_normal;

// Uniforms for light properties
uniform vec3 light_direction;
uniform vec3 light_position;
uniform vec3 eye_position;

uniform float material_kd;
uniform float material_ks;
uniform int material_shininess;

// TODO(student): Declare any other uniforms
uniform int is_spot_light;

uniform vec3 object_color;

uniform vec3 point_light_pos[2];
uniform vec3 cut_off;

// Output
layout(location = 0) out vec4 out_color;


void main()
{
    // TODO(student): Define ambient, diffuse and specular light components
    float light = 0.25;


    for (int i = 0; i < 2; i++) {
        float diffuse_light = 0;
        float specular_light = 0;
        vec3 L = normalize( point_light_pos[i] - world_position );
        vec3 V = normalize( eye_position - world_position );
        vec3 H = normalize( L + V );

        diffuse_light = material_kd * max (dot(world_normal,L), 0);

        // It's important to distinguish between "reflection model" and
        // "shading method". In this shader, we are experimenting with the Phong
        // (1975) and Blinn-Phong (1977) reflection models, and we are using the
        // Phong (1975) shading method. Don't mix them up!
        if (diffuse_light > 0)
        {
            specular_light = material_ks * pow(max(dot(world_normal, H), 0), material_shininess);
        }

        // TODO(student): If (and only if) the light is a spotlight, we need to do
        // some additional things.

        // TODO(student): Compute the total light. You can just add the components
        // together, but if you're feeling extra fancy, you can add individual
        // colors to the light components. To do that, pick some vec3 colors that
        // you like, and multiply them with the respective light components.

        float light_att_factor = 0;

        if (is_spot_light == 1) {
            //float cut_off = radians(30.0f);
            float spot_light = dot(-L, light_direction);

            if (spot_light > cos(cut_off)) {
                float spot_light_limit = cos(cut_off);
                float linear_att = (spot_light - spot_light_limit) / (1.0f - spot_light_limit);
                light_att_factor = pow(linear_att, 2);
            }
        } else {
            light_att_factor = 1;   
        }

        float d = distance(point_light_pos[i], world_position);
        float factor = 1 / (d * d);
        light += light_att_factor* factor * (diffuse_light + specular_light);


        // TODO(student): Write pixel out color
    }

            out_color = vec4(object_color * light, 1);

}
