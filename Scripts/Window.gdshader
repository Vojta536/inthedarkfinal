shader_type spatial;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_linear_mipmap;
uniform vec4 window_tint  = vec4(0.8, 0.9, 1.0, 0.15); 
uniform float reflection_intensity : hint_range(0.0, 1.0) = 0.1;
uniform float distortion_strength : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    ALBEDO = window_tint.rgb;
    ALPHA = window_tint.a;
    vec2 screen_uv = SCREEN_UV;
    screen_uv += (NORMAL.xy * 0.5 + vec2(0.5)) * distortion_strength;
    vec4 reflection = texture(SCREEN_TEXTURE, screen_uv);
    ALBEDO = mix(ALBEDO, reflection.rgb, reflection_intensity);
}
