shader_type canvas_item;

// magic inspired shader
uniform vec4 particle_color : source_color = vec4(0.4, 0.8, 1.0, 1.0);
uniform vec4 glow_color : source_color = vec4(0.8, 0.3, 1.0, 1.0);
uniform float particle_speed : hint_range(0.0, 5.0) = 1.0;
uniform float   : hint_range(1.0, 20.0) = 8.0;
uniform float sparkle_intensity : hint_range(0.0, 2.0) = 1.0;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = UV;

    // animated floating particles
    vec2 particle_uv = uv * particle_density;
    particle_uv.y += TIME * particle_speed * 0.3;

    float particles = 0.0;
    for(int i = 0; i < 3; i++) {
        float offset = float(i) * 2.5;
        vec2 p = particle_uv + vec2(offset, offset * 0.7);
        float n = noise(p);

        // make some particle dots
        vec2 cell = fract(p) - 0.5;
        float dist = length(cell);
        float particle = smoothstep(0.15, 0.0, dist) * n;
        particles += particle;
    }

    // shimmer overlay
    float shimmer = noise(uv * 15.0 + TIME * 0.5);
    shimmer = pow(shimmer, 3.0) * sparkle_intensity;

    // make the waves flow
    float wave = sin(uv.x * 8.0 + TIME * 2.0) * cos(uv.y * 8.0 - TIME * 1.5);
    wave = (wave + 1.0) * 0.5;
    wave = pow(wave, 4.0) * 0.3;

    // combine the effects
    vec3 final_color = particle_color.rgb * particles;
    final_color += glow_color.rgb * (shimmer + wave);

    float alpha = particles * 0.6 + shimmer * 0.4 + wave * 0.3;

    COLOR = vec4(final_color, alpha * 0.7);
}