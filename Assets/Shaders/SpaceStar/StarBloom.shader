Shader "Hidden/StarBloom"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SunPosition("Position of the sun", vector) = (0, 0, 0, 0)
		_HorizontalBlurIntensity("Horizontal blur intensity", Range(0,50)) = 5.0
		_VerticalBlurIntensity("Vertical blur intensity", Range(0,50)) = 5.0
		_CircleBlurIntensity("Circle blur intensity", Range(0,50)) = 5.0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				_SunPosition = mul(UNITY_MATRIX_MVP, _SunPosition);
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				
				fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				if(length(_SunPosition - i.vertex) > 100)
					col = 1 - col;
				return col;
			}
			ENDCG
		}
	}
}
