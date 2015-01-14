#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(){
	
	vec3 col = vec3(0., 0., 0.);
	const int itrCount = 10;
	for (int i = 0; i < itrCount; ++i)
	{
		
		float offset = float(i) / float(itrCount);
		float t = time + (offset * offset * 2.);
		
		vec2 pos=(gl_FragCoord.xy/resolution.xy);
		pos.y-=0.5;
		pos.y+=sin(pos.x*9.0+t)*.2*sin(t*.8);
		float color=1.0-pow(abs(pos.y),0.2);
		float colora=pow(1.,0.2*abs(pos.y));
		
		float rColMod = ((offset * .5) + .5) * colora;
		float bColMod = (1. - (offset * .5) + .5) * colora;
		
		col += vec3(color * rColMod, color, color * bColMod) * (1. / float(itrCount));
	}
	col = clamp(col, 0., 1.);
	
	gl_FragColor=vec4(col.x, col.y, col.z ,1.0);
		
}

