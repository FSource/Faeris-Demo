uniform sampler2D u_texture0;
uniform vec2 c;
varying vec2 v_texCoord;


void main() {
	int iter=2000;
    vec2 z;
    z.x = 3.0 * (v_texCoord.x - 0.5);
    z.y = 2.0 * (v_texCoord.y - 0.5);

    int i;
    for(i=0; i<iter; i++) {
        float x = (z.x * z.x - z.y * z.y) + c.x;
        float y = (z.y * z.x + z.x * z.y) + c.y;

        if((x * x + y * y) > 4.0) break;
        z.x = x;
        z.y = y;
    }

    gl_FragColor = texture2D(u_texture0, (i == iter ? 0.0 : float(i)) / 100.0);
}


