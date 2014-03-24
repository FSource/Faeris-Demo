// Shader by Nicolas Robert [NRX]
// Latest version: http://glsl.heroku.com/e#14872.16
//
// Forked from: http://glsl.heroku.com/e#14825.2 (Ray marching by MG - thanks to him!)
//
// Modification of MG's shader by NRX: optimized the ray marching by avoiding evaluating the distance to each shape at every step. Also
// added new shapes and deformation (to check whether it works fine or not), and removed the noise used to map the ground, to simplify the
// experiment. Also, added the possibility to texture each shape by having the local coordinates of the intersection point with the ray.
//
// You can also check http://glsl.heroku.com/e#15072.8 (and later revisions).

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float iGlobalTime = time;
vec3 iResolution = vec3 (resolution, 0.0);

#define DELTA			0.01
#define RAY_LENGTH_MAX		50.0
#define RAY_STEP_MAX		100
#define LIGHT			vec3 (0.5, 0.75, 1.0)
#define SHADOW
#define BACK_COLOR		vec3 (0.25, 0.5, 1.0)
#define AMBIENT			0.2
#define SPECULAR_POWER		4.0
#define SPECULAR_INTENSITY	0.5
#define REFLECT_COUNT		2
#define FADE_POWER		1.0
#define OBJ_COUNT		7
#define M_PI			3.1415926535897932384626433832795
#define OPTIMIZED

int debugCounter1;
int debugCounter2;

mat3 mRotate (in vec3 angle) {
	float c = cos (angle.x);
	float s = sin (angle.x);
	mat3 rx = mat3 (1.0, 0.0, 0.0, 0.0, c, s, 0.0, -s, c);

	c = cos (angle.y);
	s = sin (angle.y);
	mat3 ry = mat3 (c, 0.0, -s, 0.0, 1.0, 0.0, s, 0.0, c);

	c = cos (angle.z);
	s = sin (angle.z);
	mat3 rz = mat3 (c, s, 0.0, -s, c, 0.0, 0.0, 0.0, 1.0);

	return rz * ry * rx;
}

vec3 vRotateX (in vec3 p, in float angle) {
	float c = cos (angle);
	float s = sin (angle);
	return vec3 (p.x, c * p.y + s * p.z, c * p.z - s * p.y);
}

vec3 vRotateY (in vec3 p, in float angle) {
	float c = cos (angle);
	float s = sin (angle);
	return vec3 (c * p.x - s * p.z, p.y, c * p.z + s * p.x);
}

vec3 vRotateZ (in vec3 p, in float angle) {
	float c = cos (angle);
	float s = sin (angle);
	return vec3 (c * p.x + s * p.y, c * p.y - s * p.x, p.z);
}

float sphere (in vec3 p, in float r) {
	return length (p) - r;
}

float box (in vec3 p, in vec3 b, in float r) {
	vec3 d = abs (p) - b + r;
	return min (max (d.x, max (d.y, d.z)), 0.0) + length (max (d, 0.0)) - r;
}

float plane (in vec3 p, in vec3 n, in float d) {
	return dot (p, normalize (n)) + d;
}

float planeZ (in vec3 p) {
	return p.z;
}

float torusX (in vec3 p, in float r1, in float r2) {
	vec2 q = vec2 (length (p.yz) - r1, p.x);
	return length (q) - r2;
}

float torusY (in vec3 p, in float r1, in float r2) {
	vec2 q = vec2 (length (p.xz) - r1, p.y);
	return length (q) - r2;
}

float torusZ (in vec3 p, in float r1, in float r2) {
	vec2 q = vec2 (length (p.xy) - r1, p.z);
	return length (q) - r2;
}

float cylinderX (in vec3 p, in float r) {
 	return length (p.yz) - r;
}

float cylinderY (in vec3 p, in float r) {
 	return length (p.xz) - r;
}

float cylinderZ (in vec3 p, in float r) {
 	return length (p.xy) - r;
}

vec3 twistX (in vec3 p, in float k, in float angle) {
	return vRotateX (p, angle + k * p.x);
}

vec3 twistY (in vec3 p, in float k, in float angle) {
	return vRotateY (p, angle + k * p.y);
}

vec3 twistZ (in vec3 p, in float k, in float angle) {
	return vRotateZ (p, angle + k * p.z);
}

vec3 repeat (in vec3 p, in vec3 k) {
	if (k.x > 0.0) {
		p.x = mod (p.x, k.x) - 0.5 * k.x;
	}
	if (k.y > 0.0) {
		p.y = mod (p.y, k.y) - 0.5 * k.y;
	}
	if (k.z > 0.0) {
		p.z = mod (p.z, k.z) - 0.5 * k.z;
	}
	return p;
}

float fixDistance (in float d, in float correction, in float k) {
	correction = max (correction, 0.0);
	k = clamp (k, 0.0, 1.0);
	return min (d, max ((d - DELTA) * k + DELTA, d - correction));
}

