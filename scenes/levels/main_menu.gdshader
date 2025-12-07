shader_type canvas_item;

// script to draw moving stars
uniform float star_density : hint_range(0.5, 5.0) = 2.0;
uniform float star_speed : hint_range(10.0, 200.0) = 60.0;
uniform float dot_size : hint_range(0.0005, 0.01) = 0.002; // pixel dot size
uniform vec3 bg_color : source_color = vec3(0.05, 0.08, 0.18);
uniform vec3 star_color : source_color = vec3(0.9, 0.95, 1.0);

float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

void fragment() {
    vec3 final_color = bg_color;
    
    float num_stars = star_density * 50.0;

    for (float i = 0.0; i < 100.0; i++) {
        if (i >= num_stars) break;

        float star_seed = i * 123.456;
        float start_x = hash(star_seed);
        float start_time = hash(star_seed + 1.0) * 100.0;
        float speed_var = 0.8 + hash(star_seed + 2.0) * 0.4;

        float star_y = mod((TIME * star_speed * 0.001 * speed_var + start_time), 1.2) - 0.2;

        // only draw visible dots
        if (star_y > -0.1 && star_y < 1.1) {
            vec2 pos = vec2(start_x, star_y);

            // a dot is just a small rectangle around pos
            float inside =
                step(abs(UV.x - pos.x), dot_size) *
                step(abs(UV.y - pos.y), dot_size);

            // fade in / out at screen edges
            float alpha = smoothstep(-0.1, 0.02, star_y) *
                          smoothstep(1.1, 0.95, star_y);

            inside *= alpha;

            final_color = mix(final_color, star_color, inside);
        }
    }

    COLOR = vec4(final_color, 1.0);
}
