
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

	varying vec2 v_texCoord; 

	vec3 col = vec3(0.0, 0.0, 0.0);
	const int itrCount = 10;
	for (int i = 0; i < itrCount; ++i)
	{
		
		float offset = float(i) / float(itrCount);
		float t = time + (offset * offset * 2.0);
		
		vec2 pos=v_texCoord;
		pos.y-=0.5;
		pos.y+=sin(pos.x*9.0+t)*0.2*sin(t*0.8);
		float color=1.0-pow(abs(pos.y),0.2);
		float colora=pow(1.,0.2*abs(pos.y));
		
		float rColMod = ((offset * 0.5) + 0.5) * colora;
		float bColMod = (1.0 - (offset * 0.5) + 0.5) * colora;
		
		col += vec3(color * rColMod, color, color * bColMod) * (1.0 / float(itrCount));
	}
	col = clamp(col, 0.0, 1.0);
	
	gl_FragColor=vec4(col.x, col.y, col.z ,1.0);


}
