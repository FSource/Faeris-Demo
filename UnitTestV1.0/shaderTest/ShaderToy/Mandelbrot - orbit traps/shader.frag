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
// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / iResolution.xy;
    p.x *= iResolution.x/iResolution.y;

    //float zoo = 1.0/250.0;
	
	float zoo = 1.0/250.0;
	
	zoo = 1.0/(400.0 - 150.0*sin(0.15*iGlobalTime-0.3));
	
	vec2 cc = vec2(-0.533516,0.526141) + p*zoo;

	vec2 t2c = vec2(-0.5,2.0);
	t2c += 0.5*vec2( cos(0.13*(iGlobalTime-10.0)), sin(0.13*(iGlobalTime-10.0)) );
		
    // iterate
    vec2 z  = vec2(0.0);
    vec2 dz = vec2(0.0);
	float trap1 = 0.0;
	float trap2 = 1e20;
	float co2 = 0.0;
    for( int i=0; i<150; i++ )
    {
        if( dot(z,z)>1024.0 ) continue;

		// Z' -> 2·Z·Z' + 1
        dz = 2.0*vec2(z.x*dz.x-z.y*dz.y, z.x*dz.y + z.y*dz.x ) + vec2(1.0,0.0);
			
        // Z -> Z2 + c			
        z = cc + vec2( z.x*z.x - z.y*z.y, 2.0*z.x*z.y );
			
        // trap 1
		float d1 = abs(dot(z-vec2(0.0,1.0),vec2(0.707)));
		float ff = step( d1, 1.0 );
		co2 += ff;
		trap1 += ff*d1;

		//trap2
		trap2 = min( trap2, dot(z-t2c,z-t2c) );
    }

    // distance, d(c) = |Z|·log|Z|/|Z'|
	float d = sqrt( dot(z,z)/dot(dz,dz) )*log(dot(z,z));
	
	float c1 = pow( clamp( 2.00*d/zoo,    0.0, 1.0 ), 0.5 );
	float c2 = pow( clamp( 1.5*trap1/co2, 0.0, 1.0 ), 2.0 );
	float c3 = pow( clamp( 0.4*trap2, 0.0, 1.0 ), 0.25 );

	vec3 col1 = 0.5 + 0.5*sin( 3.0 + 4.0*c2 + vec3(0.0,0.5,1.0) );
	vec3 col2 = 0.5 + 0.5*sin( 4.1 + 2.0*c3 + vec3(1.0,0.5,0.0) );
	vec3 col = 2.0*sqrt(c1*col1*col2);

	gl_FragColor = vec4( col, 1.0 );
}
