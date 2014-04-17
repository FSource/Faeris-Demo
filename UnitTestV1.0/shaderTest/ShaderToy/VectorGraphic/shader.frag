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
uniform vec2      iMouse; 


// colors used
vec3 cCOut = vec3(0.42, 0.682, 0.875);	
vec3 cCoat = vec3(0.616, 0.851, 0.969);
vec3 cCoatShad = vec3(0.565, 0.745, 0.902);
vec3 cEyeLo = vec3(0.784, 0.141, 0.463);
vec3 cEyeHi = vec3(0.51, 0.141, 0.353);
vec3 cEyeSHi = vec3(0.859, 0.392, 0.643);
vec3 cEyeSLo = vec3(0.957, 0.761, 0.855);
vec3 cMOut = vec3(0.0, 0.576, 0.816);
vec3 cM1 = vec3(0.953, 0.467, 0.212);
vec3 cM2 = vec3(0.937, 0.251, 0.208);
vec3 cM3 = vec3(1.0, 0.969, 0.592);
vec3 cM4 = vec3(0.478, 0.757, 0.259);
vec3 cM5 = cMOut;
vec3 cM6 = vec3(0.502, 0.251, 0.596);

// outline thickness
float olw = 0.013;

// anti aliasing controller
float aav = 1.5 / iResolution.y;

// global time
float time = (iGlobalTime - 10.0) * 20.0;


// noise for testing
float hash(float x)
{
	return fract(484.982 * sin(x)) * 2.0 - 1.0;
}
float hermite(float x)
{
	return x * x * (3.0 - 2.0 * x);
}
float noise1(float x)
{
	float fl = floor(x);
	return mix(hash(fl), hash(fl + 1.0), hermite(fract(x)));
}
float fbm(float x)
{
	return noise1(x) * 0.5 + noise1(x * 2.2) * 0.1 + noise1(x * 4.1) * 0.005;
}
float eyenoise(float x)
{
	float fl = floor(x);
	return mix(hash(fl), hash(fl + 1.0), pow(fract(x), 0.1));
}

vec2 rotate(vec2 p, float a)
{
	return vec2(p.x * cos(a) - p.y * sin(a), p.x * sin(a) + p.y * cos(a));
}


/////////////////////////////////////////////////////////////////////////////////////////////
// massive chunk of vector data starts here /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

// mane, front part, shape
float mane(vec2 pp)
{
	float v, w, c, u; vec2 q, p;
	p = pp - vec2(1.2253, 0.0261);
	p = rotate(p, sin(time) * 0.03);
	q = p - vec2(-0.0191, 0.2107); w = length(q) - 0.2240; v = w;
	q = p - vec2(-0.0765, 0.6819); w = length(q) - 0.6758; v = max(v, -w);
	u = v;
	p = pp - vec2(1.2574, 0.0785);
	p = rotate(p, sin(time + 0.4) * 0.03);
	q = p - vec2(-0.2199, 0.3017); w = length(q) - 0.3953;
	q = p - vec2(-0.0451, -0.0480); c = dot(q, vec2(0.9949, 0.1012)); v = max(w, -c);
	q = p - vec2(-0.1254, 0.3789); w = length(q) - 0.3778; v = max(v, -w);
	u = min(u, v);
	p = pp - vec2(1.2286, 0.1300);
	p = rotate(p, sin(time + 0.8) * 0.03);
	q = p - vec2(0.2807, -0.3827); w = length(q) - 0.5428;
	q = p - vec2(0.0272, -0.0531); c = dot(q, vec2(-0.0008, 1.0000)); v = max(w, -c);
	q = p - vec2(0.7080, -0.3599); w = length(q) - 0.7345; v = max(v, -w);
	u = min(u, v);
	p = pp - vec2(1.0494, 0.1115);
	q = p - vec2(-0.1747, 0.2383); w = length(q) - 0.3476;
	q = p - vec2(0.0035, -0.0434); c = dot(q, vec2(0.6608, 0.7505)); v = max(w, -c);
	q = p - vec2(-0.1103, 0.4400); w = length(q) - 0.4176; v = max(v, -w);
	u = min(u, v);
	p = pp - vec2(0.9697, 0.1302);
	q = p - vec2(0.2265, 0.1746); w = length(q) - 0.2921;
	q = p - vec2(0.1081, 0.0078); c = dot(q, vec2(0.0253, -0.9997)); v = max(w, -c);
	q = p - vec2(0.0792, -0.0610); w = length(q) - 0.1777; v = max(v, w);
	u = min(u, v);
	return u;
}

// mane, front part, color
vec3 mcolor(vec2 p)
{
	float v;
	vec3 col = cM1;
	v = length(p - vec2(0.6766, 1.4003)) - 1.4598;
	col = mix(col, cM2, smoothstep(aav, 0.0, v));
	v = length(p - vec2(0.9126, 0.4813)) - 0.4295;
	col = mix(col, cM3, smoothstep(aav, 0.0, v));
	return col;
}