vec4 getDistance (in vec3 p, in int objectIndex) {
	++debugCounter2;

	vec4 q;
	if (objectIndex == 0) {
		q.xyz = p + vec3 (0.0 , 0.0, sin (iGlobalTime + p.x * 0.5) + sin (p.y * 0.5));
		q.w = fixDistance (plane (q.xyz, vec3 (-0.2, 0.0, 1.0), 5.0), 0.6, 0.8); // need to fix the distance because of the sine deformation
	}
	else if (objectIndex == 1) {
		q.xyz = twistY (p + vec3 (-5.0, 0.0, 0.0), cos (iGlobalTime), iGlobalTime);
		q.w = box (q.xyz, vec3 (1.0, 1.0, 1.0), 0.1); // no need to fix the distance here, despite of the twist
	}
	else if (objectIndex == 2) {
		q.xyz = mRotate (vec3 (0.7, 0.0, -0.2)) * (p + vec3 (0.0, -3.0, 0.0));
		q.w = box (q.xyz, vec3 (1.0, 0.5, 1.0), 0.3);
	}
	else if (objectIndex == 3) {
		q.xyz = p + vec3 (3.0, -1.0, sin (iGlobalTime * 2.0) - 1.0);
		q.w = sphere (q.xyz, 1.0);
	}
	else if (objectIndex == 4) {
		q.xyz = twistY (p + vec3 (0.0, 4.0, 0.0), 2.0, 0.0);
		q.w = fixDistance (torusZ (q.xyz, 1.0, 0.3), 0.8, 0.5); // need to fix the distance because of the twist
	}
	else if (objectIndex == 5) {
		q.xyz = repeat (p + vec3 (0.0, 0.0, 2.0), vec3 (0.0, 5.0, 0.0));
		q.w = cylinderX (q.xyz, 0.2);
	}
	else if (objectIndex == 6) {
		q.xyz = repeat (p + vec3 (0.0, 0.0, 2.0), vec3 (5.0, 0.0, 0.0));
		q.w = cylinderY (q.xyz, 0.2);
	}
	else {
		q.w = RAY_LENGTH_MAX;
	}
	return q;
}

vec3 getObjectColor (in int objectIndex, in vec3 q, out float reflection) {
	float tint = 0.6 + 0.4 * sin (q.x * 10.0) * sin (q.y * 10.0) * sin (q.z * 10.0);
	if (objectIndex == 0) {
		reflection = 0.0;
		return (0.6 + 0.4 * tint) * vec3 (0.2, 1.0, 1.0);
	}
	if (objectIndex == 1) {
		reflection = 0.2;
		return tint * vec3 (1.0, 0.0, 0.0);
	}
	if (objectIndex == 2) {
		reflection = 0.0;
		return tint * vec3 (0.0, 0.0, 1.0);
	}
	if (objectIndex == 3) {
		reflection = 0.5;
		return tint * vec3 (1.0, 1.0, 0.0);
	}
	if (objectIndex == 4) {
		reflection = 0.0;
		return tint * vec3 (1.0, 0.2, 0.5);
	}
	if (objectIndex >= 5) {
		reflection = 0.0;
		return tint * vec3 (0.5, 0.5, 0.6);
	}
	reflection = 0.0;
	return BACK_COLOR;
}

vec3 getNormal (in vec3 p, in int objectIndex) {
	vec2 h = vec2 (DELTA, 0.0);
	return normalize (vec3 (
		getDistance (p + h.xyy, objectIndex).w - getDistance (p - h.xyy, objectIndex).w,
		getDistance (p + h.yxy, objectIndex).w - getDistance (p - h.yxy, objectIndex).w,
		getDistance (p + h.yyx, objectIndex).w - getDistance (p - h.yyx, objectIndex).w
	));
}

#ifndef OPTIMIZED
int getClosestObject (in vec3 p, out vec3 q, out float rayIncrement) {
	int closestObjectIndex = -1;
	rayIncrement = RAY_LENGTH_MAX;
	for (int objectIndex = 0; objectIndex < OBJ_COUNT; ++objectIndex) {
		vec4 objectInfo = getDistance (p, objectIndex);
		if (objectInfo.w < rayIncrement) {
			rayIncrement = objectInfo.w;
			closestObjectIndex = objectIndex;
			q = objectInfo.xyz;
		}
	}
	return closestObjectIndex;
}
#else
float distObject [OBJ_COUNT];

