#ifdef GL_ES                            
precision lowp float;                  
#endif                                
#
varying vec4 v_fragmentColor; 		
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

#define PI 3.14159

void main(){
	vec2 p = (gl_FragCoord.xy - 0.5 * u_resolution) / min(u_resolution.x, u_resolution.y);
	vec2 t = vec2(gl_FragCoord.xy / u_resolution);
	
	vec3 c = vec3(0);
	
	for(int i = 0; i < 30; i++) {
		float t = 0.1 * PI * float(i+1) / 50.0 * u_time * 0.5;
		float x = cos(5.0*t);
		float y = sin(20.0*fract(t));
		vec2 o = 0.30 * vec2(x, y);
		float r = fract(x-y*t);
		float g = 0.5 - r;
		c += 0.01 / (length(sin(p)-o)) * vec3(r, g, 0.5);
	}
	
	gl_FragColor = vec4(c, 1);
}