// mane, back part, shape
float mback(vec2 pp)
{
	float u, v, w, c; vec2 p;
	p = pp - vec2(0.9602, 0.4182); // layer 0
	w = length(p - vec2(1.0297, -0.2105)) - 1.0754; c = dot(p - vec2(0.0506, 0.0798), vec2(-0.9869, 0.1611)); v = max(w, -c);
	w = length(p - vec2(0.4516, -0.1273)) - 0.5022; c = dot(p - vec2(-0.0270, 0.0771), vec2(-0.3698, -0.9291)); v = max(v, min(w, -c));
	w = length(p - vec2(0.3369, -0.3594)) - 0.4470;
	v = max(v, -w);
	u = v;
	p = pp - vec2(1.0066, 0.4125); // layer 1
	p = rotate(p, sin(time) * 0.02 + 0.05);
	w = length(p - vec2(0.0628, -0.0642)) - 0.1015; v = w;
	w = length(p - vec2(0.2157, -0.2964)) - 0.3537; v = max(v, -w);
	u = min(u, v);
	p = pp - vec2(1.0531, 0.5104); // layer 2
	p = rotate(p, sin(time + 0.4) * 0.03);
	w = length(p - vec2(-0.2372, 0.1561)) - 0.3159; c = dot(p - vec2(-0.0797, -0.0765), vec2(0.9670, -0.2547)); v = max(w, -c);
	w = length(p - vec2(-0.0497, 0.1863)) - 0.1558; c = dot(p - vec2(0.1359, 0.1216), vec2(0.5796, 0.8149)); v = max(v, -min(w, -c));
	u = min(u, v);
	p = pp - vec2(1.0330, 0.5708); // layer 3
	p = rotate(p, sin(time + 0.4) * 0.01);
	w = length(p - vec2(-0.1426, 0.0913)) - 0.2015; c = dot(p - vec2(0.0222, -0.0739), vec2(0.7900, 0.6131)); v = max(w, -c);
	w = length(p - vec2(-0.5145, 0.3734)) - 0.6075; v = max(v, -w);
	u = min(u, v);
	return u;
}

// mane, back part, color
vec3 mbcolor(vec2 p)
{
	vec3 col = cM5;
	float v;
	v = length(p - vec2(1.1871, 0.2127)) - 0.2967;
	col = mix(col, cM4, smoothstep(aav, 0.0, v));
	v = length(p - vec2(0.6659, 0.8068)) - 0.4435;
	col = mix(col, cM6, smoothstep(aav, 0.0, v));
	return col;
}

// head, shape
float head(vec2 p)
{
	float u, v, w, c; vec2 q;
	
	p -= vec2(0.9919, 0.3395);
	
	w = length(p - vec2(0.1598, -0.1325)) - 0.2652; c = dot(p - vec2(0.3610, -0.0813), vec2(0.6243, 0.7812)); v = max(w, -c);
	w = length(p - vec2(0.2406, 0.0039)) - 0.1067; c = dot(p - vec2(0.2874, 0.1182), vec2(-0.9254, -0.3791)); v = max(v, min(w, -c));
	u = v;
	w = length(p - vec2(0.3718, -0.1185)) - 0.1317; v = w;
	w = length(p - vec2(0.3248, -0.0164)) - 0.0198; c = dot(p - vec2(0.2991, -0.0229), vec2(0.8019, -0.5974)); v = max(v, min(w, -c));
	u = max(u, -v);
	w = length(p - vec2(0.1252, -0.0503)) - 0.1819; v = w;
	u = min(u, v);
	return u;
}

// head, mouth and nostril lines
float face_line(vec2 p)
{
	float u, v, w, c;
	w = length(p - vec2(1.3131, 0.3650)) - 0.0074; v = w;
	w = length(p - vec2(1.3179, 0.3543)) - 0.0147; v = max(v, -w);
	u = v;
	w = length(p - vec2(1.2836, 0.4599)) - 0.0529; c = dot(p - vec2(1.3072, 0.4263), vec2(-0.7726, -0.6349)); v = max(w, -c);
	w = length(p - vec2(1.2331, 0.5459)) - 0.1451; v = max(v, -w);
	u = min(u, v);
	return u;
}

// arm, upper part, shape
float arm1(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(1.0279, 0.6786); // layer 0
	w = length(p - vec2(0.0411, 0.1007)) - 0.1400;
	v = w;
	w = length(p - vec2(0.1661, 0.2066)) - 0.2965;
	v = max(v, w);
	w = length(p - vec2(-0.0423, 0.0792)) - 0.0547;
	c = dot(p - vec2(-0.0917, 0.0655), vec2(0.1429, -0.9897));
	v = max(v, min(w, -c));
	w = length(p - vec2(-0.4571, -0.2234)) - 0.5465;
	v = max(v, w);
	u = v;
	return u;
}

// arm, upper part, outline controller
float arm1_oc(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(0.0000, 0.0000); // layer 0
	w = length(p - vec2(1.1216, 0.8693)) - 0.2442;
	c = dot(p - vec2(1.0763, 0.6944), vec2(-0.4897, 0.8719));
	v = max(w, -c);
	w = length(p - vec2(0.8826, 0.6409)) - 0.1902;
	v = max(v, w);
	u = v;
	return u;
}

