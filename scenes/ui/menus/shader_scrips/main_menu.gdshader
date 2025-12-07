shader_type canvas_item;

uniform float speed = 0.15;
uniform float density = 60.0;
uniform float brightness = 1.0;
uniform float star_size = 0.015;
uniform float twinkle_strength = 0.2;

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;

    // Scroll horizontally
    uv.x += TIME * speed;

    // Star grid
    vec2 gv = fract(uv * density) - 0.5;
    vec2 id = floor(uv * density);

    float rnd = rand(id);
    vec2 offset = vec2(rnd - 0.5, fract(rnd * 23.1) - 0.5);

    float d = length(gv - offset);
    float star = smoothstep(star_size, 0.0, d);

    // Twinkle effect
    float t = sin(TIME * (3.0 + rnd * 10.0)) * twinkle_strength + 1.0;
    star *= t;

    COLOR = vec4(vec3(star * brightness), 1.0);
}