int getClosestObject (in vec3 p, out vec3 q, inout float rayIncrement, inout float minDist1) {
	int closestObjectIndex = -1;
	float minDist2 = RAY_LENGTH_MAX;
	for (int objectIndex = 0; objectIndex < OBJ_COUNT; ++objectIndex) {
		float dist = distObject [objectIndex];
		dist -= rayIncrement;
		if (dist < minDist1) {
			vec4 objectInfo = getDistance (p, objectIndex);
			dist = objectInfo.w;
			if (dist < minDist1) {
				minDist2 = minDist1;
				minDist1 = dist;
				closestObjectIndex = objectIndex;
				q = objectInfo.xyz;
			}
			else if (dist < minDist2) {
				minDist2 = dist;
			}
		}
		distObject [objectIndex] = dist;
	}
	rayIncrement = minDist1;
	minDist1 = minDist2;
	return closestObjectIndex;
}
#endif

int rayMarch (in vec3 origin, in vec3 direction, out vec4 objectInfo) {
	#ifdef OPTIMIZED
	for (int objectIndex = 0; objectIndex < OBJ_COUNT; ++objectIndex) {
		distObject [objectIndex] = 0.0;
	}
	float minDist = RAY_LENGTH_MAX;
	#endif

	vec3 p = origin;
	objectInfo.w = 0.0;
	float rayIncrement = RAY_LENGTH_MAX;
	int closestObjectIndex = -1;
	for (int rayStep = 0; rayStep < RAY_STEP_MAX; ++rayStep) {
		++debugCounter1;

		#ifdef OPTIMIZED
		closestObjectIndex = getClosestObject (p, objectInfo.xyz, rayIncrement, minDist);
		#else
		closestObjectIndex = getClosestObject (p, objectInfo.xyz, rayIncrement);
		#endif
		objectInfo.w += rayIncrement;
		if (rayIncrement < DELTA || objectInfo.w > RAY_LENGTH_MAX) {
			break;
		}
		p = origin + direction * objectInfo.w;
	}
	return rayIncrement < DELTA ? closestObjectIndex : -1;
}

vec3 getFragmentColor (in vec3 origin, in vec3 direction) {
	vec3 lightDirection = normalize (LIGHT);
	float moveAway = DELTA * 10.0;

	vec3 color = vec3 (0.0, 0.0, 0.0);
	float absorb = 1.0;
	float fade = 0.0;

	for (int reflectionIndex = 0; reflectionIndex < REFLECT_COUNT; ++reflectionIndex) {

		// Get the object information
		vec4 objectInfo;
		int objectIndex = rayMarch (origin, direction, objectInfo);

		// Compute the fade factor
		if (reflectionIndex == 0) {
			fade = pow (1.0 - objectInfo.w / RAY_LENGTH_MAX, FADE_POWER);
		}

		// Compute the fragment color
		color *= 1.0 - absorb;
		if (objectIndex < 0) {
			color += BACK_COLOR * absorb;
			break;
		}

		// Object color
		float reflection;
		vec3 objectColor = getObjectColor (objectIndex, objectInfo.xyz, reflection);
		// Intersection point
		vec3 p = origin + direction * objectInfo.w;
		vec3 normal = getNormal (p, objectIndex);
		direction = reflect (direction, normal);

		// Lighting
		#ifdef SHADOW
		int otherObject = rayMarch (p + lightDirection * moveAway, lightDirection, objectInfo);
		if (otherObject >= 0) {
			objectColor *= AMBIENT;
		}
		else
		#endif
		{
			float diffuse = max (0.0, dot (normal, lightDirection));
			float specular = pow (max (0.0, dot (direction, lightDirection)), SPECULAR_POWER) * SPECULAR_INTENSITY;
			objectColor = (AMBIENT + diffuse) * objectColor + specular;
		}
		color += objectColor * absorb;

		// Next ray...
		if (reflection < DELTA) {
			break;
		}
		absorb *= reflection;
		origin = p + direction * moveAway;
	}
	return mix (BACK_COLOR, color, fade);
}

void main () {

	// Initialize some debug variables
	debugCounter1 = 0;
	debugCounter2 = 0;

	// Define the ray corresponding to this fragment
	vec2 p = (2.0 * gl_FragCoord.xy - iResolution.xy) / iResolution.y;
	vec3 direction = normalize (vec3 (p.x, p.y, 2.0));

	// Set the camera
	float angle = M_PI * sin (0.1 * iGlobalTime);
	vec3 origin = vec3 (10.0 * cos (angle), 10.0 * sin (angle), 2.5);
	direction = mRotate (vec3 (M_PI / 2.0 + 0.45, 0.0, angle - M_PI / 2.0)) * direction;

	// Get the color of this fragment
	vec3 color = getFragmentColor (origin, direction);
	vec3 debugColor = vec3 (float (debugCounter1) / float (RAY_STEP_MAX / 2), float (debugCounter2) / float (OBJ_COUNT * RAY_STEP_MAX / 2), 0.0);
	gl_FragColor = vec4 (mix (color, debugColor, max (0.0, sin (iGlobalTime * 0.3))), 1.0);

}
