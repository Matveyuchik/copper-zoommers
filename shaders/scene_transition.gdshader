shader_type canvas_item;

// This captures whatever is currently rendering on the screen
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float columns = 32.0;

// Pseudo-random function to vary column melt speeds
float random(float x) {
    return fract(sin(x * 12.9898) * 43758.5453);
}

void fragment() {
    float col_index = floor(UV.x * columns);
    
    // Each column gets a different delay and speed based on a random seed
    float delay = random(col_index);
    float melt_amount = max(0.0, (progress * 1.5) - delay * 0.5);
    
    // Shift the texture coordinates vertically
    vec2 uv = SCREEN_UV;
    uv.y -= melt_amount;
    
    // If the melted texture goes off-screen, show black underneath
    if (uv.y < 0.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        COLOR = texture(screen_texture, uv);
    }
}
