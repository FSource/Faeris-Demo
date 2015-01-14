
Feature 
{
}

UniformMap 
{
	u_mvp=$(R.WORLD_VIEW_PROJECTION_MAT)	
	u_texture0=$(M.COLOR_MAP)
	u_time=$(R.TIME)
}

AttributeMap 
{
	a_position=$(VERTICES) 	   
	a_texCoord=$(UVS)	
}


VertexShader 
{
	attribute vec4 a_position;
	attribute vec2 a_texCoord;
	uniform mat4 u_mvp;
#ifdef GL_ES						
	varying mediump vec2 v_texCoord;
#else						
	varying vec2 v_texCoord;
#endif				
	void main() 	
	{ 			
		gl_Position=u_mvp*a_position;
		v_texCoord=a_texCoord;		
	}							

}



FragmentShader 
{

#ifdef GL_ES                            
	precision lowp float;                  
#endif                                
	uniform float u_time;

	varying v_texCoord; 


	void main() 					   
	{								
		vec2 p = v_texCoord - vec2(0.5);
		float sx = 0.4 * (p.x + 0.5) * sin( 24.0 * p.x - 10. * u_time);
		float dy = 1./ ( 50. * abs(p.y - sx));
		dy += 1./ (20. * length(p - vec2(p.x, 0.)));
		gl_FragColor = vec4( (p.x + 0.5) * dy, 0.5 * dy, dy * 2.0, 1.0 );
	}								

}
