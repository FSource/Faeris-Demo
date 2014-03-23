#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
void main( void ) {
	vec2 p=(gl_FragCoord.xy-.5*resolution)/min(resolution.x,resolution.y);
	vec3 c=vec3(0);
	for(int i=0;i<25;i++)
	{
		float t = 2.*3.14*float(i)/20.  * fract(time*.4);
		float x = cos(5.*t);
		float y = sin(4.*t);
		vec2 o = .4*vec2(x,y);
		c += .01/(length(p-o))*vec3(.1,.1,.7);
	} 
	gl_FragColor = vec4(c,1);
}

