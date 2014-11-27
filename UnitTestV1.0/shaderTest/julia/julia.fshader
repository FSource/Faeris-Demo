VertexShader {
	attribute vec4 a_position=$(VERTICES); 	    
	attribute vec2 a_texCoord=$(UVS);	
	uniform mat4 u_mvp=$(R.WORLD_VIEW_PROJECTION_MAT);		
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



FragmentShader {

	uniform sampler2D u_texture0=$(M.COLOR_MAP);
	uniform float u_scale=$(R.TIME);
	varying vec2 v_texCoord;

	void main() {
		vec2 center=vec2(0.5,0.5);
		int iter=20;
		float scale=sin(u_scale/10000)*20;

		vec2 z, c;

		c.x = 1.3333 * (v_texCoord.x - 0.5) * scale - center.x;
		c.y = (v_texCoord.y - 0.5) * scale - center.y;

		int i;
		z = c;
		for(i=0; i<iter; i++) {
			float x = (z.x * z.x - z.y * z.y) + c.x;
			float y = (z.y * z.x + z.x * z.y) + c.y;

			if((x * x + y * y) > 4.0) break;
			z.x = x;
			z.y = y;
		}

		//gl_FragColor = texture2D(u_texture0, vec2((i == iter ? 0.0 : float(i),0.0) / 100.0));
		gl_FragColor = texture2D(u_texture0, vec2(float(i)/100,0.0));
	}




}
