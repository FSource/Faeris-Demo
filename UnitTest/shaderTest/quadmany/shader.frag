#ifdef GL_ES                            
precision lowp float;                  
#endif                                
#
varying vec4 v_fragmentColor; 		
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

#define t u_time/4.0

void main(void) {

	vec2 p = (2.0*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;
	vec2 mp = u_mouse.xy/u_resolution.xy*0.5+0.5;
		
	float s = 1.0;
	for (int i=0; i < 7; i++) {
		s = max(s,abs(p.x)-0.375);
		p = abs(p*2.25)-mp*1.25;
		p *= mat2(cos(t+mp.x),-sin(t+mp.y),sin(t+mp.y),cos(t+mp.x));
	}
	
	vec3 col = vec3(4.0,2.0,1.0)/abs(atan(p.y,p.x))/s;
	
	gl_FragColor = vec4(col,1.0);
}


