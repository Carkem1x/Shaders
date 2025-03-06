#ifndef CUSTOM_LIGHTING_INCLUDED
#define CUSTOM_LIGHTING_INCLUDED

//Obtine una posicion en el mundo y nos regresa una direccion y color de la luz en Unity
void CalculateMainLight_float(float3 WorldPos, out float3 Direction, out float3 Color, 
            out half DistanceAtten, out half ShadowAtten)
{
    #if SHADERGRAPH_PREVIEW
    Direction = float3(0.5f,0.5f,0);
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;
    #else
    #if SHADOW_SCREEN
        half4 clipPos = TransformWorldToShadowCoord(WorldPos);
        half4 shadowCoord = ComputeScreenPos(clipPos);
    #else
    half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    #endif
    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
    #endif
}
#endif