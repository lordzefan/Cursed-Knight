// Made with Amplify Shader Editor v1.9.1.6
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tobyfredson/Toby Standard Shader"
{
	Properties
	{
		[Header(___________TOBY STANDARD SHADER___________)][Header(_____________________________________________________)][Header(Texture Maps)][NoScaleOffset]_AlbedoMap("Albedo Map", 2D) = "white" {}
		[NoScaleOffset]_NormalMap("Normal Map", 2D) = "bump" {}
		[NoScaleOffset]_MetallicAoGloss("Metallic/Ao/Gloss", 2D) = "white" {}
		[Header((Tiling and Offset))]_Tiling("Tiling", Vector) = (1,1,0,0)
		_Offset("Offset", Vector) = (1,1,0,0)
		[Header(_____________________________________________________)][Header(Material Settings)]_NormalIntensity("Normal Intensity", Float) = 1
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_Ao("Ambient Occlusion", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform float2 _Tiling;
		uniform float2 _Offset;
		uniform float _NormalIntensity;
		uniform sampler2D _AlbedoMap;
		uniform sampler2D _MetallicAoGloss;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Ao;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord24 = i.uv_texcoord * _Tiling + _Offset;
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, uv_TexCoord24 ), _NormalIntensity );
			o.Albedo = tex2D( _AlbedoMap, uv_TexCoord24 ).rgb;
			float4 tex2DNode9 = tex2D( _MetallicAoGloss, uv_TexCoord24 );
			o.Metallic = ( tex2DNode9.r * _Metallic );
			o.Smoothness = ( tex2DNode9.a * _Smoothness );
			o.Occlusion = pow( abs( tex2DNode9.g ) , _Ao );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=19106
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;Standard;Tobyfredson/Toby Standard Shader;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-380.5318,152.2534;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;-1426.712,-220.7635;Inherit;False;446.7931;372.0089;Comment;3;24;23;22;Tile UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1215.892,-141.1457;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-378.6681,273.0578;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;19;-387.6128,380.4141;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;18;-261.8474,403.7131;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-705.5752,-178.3384;Inherit;True;Property;_NormalMap;Normal Map;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;7f88e09ccdd263d45ab74a1907c018fb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-709.6246,33.27417;Inherit;True;Property;_MetallicAoGloss;Metallic/Ao/Gloss;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;7789c962a7b31574b8197e96d77603f9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-709.8501,-413.965;Inherit;True;Property;_AlbedoMap;Albedo Map;0;2;[Header];[NoScaleOffset];Create;True;3;___________TOBY STANDARD SHADER___________;_____________________________________________________;Texture Maps;0;0;False;0;False;-1;None;217f2a9aa369d534991f7646ddc3be62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;22;-1396.342,-0.04814887;Float;False;Property;_Offset;Offset;4;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;23;-1404.515,-149.7396;Float;False;Property;_Tiling;Tiling;3;1;[Header];Create;True;1;(Tiling and Offset);0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;4;-705.6759,261.0875;Float;False;Property;_Metallic;Metallic;6;1;[Header];Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-701.3278,356.0981;Float;False;Property;_Smoothness;Smoothness;7;1;[Header];Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-696.3218,448.859;Float;False;Property;_Ao;Ambient Occlusion;8;1;[Header];Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-903.2498,-79.17662;Inherit;False;Property;_NormalIntensity;Normal Intensity;5;1;[Header];Create;True;2;_____________________________________________________;Material Settings;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
WireConnection;0;0;13;0
WireConnection;0;1;17;0
WireConnection;0;3;15;0
WireConnection;0;4;16;0
WireConnection;0;5;18;0
WireConnection;15;0;9;1
WireConnection;15;1;4;0
WireConnection;24;0;23;0
WireConnection;24;1;22;0
WireConnection;16;0;9;4
WireConnection;16;1;5;0
WireConnection;19;0;9;2
WireConnection;18;0;19;0
WireConnection;18;1;11;0
WireConnection;17;1;24;0
WireConnection;17;5;8;0
WireConnection;9;1;24;0
WireConnection;13;1;24;0
ASEEND*/
//CHKSM=64C0D91F39825964301F431B0C34532655851A16