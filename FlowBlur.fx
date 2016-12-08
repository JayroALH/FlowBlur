/*
 *	Author: Jairo Arturo Ledesma Hernández 
 *	Year: 2016
 *	File Name: FlowBlur
 *
 *	V2
 */


//Input texture
sampler InputTexture;

//Input Flow Texture
texture flow;

//Sampler for the flow texture
sampler flow_sampler = sampler_state { Texture = flow; };

//Nesesary for the Vertex shader 3.0 function 
float4x4 MatrixTransform;

//How many samples will it do?
int samples;

//How far will it move each sample
float distance;

//Min Distance
//float minDistance;

//In order to use a pixel shader 3.0 we need a vertex shader 3.0. we cannot mix the 2, so we just declare a simple Vertex Shader 
void VertexShaderFunction(inout float4 color    : COLOR0,
	inout float2 texCoord : TEXCOORD0,
	inout float4 position : SV_Position)
{
	position = mul(position, MatrixTransform);
}



float4 PixelShaderFunction(float2 coords: TEXCOORD0) : COLOR0
{
	//Output Color
	float4 color = float4(0,0,0,1);


	//Current displacement
	float2 displacement = float2(0, 0);

	for (int i = 0; i < samples; i++)
	{
		//Sample Flow map at the original point + the acumulative displacement
		float4 otherColor = tex2D(flow_sampler, coords + displacement);

		//The R channel contains the X information
		//The G channel contains the Y information
		//The B channel contains the lenght information


		//Flowmap comes in the 0,1 range but the displacement should be in the -1 to 1 range. 
		//	So we multply the R and G channels by 2 and then substract 1 from each chanel, this way the R and G channels become a X and Y vector
		float2 direction = (otherColor.rg * 2) - float2(1, 1);

		//Depending on the format of your normal you should invert the x or y directions.

		//if your normal is in DirectX format you should use this line. otherwise just comment it
		direction.y = -direction.y;

		direction.x = -direction.x;

		



		//You could normalize the direction but this causes a lot of artifacts , but if you want to here is the line of code
		//direction = normalize(direction);//Causes artifacts

		//With all the pieces calculated we can just simply calculate the displacement
		//The formula is simple:
		displacement += (direction*distance*otherColor.b);

		//Sample the texture map at this coordinate plus the displacement
		float4 thisColor = tex2D(InputTexture, coords + displacement);

		//Now we just add it to the sum
		color += thisColor*thisColor;//Gamma correction

		//Please note This is using a simple Gamma correction tecnique described in this video https://youtu.be/LKnqECcg6Gw
}

	//Divide by the number of samples to get an average
	color = color / samples;

	//Square root all channels. This is part of the gamma correction mention above 
	color.r = sqrt(color.r);
	color.g = sqrt(color.g);
	color.b = sqrt(color.b);
	color.a = sqrt(color.a);//IDK if nesesary. better safe than sorry. ¯\_(ツ)_/¯

	//Done! Just return the final color
	return color;
}

technique Technique1
{
	pass Pass1
	{
		VertexShader = compile vs_3_0 VertexShaderFunction();
		PixelShader = compile ps_3_0 PixelShaderFunction();
		//This shader will only compile on Pixel Shader 3 and above
	}
}