// arm, lower part, shape
float arm2(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(0.9734, 0.7685); // layer 0
	w = length(p - vec2(0.0949, 0.1043)) - 0.1796;
	v = w;
	w = length(p - vec2(0.1077, 0.0643)) - 0.1376;
	c = dot(p - vec2(0.1459, 0.1775), vec2(-1.0000, 0.0042));
	v = max(v, min(w, -c));
	w = length(p - vec2(0.1208, -0.2676)) - 0.3421;
	v = max(v, w);
	w = length(p - vec2(0.2286, 0.0416)) - 0.0146;
	c = dot(p - vec2(0.2252, 0.0677), vec2(-0.8735, -0.4869));
	v = max(v, min(w, -c));
	u = v;
	p = pp - vec2(0.9734, 0.7685); // layer 1
	w = length(p - vec2(-0.0009, 0.1606)) - 0.1275;
	v = w;
	w = length(p - vec2(-0.0081, 0.2307)) - 0.1946;
	v = max(v, w);
	u = max(u, -v);
	return u;
}

// arm, lower part, outline controller
float arm2_oc(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(0.0000, 0.0000); // layer 2
	w = length(p - vec2(1.0612, 0.8100)) - 0.1302;
	c = dot(p - vec2(0.9512, 0.7051), vec2(0.9990, -0.0445));
	v = max(w, -c);
	w = length(p - vec2(1.1435, 0.7685)) - 0.1193;
	v = min(v, w);
	u = v;//min(u, v);
	return u;
}

// body, shape
float body(vec2 p)
{
	float u, v, w, c;
	
	p -= vec2(0.8622, 0.6653);
	w = length(p - vec2(0.0248, -0.1253)) - 0.2893; c = dot(p - vec2(-0.2190, 0.0744), vec2(0.0427, -0.9991)); v = max(w, -c);
	w = length(p - vec2(-0.0951, 0.0066)) - 0.1327; c = dot(p - vec2(-0.0491, -0.1211), vec2(0.7187, 0.6954)); v = max(v, min(w, -c));
	w = length(p - vec2(-0.3217, 0.6689)) - 0.8324; v = max(v, w);
	u = v;
	w = length(p - vec2(0.1072, 1.4239)) - 1.5106; v = w;
	w = length(p - vec2(0.1309, -0.0390)) - 0.1227; v = max(v, w);
	u = min(u, v);
	return u;
}

// nech, shape
float neck(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(1.0304, 0.6354); // layer 0
	w = length(p - vec2(-0.4434, 0.0079)) - 0.5635;
	c = dot(p - vec2(0.1418, -0.1586), vec2(-0.5168, 0.8561));
	v = max(w, -c);
	w = length(p - vec2(-0.0617, -0.0234)) - 0.1808;
	c = dot(p - vec2(-0.0079, -0.1171), vec2(0.4266, -0.9044));
	v = max(v, min(w, -c));
	w = length(p - vec2(0.2228, -0.1854)) - 0.3593;
	c = dot(p - vec2(-0.0079, -0.1171), vec2(0.4266, -0.9044));
	v = max(v, min(w, -c));
	u = v;
	p = pp - vec2(1.0304, 0.6354); // layer 1
	w = length(p - vec2(-0.7903, -0.0741)) - 0.7330;
	v = w;
	w = length(p - vec2(-0.2201, -0.1180)) - 0.1611;
	c = dot(p - vec2(-0.3026, -0.1235), vec2(0.0083, -1.0000));
	v = max(v, min(w, -c));
	w = length(p - vec2(-0.1002, -0.0880)) - 0.0385;
	c = dot(p - vec2(-0.1464, -0.0583), vec2(-0.1402, -0.9901));
	v = max(v, min(w, -c));
	u = max(u, -v);
	return u;
}

// neck, outline controller
float neck_oc(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	p = pp - vec2(0.0000, 0.0000); // layer 2
	w = length(p - vec2(1.0985, 0.2796)) - 0.3501;
	v = w;
	w = length(p - vec2(1.1352, 0.6959)) - 0.0815;
	v = min(v, w);
	u = v;//min(u, v);
	p = pp - vec2(0.0000, 0.0000); // layer 3
	w = length(p - vec2(0.8834, 0.5291)) - 0.0760;
	v = w;
	u = max(u, -v);
	return u;
}

// ear, shape
float ear(vec2 p)
{
	float u, v, w, c;
	p -= vec2(0.9568, 0.2445);
	w = length(p - vec2(0.1113, -0.0499)) - 0.1732; v = w;
	w = length(p - vec2(-0.1392, -0.0221)) - 0.1839; v = max(v, w);
	w = length(p - vec2(-0.0194, -0.1503)) - 0.0087; c = dot(p - vec2(-0.0101, -0.1549), vec2(0.1015, 0.9948)); v = max(v, min(w, -c));
	u = v;
	return u;
}

