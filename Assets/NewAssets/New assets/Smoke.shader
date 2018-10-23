Shader "Chris/Environment/Smoke"
{
	Properties
	{
		//_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		//_MainTex ("Particle Texture", 2D) = "white" {}
		//_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Scale("Scale", Range( 0 , 2)) = 0
		_Speed("Speed", Range( -2 , 2)) = 0
	}

	Category 
	{
		SubShader
		{
			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 3.0
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_OUTPUT_STEREO
					
				};
				
				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform sampler2D_float _CameraDepthTexture;
				uniform float _InvFade;
				uniform sampler2D _TextureSample2;
				uniform float _Scale;
				uniform float _Speed;
				uniform sampler2D _TextureSample1;

				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float2 temp_cast_0 = (_Scale).xx;
					float mulTime40 = _Time.y * _Speed;
					float2 panner6 = ( mulTime40 * float2( 0,-0.2 ) + float2( 0,0 ));
					float2 uv29 = i.texcoord.xy * temp_cast_0 + panner6;
					float2 uv22 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					

					fixed4 col = ( tex2D( _TextureSample2, uv29 ) * i.color * tex2D( _TextureSample1, uv22 ) );
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15401
3474;548;1906;968;2413.018;800.0356;2.085757;True;True
Node;AmplifyShaderEditor.RangedFloatNode;1;-1223.576,-359.1596;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;0;0.63;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;40;-710.0933,-147.7379;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-825.2861,-519.8364;Float;False;Property;_Scale;Scale;1;0;Create;True;0;0;False;0;0;0.87;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;-534.9935,-383.0848;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-467.3641,-14.57893;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-292.2429,-488.2894;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;20;283.1854,-175.2155;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;71.61163,-583.5831;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;False;0;a3ca8064a76ece34295b6c3d8c2a652e;fe4d9626bafcd9d47ae562f858871a82;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;115.0144,61.01543;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;f8f49fb916d736847b14fb9f402ec02f;f8f49fb916d736847b14fb9f402ec02f;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-1673.478,180.8105;Float;False;Property;_Distortionspeed;Distortionspeed;4;0;Create;True;0;0;False;0;-0.2577616;1.07;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1281.53,144.8276;Float;False;Property;_Tiling;Tiling;5;0;Create;True;0;0;False;0;1.35;0.63;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;4;-1089.996,291.5345;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;603.2521,8.018833;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-626.8539,330.0145;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1272.519,579.1645;Float;False;Property;_NormalScale;Normal Scale;3;0;Create;True;0;0;False;0;0.5;0.04711895;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-1336.544,256.7413;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-813.6674,177.8813;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;31;1037.022,8.798368;Float;False;True;2;Float;ASEMaterialInspector;0;6;BG/Smoke;0b6a9f8b4f707c74ca64c0be8e590de0;0;0;SubShader 0 Pass 0;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;10;False;-1;False;True;2;False;-1;True;True;True;True;False;0;False;-1;False;True;2;False;-1;True;3;False;-1;False;True;4;Queue=Transparent;IgnoreProjector=True;RenderType=Transparent;PreviewType=Plane;False;0;False;False;False;False;False;False;False;False;False;True;2;0;;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;40;0;1;0
WireConnection;6;1;40;0
WireConnection;29;0;5;0
WireConnection;29;1;6;0
WireConnection;13;1;29;0
WireConnection;12;1;22;0
WireConnection;4;1;2;0
WireConnection;16;0;13;0
WireConnection;16;1;20;0
WireConnection;16;2;12;0
WireConnection;36;0;8;0
WireConnection;2;0;35;0
WireConnection;8;0;34;0
WireConnection;8;1;4;0
WireConnection;31;0;16;0
ASEEND*/
//CHKSM=B63D61748F72313B09F5B0F57F5708DC0309EC70