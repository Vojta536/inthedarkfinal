shader_type spatial;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_linear_mipmap;
// Uniforms allow tweaking the shader properties in the editor.
uniform vec4 window_tint  = vec4(0.8, 0.9, 1.0, 0.15); // Light blue tint.
uniform float reflection_intensity : hint_range(0.0, 1.0) = 0.2;
uniform float distortion_strength : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    // Basic transparency for the window.
    ALBEDO = window_tint.rgb;
    ALPHA = window_tint.a;

    // Reflection simulation using SCREEN_TEXTURE (the scene behind the window).
    vec2 screen_uv = SCREEN_UV;

    // Add distortion to simulate glass imperfections.
    screen_uv += (NORMAL.xy * 0.5 + vec2(0.5)) * distortion_strength;

    // Sample the scene behind the window.
    vec4 reflection = texture(SCREEN_TEXTURE, screen_uv);

    // Blend the reflection with the window's tint.
    ALBEDO = mix(ALBEDO, reflection.rgb, reflection_intensity);
}
