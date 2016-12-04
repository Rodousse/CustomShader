Shader "Custom/SimpleLight" {
	Properties {
            _MainTex ("Texture", 2D) = "white" {}
			_MainColor("Main color", Color) = (0, 0.83, 1, 1)
			_ShadowColor("Shadow color", Color) = (0,0,0,1)
			_AttenValue("Atten Value", Range(0,1)) = 0.4
			_AttenTresh("Atten treshold", Range(0,1)) = 0.4
			
			 }
        SubShader {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
          #pragma surface surf SimpleLambert
		  #include <UnityCG.cginc>
		  float4 _MainColor;
		  float4 _ShadowColor;
		  float _AttenValue;
		  float _AttenTresh;

          half4 LightingSimpleLambert (SurfaceOutput s, half3 lightDir, half atten) {
              half NdotL = dot (normalize(s.Normal), normalize(lightDir));
			  
              half4 c;
			  //c.rgba = s.Albedo;
			  if(NdotL < 0.0f)
			  {
				 c.rgb =  _ShadowColor * _LightColor0.rgb  ;
				 
			  }
			  else
			  {
				 if(atten >_AttenTresh)
					c.rgb = _MainColor * _LightColor0.rgb * _AttenValue;
				else
					c.rgb = _ShadowColor * _LightColor0.rgb ;
              }
			  //c.rgb = s.Albedo;
			  //c.rgba = s.Alpha;
			  
			  
              //c.a = s.Alpha;
			 //c.rgba = (NdotL,NdotL,NdotL,1);
              return c;
          }
  
        struct Input {
            float2 uv_MainTex;
        };
        
        sampler2D _MainTex;
        
        void surf (Input IN, inout SurfaceOutput o) {
            //o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
        }
        Fallback "Diffuse"
    }