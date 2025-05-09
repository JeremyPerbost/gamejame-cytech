RSRC                    VisualShader            ��������                                            R      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    parameter_name 
   qualifier    texture_type    color_default    texture_filter    texture_repeat    texture_source    script    source    texture 	   constant    hint    min    max    step    default_value_enabled    default_value    input_name    op_type 	   operator    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/13/node    nodes/fragment/13/position    nodes/fragment/14/node    nodes/fragment/14/position    nodes/fragment/15/node    nodes/fragment/15/position    nodes/fragment/16/node    nodes/fragment/16/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        1   local://VisualShaderNodeTexture2DParameter_ojflt *      &   local://VisualShaderNodeTexture_13ox8 o      !   local://VisualShaderNodeIf_31rq0 �      ,   local://VisualShaderNodeFloatConstant_vrh42 �      ,   local://VisualShaderNodeFloatConstant_k0t6s �      -   local://VisualShaderNodeFloatParameter_vj3ax .      $   local://VisualShaderNodeInput_k8gfl �      "   local://VisualShaderNodeMix_4enpw �      &   local://VisualShaderNodeTexture_i7po5 �      $   local://VisualShaderNodeInput_hj3hs )      !   local://VisualShaderNodeIf_4f3ld e      "   local://VisualShaderNodeMix_3ym76 �      ,   local://VisualShaderNodeColorConstant_17k0v       &   local://VisualShaderNodeFloatOp_inlut f         res://shader/inventaire.tres �      #   VisualShaderNodeTexture2DParameter             Noise          VisualShaderNodeTexture                      VisualShaderNodeIf             VisualShaderNodeFloatConstant             VisualShaderNodeFloatConstant            �?         VisualShaderNodeFloatParameter             Dissolvevalue                   VisualShaderNodeInput             texture          VisualShaderNodeMix             VisualShaderNodeTexture                                      VisualShaderNodeInput          
   screen_uv          VisualShaderNodeIf             VisualShaderNodeMix                                              �?  �?  �?            ?   ?   ?                  VisualShaderNodeColorConstant                          ��\?NE�>���=  �?         VisualShaderNodeFloatOp                                 )   ���Q��?         VisualShader "         �  shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D Noise;
uniform float Dissolvevalue : hint_range(0, 1);



void fragment() {
// ColorConstant:15
	vec4 n_out15p0 = vec4(0.862496, 0.441935, 0.105241, 1.000000);


	vec4 n_out11p0;
// Texture2D:11
	n_out11p0 = texture(TEXTURE, UV);
	float n_out11p4 = n_out11p0.a;


// Input:12
	vec2 n_out12p0 = SCREEN_UV;


	vec4 n_out3p0;
// Texture2D:3
	n_out3p0 = texture(Noise, n_out12p0);


// FloatParameter:7
	float n_out7p0 = Dissolvevalue;


// FloatConstant:5
	float n_out5p0 = 0.000000;


// FloatConstant:6
	float n_out6p0 = 1.000000;


	vec3 n_out13p0;
// If:13
	float n_in13p2 = 0.00001;
	vec3 n_in13p3 = vec3(0.00000, 0.00000, 0.00000);
	if(abs(n_out3p0.x - n_out7p0) < n_in13p2)
	{
		n_out13p0 = n_in13p3;
	}
	else if(n_out3p0.x < n_out7p0)
	{
		n_out13p0 = vec3(n_out6p0);
	}
	else
	{
		n_out13p0 = vec3(n_out5p0);
	}


// Mix:14
	vec3 n_out14p0 = mix(vec3(n_out15p0.xyz), vec3(n_out11p0.xyz), n_out13p0);


// FloatOp:16
	float n_in16p1 = 0.03000;
	float n_out16p0 = n_out7p0 + n_in16p1;


	vec3 n_out4p0;
// If:4
	float n_in4p2 = 0.00001;
	vec3 n_in4p3 = vec3(0.00000, 0.00000, 0.00000);
	if(abs(n_out3p0.x - n_out16p0) < n_in4p2)
	{
		n_out4p0 = n_in4p3;
	}
	else if(n_out3p0.x < n_out16p0)
	{
		n_out4p0 = vec3(n_out6p0);
	}
	else
	{
		n_out4p0 = vec3(n_out5p0);
	}


// Mix:10
	float n_in10p0 = 0.00000;
	float n_out10p0 = mix(n_in10p0, n_out4p0.x, n_out11p4);


// Output:0
	COLOR.rgb = n_out14p0;
	COLOR.a = n_out10p0;


}
                     $   
     �D  /D%             &   
     C  LC'            (   
   ��D�#�C)            *   
   �DN�C+            ,   
   ZDD�dSD-            .   
     CD  pD/            0   
     �C  >D1            2   
   ��D�ʂD3            4   
   fV�D#�CD5            6   
     �D  WD7         	   8   
   �De��B9         
   :   
   �?�D�$C;            <   
     �D  pC=            >   
     �D  �A?            @   
     �C  �DA       L                                                               
                         
                                                                                                                                                           
                    RSRC