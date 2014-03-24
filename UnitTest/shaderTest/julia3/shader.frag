#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void )
{

	vec2 z1 = (gl_FragCoord.xy / resolution.x - vec2(0.50, 0.30)) * 2.5;
	vec2 p = vec2(0.7*cos(time/2.),0.7*sin(0.3*time));
	
	float hue = 0.6;
	vec4 color = vec4(0.1, 0.1, 0.3, 1);
	for(int i = 0; i < 44; i++)
	{
		if(length(z1) > 2.0)
		{
			color = vec4(cos(hue) + .6, sin(hue + 1.2) + 0.3, cos(hue + 4.8) + 0.7, 1);
			break;
		}

		z1 = vec2(z1.x * z1.x - z1.y * z1.y, 2.0 * z1.x * z1.y) + p;

		hue += 0.07;
	}
	gl_FragColor = color;
}

