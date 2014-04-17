/* srtuss, 2013 /////////////////////////////////////////////////////////////////////////////

Here is a vector graphic character, completely based on a continuous distance field,
slightly animated by simple noise functions.

/////////////////////////////////////////////////////////////////////////////////////////////

Sadly I hit the instruction limit quickly and so only some parts can be seen.

I used distance fields because they give you an easy way to compute outlines and free
anti-aliasing. This actually was the first time I had a straight concept right from the
beginning (usually I start with a random idea and see where its takse me ;) ). First I
sketched the pose and then I converted it into a distance field using lines and circles.
My new distance-field-editor generated big parts of the code for me.

The character is Rainbow Dash, a pegasus from a popular tv-show. I chose these characters
because they consinst of simple geometric shapes and plain coloring. Also I enjoy working
with them a lot. :)

Effects like wing-flapping and blinking are removed, some invisible things are still
included in the code.

/////////////////////////////////////////////////////////////////////////////////////////////

my first sketch for this
http://srtuss.net/stuff/concept.png

my vector drawing, used as template
http://srtuss.deviantart.com/art/Rainbow-Dash-384641748

///////////////////////////////////////////////////////////////////////////////////////////*/
uniform vec2      iResolution;           // viewport resolution (in pixels)
uniform float     iGlobalTime;           // shader playback time (in seconds)
uniform vec3      iMouse; 
uniform sampler2D u_texture0;

#define BLADES 110

vec3 rotateX(float a, vec3 v)
{
	return vec3(v.x, cos(a) * v.y + sin(a) * v.z, cos(a) * v.z - sin(a) * v.y);
}

vec3 rotateY(float a, vec3 v)
{
	return vec3(cos(a) * v.x + sin(a) * v.z, v.y, cos(a) * v.z - sin(a) * v.x);
}

vec3 rotateZ(float a, vec3 v)
{
	return vec3(cos(a) * v.x + sin(a) * v.y, cos(a) * v.y - sin(a) * v.x, v.z);
}

vec4 grass(vec2 p, float x)
{
	float s = mix(0.7, 2.0, 0.5 + sin(x * 12.0) * 0.5);
	p.x += pow(1.0 + p.y, 2.0) * 0.1 * cos(x * 0.5 + iGlobalTime);
	p.x *= s;
	p.y = (1.0 + p.y) * s - 1.0;
	float m = 1.0 - smoothstep(0.0, clamp(1.0 - p.y * 1.5, 0.01, 0.6) * 0.2 * s, pow(abs(p.x) * 19.0, 1.5) + p.y - 0.6);
	return vec4(mix(vec3(0.05, 0.1, 0.0) * 0.8, vec3(0.0, 0.3, 0.0), (p.y + 1.0) * 0.5 + abs(p.x)), m * smoothstep(-1.0, -0.9, p.y));
}

vec3 backg(vec3 ro, vec3 rd)
{
	float t = (-1.0 - ro.y) / rd.y;
	vec2 tc = ro.xz + rd.xz * t;
	vec3 horiz = vec3(0.0, 0.2, 0.2) * 0.7;
	vec3 sky = mix(horiz, vec3(0.1, 0.13, 0.15) * 0.8, dot(rd, vec3(0.0, 1.0, 0.0)));
	vec3 ground = mix(horiz, vec3(0.04, 0.07, 0.0) * 0.6, pow(max(0.0, dot(rd, vec3(0.0, -1.0, 0.0))), 0.2));
	return mix(sky, ground, step(0.0, t));
}

// some simple noise just to break up the hideous banding
float dither()
{
	return fract(gl_FragCoord.x * 0.482635532 + gl_FragCoord.y * 0.1353412 + iGlobalTime * 100.0) * 0.008;
}

void main()
{
	vec3 ct = vec3(0.0, 1.0, 5.0);
	vec3 cp = rotateY(cos(iGlobalTime * 0.2) * 0.4, vec3(0.0, 0.6, 0.0));
	vec3 cw = normalize(cp - ct);
	vec3 cu = normalize(cross(cw, vec3(0.0, 1.0, 0.0)));
	vec3 cv = normalize(cross(cu, cw));
	
	mat3 rm = mat3(cu, cv, cw);
	
	vec2 uv = (gl_FragCoord.xy / iResolution.xy) * 2.0 - vec2(1.0);
	vec2 t = uv;
	t.x *= iResolution.x / iResolution.y;
	
	vec3 ro = cp, rd = rotateY(sin(iGlobalTime * 0.7) * 0.1,
							   rm * rotateZ(sin(iGlobalTime * 0.15) * 0.1, vec3(t, -1.3)));
	
	vec3 fcol = backg(ro, rd);
	
	for(int i = 0; i < BLADES; i += 1)
	{
		float z = -(float(BLADES - i) * 0.1 + 1.0);
		vec4 pln = vec4(0.0, 0.0, -1.0, z);
		float t = (pln.w - dot(pln.xyz, ro)) / dot(pln.xyz, rd);
		vec2 tc = ro.xy + rd.xy * t;
		
		tc.x += cos(float(i) * 3.0) * 4.0;
		
		float cell = floor(tc.x);
		
		tc.x = (tc.x - cell) - 0.5;
		
		vec4 c = grass(tc, float(i) + cell * 10.0);
		
		fcol = mix(fcol, c.rgb, step(0.0, t) * c.w);
	}
	
	fcol = pow(fcol * 1.1, vec3(0.8));
	
	
	// i?igo quilez's great vigneting effect!
	vec2 q = (uv + vec2(1.0)) * 0.5;
	fcol *= 0.2 + 0.8*pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.1 );
	
	
	gl_FragColor.rgb = fcol + vec3(dither());
	gl_FragColor.a = 1.0;
}

