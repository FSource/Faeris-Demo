uniform mat4 u_mvp;					
attribute vec4 a_position;	

#ifdef GL_ES						
varying lowp vec4 v_fragmentColor;
#else							
varying vec4 v_fragmentColor;
#endif						
void main()   			
{									
	gl_Position=u_mvp*a_position;
}  									

