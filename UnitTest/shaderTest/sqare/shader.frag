#ifdef GL_ES                            
precision lowp float;                  
#endif                                
#
varying vec4 v_fragmentColor; 		
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;


void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / u_resolution.x );
	float col;
	vec3 light;
	light = vec3(0.0);
	const int num = 6;
	for(int i = 0;i < num;++i)
	{
		col = pow(1.0-length(pos-vec2(cos(u_time+float(i))*0.125+0.5,sin(u_time+float(i))*0.125+0.25)),20.0);
		light += vec3(sign(abs(mod(float(i),3.0)-2.0))*col,sign(abs(mod(float(i),3.0)-1.0))*col,sign(abs(mod(float(i),3.0)))*col);
	}

	gl_FragColor = vec4( light, 1.0 );

}

