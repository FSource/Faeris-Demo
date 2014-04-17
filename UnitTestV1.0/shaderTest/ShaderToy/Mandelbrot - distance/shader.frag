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


// This shader computes the distance to the Mandelbrot Set for everypixel, and colorizes
// it accoringly.
// 
// Z -> Z2+c, Z0 = 0. 
// therefore Z' -> 2·Z·Z' + 1
//
// The Hubbard-Douady potential G(c) is G(c) = log Z/2^n
// G'(c) = Z'/Z/2^n
//
// So the distance is |G(c)|/|G'(c)| is |Z|·log|Z|/|Z'|
//
// More info here: http://www.iquilezles.org/www/articles/distancefractals/distancefractals.htm


void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / iResolution.xy;
    p.x *= iResolution.x/iResolution.y;

    // animation	
	float tz = 0.5 - 0.5*cos(0.225*iGlobalTime);
    float zoo = pow( 0.5, 13.0*tz );
	vec2 cc = vec2(-0.05,.6805) + p*zoo;

    // iterate
    vec2 z  = vec2(0.0);
    float m2 = 0.0;
    float co = 0.0;
    vec2 dz = vec2(0.0);
    for( int i=0; i<256; i++ )
    {
        if( m2>1024.0 ) continue;

		// Z' -> 2·Z·Z' + 1
        dz = 2.0*vec2(z.x*dz.x-z.y*dz.y, z.x*dz.y + z.y*dz.x ) + vec2(1.0,0.0);
			
        // Z -> Z2 + c			
        z = cc + vec2( z.x*z.x - z.y*z.y, 2.0*z.x*z.y );
			
        m2 = dot(z,z);
        co += 1.0;
    }

    // distance	
	// d(c) = |Z|·log|Z|/|Z'|
	float d = 0.0;
    if( co<256.0 ) d = sqrt( dot(z,z)/dot(dz,dz) )*log(dot(z,z));

	
    // do some soft coloring based on distance
	d = clamp( 4.0*d/zoo, 0.0, 1.0 );
	d = pow( d, 0.25 );
    vec3 col = vec3( d );
    
    gl_FragColor = vec4( col, 1.0 );
}

