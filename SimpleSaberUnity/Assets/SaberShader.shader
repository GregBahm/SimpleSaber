Shader "Unlit/SaberShader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _BaseColor("Base Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 100

        Pass
        {
            Blend One One
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                half3 viewDir : VIEWDIR;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            half4 _Color;
            half4 _BaseColor;

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = v.normal;
                o.viewDir = ObjSpaceViewDir(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                i.viewDir = normalize(i.viewDir);
            i.normal = normalize(i.normal);
                float fresnel = dot(i.viewDir, i.normal);
            fresnel = pow(fresnel, 2);
                return fresnel * _Color + _BaseColor;
            }
            ENDCG
        }
    }
}
