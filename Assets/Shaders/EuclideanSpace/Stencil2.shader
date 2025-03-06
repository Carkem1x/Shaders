Shader"Custom/Stencil2"
{
    Properties
    {
       [IntRange] _StencilID ("Stencil ID", Range(0,255)) = 0
    }
    SubShader{
        
        Tags{
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeLine"
        }

        Pass{ //Configuracion de Renderizacion
         
            Blend Zero One //El objeto hace que sea invisible
            ZWrite Off //No bloquear objeto detas de el

            Stencil
            {
                Ref[_StencilID]
                Comp Always
                Pass Replace
                Fail keep
            }
        }
    }
    
}
