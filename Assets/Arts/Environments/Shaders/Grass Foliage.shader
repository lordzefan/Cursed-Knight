// Made with Amplify Shader Editor v1.9.1.6
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tobyfredson/Grass Foliage"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.2
		[Header(___________(TFS) GRASS FOLIAGE SHADER___________)][Header(_____________________________________________________)][Header(Texture Maps)][NoScaleOffset]_AlbedoMap("Albedo Map", 2D) = "white" {}
		[NoScaleOffset]_NormalMap("Normal Map", 2D) = "bump" {}
		[NoScaleOffset]_MaskMap("Mask Map", 2D) = "white" {}
		[Toggle(_ALPHAFADEONOFF_ON)] _AlphaFadeOnOff("Alpha Fade On/Off", Float) = 0
		_CutoutAlphalOD("Cutout Alpha lOD", Float) = 1
		_CameraLength("Camera Length", Float) = 0
		_CameraOffset("Camera Offset", Float) = 0
		[Header((Albedo))]_AlbedoColor("Albedo Color", Color) = (1,1,1,0)
		_AlbedoLightness("Albedo Lightness", Range( 0 , 5)) = 1
		[Toggle(_COLORVARIATION_ON)] _ColorVariation("Color Variation", Float) = 0
		_GrassColorVariation("Grass Color Variation", Range( 0 , 5)) = 0.4
		[Header((Normal))]_NormalIntensity("Normal Intensity", Range( -3 , 3)) = 1
		[Toggle(_NORMALBACKFACEFIXBRANCH_ON)] _NormalBackFaceFixBranch("Normal Back Face Fix (Branch)", Float) = 0
		[Toggle]_WolrdUp("Wolrd Up", Float) = 0
		[Header((Specular))]_Specularpower("Specular power", Range( 0 , 1)) = 1
		[Toggle]_SpecularONOff("Specular ON/Off", Float) = 1
		[Header((Smoothness))]_SmoothnessIntensity("Smoothness Intensity", Float) = 1
		[Header((Ambient Occlusion))]_AmbientOcclusionIntensity("Ambient Occlusion Intensity", Range( 0 , 1)) = 1
		[Header((Translucency))]_TranslucencyPower1("Translucency Power", Range( 1 , 10)) = 1
		_TranslucencyRange1("Translucency Range", Float) = 1
		[Toggle]_TranslucencyFluffiness("Translucency Fluffiness", Float) = 1
		[Header(_____________________________________________________)][Header(Wind Settings)][Header((Vertex Offset))]_GlobalWindPower("Global Wind Power", Range( 0 , 1)) = 1
		_WindPower("Wind Power", Range( 0 , 1)) = 1
		_WindSpeed("Wind Speed", Range( 0 , 2)) = 1
		_WindAnglexz("Wind Angle (xz)", Range( 0 , 1)) = 0.6
		_WindAngley("Wind Angle (y)", Range( 0 , 1)) = 0.6
		[Toggle(_WINDONOFF_ON)] _WindOnOff("Wind On/Off", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _WINDONOFF_ON
		#pragma shader_feature_local _NORMALBACKFACEFIXBRANCH_ON
		#pragma shader_feature _COLORVARIATION_ON
		#pragma shader_feature_local _ALPHAFADEONOFF_ON
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			half ASEIsFrontFacing : VFACE;
			float eyeDepth;
		};

		uniform float _GlobalWindPower;
		uniform float _WindAngley;
		uniform float _WindAnglexz;
		uniform float _WindPower;
		uniform float _WindSpeed;
		uniform float _WolrdUp;
		uniform sampler2D _NormalMap;
		uniform float _NormalIntensity;
		uniform sampler2D _AlbedoMap;
		uniform float _GrassColorVariation;
		uniform float _AlbedoLightness;
		uniform float4 _AlbedoColor;
		uniform float _TranslucencyFluffiness;
		uniform float _TranslucencyRange1;
		uniform sampler2D _MaskMap;
		uniform float _TranslucencyPower1;
		uniform float _SpecularONOff;
		uniform float _Specularpower;
		uniform float _SmoothnessIntensity;
		uniform float _AmbientOcclusionIntensity;
		uniform float _CameraLength;
		uniform float _CameraOffset;
		uniform float _CutoutAlphalOD;
		uniform float _Cutoff = 0.2;


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

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime607 = _Time.y * 0.1;
			float simplePerlin2D542 = snoise( (ase_worldPos*1.0 + float3( ( mulTime607 * float2( -0.5,-0.5 ) ) ,  0.0 )).xy*3.0 );
			simplePerlin2D542 = simplePerlin2D542*0.5 + 0.5;
			float temp_output_549_0 = ( ase_vertex3Pos.y + simplePerlin2D542 );
			float gradientNoise609 = GradientNoise((ase_worldPos*1.0 + float3( ( _Time.y * float2( 0,-0.1 ) ) ,  0.0 )).xy,20.0);
			gradientNoise609 = gradientNoise609*0.5 + 0.5;
			float4 temp_cast_6 = (gradientNoise609).xxxx;
			float temp_output_541_0 = ( ase_vertex3Pos.y * 1.2 );
			float3 appendResult553 = (float3(temp_output_549_0 , ( ( CalculateContrast((-100.0 + (_WindAngley - 0.0) * (100.0 - -100.0) / (1.0 - 0.0)),temp_cast_6) * 0.2 ) + temp_output_541_0 ).r , ase_vertex3Pos.z));
			float4 temp_cast_9 = (gradientNoise609).xxxx;
			float4 appendResult552 = (float4(( ( CalculateContrast((-200.0 + (_WindAnglexz - 0.0) * (200.0 - -200.0) / (1.0 - 0.0)),temp_cast_9) * 0.2 ) + temp_output_541_0 ).r , temp_output_549_0 , ase_vertex3Pos.z , 0.0));
			float4 lerpResult561 = lerp( float4( ase_vertex3Pos , 0.0 ) , ( float4( appendResult553 , 0.0 ) + appendResult552 ) , v.color.g);
			float2 appendResult554 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult555 = (float2(_Time.y , _Time.y));
			float simplePerlin2D560 = snoise( ( appendResult554 + appendResult555 )*_WindSpeed );
			simplePerlin2D560 = simplePerlin2D560*0.5 + 0.5;
			#ifdef _WINDONOFF_ON
				float4 staticSwitch599 = ( ( _GlobalWindPower * ( float4( ase_vertex3Pos , 0.0 ) - lerpResult561 ) ) * ( v.color.g * ( pow( abs( ( v.texcoord.xy.y * 0.5 ) ) , ( 1.0 - (0.0 + (_WindPower - 0.0) * (0.9 - 0.0) / (1.0 - 0.0)) ) ) * simplePerlin2D560 ) ) );
			#else
				float4 staticSwitch599 = float4( 0,0,0,0 );
			#endif
			float4 WindOutput598 = staticSwitch599;
			v.vertex.xyz += WindOutput598.xyz;
			v.vertex.w = 1;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 LocalVertexNormal_Output655 = (( _WolrdUp )?( float3(0,1,0) ):( ase_vertexNormal ));
			v.normal = LocalVertexNormal_Output655;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_NormalMap581 = i.uv_texcoord;
			float3 tex2DNode581 = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap581 ), _NormalIntensity );
			float3 appendResult580 = (float3(tex2DNode581.r , tex2DNode581.g , ( tex2DNode581.b * i.ASEIsFrontFacing )));
			#ifdef _NORMALBACKFACEFIXBRANCH_ON
				float3 staticSwitch632 = appendResult580;
			#else
				float3 staticSwitch632 = tex2DNode581;
			#endif
			float3 NormalMapOutput684 = staticSwitch632;
			o.Normal = NormalMapOutput684;
			float2 uv_AlbedoMap633 = i.uv_texcoord;
			float4 tex2DNode633 = tex2D( _AlbedoMap, uv_AlbedoMap633 );
			float4 break574 = tex2DNode633;
			float4 transform570 = mul(unity_ObjectToWorld,float4( 1,1,1,1 ));
			float dotResult4_g20 = dot( transform570.xy , float2( 12.9898,78.233 ) );
			float lerpResult10_g20 = lerp( 0.9 , 1.15 , frac( ( sin( dotResult4_g20 ) * 43758.55 ) ));
			float4 appendResult586 = (float4(( break574.r * lerpResult10_g20 ) , break574.g , break574.b , 0.0));
			float4 lerpResult576 = lerp( tex2DNode633 , appendResult586 , _GrassColorVariation);
			#ifdef _COLORVARIATION_ON
				float4 staticSwitch630 = lerpResult576;
			#else
				float4 staticSwitch630 = tex2DNode633;
			#endif
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform666 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float dotResult673 = dot( float4( ase_worldViewDir , 0.0 ) , -( float4( ase_worldlightDir , 0.0 ) + ( (( _TranslucencyFluffiness )?( transform666 ):( float4( ase_vertex3Pos , 0.0 ) )) * _TranslucencyRange1 ) ) );
			float2 uv_MaskMap682 = i.uv_texcoord;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float TobyTranslucency683 = ( saturate( dotResult673 ) * tex2D( _MaskMap, uv_MaskMap682 ).b * ase_lightColor.a );
			float TranslucencyIntensity677 = _TranslucencyPower1;
			float4 AlbedoMain641 = ( ( staticSwitch630 * _AlbedoLightness * _AlbedoColor ) * (1.0 + (TobyTranslucency683 - 0.0) * (TranslucencyIntensity677 - 1.0) / (1.0 - 0.0)) );
			o.Albedo = AlbedoMain641.rgb;
			float Specular_Output698 = (( _SpecularONOff )?( ( 0.04 * 1.0 * _Specularpower ) ):( 0.0 ));
			float3 temp_cast_8 = (Specular_Output698).xxx;
			o.Specular = temp_cast_8;
			float2 uv_MaskMap592 = i.uv_texcoord;
			float4 tex2DNode592 = tex2D( _MaskMap, uv_MaskMap592 );
			float SmoothnessOutput685 = ( tex2DNode592.a * _SmoothnessIntensity );
			o.Smoothness = SmoothnessOutput685;
			float AoMap686 = tex2DNode592.g;
			float Ao_Output688 = ( pow( AoMap686 , _AmbientOcclusionIntensity ) * ( 1.5 / ( ( saturate( TobyTranslucency683 ) * TranslucencyIntensity677 ) + 1.5 ) ) );
			o.Occlusion = Ao_Output688;
			o.Alpha = 1;
			float cameraDepthFade588 = (( i.eyeDepth -_ProjectionParams.y - _CameraOffset ) / _CameraLength);
			#ifdef _ALPHAFADEONOFF_ON
				float staticSwitch597 = ( ( 1.0 - cameraDepthFade588 ) * tex2DNode633.a * _CutoutAlphalOD );
			#else
				float staticSwitch597 = tex2DNode633.a;
			#endif
			float GrassDistanceFade591 = staticSwitch597;
			clip( GrassDistanceFade591 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=19106
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;285;0,0;Float;False;True;-1;2;;0;0;StandardSpecular;Tobyfredson/Grass Foliage;False;False;False;False;False;False;False;False;False;False;False;False;True;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.2;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;532;-2288.248,-650.5682;Inherit;False;976.9136;441.9356;Comment;5;691;690;641;639;627;Albedo Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;533;-5621.487,536.4332;Inherit;False;3507.787;827.4147;;37;624;619;618;617;616;615;614;613;612;611;610;609;608;607;606;605;604;603;564;562;561;559;556;553;552;549;547;545;542;541;540;539;538;537;536;535;534;Vertex Wind_Layer A;0,0.7931032,1,1;0;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;534;-4142.089,821.7203;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleNode;535;-3900.398,825.6575;Inherit;False;0.2;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;536;-3940.006,1134.784;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;537;-4180.462,593.5903;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;538;-3748.66,992.3145;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;539;-3936.104,596.1702;Inherit;False;0.2;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;540;-3607.998,866.7045;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleNode;541;-3705.547,981.5755;Inherit;False;1.2;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;542;-4178.888,1086.305;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;543;-3742.873,1431.309;Inherit;False;1617.475;709.0101;;16;626;625;602;601;600;595;594;593;565;563;560;557;555;554;551;544;Vertex Wind_Layer B;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;544;-3439.939,2025.195;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;545;-3519.966,814.2607;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;546;-4746.29,1752.362;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;547;-3494.415,1053.871;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;548;-4718.359,1701.581;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;549;-3523.924,591.0508;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;550;-3948.201,-1162.819;Inherit;False;1289.431;412.6073;Comment;8;622;621;597;591;590;589;588;587;Grass Distance Fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;551;-3453.209,1492.309;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;552;-3205.668,823.5452;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;553;-3199.001,602.675;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;554;-3217.075,1921.143;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;555;-3246.074,2018.144;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;556;-2947.002,668.2149;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;557;-3041.36,1966.428;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;558;-4161.485,-646.4661;Inherit;False;1763.195;1148.129;;26;686;685;684;642;637;636;635;634;633;632;631;630;629;628;620;596;592;585;584;583;582;581;580;579;575;571;Base Inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;559;-3155.87,1119.023;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;560;-2850.907,1757.799;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;561;-2661.995,959.0995;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;562;-2490.967,855.8389;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;563;-2605.63,1657.273;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;564;-2275.605,803.3818;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;565;-2368.5,1532.559;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;566;-2060.822,1049.36;Inherit;False;285;304;Comment;1;567;Final Wind;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;567;-2010.822,1099.36;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;568;-5267.993,-646.1339;Inherit;False;1055.403;552.1744;Comment;10;623;586;578;577;576;574;573;572;570;569;Grass Color Variation;0.7504205,1,0,1;0;0
Node;AmplifyShaderEditor.WireNode;569;-4466.276,-240.8157;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;570;-5202.234,-582.8003;Inherit;False;1;0;FLOAT4;1,1,1,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;571;-3592.48,-185.3231;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;572;-4813.142,-526.7581;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;573;-4447.173,-187.5821;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;574;-5003.145,-470.1408;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FaceVariableNode;575;-3684.887,92.14465;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;576;-4478.814,-475.1623;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;577;-5002.005,-592.6068;Inherit;False;Random Range;-1;;20;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.9;False;3;FLOAT;1.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;578;-5006.803,-238.996;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;579;-3667.563,-424.1219;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;580;-3400.168,-11.62705;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;581;-3860.099,-104.2978;Inherit;True;Property;_NormalMap;Normal Map;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;582;-3534.605,66.84532;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;583;-3844.373,-161.0744;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;584;-3300.4,321.4709;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;585;-3692.703,-504.6169;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;586;-4673.228,-464.0224;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;587;-3909.201,-1111.819;Inherit;False;Property;_CameraLength;Camera Length;6;0;Create;True;0;0;0;False;0;False;0;80;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;588;-3735.775,-1083.876;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;60;False;1;FLOAT;25;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;589;-3492.776,-1079.575;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;590;-3333.161,-991.7396;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;591;-2953.085,-950.4725;Inherit;False;GrassDistanceFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;592;-3860.567,172.5829;Inherit;True;Property;_MaskMap;Mask Map;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;593;-3197.521,1483.967;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;594;-2993.78,1498.835;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;595;-2849.173,1499.073;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;596;-3532.548,389.9265;Inherit;False;Property;_SmoothnessIntensity;Smoothness Intensity;17;1;[Header];Create;True;1;(Smoothness);0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;597;-3187.049,-952.8865;Inherit;False;Property;_AlphaFadeOnOff;Alpha Fade On/Off;4;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;598;-1514.718,1074.476;Inherit;False;WindOutput;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;599;-1730.707,1069.771;Inherit;False;Property;_WindOnOff;Wind On/Off;28;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;600;-3183.933,1723.021;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;601;-3378.493,1723.194;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;602;-3418.171,1623.388;Inherit;False;Constant;_WindGradient;Wind Gradient;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;603;-5340.482,621.5375;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;604;-5159.742,677.545;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;605;-5350.438,1137.443;Inherit;False;Constant;_Vector1;Vector 1;12;0;Create;True;0;0;0;True;0;False;-0.5,-0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleAndOffsetNode;606;-5006.538,745.3923;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;607;-5341.878,1037.07;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;608;-5134.814,1096.756;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;609;-4776.886,589.717;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;610;-5006.048,877.3728;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;611;-4834.599,1069.432;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;612;-5344.997,872.6405;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;613;-5524.525,863.5859;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;614;-4488.461,739.3735;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-200;False;4;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;615;-4495.461,929.3735;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-100;False;4;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;616;-4792.121,947.2775;Inherit;False;Property;_WindAngley;Wind Angle (y);27;0;Create;True;0;0;0;True;0;False;0.6;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;617;-5405.157,718.6279;Inherit;False;Constant;_EdgeFlutterFrequency;Edge Flutter Frequency;14;0;Create;True;0;0;0;True;0;False;0,-0.1;0,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;618;-4793.778,822.1484;Inherit;False;Property;_WindAnglexz;Wind Angle (xz);26;0;Create;True;0;0;0;True;0;False;0.6;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-4841.612,1168.927;Inherit;False;Constant;_FlutterFrequency;Flutter Frequency;24;0;Create;True;0;0;0;True;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;620;-4131.809,-52.32213;Inherit;False;Property;_NormalIntensity;Normal Intensity;12;1;[Header];Create;True;1;(Normal);0;0;False;0;False;1;1;-3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;621;-3638.055,-945.7283;Inherit;False;Property;_CutoutAlphalOD;Cutout Alpha lOD;5;0;Create;True;0;0;0;False;0;False;1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;622;-3907.201,-984.8206;Inherit;False;Property;_CameraOffset;Camera Offset;7;0;Create;True;0;0;0;False;0;False;0;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;623;-4802.349,-315.9103;Inherit;False;Property;_GrassColorVariation;Grass Color Variation;11;0;Create;True;0;0;0;False;0;False;0.4;0.7;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;624;-2576.105,765.3594;Inherit;False;Property;_GlobalWindPower;Global Wind Power;23;1;[Header];Create;True;3;_____________________________________________________;Wind Settings;(Vertex Offset);0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;625;-3162.278,1831.82;Inherit;False;Property;_WindSpeed;Wind Speed;25;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;626;-3682.118,1699.068;Inherit;False;Property;_WindPower;Wind Power;24;1;[Header];Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;627;-1990.99,-600.5682;Inherit;False;257;257;Comment;1;640;Translucency Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;628;-3501.885,-576.5811;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;629;-3481.895,-571.939;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;630;-3468.844,-392.2742;Inherit;False;Property;_ColorVariation;Color Variation;10;0;Create;True;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;631;-3434.765,-570.1169;Inherit;False;Property;_AlbedoColor;Albedo Color;8;1;[Header];Create;True;1;(Albedo);0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;632;-3242.515,-150.9517;Inherit;False;Property;_NormalBackFaceFixBranch;Normal Back Face Fix (Branch);13;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;633;-3881.74,-371.2415;Inherit;True;Property;_AlbedoMap;Albedo Map;1;2;[Header];[NoScaleOffset];Create;True;3;___________(TFS) GRASS FOLIAGE SHADER___________;_____________________________________________________;Texture Maps;0;0;True;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;634;-3490.162,-280.4404;Inherit;False;Property;_AlbedoLightness;Albedo Lightness;9;0;Create;True;0;0;0;True;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;635;-2744.982,15.20418;Inherit;False;TranslucencyPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;636;-2942.917,15.23458;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;637;-3236.169,17.6838;Inherit;False;Property;_TranslucencyPower;Translucency Power;22;1;[Header];Create;True;1;(Translucency);0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;639;-1665.73,-356.7505;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;640;-1940.99,-550.5684;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;641;-1519.298,-342.0554;Inherit;False;AlbedoMain;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;642;-3139.419,-357.0876;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;643;-4241.607,2315.298;Inherit;False;2460.807;1975.002;;5;651;650;646;645;644;Mesh Shading and Lighting;1,0.8000001,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;644;-3745.602,2443.298;Inherit;False;980.2041;235;Flat shading (world up y).;3;655;654;652;Vertex Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;645;-4033.607,2763.297;Inherit;False;2050.612;629.3674;Faux translucency reconstruction.;16;683;682;674;673;672;671;668;667;666;664;662;661;660;659;656;653;Toby Translucency;1,0.9529412,0.3529412,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;646;-3969.606,3531.296;Inherit;False;1928.208;454.9563;Occlude translucency with Ambient occlusion. To occlude the translucency, we need to invert it and use it as an ambient occlusion mask.;3;649;648;647;Ao + Translucency Ao;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;647;-3921.602,3611.297;Inherit;False;811.7209;325.9332;Set the value of "Float One" to more than "1" to fix glowing in shadow.;7;681;680;669;665;663;658;657;Translucency Ao;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;648;-2369.605,3723.296;Inherit;False;274;166;;1;688;Ambient Occlusion_Output;1,0.4,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;649;-3073.604,3627.296;Inherit;False;652.7767;313.01;;5;687;679;676;675;670;Add Ao Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;650;-2641.605,2507.297;Inherit;False;570.9844;166.2852;;2;678;677;Translucency Intensity;0.7490196,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;651;-4145.607,4107.297;Inherit;False;2262.437;100;;0;*Using the Ambient occlusion to mask the translucency!;0.7333333,0.7333333,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;652;-3601.603,2507.297;Inherit;False;Constant;_Vector2;Vector 2;28;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;653;-3985.606,2875.297;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;654;-3377.605,2523.297;Inherit;False;Property;_WolrdUp;Wolrd Up;14;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;655;-3073.604,2523.297;Inherit;False;LocalVertexNormal_Output;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;656;-3249.604,2923.297;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;657;-3521.603,3723.296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;658;-3233.604,3835.296;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;659;-2881.604,3051.297;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;660;-3457.603,3211.296;Inherit;False;Property;_TranslucencyRange1;Translucency Range;20;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;661;-3009.604,2859.297;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;662;-3009.604,3051.297;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;663;-3377.605,3755.296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;664;-3233.604,3147.296;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;665;-3665.603,3691.296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;666;-3777.602,3147.296;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;667;-3985.606,3051.297;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;668;-3553.603,3083.297;Inherit;False;Property;_TranslucencyFluffiness;Translucency Fluffiness;21;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;669;-3521.603,3851.296;Inherit;False;Constant;_One;One;28;0;Create;True;0;0;0;False;0;False;1.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;670;-2705.604,3883.296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;671;-2369.605,3083.297;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;672;-2593.605,2891.297;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;673;-2721.604,2891.297;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;674;-2561.605,3243.296;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;675;-2737.604,3739.296;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;676;-2593.605,3803.296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;677;-2321.605,2555.297;Inherit;False;TranslucencyIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;678;-2625.605,2555.297;Inherit;False;Property;_TranslucencyPower1;Translucency Power;19;1;[Header];Create;True;1;(Translucency);0;0;False;0;False;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;679;-3025.604,3787.296;Inherit;False;Property;_AmbientOcclusionIntensity;Ambient Occlusion Intensity;18;1;[Header];Create;True;1;(Ambient Occlusion);0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;680;-3889.603,3675.296;Inherit;False;683;TobyTranslucency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;681;-3809.603,3787.296;Inherit;False;677;TranslucencyIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;683;-2209.605,3067.297;Inherit;False;TobyTranslucency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;684;-2890.926,-135.8217;Inherit;False;NormalMapOutput;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;685;-3117.79,320.5544;Inherit;False;SmoothnessOutput;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;686;-3399.711,125.5137;Inherit;False;AoMap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;687;-2929.604,3707.296;Inherit;False;686;AoMap;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;688;-2337.605,3787.296;Inherit;False;Ao_Output;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;689;-297.7103,-17.58043;Inherit;False;684;NormalMapOutput;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;690;-2238.248,-585.4092;Inherit;False;683;TobyTranslucency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;691;-2233.115,-443.9175;Inherit;False;677;TranslucencyIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;692;-1812.815,1494.796;Inherit;False;1145.524;454.7844;;7;700;699;697;696;695;694;693;Specular;0.4588235,0.7921569,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;693;-1012.816,1734.796;Inherit;False;292;163;;1;698;Specular_Output;1,0.4,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;694;-1444.815,1606.796;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;695;-1652.815,1670.796;Inherit;False;Constant;_Float2;Float 1;34;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;696;-1700.815,1574.796;Inherit;False;Constant;_Float9;Float 9;8;0;Create;True;0;0;0;False;0;False;0.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;697;-1780.815,1750.796;Inherit;False;Property;_Specularpower;Specular power;15;1;[Header];Create;True;1;(Specular);0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;698;-948.8159,1798.796;Inherit;False;Specular_Output;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;699;-1652.815,1846.796;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;700;-1220.815,1814.796;Inherit;False;Property;_SpecularONOff;Specular ON/Off;16;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;704;-284.8016,73.89374;Inherit;False;698;Specular_Output;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;638;-278.1419,-110.9673;Inherit;False;641;AlbedoMain;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;702;-295.1317,166.2005;Inherit;False;685;SmoothnessOutput;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;701;-249.577,259.6743;Inherit;False;688;Ao_Output;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;703;-297.2073,352.9853;Inherit;False;591;GrassDistanceFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;705;-266.5067,446.874;Inherit;False;598;WindOutput;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;706;-345.9852,537.8179;Inherit;False;655;LocalVertexNormal_Output;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;682;-2705.604,3035.297;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;592;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;285;0;638;0
WireConnection;285;1;689;0
WireConnection;285;3;704;0
WireConnection;285;4;702;0
WireConnection;285;5;701;0
WireConnection;285;10;703;0
WireConnection;285;11;705;0
WireConnection;285;12;706;0
WireConnection;534;1;609;0
WireConnection;534;0;615;0
WireConnection;535;0;534;0
WireConnection;537;1;609;0
WireConnection;537;0;614;0
WireConnection;538;0;536;2
WireConnection;539;0;537;0
WireConnection;540;0;535;0
WireConnection;541;0;536;2
WireConnection;542;0;611;0
WireConnection;542;1;619;0
WireConnection;545;0;539;0
WireConnection;545;1;541;0
WireConnection;546;0;612;3
WireConnection;547;0;540;0
WireConnection;547;1;541;0
WireConnection;548;0;612;1
WireConnection;549;0;538;0
WireConnection;549;1;542;0
WireConnection;552;0;545;0
WireConnection;552;1;549;0
WireConnection;552;2;536;3
WireConnection;553;0;549;0
WireConnection;553;1;547;0
WireConnection;553;2;536;3
WireConnection;554;0;548;0
WireConnection;554;1;546;0
WireConnection;555;0;544;0
WireConnection;555;1;544;0
WireConnection;556;0;553;0
WireConnection;556;1;552;0
WireConnection;557;0;554;0
WireConnection;557;1;555;0
WireConnection;560;0;557;0
WireConnection;560;1;625;0
WireConnection;561;0;536;0
WireConnection;561;1;556;0
WireConnection;561;2;559;2
WireConnection;562;0;536;0
WireConnection;562;1;561;0
WireConnection;563;0;595;0
WireConnection;563;1;560;0
WireConnection;564;0;624;0
WireConnection;564;1;562;0
WireConnection;565;0;559;2
WireConnection;565;1;563;0
WireConnection;567;0;564;0
WireConnection;567;1;565;0
WireConnection;569;0;585;0
WireConnection;571;0;633;0
WireConnection;572;0;574;0
WireConnection;572;1;577;0
WireConnection;573;0;583;0
WireConnection;574;0;578;0
WireConnection;576;0;569;0
WireConnection;576;1;586;0
WireConnection;576;2;623;0
WireConnection;577;1;570;0
WireConnection;578;0;573;0
WireConnection;579;0;576;0
WireConnection;580;0;581;1
WireConnection;580;1;581;2
WireConnection;580;2;582;0
WireConnection;581;5;620;0
WireConnection;582;0;581;3
WireConnection;582;1;575;0
WireConnection;583;0;571;0
WireConnection;584;0;592;4
WireConnection;584;1;596;0
WireConnection;585;0;633;0
WireConnection;586;0;572;0
WireConnection;586;1;574;1
WireConnection;586;2;574;2
WireConnection;588;0;587;0
WireConnection;588;1;622;0
WireConnection;589;0;588;0
WireConnection;590;0;589;0
WireConnection;590;1;628;0
WireConnection;590;2;621;0
WireConnection;591;0;597;0
WireConnection;593;0;551;2
WireConnection;593;1;602;0
WireConnection;594;0;593;0
WireConnection;595;0;594;0
WireConnection;595;1;600;0
WireConnection;597;1;629;0
WireConnection;597;0;590;0
WireConnection;598;0;599;0
WireConnection;599;0;567;0
WireConnection;600;0;601;0
WireConnection;601;0;626;0
WireConnection;604;0;603;0
WireConnection;604;1;617;0
WireConnection;606;0;612;0
WireConnection;606;2;604;0
WireConnection;608;0;607;0
WireConnection;608;1;605;0
WireConnection;609;0;606;0
WireConnection;610;0;612;0
WireConnection;610;2;608;0
WireConnection;611;0;610;0
WireConnection;614;0;618;0
WireConnection;615;0;616;0
WireConnection;628;0;633;4
WireConnection;629;0;633;4
WireConnection;630;1;633;0
WireConnection;630;0;579;0
WireConnection;632;1;581;0
WireConnection;632;0;580;0
WireConnection;635;0;636;0
WireConnection;636;0;637;0
WireConnection;639;0;642;0
WireConnection;639;1;640;0
WireConnection;640;0;690;0
WireConnection;640;4;691;0
WireConnection;641;0;639;0
WireConnection;642;0;630;0
WireConnection;642;1;634;0
WireConnection;642;2;631;0
WireConnection;654;0;653;0
WireConnection;654;1;652;0
WireConnection;655;0;654;0
WireConnection;657;0;665;0
WireConnection;657;1;681;0
WireConnection;658;0;669;0
WireConnection;658;1;663;0
WireConnection;659;0;662;0
WireConnection;662;0;656;0
WireConnection;662;1;664;0
WireConnection;663;0;657;0
WireConnection;663;1;669;0
WireConnection;664;0;668;0
WireConnection;664;1;660;0
WireConnection;665;0;680;0
WireConnection;666;0;667;0
WireConnection;668;0;667;0
WireConnection;668;1;666;0
WireConnection;670;0;658;0
WireConnection;671;0;672;0
WireConnection;671;1;682;3
WireConnection;671;2;674;2
WireConnection;672;0;673;0
WireConnection;673;0;661;0
WireConnection;673;1;659;0
WireConnection;675;0;687;0
WireConnection;675;1;679;0
WireConnection;676;0;675;0
WireConnection;676;1;670;0
WireConnection;677;0;678;0
WireConnection;683;0;671;0
WireConnection;684;0;632;0
WireConnection;685;0;584;0
WireConnection;686;0;592;2
WireConnection;688;0;676;0
WireConnection;694;0;696;0
WireConnection;694;1;695;0
WireConnection;694;2;697;0
WireConnection;698;0;700;0
WireConnection;700;0;699;0
WireConnection;700;1;694;0
ASEEND*/
//CHKSM=41A2F83A083BEBB8321F12C833556BFCE27B62D9