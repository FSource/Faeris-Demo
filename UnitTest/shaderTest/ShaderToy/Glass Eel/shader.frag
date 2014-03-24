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


//"Glass Eel" by Kali

#define lightcol1 vec3(1.,.5,.5)
#define lightcol2 vec3(.5,.5,1.)



//Distance Field
float de(vec3 p) {
	p+=sin(p*10.+iGlobalTime*10.)*.012;
	float rot=p.z-iGlobalTime*3.;
	p.x+=sin(p.z-iGlobalTime*3.)*1.1+p.z*.5;
	p.y+=cos(p.z*.5-iGlobalTime*2.)*.8-1.5+p.z*.4;
	p.z-=5.;
	p.xy*=mat2(cos(rot),sin(rot),-sin(rot),cos(rot));
	float sc=max(1.,pow(abs(p.z),5.)*.000002);
	p*=sc;
	float d=((length(p.xy)-.3)-length(cos(p*20.))*.03-length(cos(p*10.))*.05);
	d=min(max(-p.z,d),length(p*vec3(1.,1.,1.4))-.47);
	return d*.5/sc;
}

// finite difference normal
vec3 normal(vec3 pos) {
	vec3 e = vec3(0.0,0.002,0.0);
	
	return normalize(vec3(
			de(pos+e.yxx)-de(pos-e.yxx),
			de(pos+e.xyx)-de(pos-e.xyx),
			de(pos+e.xxy)-de(pos-e.xxy)
			)
		);	
}


void main(void)
{
	float time = iGlobalTime*.6; 

	//camera
	vec2 uv = gl_FragCoord.xy / iResolution.xy *2. - vec2(1.);
	vec2 coord=uv;
	coord.y *= iResolution.y / iResolution.x;
	coord.xy*=mat2(cos(time),sin(time),-sin(time),cos(time));
	float fov=.5;
	vec3 from = vec3(-3.,-1.,sin(time)*4.-1.);

	//vars
	float totdist=0.;
	float distfade=1.;
	float glassfade=1.;
	float intens=1.;
	float maxdist=30.;
	float vol=0.;
	vec3 spec=vec3(0.);
	vec3 dir=normalize(vec3(coord.xy*fov,1.)); 
	float ref=0.;
	vec3 light1=normalize(vec3(sin(time),sin(time*2.)*.5,1.5));
	vec3 light2=normalize(vec3(sin(time+2.),sin((time+2.)*2.)*.5,1.5));

	//march
	for (int r=0; r<120; r++) {
		vec3 p=from+totdist*dir;
		float d=de(p);
		float distfade=exp(-5.*pow(totdist/maxdist,1.2));
		intens=min(distfade,glassfade);

	   if (totdist<maxdist) {

		// refraction
		if (d>0.0 && ref>.5) {
			ref=0.;
			vec3 n=normal(p);
			if (dot(dir,n)<-0.5) dir=normalize(refract(dir,n,1./.85));
			vec3 refl=reflect(dir,-n);
			spec+=lightcol1*pow(max(dot(refl,light1),0.0),40.);
			spec+=lightcol2*pow(max(dot(refl,light2),0.0),40.);
			spec*=intens;
			spec*=glassfade;
		}
		if (d<0.0 && ref<.5) {
			ref=1.;
			vec3 n=normal(p);
			if (dot(dir,n)<0.) dir=normalize(refract(dir,n,.85));
			vec3 refl=reflect(dir,n);
			glassfade*=.6;
			spec+=lightcol1*pow(max(dot(refl,light1),0.0),50.);
			spec+=lightcol2*pow(max(dot(refl,light2),0.0),50.);
			spec+=pow(max(dot(refl,vec3(0.,0.,-1.)),0.0),50.)*3.;
			
		}
		
		totdist+=max(0.001,abs(d)); //advance ray 
	   }
		vol+=max(0.,.6-d)*intens; //glow
	}
	
	vol*=.025;
	vec3 col=vec3(vol*vol,vol*.9,vol*vol*vol)+vec3(spec)*.5+.13;

	//lights
	vec3 tcoor=vec3((dir.xy*(2.-sin(time)*.8))+sin(coord.xy*20.+iGlobalTime*10.)*.007,1.);
	vec3 li=vec3(0.15);
	col+=2.*lightcol1*pow(max(0.,max(0.,dot(normalize(tcoor+vec3(0.15,.1,0.)),light1))),500.)*glassfade; 
	col+=2.*lightcol2*pow(max(0.,max(0.,dot(normalize(tcoor+vec3(0.15,.1,0.)),light2))),500.)*glassfade; 
	li+=lightcol1*pow(max(0.,max(0.,dot(normalize(tcoor),light1))),40.)*glassfade; 
	li+=lightcol2*pow(max(0.,max(0.,dot(normalize(tcoor),light2))),40.)*glassfade; 
	//background
	col+=li*.3+li*5.*pow(texture2D(u_texture0,tcoor.xy*vec2(.5+(1.+cos(time))*.5,1.)+time).x,1.7)*glassfade*vec3(.3,1.,.3)*max(0.,1.-length(coord));
	
	col*=1.-pow(max(0.,max(abs(uv.x),abs(uv.y))-.8)/.2,10.); //borders

	//color adjust	
	col=pow(col,vec3(1.2,1.1,1.));
	col*=vec3(1.,.8,1.);

	col*=min(1.,time); //fade in
	gl_FragColor = vec4(col,1.0);	
}

