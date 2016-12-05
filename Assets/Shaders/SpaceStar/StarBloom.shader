Shader "Hidden/StarBloom"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SunPosition("Position of the sun", vector) = (0, 0, 0, 0)
		_HorizontalBlurIntensity("Horizontal blur intensity", Range(0,500)) = 5.0
		_VerticalBlurIntensity("Vertical blur intensity", Range(0,50)) = 5.0
		_CircleBlurIntensity("Circle blur intensity", Range(0,50)) = 5.0
		_Size ("Size", Range(0, 20)) = 5
		

	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always
		GrabPass{
			"_GrabTexture"
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"


			float4 _SunPosition;
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 screenPos: TEXCOORD1;
				//float4 sunScreenPos: TEXCOORD2;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				
				
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _GrabTexture;
			float _Size;
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				if(length(_SunPosition.xy - i.vertex.xy) < 200 && _SunPosition.x > 0)
					//col = 1 - col;
				{
					fixed4 sum = (0,0,0,0);
					float2 uc = i.uv;
					int i = 0;
					while(i < 5)
					{
						sum+= tex2D(_GrabTexture, float2(uc.x - float(i), uc.y)) * 1/(i+2);
						sum+= tex2D(_GrabTexture, float2(uc.x + i, uc.y)) * 1/(i+2);
						i+=1;
					}	
					return sum;
					
				}	
				return col;
			}
			ENDCG
		}

		
	}
}
