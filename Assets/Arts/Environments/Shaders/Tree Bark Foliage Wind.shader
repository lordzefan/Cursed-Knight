// Made with Amplify Shader Editor v1.9.1.6
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tobyfredson/Tree Bark Foliage Wind"
{
	Properties
	{
		[Header(_____________(TFS) TREE BARK SHADER______________)][Header(_____________________________________________________)][Header(Texture Maps)][NoScaleOffset]_AlbedoMap("Albedo Map", 2D) = "white" {}
		[NoScaleOffset][Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		[NoScaleOffset]_MaskMap("Mask Map", 2D) = "white" {}
		[Header((Tiling and Offset))]_Tiling("Tiling", Vector) = (1,1,0,0)
		_Offset("Offset", Vector) = (1,1,0,0)
		[Header(_____________________________________________________)][Header(Material Settings)][Header((Normal))]_NormalIntensity("Normal Intensity", Range( -3 , 3)) = 1
		[Header((Smoothness))]_Float5("Smoothness", Range( 0 , 1)) = 0
		[Header((Ambient Occlusion))]_Float6("Ambient Occlusion", Range( 0 , 1)) = 0
		[Toggle(_VERTEXAOONOFF_ON)] _VertexAoOnOff("Vertex Ao (On/Off)", Float) = 1
		_VertexAointensity("Vertex Ao intensity", Range( 0 , 1)) = 0
		[Header(_____________________________________________________)][Header(Wind Settings)]_WindDirection("Wind Direction", Range( 1.54 , 1.6)) = 1
		_WorldFrequency("World Frequency", Range( 0 , 1)) = 1
		_BranchBending("Branch Bending", Range( 0 , 10)) = 1
		_BendAmount("Bend Amount", Range( 0 , 1)) = 1
		[Toggle(_WINDONOFF_ON)] _WindOnOff("Wind On/Off", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature_local _WINDONOFF_ON
		#pragma shader_feature_local _VERTEXAOONOFF_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _BranchBending;
		uniform float _WindDirection;
		uniform float _WorldFrequency;
		uniform float _BendAmount;
		uniform sampler2D _NormalMap;
		uniform float2 _Tiling;
		uniform float2 _Offset;
		uniform float _NormalIntensity;
		uniform sampler2D _AlbedoMap;
		uniform sampler2D _MaskMap;
		uniform float _Float5;
		uniform float _Float6;
		uniform float _VertexAointensity;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float clampResult356 = clamp( ase_vertex3Pos.y , -0.9 , 1.2 );
			float clampResult348 = clamp( ase_vertex3Pos.x , -0.3 , 0.3 );
			float clampResult346 = clamp( ase_vertex3Pos.z , -1.5 , 1.5 );
			float clampResult366 = clamp( ( clampResult356 * ( ( clampResult348 * ( clampResult346 * ( 0.25 * (ase_vertex3Pos).x ) ) ) * 0.002 ) ) , -1.0 , 1.0 );
			float3 temp_cast_0 = (( ( 1.0 * clampResult366 ) * _BranchBending )).xxx;
			float3 _Vector0 = float3(0,0,0);
			float2 temp_cast_1 = (_Vector0.y).xx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 transform339 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float2 appendResult369 = (float2(( ( ase_vertex3Pos.y * cos( ( ( ( transform339.x + transform339.z ) * _WorldFrequency ) + _Time.y ) ) ) * _BendAmount ) , _Vector0.y));
			float normalizeResult362 = normalize( transform339.y );
			float clampResult368 = clamp( ( normalizeResult362 * 10.0 ) , 0.0 , 10.0 );
			float2 lerpResult372 = lerp( temp_cast_1 , appendResult369 , clampResult368);
			float3 rotatedValue380 = RotateAroundAxis( float3( 0,0,0 ), float3( lerpResult372 ,  0.0 ), temp_cast_0, _WindDirection );
			#ifdef _WINDONOFF_ON
				float3 staticSwitch398 = rotatedValue380;
			#else
				float3 staticSwitch398 = float3( 0,0,0 );
			#endif
			v.vertex.xyz += staticSwitch398;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord388 = i.uv_texcoord * _Tiling + _Offset;
			float2 TileUVs387 = uv_TexCoord388;
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, TileUVs387 ), _NormalIntensity );
			o.Albedo = tex2D( _AlbedoMap, TileUVs387 ).rgb;
			float4 tex2DNode386 = tex2D( _MaskMap, TileUVs387 );
			o.Smoothness = ( tex2DNode386.a * _Float5 );
			float temp_output_383_0 = pow( abs( tex2DNode386.g ) , _Float6 );
			float blendOpSrc377 = i.vertexColor.r;
			float blendOpDest377 = temp_output_383_0;
			float lerpBlendMode377 = lerp(blendOpDest377,( blendOpSrc377 * blendOpDest377 ),_VertexAointensity);
			#ifdef _VERTEXAOONOFF_ON
				float staticSwitch376 = ( saturate( lerpBlendMode377 ));
			#else
				float staticSwitch376 = temp_output_383_0;
			#endif
			o.Occlusion = staticSwitch376;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=19106
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;Standard;Tobyfredson/Tree Bark Foliage Wind;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;True;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;323;-3227.436,1384.076;Inherit;False;3186.917;647.4363;Comment;25;394;380;372;369;368;365;364;363;362;361;359;358;355;354;352;349;347;344;343;342;339;337;336;335;398;Trunk and Branch Bending;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;324;-2239.525,2110.263;Inherit;False;1970.539;923.8995;Comment;17;373;371;370;367;366;360;353;351;350;345;341;340;329;328;327;326;325;Branch Bending;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;325;-2131.174,2568.794;Inherit;False;318;280;Comment;1;338;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;326;-2058.801,2320.439;Inherit;False;221;209;(z);1;346;Remove this (Z);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;327;-1588.448,2235.949;Inherit;False;221;209;(X);1;348;Set this to control the bending;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;328;-1191.855,2573.566;Inherit;False;212;185;Comment;1;357;Final Rotation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;329;-1324.555,2164.253;Inherit;False;221;209;Comment;1;356;(Y);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;330;-1233.978,317.95;Inherit;False;212;185;Smoothness Output;1;374;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;331;-1257.027,527.9521;Inherit;False;326;193;AO Output;2;384;383;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;332;-1246.583,760.0778;Inherit;False;219;183;Metallic Output;1;375;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;333;-2317.445,416.6908;Inherit;False;698.2522;375.7902;Comment;4;390;389;388;387;Tile UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;334;-1165.934,997.13;Inherit;False;809.1835;350.3906;;4;382;381;377;376;Vertex Ao Switch;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;335;-2342.168,1523.673;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;336;-3166.597,1456.788;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;337;-2154.806,1845.641;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;338;-2083.395,2616.573;Inherit;True;True;False;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;339;-2962.763,1468.337;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;340;-2189.525,2160.264;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-1747.053,2576.716;Inherit;False;Constant;_Float3;Float 3;14;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;342;-2815.766,1747.152;Inherit;False;Property;_WorldFrequency;World Frequency;12;0;Create;True;0;0;0;False;0;False;1;0.08;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;343;-2059.751,2017.224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;344;-2727.882,1521.44;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;-1564.488,2626.27;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;346;-2008.801,2370.439;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1.5;False;2;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;347;-2496.648,1568.787;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;348;-1537.442,2284.943;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.3;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;349;-2495.396,1821.204;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;350;-1399.162,2562.811;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;351;-1288.955,2401.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;352;-2310.306,1685.694;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;353;-1739.522,2725.415;Inherit;False;Constant;_Float7;Float 7;14;0;Create;True;0;0;0;False;0;False;0.002;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;354;-2240.808,1782.221;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;355;-2265.457,1455.632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;356;-1274.555,2214.252;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.9;False;2;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;357;-1141.855,2625.934;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;358;-2024.376,1917.626;Inherit;False;Property;_BendAmount;Bend Amount;14;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;359;-1712.912,1523.807;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;360;-1068.458,2336.417;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;361;-1958.615,1659.805;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;362;-1723.683,1437.902;Inherit;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;363;-1725.185,1714.936;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;364;-1927.859,1487.696;Inherit;False;Constant;_Vector0;Vector 0;14;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;-1526.834,1429.751;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;366;-917.1162,2691.124;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;367;-974.6917,2838.276;Inherit;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;368;-1265.239,1490.135;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;369;-1518.089,1674.499;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-763.979,2903.011;Inherit;False;Property;_BranchBending;Branch Bending;13;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;371;-740.9944,2791.462;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;372;-943.774,1582.183;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;373;-538.7325,2718.897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;374;-1185.977,377.9503;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-1196.583,810.0779;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;376;-610.8496,1062.938;Inherit;False;Property;_VertexAoOnOff;Vertex Ao (On/Off);9;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;377;-806.5105,1099.83;Inherit;False;Multiply;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;378;-1866.243,165.9751;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;379;-2162.555,212.1236;Inherit;False;387;TileUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;380;-626.1525,1456.902;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;381;-1122.935,1245.083;Inherit;False;Property;_VertexAointensity;Vertex Ao intensity;10;0;Create;True;0;0;0;False;0;False;0;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;382;-1014.037,1057.371;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;383;-1070.027,578.9521;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;384;-1211.077,575.1832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;385;-1593.9,101.959;Inherit;True;Property;_NormalMap;Normal Map;1;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;386;-1578.891,315.8586;Inherit;True;Property;_MaskMap;Mask Map;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;387;-1835.654,606.9036;Inherit;False;TileUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;388;-2106.626,496.3086;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;389;-2287.076,637.4063;Float;False;Property;_Offset;Offset;4;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;390;-2295.248,487.7147;Float;False;Property;_Tiling;Tiling;3;1;[Header];Create;True;1;(Tiling and Offset);0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;391;-1879.297,209.5725;Inherit;False;Property;_NormalIntensity;Normal Intensity;5;1;[Header];Create;True;3;_____________________________________________________;Material Settings;(Normal);0;0;False;0;False;1;1;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;392;-1564.334,530.142;Float;False;Property;_Float5;Smoothness;7;1;[Header];Create;False;1;(Smoothness);0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;393;-1567.411,632.9534;Float;False;Property;_Float6;Ambient Occlusion;8;1;[Header];Create;False;1;(Ambient Occlusion);0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;394;-1003.062,1484.637;Inherit;False;Property;_WindDirection;Wind Direction;11;1;[Header];Create;True;2;_____________________________________________________;Wind Settings;0;0;False;0;False;1;1.5678;1.54;1.6;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;395;-1566.251,728.3163;Float;False;Property;_Float4;Metallic;6;1;[Header];Create;False;1;(Metallic);0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;396;-1592.996,-109.3206;Inherit;True;Property;_AlbedoMap;Albedo Map;0;2;[Header];[NoScaleOffset];Create;True;3;_____________(TFS) TREE BARK SHADER______________;_____________________________________________________;Texture Maps;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;398;-293.8137,1452.134;Inherit;False;Property;_WindOnOff;Wind On/Off;15;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
WireConnection;0;0;396;0
WireConnection;0;1;385;0
WireConnection;0;4;374;0
WireConnection;0;5;376;0
WireConnection;0;11;398;0
WireConnection;337;0;335;0
WireConnection;338;0;337;0
WireConnection;339;0;336;0
WireConnection;340;0;335;3
WireConnection;343;0;335;1
WireConnection;344;0;339;1
WireConnection;344;1;339;3
WireConnection;345;0;341;0
WireConnection;345;1;338;0
WireConnection;346;0;340;0
WireConnection;347;0;344;0
WireConnection;347;1;342;0
WireConnection;348;0;343;0
WireConnection;350;0;346;0
WireConnection;350;1;345;0
WireConnection;351;0;348;0
WireConnection;351;1;350;0
WireConnection;352;0;347;0
WireConnection;352;1;349;2
WireConnection;354;0;352;0
WireConnection;355;0;339;2
WireConnection;356;0;335;2
WireConnection;357;0;351;0
WireConnection;357;1;353;0
WireConnection;360;0;356;0
WireConnection;360;1;357;0
WireConnection;361;0;335;2
WireConnection;361;1;354;0
WireConnection;362;0;355;0
WireConnection;363;0;361;0
WireConnection;363;1;358;0
WireConnection;365;0;362;0
WireConnection;365;1;359;0
WireConnection;366;0;360;0
WireConnection;368;0;365;0
WireConnection;369;0;363;0
WireConnection;369;1;364;2
WireConnection;371;0;367;0
WireConnection;371;1;366;0
WireConnection;372;0;364;2
WireConnection;372;1;369;0
WireConnection;372;2;368;0
WireConnection;373;0;371;0
WireConnection;373;1;370;0
WireConnection;374;0;386;4
WireConnection;374;1;392;0
WireConnection;375;0;386;1
WireConnection;375;1;395;0
WireConnection;376;1;383;0
WireConnection;376;0;377;0
WireConnection;377;0;382;1
WireConnection;377;1;383;0
WireConnection;377;2;381;0
WireConnection;378;0;379;0
WireConnection;380;0;373;0
WireConnection;380;1;394;0
WireConnection;380;3;372;0
WireConnection;383;0;384;0
WireConnection;383;1;393;0
WireConnection;384;0;386;2
WireConnection;385;1;378;0
WireConnection;385;5;391;0
WireConnection;386;1;379;0
WireConnection;387;0;388;0
WireConnection;388;0;390;0
WireConnection;388;1;389;0
WireConnection;396;1;379;0
WireConnection;398;0;380;0
ASEEND*/
//CHKSM=CDF6D4644F6D71597A55398BC7B521DD09E908BE