// ear, outline controller
float ear_oc(vec2 p)
{
	float u, v, w, c;
	w = length(p - vec2(0.8595, 0.1863)) - 0.1403; v = w;
	w = length(p - vec2(0.9921, 0.2162)) - 0.1078; c = dot(p - vec2(0.8415, 0.2123), vec2(0.5160, -0.8566)); v = max(v, min(w, -c));
	return v;
}

// ear, line
float ear_line(vec2 p)
{
	float u, v, w, c;
	w = length(p - vec2(1.0096, 0.1699)) - 0.0901; v = w;
	w = length(p - vec2(1.0738, 0.1386)) - 0.1554; v = max(v, -w);
	return v;
}

// eye, shape
float eye(vec2 pp)
{
	float v, w, c; vec2 p;
	p = pp - vec2(1.1567, 0.3152);
	w = length(p - vec2(-0.0414, 0.0298)) - 0.1206; v = w;
	w = length(p - vec2(0.0519, -0.0338)) - 0.1317; v = max(v, w);
	w = length(p - vec2(-0.0233, -0.0316)) - 0.0568; c = dot(p - vec2(-0.0015, -0.0940), vec2(0.6560, 0.7548)); v = max(v, min(w, -c));
	w = length(p - vec2(0.0216, 0.0345)) - 0.0572; c = dot(p - vec2(-0.0308, 0.1017), vec2(-0.5112, -0.8595)); v = max(v, min(w, -c));
	return v;
}

// tail, shape
float tail(vec2 pp)
{
	float u, v, w, c; vec2 p;
	p = pp - vec2(0.6995, 0.5739); // layer 0
	w = length(p - vec2(-0.3282, 0.2556)) - 0.4436; c = dot(p - vec2(-0.5523, -0.2676), vec2(0.4180, -0.9085)); v = max(w, -c);
	w = length(p - vec2(-0.2424, 0.0392)) - 0.2111; c = dot(p - vec2(-0.1039, -0.1677), vec2(0.1419, 0.9899)); v = max(v, min(w, -c));
	w = length(p - vec2(0.0151, 0.2533)) - 0.5033; c = dot(p - vec2(-0.0094, -0.0274), vec2(-0.4079, 0.9130)); v = min(v, max(w, -c));
	w = length(p - vec2(-0.2227, -0.1679)) - 0.2786; c = dot(p - vec2(-0.3528, 0.1040), vec2(-0.4607, -0.8876)); v = max(v, min(w, -c));
	u = v;
	p = pp - vec2(0.6995, 0.5739); // layer 1
	w = length(p - vec2(-0.0943, 0.1653)) - 0.1719; v = w;
	w = length(p - vec2(-0.0338, 0.2071)) - 0.2385; v = max(v, w);
	u = max(u, -v);
	p = pp - vec2(0.3737, 0.4466); // layer 2
	p = rotate(p, sin(time) * 0.02);
	w = length(p - vec2(0.0796, 0.1600)) - 0.2037; c = dot(p - vec2(0.0405, 0.0431), vec2(-0.9965, -0.0834)); v = max(w, -c);
	w = length(p - vec2(-0.0080, 0.2050)) - 0.1817; v = max(v, -w);
	u = min(u, v);
	p = pp - vec2(0.2378, 0.7297); // layer 3
	p = rotate(p, sin(time + 0.4) * 0.02);
	w = length(p - vec2(2.4159, 1.0297)) - 2.6540; c = dot(p - vec2(0.0825, -0.0475), vec2(-0.4446, 0.8957)); v = max(w, -c);
	w = length(p - vec2(-0.5442, -0.4311)) - 0.7098; v = max(v, w);
	u = min(u, v);
	p = pp - vec2(0.2787, 0.7868); // layer 4
	p = rotate(p, sin(time + 0.8) * 0.01);
	w = length(p - vec2(-0.2434, -0.2168)) - 0.3946; c = dot(p - vec2(0.0406, -0.1031), vec2(0.4614, 0.8872)); v = max(w, -c);
	w = length(p - vec2(-0.3085, -0.0772)) - 0.2736; c = dot(p - vec2(-0.3029, 0.1763), vec2(-0.8272, -0.5618)); v = max(v, -min(w, -c));
	u = min(u, v);
	p = pp - vec2(0.2322, 0.9199); // layer 5
	p = rotate(p, sin(time + 1.2) * 0.01);
	w = length(p - vec2(-0.2396, -0.3250)) - 0.4114; c = dot(p - vec2(-0.0011, -0.0362), vec2(0.6931, 0.7208)); v = max(w, -c);
	w = length(p - vec2(-0.1655, 0.0018)) - 0.1141; v = max(v, -w);
	u = min(u, v);
	p = pp - vec2(0.3674, 0.7854); // layer 6
	p = rotate(p, sin(time + 1.6) * 0.015);
	w = length(p - vec2(-0.4608, -0.1681)) - 0.5124; c = dot(p - vec2(0.0690, -0.1095), vec2(-0.1087, 0.9941)); v = max(w, -c);
	w = length(p - vec2(-0.5998, -0.0389)) - 0.5631; v = max(v, -w);
	u = min(u, v);
	p = pp - vec2(0.4392, 0.6790); // layer 7
	p = rotate(p, sin(time + 2.0) * 0.02);
	w = length(p - vec2(0.3503, 0.0856)) - 0.3843; c = dot(p - vec2(0.1132, -0.0549), vec2(-0.2666, 0.9638)); v = max(w, -c);
	w = length(p - vec2(0.5058, 0.2780)) - 0.5660; v = max(v, -w);
	u = min(u, v);
	return u;
}

