#include "../ReShade.fxh"
#include "voronoi.hlsl"

uniform float2 level = float2(370., 280.);
uniform float time < source = "framecount"; >;

float3 main(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	//	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;

	float4 color = float4(1., 1., 1., 1.);
    float2 uv = texcoord.xy ;

    // get the cell
    float4 cell = float4(voronoi(uv * level, time / 8.), 1.);

    // cells n.0
    float2 i_uv = floor(uv * level);
    // cells 0.n
    float2 f_uv = frac(uv * level);

    // add the n.0 to the cell so we can divide it
    // (the xy of the cell is its center point on its square)
    cell.xy += i_uv;

    // divide it by the amount of cells per row we want
    // so we get the location of the cells center in screen instead
    // of its center in its own square
    cell.xy /= level;

    // get the textures location with the cells location
    float2 texLoc = float2(cell.xy);
	
    color.rgb = tex2D(ReShade::BackBuffer, texLoc).rgb;

	return float3(color.rgb);
}

technique VoronoiPattern
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = main;
	}
}
