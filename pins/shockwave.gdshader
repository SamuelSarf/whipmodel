shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float width : hint_range(0.01, 0.3) = 0.1;
uniform vec4 core_color : source_color = vec4(0.8, 0.9, 1.0, 1.0);
uniform vec4 edge_color : source_color = vec4(0.2, 0.4, 1.0, 0.5);
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.02;

void fragment() {
    // Calculate distance from center
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    // Create the wave effect
    float wave_front = smoothstep(progress - width, progress, dist);
    float wave_back = smoothstep(progress, progress + width * 0.5, dist);
    float wave = wave_front * (1.0 - wave_back);
    
    // Add some distortion to make it look more like a shockwave
    vec2 distorted_uv = UV + (UV - center) * distortion_strength * wave;
    
    // Create color gradient from core to edge
    vec4 wave_color = mix(core_color, edge_color, wave_back);
    
    // Apply to output
    COLOR = wave_color * wave;
    
    // Add a subtle glow outside the wave
    float glow = max(0.0, 1.0 - abs(dist - progress) / (width * 2.0));
    COLOR += edge_color * glow * 0.2 * (1.0 - wave);
}