// tail, color
vec3 tcolor(vec2 p)
{
	vec3 col = cM6;
	float v, w, c; vec2 q;
	q = p - vec2(0.0, 0.0);
	w = length(q - vec2(2.3051, 1.5097)) - 2.2003; v = w;
	w = length(q - vec2(0.5213, 0.6589)) - 0.2245; c = dot(q - vec2(0.6200, 0.5568), vec2(0.0479, 0.9989)); v = max(v, min(w, -c));
	col = mix(col, cM5, smoothstep(aav, 0.0, v));
	q = p - vec2(0.03, 0.03);
	w = length(q - vec2(2.3051, 1.5097)) - 2.2003; v = w;
	w = length(q - vec2(0.5213, 0.6589)) - 0.2245; c = dot(q - vec2(0.6200, 0.5568), vec2(0.0479, 0.9989)); v = max(v, min(w, -c));
	col = mix(col, cM4, smoothstep(aav, 0.0, v));
	q = p - vec2(0.06, 0.06);
	w = length(q - vec2(2.3051, 1.5097)) - 2.2003; v = w;
	w = length(q - vec2(0.5213, 0.6589)) - 0.2245; c = dot(q - vec2(0.6200, 0.5568), vec2(0.0479, 0.9989)); v = max(v, min(w, -c));
	col = mix(col, cM3, smoothstep(aav, 0.0, v));
	q = p - vec2(0.09, 0.08);
	w = length(q - vec2(2.3051, 1.5097)) - 2.2003; v = w;
	w = length(q - vec2(0.5213, 0.6589)) - 0.2245; c = dot(q - vec2(0.6200, 0.5568), vec2(0.0479, 0.9989)); v = max(v, min(w, -c));
	col = mix(col, cM1, smoothstep(aav, 0.0, v));
	q = p - vec2(0.11, 0.11);
	w = length(q - vec2(2.3051, 1.5097)) - 2.2003; v = w;
	w = length(q - vec2(0.5213, 0.6589)) - 0.2245; c = dot(q - vec2(0.6200, 0.5568), vec2(0.0479, 0.9989)); v = max(v, min(w, -c));
	col = mix(col, cM2, smoothstep(aav, 0.0, v));
	return col;
}

// leg, upper part, shape
float leg1(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(0.0000, 0.0000); // layer 0
	w = length(p - vec2(0.7257, 0.6589)) - 0.0945;
	v = w;
	w = length(p - vec2(0.7814, 0.6779)) - 0.1485;
	v = max(v, w);
	w = length(p - vec2(0.6342, 0.6873)) - 0.1602;
	v = max(v, w);
	w = length(p - vec2(0.6295, 0.5875)) - 0.1940;
	v = max(v, w);
	w = length(p - vec2(0.7558, 0.6792)) - 0.0381;
	c = dot(p - vec2(0.7617, 0.7662), vec2(-0.9413, -0.3376));
	v = max(v, min(w, -c));
	u = v;
	return u;
}

// leg, upper part, outline controller
float leg1_oc(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(0.0000, 0.0000); // layer 0
	w = length(p - vec2(0.6970, 0.6769)) - 0.1080;
	v = w;
	w = length(p - vec2(0.7302, 0.6621)) - 0.1032;
	c = dot(p - vec2(0.7489, 0.5796), vec2(0.3257, 0.9455));
	v = max(v, min(w, -c));
	w = length(p - vec2(0.7018, 0.6635)) - 0.0825;
	c = dot(p - vec2(0.6185, 0.6686), vec2(0.7463, -0.6656));
	v = max(v, min(w, -c));
	w = length(p - vec2(0.6735, 0.6022)) - 0.1607;
	v = max(v, w);
	w = length(p - vec2(0.6725, 0.8468)) - 0.1080;
	v = max(v, -w);
	u = v;
	return u;
}

// leg, mid part, shape
float leg2(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(0.6912, 0.7315); // layer 0
	w = length(p - vec2(0.0753, 0.1008)) - 0.1592;
	c = dot(p - vec2(0.0635, 0.0766), vec2(-0.0007, -1.0000));
	v = max(w, -c);
	w = length(p - vec2(-0.0137, 0.8304)) - 0.8630;
	v = max(v, w);
	w = length(p - vec2(-0.0576, 0.0352)) - 0.0110;
	c = dot(p - vec2(-0.0745, 0.0107), vec2(0.8896, -0.4567));
	v = max(v, min(w, -c));
	u = v;
	p = pp - vec2(0.6912, 0.7315); // layer 1
	w = length(p - vec2(-0.0518, 0.3509)) - 0.3088;
	v = w;
	w = length(p - vec2(-0.0708, 0.6350)) - 0.5910;
	v = max(v, w);
	u = max(u, -v);
	return u;
}

