#ifdef GL_ES                            
precision lowp float;                  
#endif                                
#
varying vec4 v_fragmentColor; 		
uniform float u_time;
uniform vec2 u_resolution;

void main() 					   
{								
	vec2 p = ( gl_FragCoord.xy / u_resolution.xy ) - 0.5;
	float sx = 0.4 * (p.x + 0.5) * sin( 24.0 * p.x - 10. * u_time);
	float dy = 1./ ( 50. * abs(p.y - sx));
	dy += 1./ (20. * length(p - vec2(p.x, 0.)));
	gl_FragColor = vec4( (p.x + 0.5) * dy, 0.5 * dy, dy * 2.0, 1.0 );
}								

