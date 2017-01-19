Shader "Hidden/BloomLowCost"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_BluredTexture("Blured Texture", 2D) = "white"{}
		_MinValue("MinValue", Range(0, 1)) = 0.8
		_Size("Size", Range(0, 20)) = 10
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always
		GrabPass
		{
			"_OriginalTexture"
		}
		Pass
		{
			Tags{ "Queue" = "Transparent" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct appdata
			{
				float4 vertex : POSITION; 
				float2 uv : TEXCOORD0;
			};
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			sampler2D _MainTex;
			float _MinValue;
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				if (col.x < _MinValue && col.y < _MinValue && col.z < _MinValue)
					col = fixed4(0, 0, 0, 0);
				return col;
			}
			ENDCG
		}
		GrabPass{
				"_LightenMap"
		}
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD1;
			};
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif
				o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;
				return o;
			}
			sampler2D _LightenMap;
			float4 _GrabTexture_TexelSize;
			float _Size;
			fixed4 frag(v2f i) : SV_Target
			{
				half4 sum = half4(0,0,0,0);
				#define GRABPIXEL(weight,kernelx) tex2Dproj( _LightenMap, UNITY_PROJ_COORD(float4(i.uvgrab.x + _GrabTexture_TexelSize.x * kernelx*_Size, i.uvgrab.y, i.uvgrab.z, i.uvgrab.w))) * weight
				sum += GRABPIXEL(0.05, -4.0);
				sum += GRABPIXEL(0.09, -3.0);
				sum += GRABPIXEL(0.12, -2.0);
				sum += GRABPIXEL(0.15, -1.0);
				sum += GRABPIXEL(0.18,  0.0);
				sum += GRABPIXEL(0.15, +1.0);
				sum += GRABPIXEL(0.12, +2.0);
				sum += GRABPIXEL(0.09, +3.0);
				sum += GRABPIXEL(0.05, +4.0);
				return sum;
			}
			ENDCG
		}






		GrabPass{
			Tags{ "LightMode" = "Always" }
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD1;
			};
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif
				o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;
				return o;
			}
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			float _Size;
			fixed4 frag(v2f i) : SV_Target
			{
				half4 sum = half4(0,0,0,0);
				
				#define GRABPIXELY(weight,kernely) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x, i.uvgrab.y + _GrabTexture_TexelSize.y * kernely*_Size, i.uvgrab.z, i.uvgrab.w))) * weight
				//			//G(X) = (1/(sqrt(2*PI*deviation*deviation))) * exp(-(x*x / (2*deviation*deviation)))

				sum += GRABPIXELY(0.05, -4.0);
				sum += GRABPIXELY(0.09, -3.0);
				sum += GRABPIXELY(0.12, -2.0);
				sum += GRABPIXELY(0.15, -1.0);
				sum += GRABPIXELY(0.18,  0.0);
				sum += GRABPIXELY(0.15, +1.0);
				sum += GRABPIXELY(0.12, +2.0);
				sum += GRABPIXELY(0.09, +3.0);
				sum += GRABPIXELY(0.05, +4.0);
				return sum ;
			}
			ENDCG
		}


					

		GrabPass{
			Tags{ "LightMode" = "Always" }
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD1;
			};
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif
				o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;
				return o;
			}
			sampler2D _GrabTexture;
			sampler2D _OriginalTexture;
			sampler2D _LightenMap;
			float _MinValue;
			float _Size;
			fixed4 frag(v2f i) : SV_Target
			{
				half4 light = tex2D(_LightenMap, i.uv);
				half4 blur = tex2D(_GrabTexture,i.uv) ;
				half4 col = tex2D(_OriginalTexture, i.uv);
				if (light.x == 0 && light.y == 0 && light.z == 0)
					return lerp(col, col+blur, blur.x);
				
				return light;
			}
			ENDCG
		}
	}
}