// leg, lower part, shape
float leg3(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(0.0000, 0.0000); // layer 0
	w = length(p - vec2(0.8492, 0.8011)) - 0.0848;
	v = w;
	w = length(p - vec2(0.8257, 0.8063)) - 0.1052;
	v = max(v, w);
	w = length(p - vec2(0.8915, 0.3509)) - 0.4751;
	v = max(v, w);
	w = length(p - vec2(0.9232, 0.8181)) - 0.0070;
	c = dot(p - vec2(0.9109, 0.8325), vec2(-0.6018, -0.7986));
	v = max(v, min(w, -c));
	w = length(p - vec2(0.9550, 0.6903)) - 0.2143;
	v = max(v, w);
	u = v;
	return u;
}

// leg, lower part, outline controller
float leg3_oc(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	
	p = pp - vec2(0.0000, 0.0000); // layer 0
	w = length(p - vec2(0.8762, 0.7770)) - 0.1131;
	c = dot(p - vec2(0.8980, 0.6651), vec2(0.6771, 0.7359));
	v = max(w, -c);
	w = length(p - vec2(0.8953, 0.8852)) - 0.1797;
	v = max(v, w);
	u = v;
	return u;
}

// cutie mark, bolt part, shape *invisible*
float cm_bolt(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	p = pp - vec2(0.6919, 0.7410);
	w = length(p - vec2(0.1212, -0.0547)) - 0.1528; c = dot(p - vec2(0.0260, -0.1165), vec2(-0.8935, 0.4490)); v = max(w, -c);
	w = length(p - vec2(0.0559, -0.0641)) - 0.0570; v = max(v, -w);
	w = length(p - vec2(0.0834, 0.0935)) - 0.1899; v = max(v, -w);
	u = v;
	p = pp - vec2(0.6919, 0.7410);
	w = length(p - vec2(0.0990, -0.0483)) - 0.1100; c = dot(p - vec2(0.0225, -0.0972), vec2(0.2557, 0.9668)); v = max(w, -c);
	w = length(p - vec2(0.1994, -0.0127)) - 0.1988; v = max(v, -w);
	u = min(u, v);
	return u;
}

// cutie mark, cloud part, shape *invisible*
float cm_cloud(vec2 pp)
{
	float u, v, w, c; vec2 p, q;
	p = pp - vec2(0.6919, 0.7410); // layer 0
	w = length(p - vec2(0.0425, -0.1134)) - 0.0202; v = w;
	w = length(p - vec2(0.0423, -0.1464)) - 0.0165; v = min(v, w);
	w = length(p - vec2(0.0194, -0.1526)) - 0.0165; v = min(v, w);
	w = length(p - vec2(0.0238, -0.1287)) - 0.0111; v = min(v, w);
	w = length(p - vec2(0.0184, -0.1250)) - 0.0097; v = min(v, w);
	w = length(p - vec2(0.0136, -0.1218)) - 0.0081; v = min(v, w);
	return v;
}

// cutie mark, color
vec3 cm_color(vec2 p)
{
	float v, w, c;
	vec3 col = cM2;
	w = length(p - vec2(0.8374, 0.7015)) - 0.1686; c = dot(p - vec2(0.6711, 0.6687), vec2(-0.4633, -0.8862)); v = max(w, -c);
	w = length(p - vec2(0.8191, 0.6984)) - 0.1333; v = min(v, w);
	col = mix(col, cM3, smoothstep(aav, 0.0, v));
	w = length(p - vec2(0.8121, 0.7030)) - 0.1332; c = dot(p - vec2(0.6836, 0.6580), vec2(-0.3880, -0.9217)); v = max(w, -c);
	w = length(p - vec2(0.8575, 0.7118)) - 0.1673; v = min(v, w);
	col = mix(col, cM5, smoothstep(aav, 0.0, v));
	return col;
}

// eyelash, shape
float lash(vec2 p)
{
	float v, w, c;
	v = length(p - vec2(0.0, -0.132)) - 0.136;
	w = length(p - vec2(0.0, 0.132)) - 0.136;
	v = max(v, w);
	return v;
}

float ellipse(vec2 p, float scale)
{
	float v, w, c;
	p /= scale;
	w = length(p - vec2(0.03, 0.0)) - 0.08; v = w;
	w = length(p - vec2(-0.03, 0.0)) - 0.08; v = max(v, w);
	w = length(p - vec2(0.0, -0.027)) - 0.04; c = dot(p - vec2(0.0, -0.056), vec2(0.0, 1.0)); v = max(v, min(w, -c));
	w = length(p - vec2(0.0, 0.027)) - 0.04; c = dot(p - vec2(0.0, 0.056), vec2(0.0, -1.0)); v = max(v, min(w, -c));
	return v * scale;
}

