Shader "Custom/HologramShader" {
    Properties {
        _Color("Main Color", Color) = (0, 1, 1, 1) // Color principal del holograma (cian por defecto)
        _ScanSpeed("Scan Speed", Float) = 2.0     // Velocidad de la l�nea de escaneo
    }
    SubShader {
        Tags { "RenderType"="Transparent" }       // Hace que el shader sea transparente
        LOD 25

        Pass {
            CGPROGRAM
            // Declaramos que vamos a usar Vertex y Fragment shaders
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"              // Incluye funciones comunes de Unity

            // Estructura de entrada para los datos del v�rtice
            struct appdata {
                float4 vertex : POSITION;         // Posici�n del v�rtice
                float2 uv : TEXCOORD0;            // Coordenadas UV (para texturas)
            };

            // Estructura de salida del Vertex Shader hacia el Fragment Shader
            struct v2f {
                float4 pos : SV_POSITION;         // Posici�n en pantalla
                float2 uv : TEXCOORD0;            // Coordenadas UV
            };

            // Propiedades definidas en el Material
            float4 _Color;                        // Color principal
            float _ScanSpeed;                     // Velocidad de la l�nea de escaneo

            // Vertex Shader: Calcula la posici�n en pantalla y pasa datos al Fragment Shader
            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // Transforma la posici�n del objeto a coordenadas de pantalla
                o.uv = v.uv;                           // Pasa las coordenadas UV sin cambios
                return o;
            }

            // Fragment Shader: Define el color final del p�xel
            fixed4 frag(v2f i) : SV_Target {
                // Tiempo global para animaciones
                float time = _Time.y * _ScanSpeed; // Escala el tiempo seg�n la velocidad de escaneo

                // Genera un patr�n de l�neas basado en las coordenadas UV y el tiempo
                float scanLine = sin((i.uv.y + time) * 30.0); // Oscilaci�n de las l�neas (frecuencia de 30.0)

                // A�ade un efecto de "Fresnel" para simular bordes brillantes
                float fresnel = pow(1.0 - dot(normalize(i.uv - 0.5), float2(0.0, 0.0)), 3.0);

                // Combina el color principal con la l�nea de escaneo y el efecto Fresnel
                fixed4 hologramColor = _Color * (0.5 + 0.5 * scanLine) + fresnel * 0.2;

                return hologramColor; // Devuelve el color final del p�xel
            }
            ENDCG
        }
    }
    FallBack "Transparent/Diffuse" // Shader alternativo si no se soporta HLSL
}