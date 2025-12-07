shader_type canvas_item;
render_mode unshaded, blend_add;
// orange stars shader
uniform float speed = 0.35;
uniform float density = 35.0;
uniform float intensity = 0.6;
uniform vec4 spark_color : source_color = vec4(1.0, 0.8, 0.4, 1.0);

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;
    uv.x += TIME * speed;

    vec2 cell = floor(uv * density);
    vec2 local = fract(uv * density);

    float rnd = hash(cell);

    float spark = smoothstep(0.1, 0.0, length(local - vec2(0.2, 0.5)));
    spark *= rnd * intensity;

    COLOR = vec4(spark_color.rgb * spark, spark);
}
  