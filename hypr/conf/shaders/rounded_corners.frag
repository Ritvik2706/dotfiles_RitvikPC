#version 300 es
precision mediump float;

in vec2 v_texcoord;        // provided by Hyprland
uniform sampler2D tex;     // the rendered frame
out vec4 fragColor;

// === Tweak these ===
// Set to your actual mode height (e.g., 1600 for 2560x1600)
const float SCREEN_HEIGHT_PX = 1600.0;

// Corner radius in pixels (e.g., 40 px)
const float RADIUS_PX = 18.0;

// Anti-alias width in pixels (1–2 gives a soft edge)
const float AA_PX = 1.0;
// ===================

void main() {
    vec2 uv = v_texcoord;

    // Convert pixel measures to UV (0..1) using screen height
    float r  = RADIUS_PX / SCREEN_HEIGHT_PX;
    float aa = AA_PX     / SCREEN_HEIGHT_PX;

    // Fold into top-left quadrant for a single-corner test
    vec2 q = vec2(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));

    // Distance from the corner arc center
    float dist = distance(q, vec2(r, r));

    // Only consider the r×r corner square
    float inCornerQuad = step(q.x, r) * step(q.y, r);

    // Smooth mask: 0 inside the arc, ~1 outside it (with aa smoothing)
    float mask = inCornerQuad * smoothstep(r - aa, r + aa, dist);

    // Mix original frame with black using the mask
    vec4 col = texture(tex, uv);
    fragColor = mix(col, vec4(0.0, 0.0, 0.0, 1.0), mask);
}

