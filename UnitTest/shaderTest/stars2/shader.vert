uniform mat4 u_mvp;					
uniform float u_pointSize;		
uniform vec4 u_color;		
uniform float u_opacity; 
attribute vec4 a_position;	
attribute vec4 a_color;	
#ifdef GL_ES						
varying lowp vec4 v_fragmentColor;
#else							
varying vec4 v_fragmentColor;
#endif						
void main()   			
{									
	gl_Position=u_mvp*a_position;
	gl_PointSize=u_pointSize;	
	vec4 tmpc=a_color*u_color;	
	v_fragmentColor=vec4(tmpc.rgb,tmpc.a*u_opacity); 
}  									

