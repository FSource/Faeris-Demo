Feature 
{
}

UniformMap 
{
	u_mvp=$(R.WORLD_VIEW_PROJECTION_MAT)	
	u_texture0=$(M.COLOR_MAP)
	u_scale=$(R.TIME)
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
	uniform float u_scale;
	uniform sampler2D u_texture0;

	varying vec2 v_texCoord;

	void main() 
	{

		float precisx=10;
		float precisy=10000;
		float seed=mod(u_scale,float(precisx*precisy));
		float seedx=seed/precisy;
		float seedy=mod(seed,precisy);

		vec2 c=vec2(seedx/precisx,seedy/precisy);

		//vec2 c=vec2(0.358,0.428);

		int iter=100;
		vec2 z;
		z.x = 3.0 * (v_texCoord.x - 0.5);
		z.y = 2.0 * (v_texCoord.y - 0.5);

		int i;
		for(i=0; i<iter; i++) 
		{
			float x = (z.x * z.x - z.y * z.y) + c.x;
			float y = (z.y * z.x + z.x * z.y) + c.y;

			if((x * x + y * y) > 4.0) break;
			z.x = x;
			z.y = y;
		}

		
		gl_FragColor = texture2D(u_texture0, vec2(float(i)/100.0,0.0) );

	}

}


