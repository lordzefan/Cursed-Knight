// Made with Amplify Shader Editor v1.9.1.6
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tobyfredson/Tree Leaf Foliage Wind"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.32
		[Header(_____________(TFS) TREE LEAF SHADER_______________)][Header(_____________________________________________________)][Header(Texture Maps)][NoScaleOffset]_AlbedoMap("Albedo Map", 2D) = "white" {}
		[NoScaleOffset]_NormalMap("Normal Map", 2D) = "bump" {}
		[NoScaleOffset]_MaskMap("Mask Map", 2D) = "white" {}
		[Header((Albedo))]_AlbedoColor("Albedo Color", Color) = (1,1,1,0)
		_AlbedoLightness("Albedo Lightness", Range( 0 , 5)) = 1
		[Toggle(_COLORVARIATION_ON)] _ColorVariation("Color Variation", Float) = 0
		_LeafColorvariatoion("Leaf Color variatoion", Range( 0 , 5)) = 0.6
		[Toggle(_MOBILESHADINGBACKFACELIGHT_ON)] _MobileShadingBackfaceLight("Mobile Shading (Back face Light)", Float) = 0
		[Header((Normal))]_NormalIntensity("Normal Intensity", Range( -3 , 3)) = 1
		[Toggle(_NORMALBACKFACEFIXBRANCH_ON)] _NormalBackFaceFixBranch("Normal Back Face Fix (Branch)", Float) = 0
		[Header((Smoothness))]_SmoothnessIntensity("Smoothness Intensity", Float) = 1
		[Header((Specular))]_Specularpower("Specular power", Range( 0 , 1)) = 1
		[Toggle]_SpecularONOff("Specular ON/Off", Float) = 1
		[Header((Ambient Occlusion))]_AmbientOcclusion1("Ambient Occlusion", Range( 0 , 1)) = 1
		_VertexAo("Vertex Ao", Range( 0 , 1)) = 0
		[Header((Translucency))]_TranslucencyPower("Translucency Power", Range( 0 , 10)) = 1
		_TranslucencyRange("Translucency Range", Float) = 1
		[Toggle(_TRANSLUCENCYOCCLUSION_ON)] _TranslucencyOcclusion("Translucency Occlusion", Float) = 0
		[Header(_____________________________________________________)][Header(Wind Settings)][Header((Vertex Offset))]_GlobalWindPower("Global Wind Power", Range( 0 , 5)) = 1
		_WindDirection("Wind Direction", Range( 1.54 , 1.6)) = 1
		_WorldFrequency("World Frequency", Range( 0 , 1)) = 1
		_WindPower("Wind Power", Range( 0 , 1)) = 1
		_WindSpeed("Wind Speed", Range( 0 , 2)) = 1
		_WindAngley("Wind Angle (y)", Range( -100 , 100)) = 20
		_BranchBending("Branch Bending", Range( 0 , 10)) = 1
		_BendAmount("Bend Amount", Range( 0 , 1)) = 1
		[Toggle(_WINDONOFF_ON)] _WindOnOff("Wind On/Off", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "DisableBatching" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _WINDONOFF_ON
		#pragma shader_feature_local _MOBILESHADINGBACKFACELIGHT_ON
		#pragma shader_feature_local _NORMALBACKFACEFIXBRANCH_ON
		#pragma shader_feature _COLORVARIATION_ON
		#pragma shader_feature_local _TRANSLUCENCYOCCLUSION_ON
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			half ASEIsFrontFacing : VFACE;
			float4 vertexColor : COLOR;
		};

		uniform float _BranchBending;
		uniform float _WindDirection;
		uniform float _GlobalWindPower;
		uniform float _WindAngley;
		uniform float _WindPower;
		uniform float _WindSpeed;
		uniform float _WorldFrequency;
		uniform float _BendAmount;
		uniform sampler2D _NormalMap;
		uniform float _NormalIntensity;
		uniform sampler2D _AlbedoMap;
		uniform float _LeafColorvariatoion;
		uniform float _AlbedoLightness;
		uniform float4 _AlbedoColor;
		uniform float _VertexAo;
		uniform float _TranslucencyRange;
		uniform sampler2D _MaskMap;
		uniform float _TranslucencyPower;
		uniform float _SpecularONOff;
		uniform float _Specularpower;
		uniform float _SmoothnessIntensity;
		uniform float _AmbientOcclusion1;
		uniform float _Cutoff = 0.32;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		//https://www.shadertoy.com/view/XdXGW8
		float2 GradientNoiseDir( float2 x )
		{
			const float2 k = float2( 0.3183099, 0.3678794 );
			x = x * k + k.yx;
			return -1.0 + 2.0 * frac( 16.0 * k * frac( x.x * x.y * ( x.x + x.y ) ) );
		}
		
		float GradientNoise( float2 UV, float Scale )
		{
			float2 p = UV * Scale;
			float2 i = floor( p );
			float2 f = frac( p );
			float2 u = f * f * ( 3.0 - 2.0 * f );
			return lerp( lerp( dot( GradientNoiseDir( i + float2( 0.0, 0.0 ) ), f - float2( 0.0, 0.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 0.0 ) ), f - float2( 1.0, 0.0 ) ), u.x ),
					lerp( dot( GradientNoiseDir( i + float2( 0.0, 1.0 ) ), f - float2( 0.0, 1.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 1.0 ) ), f - float2( 1.0, 1.0 ) ), u.x ), u.y );
		}


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

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
			float clampResult330 = clamp( ase_vertex3Pos.y , -0.9 , 1.2 );
			float clampResult318 = clamp( ase_vertex3Pos.x , -0.3 , 0.3 );
			float clampResult314 = clamp( ase_vertex3Pos.z , -1.5 , 1.5 );
			float clampResult343 = clamp( ( clampResult330 * ( ( clampResult318 * ( clampResult314 * ( 0.25 * (ase_vertex3Pos).x ) ) ) * 0.002 ) ) , -1.0 , 1.0 );
			float3 temp_cast_0 = (( ( 1.0 * clampResult343 ) * _BranchBending )).xxx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime267 = _Time.y * 0.1;
			float simplePerlin2D284 = snoise( (ase_worldPos*1.0 + float3( ( mulTime267 * float2( -0.5,-0.5 ) ) ,  0.0 )).xy*2.0 );
			simplePerlin2D284 = simplePerlin2D284*0.5 + 0.5;
			float gradientNoise274 = GradientNoise((ase_worldPos*1.0 + float3( ( _Time.y * float2( 0,-0.1 ) ) ,  0.0 )).xy,20.0);
			gradientNoise274 = gradientNoise274*0.5 + 0.5;
			float4 temp_cast_7 = (gradientNoise274).xxxx;
			float4 appendResult301 = (float4(( ase_vertex3Pos.y * simplePerlin2D284 ) , ( ( CalculateContrast(_WindAngley,temp_cast_7) * 0.25 ) + ( ase_vertex3Pos.y * 1.2 ) ).r , ase_vertex3Pos.z , 0.0));
			float4 lerpResult307 = lerp( float4( ase_vertex3Pos , 0.0 ) , appendResult301 , v.color.g);
			float2 appendResult289 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult294 = (float2(_Time.y , _Time.y));
			float simplePerlin2D309 = snoise( ( appendResult289 + appendResult294 )*_WindSpeed );
			simplePerlin2D309 = simplePerlin2D309*0.5 + 0.5;
			float4 FinalWind344 = ( 100.0 * ( ( _GlobalWindPower * ( float4( ase_vertex3Pos , 0.0 ) - lerpResult307 ) ) * ( v.color.g * ( pow( abs( ( v.texcoord.xy.y * 0.5 ) ) , ( 1.0 - (0.0 + (_WindPower - 0.0) * (0.89 - 0.0) / (1.0 - 0.0)) ) ) * simplePerlin2D309 ) ) ) );
			float3 _Vector1 = float3(0,0,0);
			float4 temp_cast_9 = (_Vector1.y).xxxx;
			float4 transform288 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult342 = (float4(( ( ase_vertex3Pos.y * cos( ( ( ( transform288.x + transform288.z ) * _WorldFrequency ) + _Time.y ) ) ) * _BendAmount ) , _Vector1.y , 0.0 , 0.0));
			float normalizeResult329 = normalize( transform288.y );
			float clampResult345 = clamp( ( normalizeResult329 * 10.0 ) , 0.0 , 10.0 );
			float4 lerpResult350 = lerp( temp_cast_9 , appendResult342 , clampResult345);
			float3 rotatedValue440 = RotateAroundAxis( float3( 0,0,0 ), ( FinalWind344 + lerpResult350 ).xyz, temp_cast_0, _WindDirection );
			#ifdef _WINDONOFF_ON
				float3 staticSwitch441 = rotatedValue440;
			#else
				float3 staticSwitch441 = float3( 0,0,0 );
			#endif
			float3 TrunkPivotBend439 = staticSwitch441;
			v.vertex.xyz += TrunkPivotBend439;
			v.vertex.w = 1;
			float3 ase_vertexNormal = v.normal.xyz;
			#ifdef _MOBILESHADINGBACKFACELIGHT_ON
				float3 staticSwitch449 = float3(0,1,0);
			#else
				float3 staticSwitch449 = ase_vertexNormal;
			#endif
			v.normal = staticSwitch449;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_NormalMap386 = i.uv_texcoord;
			float3 tex2DNode386 = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap386 ), _NormalIntensity );
			float3 appendResult367 = (float3(tex2DNode386.r , tex2DNode386.g , ( tex2DNode386.b * i.ASEIsFrontFacing )));
			#ifdef _NORMALBACKFACEFIXBRANCH_ON
				float3 staticSwitch372 = appendResult367;
			#else
				float3 staticSwitch372 = tex2DNode386;
			#endif
			float3 NormalOutput402 = staticSwitch372;
			o.Normal = NormalOutput402;
			float2 uv_AlbedoMap426 = i.uv_texcoord;
			float4 tex2DNode426 = tex2D( _AlbedoMap, uv_AlbedoMap426 );
			float4 break382 = tex2DNode426;
			float4 transform394 = mul(unity_ObjectToWorld,float4( 1,1,1,1 ));
			float dotResult4_g18 = dot( transform394.xy , float2( 12.9898,78.233 ) );
			float lerpResult10_g18 = lerp( 0.9 , 1.15 , frac( ( sin( dotResult4_g18 ) * 43758.55 ) ));
			float4 appendResult368 = (float4(( break382.r * lerpResult10_g18 ) , break382.g , break382.b , 0.0));
			float4 lerpResult363 = lerp( tex2DNode426 , appendResult368 , _LeafColorvariatoion);
			#ifdef _COLORVARIATION_ON
				float4 staticSwitch369 = lerpResult363;
			#else
				float4 staticSwitch369 = tex2DNode426;
			#endif
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 objToWorldDir379 = normalize( mul( unity_ObjectToWorld, float4( ase_vertex3Pos, 0 ) ).xyz );
			float dotResult366 = dot( ase_worldViewDir , -( ase_worldlightDir + ( objToWorldDir379 * _TranslucencyRange ) ) );
			float2 uv_MaskMap593 = i.uv_texcoord;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float TranslucencyBase406 = ( saturate( dotResult366 ) * tex2D( _MaskMap, uv_MaskMap593 ).b * ase_lightColor.a );
			float TranslucencyPower471 = _TranslucencyPower;
			o.Albedo = ( ( staticSwitch369 * _AlbedoLightness * _AlbedoColor * saturate( pow( abs( (i.vertexColor.r*1.0 + 0.1) ) , _VertexAo ) ) ) * (1.0 + (TranslucencyBase406 - 0.0) * (TranslucencyPower471 - 1.0) / (1.0 - 0.0)) ).rgb;
			float Specular_Output618 = (( _SpecularONOff )?( ( 0.04 * 1.0 * _Specularpower ) ):( 0.0 ));
			float3 temp_cast_4 = (Specular_Output618).xxx;
			o.Specular = temp_cast_4;
			float2 uv_MaskMap415 = i.uv_texcoord;
			float SmoothnessOutput403 = ( tex2D( _MaskMap, uv_MaskMap415 ).a * _SmoothnessIntensity * i.ASEIsFrontFacing );
			o.Smoothness = SmoothnessOutput403;
			float2 uv_MaskMap458 = i.uv_texcoord;
			#ifdef _TRANSLUCENCYOCCLUSION_ON
				float staticSwitch465 = ( 1.0 / ( ( saturate( TranslucencyBase406 ) * TranslucencyPower471 ) + 1.0 ) );
			#else
				float staticSwitch465 = 1.0;
			#endif
			float AOOutput461 = ( pow( abs( tex2D( _MaskMap, uv_MaskMap458 ).g ) , _AmbientOcclusion1 ) * staticSwitch465 );
			o.Occlusion = AOOutput461;
			o.Alpha = 1;
			float OpacityMaskOutput359 = tex2DNode426.a;
			clip( OpacityMaskOutput359 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=19106
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;StandardSpecular;Tobyfredson/Tree Leaf Foliage Wind;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.32;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;263;-4363.596,780.4045;Inherit;False;2774.201;826.295;;30;434;321;316;312;307;303;302;301;296;295;293;286;284;283;281;278;277;276;275;274;273;272;271;270;269;268;267;266;265;264;Vertex Wind_Layer A;0,0.7931032,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;264;-4251.859,876.7293;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;265;-4316.533,973.8202;Inherit;False;Constant;_EdgeFlutterFrequency;Edge Flutter Frequency;14;0;Create;True;0;0;0;True;0;False;0,-0.1;0,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldPosInputsNode;266;-4256.374,1127.832;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;267;-4253.255,1292.264;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;-4071.118,932.7369;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;269;-4261.815,1392.635;Inherit;False;Constant;_Vector0;Vector 0;12;0;Create;True;0;0;0;True;0;False;-0.5,-0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleAndOffsetNode;270;-3916.814,1000.584;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;-4071.581,1351.948;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;272;-3716.156,1133.34;Inherit;False;Property;_WindAngley;Wind Angle (y);24;0;Create;True;0;0;0;True;0;False;20;100;-100;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;273;-3926.484,1136.591;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;274;-3690.263,886.9091;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;275;-3429.872,965.3392;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;276;-3729.978,1226.624;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;277;-3186.32,1302.234;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;278;-3677.594,1307.519;Inherit;False;Constant;_FlutterFrequency;Flutter Frequency;21;0;Create;True;0;0;0;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;279;-3106.857,1670.021;Inherit;False;1521.626;702.0196;;16;437;436;435;419;418;417;323;315;309;305;300;294;292;290;289;280;Vertex Wind_Layer B;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;280;-2953.903,2242.856;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;281;-3157.765,967.9821;Inherit;False;0.25;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;282;-3510.669,4039.473;Inherit;False;1970.539;923.8995;Comment;16;353;349;348;346;343;336;327;325;324;320;317;313;308;298;297;291;Branch Bending;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleNode;283;-2954.906,1393.155;Inherit;False;1.2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;284;-3430.399,1227.755;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;285;-3807.766,3109.12;Inherit;False;3032.439;810.6194;Comment;23;441;440;439;355;354;350;347;345;342;340;338;337;335;334;332;329;326;319;311;310;306;304;288;Trunk Pivot Bend;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;286;-2928.613,922.2971;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;287;-3837.595,4046.171;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;288;-3714.802,3471.652;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;289;-2676.906,2159.855;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;290;-2970.002,1862.102;Inherit;False;Constant;_WindGradient;Wind Gradient;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;291;-3402.319,4498.003;Inherit;False;318;280;Comment;1;299;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;292;-2923.04,1720.021;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;293;-2796.186,956.6973;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;294;-2705.906,2256.856;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;295;-2785.065,1180.493;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;296;-2765.562,1400.005;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;297;-3329.946,4249.649;Inherit;False;221;209;(z);1;314;Remove this (Z);1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;298;-3017.192,4505.926;Inherit;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;299;-3354.539,4545.783;Inherit;True;True;False;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;300;-2476.765,1970.734;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;301;-2471.615,1034.405;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;302;-2243.325,1017.853;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;303;-2937.758,884.5706;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;304;-3661.92,3654.337;Inherit;False;Property;_WorldFrequency;World Frequency;21;0;Create;True;0;0;0;False;0;False;1;0.08;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;305;-2501.192,2205.141;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;306;-3522.609,3485.577;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;307;-2184.102,1144.314;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;-2835.633,4555.48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;309;-2310.738,1996.512;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;310;-3290.446,3662.218;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-3303.619,3436.262;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;312;-2223.258,985.67;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;313;-2859.593,4165.159;Inherit;False;221;209;(X);1;318;Set this to control the bending;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;314;-3279.946,4299.649;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1.5;False;2;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;-2065.463,1895.986;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;316;-2001.404,1069.129;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;-2670.307,4492.021;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;318;-2809.593,4215.159;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.3;False;2;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;319;-3080.781,3534.262;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;320;-3010.667,4654.624;Inherit;False;Constant;_Float7;Float 7;14;0;Create;True;0;0;0;False;0;False;0.002;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;321;-1816.299,982.5931;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;322;-1547.944,1234.592;Inherit;False;705.807;416.543;Comment;4;344;339;333;331;Final Wind;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;323;-1814.851,1734.733;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;-2560.099,4330.595;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;325;-2462.999,4502.776;Inherit;False;212;185;Comment;1;328;Final Rotation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosOpNode;326;-2944.347,3535.803;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;327;-2595.699,4093.463;Inherit;False;221;209;Comment;1;330;(Y);1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;328;-2412.999,4555.144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;329;-2731.571,3159.631;Inherit;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;330;-2545.699,4143.46;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.9;False;2;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;331;-1440.819,1505.481;Inherit;False;Constant;_Float0;Float 0;22;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;-2758.228,3440.188;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;333;-1497.944,1284.592;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;334;-2720.798,3245.534;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;335;-2943.192,3763.849;Inherit;False;Property;_BendAmount;Bend Amount;26;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;336;-2339.602,4265.625;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;337;-2474.828,3380.494;Inherit;False;Constant;_Vector1;Vector 1;14;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;338;-2534.721,3151.478;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;339;-1272.868,1397.135;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;340;-2533.413,3567.755;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;341;-3280.066,-480.1826;Inherit;False;2116.803;1137.112;;27;611;402;359;598;403;372;426;600;599;429;377;473;430;428;415;413;404;401;386;384;378;376;371;369;367;365;361;Base Inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;342;-2293.15,3562.402;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;343;-2188.259,4620.333;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;344;-1049.968,1387.999;Inherit;False;FinalWind;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;345;-2273.124,3211.862;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;346;-2245.834,4767.486;Inherit;False;Constant;_Float3;Float 3;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;347;-1966.581,3682.346;Inherit;False;344;FinalWind;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;348;-2039.017,4830.763;Inherit;False;Property;_BranchBending;Branch Bending;25;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;349;-2012.137,4720.672;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;350;-2030.352,3451.78;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;353;-1702.13,4661.576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;354;-1762.419,3562.016;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;355;-2072.336,3367.498;Inherit;False;Property;_WindDirection;Wind Direction;20;0;Create;True;0;0;0;False;0;False;1;1.5678;1.54;1.6;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;357;-2841.219,2431.643;Inherit;False;1626.367;646.2914;Comment;15;406;593;594;592;389;432;471;405;392;387;385;381;379;366;362;Translucency Base;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;360;-4419.239,-488.7567;Inherit;False;1047.931;504.8553;Comment;10;400;398;397;395;394;383;382;370;368;363;Grass Color Variation;0.7504205,1,0,1;0;0
Node;AmplifyShaderEditor.WireNode;361;-2694.127,-403.7635;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NegateNode;362;-2241.492,2681.579;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;363;-3645.004,-319.4577;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;-2671.624,244.9644;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;366;-2095.766,2613.759;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;367;-2517.95,207.8676;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;368;-3839.418,-306.6457;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;369;-2572.948,-178.9293;Inherit;False;Property;_ColorVariation;Color Variation;6;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-3968.538,-158.5335;Inherit;False;Property;_LeafColorvariatoion;Leaf Color variatoion;7;0;Create;True;0;0;0;False;0;False;0.6;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;371;-2118.241,464.9751;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FaceVariableNode;376;-2850.686,161.8911;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;378;-2589.348,-61.21582;Inherit;False;Property;_AlbedoLightness;Albedo Lightness;5;0;Create;True;0;0;0;True;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;379;-2756.723,2687.028;Inherit;False;Object;World;True;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;381;-2766.455,2486.643;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;382;-4169.334,-312.7643;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;383;-3667.133,-85.3607;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;384;-2244.288,372.1873;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;385;-2413.595,2530.283;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;386;-2973.71,-57.34216;Inherit;True;Property;_NormalMap;Normal Map;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-2384.511,2689.573;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;391;-3311.386,-22.30041;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;392;-2517.085,2779.431;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;394;-4368.42,-425.4238;Inherit;False;1;0;FLOAT4;1,1,1,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;395;-4168.191,-435.2303;Inherit;False;Random Range;-1;;18;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.9;False;3;FLOAT;1.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;397;-4206.891,-120.3199;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;398;-3453.797,-72.23004;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;399;-3075.081,2521.509;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;400;-3979.331,-369.3817;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;401;-3055.204,-392.3336;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;404;-2674.666,-171.2077;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FaceVariableNode;413;-2379.029,551.4716;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;415;-3058.282,315.0198;Inherit;True;Property;_MaskMap;Mask Map;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;417;-2325.004,1738.785;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;418;-2694.354,1752.679;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;419;-2471.303,1782.359;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;428;-2546.064,-361.7621;Inherit;False;Property;_AlbedoColor;Albedo Color;4;1;[Header];Create;True;1;(Albedo);0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;430;-2489.11,475.9612;Inherit;False;Property;_SmoothnessIntensity;Smoothness Intensity;11;1;[Header];Create;True;1;(Smoothness);0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;434;-2105.177,982.1667;Inherit;False;Property;_GlobalWindPower;Global Wind Power;19;1;[Header];Create;True;3;_____________________________________________________;Wind Settings;(Vertex Offset);0;0;False;0;False;1;1.2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;435;-3082.313,1956.481;Inherit;False;Property;_WindPower;Wind Power;22;0;Create;True;0;0;0;False;0;False;1;0.89;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;436;-2807.512,1967.891;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.89;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;437;-2622.11,2070.531;Inherit;False;Property;_WindSpeed;Wind Speed;23;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;438;-285.2681,485.4624;Inherit;False;439;TrunkPivotBend;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;439;-976.6633,3445.59;Inherit;False;TrunkPivotBend;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;440;-1508.186,3493.948;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;441;-1208.565,3465.835;Inherit;False;Property;_WindOnOff;Wind On/Off;27;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;447;-461.9133,602.1975;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;450;-3611.781,5027.887;Inherit;False;1150.114;430.6915;Custom Translucency Occlusion;9;469;468;467;466;465;464;463;462;460;Tobyfredson TAO;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;451;-1680.086,5246.992;Inherit;False;274;166;Comment;1;461;AO Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;459;-2124.694,5197.476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;462;-3225.822,5284.975;Inherit;False;Constant;_One;One;28;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;463;-3080.501,5224.167;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;464;-2936.854,5295.256;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;466;-2940.912,5169.215;Inherit;False;Constant;_TAO;TAO;22;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;467;-3226.394,5163.167;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;468;-3356.588,5100.587;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;473;-2030.144,-390.4501;Inherit;False;784.5179;428.8177;Comment;4;477;476;475;474;Albedo Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;474;-1732.885,-340.4501;Inherit;False;257;257;Comment;1;478;Translucency Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;377;-2263.179,-163.2464;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;429;-3251.745,113.5353;Inherit;False;Property;_NormalIntensity;Normal Intensity;9;1;[Header];Create;True;1;(Normal);0;0;False;0;False;1;1;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;424;-344.2806,127.1718;Inherit;False;403;SmoothnessOutput;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;389;-2758.584,2858.001;Inherit;False;Property;_TranslucencyRange;Translucency Range;17;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;594;-1589.279,2755.081;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;599;-2664.221,-36.62254;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;600;-2490.478,34.70321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;423;-331.9569,295.8731;Inherit;False;359;OpacityMaskOutput;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;470;-2344.407,5312.997;Inherit;False;Property;_AmbientOcclusion1;Ambient Occlusion;14;1;[Header];Create;True;1;(Ambient Occlusion);0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;456;-2017.41,5274.379;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;465;-2790.636,5182.761;Inherit;False;Property;_TranslucencyOcclusion;Translucency Occlusion;18;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;453;-2397.731,5388.16;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;426;-2960.128,-359.7853;Inherit;True;Property;_AlbedoMap;Albedo Map;1;2;[Header];[NoScaleOffset];Create;True;3;_____________(TFS) TREE LEAF SHADER_______________;_____________________________________________________;Texture Maps;0;0;True;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;372;-2367.497,128.3277;Inherit;False;Property;_NormalBackFaceFixBranch;Normal Back Face Fix (Branch);10;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;610;-440.5911,771.9622;Inherit;False;Constant;_Vector2;Vector 2;31;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;449;-223.6311,651.9922;Inherit;False;Property;_MobileShadingBackfaceLight;Mobile Shading (Back face Light);8;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;593;-1966.985,2698.489;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;415;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;406;-1426.383,2764.089;Inherit;False;TranslucencyBase;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;403;-2032.099,465.5828;Inherit;False;SmoothnessOutput;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;598;-2089.748,36.61229;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;359;-1974.825,196.1452;Inherit;False;OpacityMaskOutput;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;402;-1966.237,81.30786;Inherit;False;NormalOutput;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;478;-1682.885,-290.4504;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;475;-1428.485,-91.72424;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;611;-2121.472,-50.36935;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;612;-2310.65,-1039.78;Inherit;False;1145.524;454.7844;;7;620;619;617;616;615;614;613;Specular;0.4588235,0.7921569,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;613;-1510.651,-799.7795;Inherit;False;292;163;;1;618;Specular_Output;1,0.4,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;614;-1942.65,-927.7794;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;615;-2150.65,-863.7795;Inherit;False;Constant;_Float4;Float 1;34;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;616;-2198.65,-959.7794;Inherit;False;Constant;_Float9;Float 9;8;0;Create;True;0;0;0;False;0;False;0.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;617;-2278.65,-783.7795;Inherit;False;Property;_Specularpower;Specular power;12;1;[Header];Create;True;1;(Specular);0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;618;-1446.651,-735.7795;Inherit;False;Specular_Output;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-2150.65,-687.7795;Inherit;False;Constant;_Float5;Float 3;20;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;620;-1718.65,-719.7795;Inherit;False;Property;_SpecularONOff;Specular ON/Off;13;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;591;-362.0406,29.40575;Inherit;False;618;Specular_Output;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;421;-377.4346,-53.122;Inherit;False;402;NormalOutput;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;621;-230.9491,-121.3013;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;592;-1802.471,2885.275;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;405;-1805.74,2615.415;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;471;-2213.026,2906.44;Inherit;False;TranslucencyPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;460;-3577.153,5102.653;Inherit;False;406;TranslucencyBase;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-3574.477,5226.082;Inherit;False;471;TranslucencyPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;477;-1988.01,-204.7994;Inherit;False;471;TranslucencyPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;476;-1980.144,-325.291;Inherit;False;406;TranslucencyBase;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;432;-2518.807,2920.076;Inherit;False;Property;_TranslucencyPower;Translucency Power;16;1;[Header];Create;True;1;(Translucency);0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;425;-294.7817,210.4353;Inherit;False;461;AOOutput;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;458;-2429.664,5076.195;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;415;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;452;-1829.764,5335.915;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;461;-1621.703,5312.501;Inherit;False;AOOutput;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;631;-3629.448,315.6218;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;629;-3760.611,266.3294;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;630;-3956.95,214.1968;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;622;-4370.318,69.00517;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;632;-4177.872,119.9967;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;623;-4163.72,407.5041;Inherit;False;Property;_VertexAo;Vertex Ao;15;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
WireConnection;0;0;621;0
WireConnection;0;1;421;0
WireConnection;0;3;591;0
WireConnection;0;4;424;0
WireConnection;0;5;425;0
WireConnection;0;10;423;0
WireConnection;0;11;438;0
WireConnection;0;12;449;0
WireConnection;268;0;264;0
WireConnection;268;1;265;0
WireConnection;270;0;266;0
WireConnection;270;2;268;0
WireConnection;271;0;267;0
WireConnection;271;1;269;0
WireConnection;273;0;266;0
WireConnection;273;2;271;0
WireConnection;274;0;270;0
WireConnection;275;1;274;0
WireConnection;275;0;272;0
WireConnection;276;0;273;0
WireConnection;281;0;275;0
WireConnection;283;0;277;2
WireConnection;284;0;276;0
WireConnection;284;1;278;0
WireConnection;286;0;277;0
WireConnection;288;0;266;0
WireConnection;289;0;266;1
WireConnection;289;1;266;3
WireConnection;293;0;277;2
WireConnection;293;1;284;0
WireConnection;294;0;280;0
WireConnection;294;1;280;0
WireConnection;295;0;281;0
WireConnection;295;1;283;0
WireConnection;299;0;287;0
WireConnection;300;0;436;0
WireConnection;301;0;293;0
WireConnection;301;1;295;0
WireConnection;301;2;277;3
WireConnection;302;0;286;0
WireConnection;303;0;277;0
WireConnection;305;0;289;0
WireConnection;305;1;294;0
WireConnection;306;0;288;1
WireConnection;306;1;288;3
WireConnection;307;0;302;0
WireConnection;307;1;301;0
WireConnection;307;2;296;2
WireConnection;308;0;298;0
WireConnection;308;1;299;0
WireConnection;309;0;305;0
WireConnection;309;1;437;0
WireConnection;311;0;306;0
WireConnection;311;1;304;0
WireConnection;312;0;303;0
WireConnection;314;0;287;3
WireConnection;315;0;417;0
WireConnection;315;1;309;0
WireConnection;316;0;312;0
WireConnection;316;1;307;0
WireConnection;317;0;314;0
WireConnection;317;1;308;0
WireConnection;318;0;287;1
WireConnection;319;0;311;0
WireConnection;319;1;310;2
WireConnection;321;0;434;0
WireConnection;321;1;316;0
WireConnection;323;0;296;2
WireConnection;323;1;315;0
WireConnection;324;0;318;0
WireConnection;324;1;317;0
WireConnection;326;0;319;0
WireConnection;328;0;324;0
WireConnection;328;1;320;0
WireConnection;329;0;288;2
WireConnection;330;0;287;2
WireConnection;332;0;277;2
WireConnection;332;1;326;0
WireConnection;333;0;321;0
WireConnection;333;1;323;0
WireConnection;336;0;330;0
WireConnection;336;1;328;0
WireConnection;338;0;329;0
WireConnection;338;1;334;0
WireConnection;339;0;331;0
WireConnection;339;1;333;0
WireConnection;340;0;332;0
WireConnection;340;1;335;0
WireConnection;342;0;340;0
WireConnection;342;1;337;2
WireConnection;343;0;336;0
WireConnection;344;0;339;0
WireConnection;345;0;338;0
WireConnection;349;0;346;0
WireConnection;349;1;343;0
WireConnection;350;0;337;2
WireConnection;350;1;342;0
WireConnection;350;2;345;0
WireConnection;353;0;349;0
WireConnection;353;1;348;0
WireConnection;354;0;347;0
WireConnection;354;1;350;0
WireConnection;361;0;426;0
WireConnection;362;0;387;0
WireConnection;363;0;383;0
WireConnection;363;1;368;0
WireConnection;363;2;370;0
WireConnection;365;0;386;3
WireConnection;365;1;376;0
WireConnection;366;0;385;0
WireConnection;366;1;362;0
WireConnection;367;0;386;1
WireConnection;367;1;386;2
WireConnection;367;2;365;0
WireConnection;368;0;400;0
WireConnection;368;1;382;1
WireConnection;368;2;382;2
WireConnection;369;1;426;0
WireConnection;369;0;391;0
WireConnection;371;0;384;0
WireConnection;379;0;399;0
WireConnection;382;0;397;0
WireConnection;383;0;398;0
WireConnection;384;0;415;4
WireConnection;384;1;430;0
WireConnection;384;2;413;0
WireConnection;386;5;429;0
WireConnection;387;0;381;0
WireConnection;387;1;392;0
WireConnection;391;0;363;0
WireConnection;392;0;379;0
WireConnection;392;1;389;0
WireConnection;395;1;394;0
WireConnection;397;0;404;0
WireConnection;398;0;401;0
WireConnection;399;0;277;0
WireConnection;400;0;382;0
WireConnection;400;1;395;0
WireConnection;401;0;361;0
WireConnection;404;0;426;0
WireConnection;417;0;419;0
WireConnection;417;1;300;0
WireConnection;418;0;292;2
WireConnection;418;1;290;0
WireConnection;419;0;418;0
WireConnection;436;0;435;0
WireConnection;439;0;441;0
WireConnection;440;0;353;0
WireConnection;440;1;355;0
WireConnection;440;3;354;0
WireConnection;441;0;440;0
WireConnection;459;0;458;2
WireConnection;463;0;467;0
WireConnection;463;1;462;0
WireConnection;464;0;462;0
WireConnection;464;1;463;0
WireConnection;467;0;468;0
WireConnection;467;1;469;0
WireConnection;468;0;460;0
WireConnection;377;0;369;0
WireConnection;377;1;378;0
WireConnection;377;2;428;0
WireConnection;377;3;631;0
WireConnection;594;0;405;0
WireConnection;594;1;593;3
WireConnection;594;2;592;2
WireConnection;599;0;426;4
WireConnection;600;0;599;0
WireConnection;456;0;459;0
WireConnection;456;1;470;0
WireConnection;465;1;466;0
WireConnection;465;0;464;0
WireConnection;453;0;465;0
WireConnection;372;1;386;0
WireConnection;372;0;367;0
WireConnection;449;1;447;0
WireConnection;449;0;610;0
WireConnection;406;0;594;0
WireConnection;403;0;371;0
WireConnection;598;0;600;0
WireConnection;359;0;598;0
WireConnection;402;0;372;0
WireConnection;478;0;476;0
WireConnection;478;4;477;0
WireConnection;475;0;611;0
WireConnection;475;1;478;0
WireConnection;611;0;377;0
WireConnection;614;0;616;0
WireConnection;614;1;615;0
WireConnection;614;2;617;0
WireConnection;618;0;620;0
WireConnection;620;0;619;0
WireConnection;620;1;614;0
WireConnection;621;0;475;0
WireConnection;405;0;366;0
WireConnection;471;0;432;0
WireConnection;452;0;456;0
WireConnection;452;1;453;0
WireConnection;461;0;452;0
WireConnection;631;0;629;0
WireConnection;629;0;630;0
WireConnection;629;1;623;0
WireConnection;630;0;632;0
WireConnection;632;0;622;1
ASEEND*/
//CHKSM=073C4D9B2B5FC09CEFC47712E88B5FD517D72282