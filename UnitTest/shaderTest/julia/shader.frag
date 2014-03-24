uniform sampler2D u_texture0;
uniform float scale;
varying vec2 v_texCoord;

void main() {
	vec2 center=vec2(0.5,0.5);
	int iter=2000;

	vec2 z, c;

	c.x = 1.3333 * (v_texCoord.x - 0.5) * scale - center.x;
	c.y = (v_texCoord.y - 0.5) * scale - center.y;

	int i;
	z = c;
	for(i=0; i<iter; i++) {
		float x = (z.x * z.x - z.y * z.y) + c.x;
		float y = (z.y * z.x + z.x * z.y) + c.y;

		if((x * x + y * y) > 4.0) break;
		z.x = x;
		z.y = y;
	}

	gl_FragColor = texture2D(u_texture0, (i == iter ? 0.0 : float(i)) / 100.0);
}


