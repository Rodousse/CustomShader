Shader "Custom/TriToonShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor("Main color", Color) = (0, 0.83, 1, 1)
		_ShadowColor("Shadow color", Color) = (0,0,0,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		// No culling or depth
		

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			 
			#include "UnityCG.cginc"
          
			
			//struct SurfaceOutput {
			//	fixed3 Albedo;
			//	fixed3 Normal;
			//	fixed3 Emission;
			//	half Specular;
			//	fixed Gloss;
			//	fixed Alpha;
			//};

				//half4 LightingSimpleLambert (SurfaceOutput s, half3 lightDir, half atten) {
   //           half NdotL = dot (normalize(s.Normal), normalize(lightDir));
			  
   //           half4 c;
			//  //c.rgba = s.Albedo;
			//  if(NdotL < 0.0f)
			//  {
			//	 c.rgb =  _ShadowColor ;
				 
			//  }
			//  else
			//  {
			//	 c.rgb = _BackgroundColor ;
   //           }
			//  //c.a = 1;
			//  //c.rgb = s.Albedo;
			//  //c.rgba = s.Alpha;
			  
			  
   //           c.a = s.Alpha;
			// //c.rgba = (NdotL,NdotL,NdotL,1);
   //           return c;
   //       }

			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				half3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				//UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				//LIGHTING_COORDS(4,5)
			};

			float4 _MainColor;
			float4 _ShadowColor;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half NdotL = dot(worldNormal, _WorldSpaceLightPos0.xyz);
				if(NdotL <= 0.0f)
				{
					o.color.xyz =  _ShadowColor ;
				 
				}
				else
				{
					o.color.xyz= _MainColor ;
				}
				//TRANSFER_VERTEX_TO_FRAGMENT(o);
				//UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				//fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				//fixed atten = LIGHT_ATTENUATION(i);
				//UNITY_APPLY_FOG(i.fogCoord, col);
				return i.color;
			}
			ENDCG
		}
	}
}