// iris and pupil
vec3 eye_color(vec2 pp)
{
	vec3 col = vec3(1.0);
	
	vec2 p = pp - vec2(1.1567, 0.3152);
	
	//vec2 look = vec2(fbm(time * 0.05 + 5.0) * 0.05, fbm(12.0 - time * 0.05) * 0.05);
	
	vec2 look = vec2(eyenoise(time * 0.03) * 0.03, eyenoise(12.0 - time * 0.02) * 0.03);
	
	vec2 q = p - vec2(0.03, 0.015) - look;
	q = rotate(q, 0.2);
	col = mix(col, mix(cEyeHi, cEyeLo, smoothstep(-0.05, 0.05, q.y)), smoothstep(aav, 0.0, ellipse(q, 1.4)));
	q = p - vec2(0.04, 0.03) - look;
	q = rotate(q, 0.2);
	col = mix(col, vec3(0.0), smoothstep(aav, 0.0, ellipse(q, 0.95)));
	
	float s = sin(time * 2.0) * 0.04 + 1.0;
	
	q = p - vec2(0.005, -0.01);
	q = rotate(q, -0.2);
	col = mix(col, vec3(1.0), smoothstep(aav, 0.0, ellipse(q, 0.5 * s)));
	
	q = p - vec2(0.048, 0.033);
	q = q.yx;
	col = mix(col, vec3(1.0), smoothstep(aav, 0.0, ellipse(q, 0.15 * s)));
	
	
	return col;
}

// wing, feathers, shape
float wing1_1(vec2 p)
{
	float v, w, c;
	w = length(p - vec2(0.7695, 0.8955)) - 0.3286; c = dot(p - vec2(0.9166, 0.6907), vec2(-0.9471, -0.3210)); v = max(w, -c);
	w = length(p - vec2(0.9455, 0.5188)) - 0.2226; v = max(v, w);
	w = length(p - vec2(0.7629, 0.5927)) - 0.0259; c = dot(p - vec2(0.7751, 0.5559), vec2(0.7985, 0.6020)); v = max(v, min(w, -c));
	w = length(p - vec2(0.8996, 0.5540)) - 0.1708; v = max(v, w);
	return v;
}

// wing, part 2, shape
float wing1_2(vec2 p)
{
	float v, w, c;
	w = length(p - vec2(0.8835, 0.6554)) - 0.0899; v = w;
	w = length(p - vec2(0.8974, 0.6375)) - 0.0872; v = max(v, w);
	w = length(p - vec2(0.8689, 0.6852)) - 0.0327; c = dot(p - vec2(0.8306, 0.6620), vec2(0.9087, -0.4174)); v = max(v, min(w, -c));
	w = length(p - vec2(0.8614, 0.6508)) - 0.0320; c = dot(p - vec2(0.8649, 0.6160), vec2(0.9159, 0.4013)); v = max(v, min(w, -c));
	w = length(p - vec2(0.9176, 0.6474)) - 0.0617; c = dot(p - vec2(0.9495, 0.6022), vec2(0.1775, 0.9841)); v = max(v, min(w, -c));
	return v;
}

// wing, part 2, outline controller
float wing1_2_olc(vec2 p)
{
	float v, w, c;
	w = length(p - vec2(0.8997, 0.6886)) - 0.1027; v = w;
	w = length(p - vec2(0.9223, 0.6428)) - 0.0547; v = min(v, w);
	return v;
}

// wing, feather lines
float wing1_2_line(vec2 p)
{
	float v;
	v = abs(dot(p - vec2(0.9154, 0.6252), vec2(-0.3633, 0.9317)));
	v = min(v, abs(dot(p - vec2(0.8472, 0.6431), vec2(-0.4785, 0.8781))));
	v = min(v, abs(dot(p - vec2(0.8338, 0.6854), vec2(-0.5502, 0.8350))));
	return v;
}

/////////////////////////////////////////////////////////////////////////////////////////////
// everything is put together here //////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

