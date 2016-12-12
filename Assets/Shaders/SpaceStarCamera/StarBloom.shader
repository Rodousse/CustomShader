Shader "Hidden/StarBloom"{
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
		_SunPosition("Position of the sun", vector) = (0, 0, 0, 0)
		_HorizontalBlurIntensity("Horizontal blur intensity", Range(0,500)) = 5.0
		_VerticalBlurIntensity("Vertical blur intensity", Range(0,500)) = 5.0
		_CircleBlurSize("Circle blur size", Range(0,5000)) = 200.0
		_StarColor("Color of the star ", Color) = (1,1,1,1)
        _BumpAmt  ("Distortion", Range (0,128)) = 10
        _MainTex ("Tint Color (RGB)", 2D) = "white" {}
        _BumpMap ("Normalmap", 2D) = "bump" {}
        _Size ("Size", Range(0, 20)) = 10
    }
 
    Category {
 
        // We must be transparent, so other objects are drawn before this one.
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Opaque" }
 
 
        SubShader {
     
            // Horizontal blur
            GrabPass {                    
                Tags { "LightMode" = "Always" }
            }
            Pass {
                Tags { "LightMode" = "Always" }
             
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
             
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
                };
             
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
                };
             
                v2f vert (appdata_t v) {
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
             
                sampler2D _GrabTexture;
				fixed4 _StarColor;
                float4 _GrabTexture_TexelSize;
				float4 _SunPosition;
				float _CircleBlurSize;
                float _Size;
             
                half4 frag( v2f i ) : COLOR {
                    half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
					
					if(length(_SunPosition.xy - i.vertex.xy) < _CircleBlurSize && _SunPosition.x > 0)
					{
						half4 sum = half4(0,0,0,0);
						#define GRABPIXEL(weight,kernelx) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x + _GrabTexture_TexelSize.x * kernelx*_Size, i.uvgrab.y, i.uvgrab.z, i.uvgrab.w))) * weight
						sum += GRABPIXEL(0.05, -4.0);
						sum += GRABPIXEL(0.09, -3.0);
						sum += GRABPIXEL(0.12, -2.0);
						sum += GRABPIXEL(0.15, -1.0);
						sum += GRABPIXEL(0.18,  0.0);
						sum += GRABPIXEL(0.15, +1.0);
						sum += GRABPIXEL(0.12, +2.0);
						sum += GRABPIXEL(0.09, +3.0);
						sum += GRABPIXEL(0.05, +4.0);
						
						sum = lerp(sum, col, length(_SunPosition.xy - i.vertex.xy)/_CircleBlurSize);
						return sum;
					}
					return col;
                }
                ENDCG
            }
            // Vertical blur
            GrabPass {                        
                Tags { "LightMode" = "Always" }
            }
            Pass {
                Tags { "LightMode" = "Always" }
             
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
             
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
                };
             
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
                };
             
                v2f vert (appdata_t v) {
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
             
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
				float4 _SunPosition;
				float _CircleBlurSize;
                float _Size;

                half4 frag( v2f i ) : COLOR {
                    half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                    
					if(length(_SunPosition.xy - i.vertex.xy) < _CircleBlurSize && _SunPosition.x > 0)
					{
						half4 sum = half4(0,0,0,0);
						
						#define GRABPIXEL(weight,kernely) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x, i.uvgrab.y + _GrabTexture_TexelSize.y * kernely*_Size, i.uvgrab.z, i.uvgrab.w))) * weight
						//G(X) = (1/(sqrt(2*PI*deviation*deviation))) * exp(-(x*x / (2*deviation*deviation)))
                 
						sum += GRABPIXEL(0.05, -4.0);
						sum += GRABPIXEL(0.09, -3.0);
						sum += GRABPIXEL(0.12, -2.0);
						sum += GRABPIXEL(0.15, -1.0);
						sum += GRABPIXEL(0.18,  0.0);
						sum += GRABPIXEL(0.15, +1.0);
						sum += GRABPIXEL(0.12, +2.0);
						sum += GRABPIXEL(0.09, +3.0);
						sum += GRABPIXEL(0.05, +4.0);
						sum = lerp(sum, col, length(_SunPosition.xy - i.vertex.xy)/_CircleBlurSize);
						return sum;
					}
					return col;
                }
                ENDCG
            }


			// Large light bloom effect
			GrabPass {                        
                Tags { "LightMode" = "Always" }
            }
            Pass {
                Tags { "LightMode" = "Always" }
             
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
             
                struct appdata_t {
                    float4 vertex : POSITION;
                };
             
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
                };
             
                v2f vert (appdata_t v) {
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
             
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
				float4 _SunPosition;
				fixed4 _StarColor;
				float _CircleBlurSize;
                float _Size;
             
                half4 frag( v2f i ) : COLOR {
                    half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
					if(length(_SunPosition.xy - i.vertex.xy) < _CircleBlurSize && _SunPosition.x > 0)
					{
						
						half4 pixelColor = lerp(_StarColor, col, (length(_SunPosition.xy - i.vertex.xy))/_CircleBlurSize);
						return lerp(pixelColor, col, (length(_SunPosition.xy - i.vertex.xy))/_CircleBlurSize);
					}
					return col;
                }
                ENDCG
            }
            
        }
    }
}