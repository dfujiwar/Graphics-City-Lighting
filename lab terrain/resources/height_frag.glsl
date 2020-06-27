#version 330 core
out vec4 color;
in vec3 vertex_pos;
in vec2 vertex_tex;
#define NUMLIGHTS 21

uniform sampler2D tex;
uniform sampler2D tex2;
uniform vec3 camoff;
uniform vec3 campos;
uniform vec2 texoff;
uniform vec3 lightpos[NUMLIGHTS];
uniform vec3 lightcolor[NUMLIGHTS];

void main()
{
vec3 lp = vec3(30,100,30);
vec3 ld = lp - vertex_pos;
float t=1./10.;
vec3 n1 = texture(tex,vertex_tex*10 + texoff - vec2(camoff.x,camoff.z)*t).rgb;
vec3 n2 = texture(tex2, vertex_tex*10 -vec2(texoff.y,texoff.x) - vec2(camoff.x,camoff.z)*t ).rgb;
vec2 texcoords= vertex_tex;
//float t=1./100.;
//texcoords -= vec2(camoff.x,camoff.z)*t;

n1 = (n1 + vec3(1,1,1))/2.;
n2 = (n2 + vec3(1,1,1))/2.;
vec3 normal = normalize(n1+n2);
normal = vec3(normal.x, normal.z,normal.y);

vec3 cd = campos - vertex_pos;
vec3 h = normalize(ld + cd);
float spec = dot(normal,h);
spec = clamp(spec, 0,1);
spec = pow(spec, 15);
color.a =1;
color.rgb = vec3(0.5,0.2,0.8) * spec;
//vec3 heightcolor = texture(tex, texcoords).rgb;
//heightcolor.r = 0.1 + heightcolor.r*0.9;
//color.rgb *= heightcolor.r;

for(int i = 0; i < NUMLIGHTS; i++){
		ld = normalize(lightpos[i] - vertex_pos);

		h = normalize(cd+ld);
		spec = dot(normal,h);
		spec = clamp(spec,0,1);
		spec = pow(spec,20);
	
		color.rgb += lightcolor[i%4]*spec*3;
	}
color.a=1;

float len = length(vertex_pos.xz+campos.xz);
len-=41;
len/=8.;
len=clamp(len,0,1);
color.a=1-len;


}