void rbd(inout vec3 col, vec2 uv)
{
	float v, v2, oc; vec2 q;
	
	// static body parts //////////////////////////////////////////////////////////
	
	v = arm2(uv - vec2(0.06, -0.045));
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw));
	col = mix(col, cCoatShad, smoothstep(aav, 0.0, v));
	
	vec2 ro;// = vec2(0.6969, 0.5691);
	//vec2 pTail = rotate(uv - ro, fbm(time)) + ro;	
	
	v = tail(uv);
	col = mix(col, cMOut, smoothstep(aav, 0.0, v - olw));
	col = mix(col, tcolor(uv), smoothstep(aav, 0.0, v));
	
	v = body(uv);
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw));
	col = mix(col, cCoat, smoothstep(aav, 0.0, v));//*/
	
	
	// face and neck section //////////////////////////////////////////////////////
	
	float ahd = fbm(time * 0.04) * 0.5;
	float ank = fbm(1482.0 - time * 0.04) * 0.5;
	
	ro = vec2(0.9919, 0.3395);
	vec2 pNeck = rotate(uv - vec2(1.0304, 0.6354), ank) + vec2(1.0304, 0.6354);	
	vec2 pHead = rotate(pNeck - vec2(0.9919, 0.3395), ahd) + vec2(0.9919, 0.3395);
	
	
	v = min(head(pHead), neck(pNeck));
	oc = smoothstep(aav, 0.0, neck_oc(pNeck));
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw) * oc);
	col = mix(col, cCoat, smoothstep(aav, 0.0, v));
	
	
	v = face_line(pHead);
	col = mix(col, cCOut, smoothstep(aav, 0.0, v));
	
	
	
	v = lash(rotate(pHead - vec2(1.0755, 0.2971), 0.0));
	col = mix(col, vec3(0.0), smoothstep(aav, 0.0, v));
	v = lash(rotate(pHead - vec2(1.0755, 0.27), -0.4));
	col = mix(col, vec3(0.0), smoothstep(aav, 0.0, v));
	v = lash(rotate(pHead - vec2(1.085, 0.24), -0.8));
	col = mix(col, vec3(0.0), smoothstep(aav, 0.0, v));
	
	
	v = eye(pHead - vec2(-0.002, -0.01));
	col = mix(col, vec3(0.0), smoothstep(aav, 0.0, v));
	v = eye(pHead);
	col = mix(col, eye_color(pHead), smoothstep(aav, 0.0, v));
	
	v = mane(pHead);
	col = mix(col, cMOut, smoothstep(aav, 0.0, v - olw));
	col = mix(col, mcolor(pHead), smoothstep(aav, 0.0, v));//*/
	
	
	v = arm1(uv);
	oc = smoothstep(aav, 0.0, arm1_oc(uv));
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw) * oc);
	col = mix(col, cCoat, smoothstep(aav, 0.0, v));

	
	pHead = rotate(pNeck - ro, ahd * 0.3) + ro;
	
	v = mback(pHead);
	col = mix(col, cMOut, smoothstep(aav, 0.0, v - olw));
	col = mix(col, mbcolor(pHead), smoothstep(aav, 0.0, v));//*/
	
	pHead = rotate(pNeck - ro, ahd * 0.7) + ro;
	
	v = ear(pHead);
	v2 = ear_oc(pHead);
	oc = smoothstep(aav, 0.0, v2);
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw) * oc);
	col = mix(col, cCoat, smoothstep(aav, 0.0, v));
	v = ear_line(pHead);
	col = mix(col, cCOut, smoothstep(aav, 0.0, v));
	
	
	
	
	// static body parts //////////////////////////////////////////////////////////

	
	
	v = leg2(uv);
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw));
	col = mix(col, cCoat, smoothstep(aav, 0.0, v));
	
	v2 = leg1_oc(uv);
	oc = smoothstep(aav, 0.0, v2);
	v = leg1(uv);
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw) * oc);
	col = mix(col, cCoat, smoothstep(aav, 0.0, v));
	
	v = cm_bolt(uv);
	/*col = mix(col, cm_color(uv), smoothstep(aav, 0.0, v));
	v = cm_cloud(uv);
	col = mix(col, cMOut, smoothstep(aav, 0.0, v - olw * 0.2));
	col = mix(col, vec3(1.0), smoothstep(aav, 0.0, v));//*/
	
	
	
	v = arm2(uv);
	oc = smoothstep(aav, 0.0, arm2_oc(uv));
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw) * oc);
	col = mix(col, cCoat, smoothstep(aav, 0.0, v));//*/
	
	
	v2 = leg3_oc(uv);
	oc = smoothstep(aav, 0.0, v2);
	v = leg3(uv);
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw) * oc);
	col = mix(col, cCoat, smoothstep(aav, 0.0, v));//*/
	
	ro = vec2(0.9248, 0.6056);
	vec2 pWing = rotate(uv - ro, fbm(492.0 - time * 0.05) * 0.2) + ro;
	
	vec3 ins = mix(cCoat, cCOut, smoothstep(aav, 0.0, wing1_2_line(pWing) - olw * 0.1));
	
	
	v = wing1_1(pWing);
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw));
	col = mix(col, ins, smoothstep(aav, 0.0, v));//*/
	v = wing1_2(pWing);
	oc = smoothstep(aav, 0.0, wing1_2_olc(pWing));
	col = mix(col, cCOut, smoothstep(aav, 0.0, v - olw) * oc);
	col = mix(col, cCoat, smoothstep(aav, 0.0, v));//*/
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
	//uv = uv * 2.0 - 1.0;
	uv.x *= iResolution.x / iResolution.y;
	
	uv *= 1.1;
	uv.y *= -1.0;
	uv.x += -0.2;
	uv.y += 1.05;
	
	/*uv.y *= -1.0;
	uv *= 2.0;
	uv.y += 1.2;
	uv.x += 0.1;*/
	
	vec3 col = mix(vec3(1.0), vec3(0.9), 1.0 - uv.y);//mix(vec3(0.678, 0.886, 0.957), vec3(0.329, 0.659, 0.835), 1.0 - uv.y);
	rbd(col, uv);
	
	gl_FragColor = vec4(col, 1.0);
}

