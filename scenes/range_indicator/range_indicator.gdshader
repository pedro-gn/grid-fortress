shader_type canvas_item;

// Settings you can change in the Inspector
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float width : hint_range(0.0, 0.5) = 0.05; // Thickness of the border
uniform float softness : hint_range(0.0, 0.1) = 0.005; // Anti-aliasing for smooth edges

void fragment() {
    // 1. Get distance from center (UV is 0.0 to 1.0, so center is 0.5)
    float dist = distance(UV, vec2(0.5));
    
    // 2. Define the Outer Circle (at radius 0.5)
    // We use smoothstep for a nice soft edge instead of a jagged pixelated one
    float outer_circle = smoothstep(0.5, 0.5 - softness, dist);
    
    // 3. Define the Inner Circle (The hole)
    // The hole radius is 0.5 minus the width
    float inner_circle = smoothstep(0.5 - width, 0.5 - width - softness, dist);
    
    // 4. Subtract the inner circle from the outer circle
    float ring = outer_circle - inner_circle;
    
    // 5. Apply Output
    COLOR = color;
    COLOR.a *= ring; // Uses the ring shape as the alpha mask
}