shader_type canvas_item;
render_mode unshaded;
// subtle background shader
uniform float speed = 0.02;
uniform float strength = 0.35;
uniform vec4 fog_color : source_color = vec4(0.12, 0.08, 0.18, 1.0);

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 4; i++) {
        v += sin(p.x * 3.0) * sin(p.y * 2.0) * a;
        p *= 2.1;
        a *= 0.5;
    }
    return abs(v);
}

void fragment() {
    vec2 uv = UV * 1.2;
    uv += vec2(TIME * speed, TIME * speed * 0.5);

    float m = fbm(uv) * strength;

    COLOR = vec4(fog_color.rgb * m, m);
}
