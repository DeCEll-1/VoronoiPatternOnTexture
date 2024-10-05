
#ifdef GL_ES
precision mediump float;
#endif

#iChannel0 "file://TestImage.jpg"

#include "lygia/generative/voronoi.glsl"
// #include "modifiedVoronoi.frag"

const vec2 level = vec2(370., 240.);

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 color = vec4(1.);
    vec2 uv = fragCoord.xy / iResolution.xy;

    // get the cell
    vec4 cell = vec4(voronoi(uv * level, iTime), 1.);

    // cells n.0
    vec2 i_uv = floor(uv * level);
    // cells 0.n
    vec2 f_uv = fract(uv * level);

    // add the n.0 to the cell so we can divide it
    // (the xy of the cell is its center point on its square)
    cell.xy += i_uv;

    // divide it by the amount of cells per row we want
    // so we get the location of the cells center in screen instead
    // of its center in its own square
    cell.xy /= level;

    // get the textures location with the cells location
    vec2 texLoc = vec2(cell.xy);

    color.rgb = texture(iChannel0, texLoc).rgb;

    fragColor = color;
}
