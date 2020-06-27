#version 330 core
#define NUMLIGHTS 28
out vec4 color;
in vec3 vertex_normal;
in vec3 vertex_pos;
in vec2 vertex_tex;
uniform vec3 campos;

uniform sampler2D tex;
uniform sampler2D tex2;
uniform vec3 lightpos[NUMLIGHTS];
uniform vec3 lightcolor[NUMLIGHTS];

void main()
{
	vec3 n = normalize(vertex_normal);
	vec3 lp = vec3(0,100,100);
	vec3 ld = normalize(lp - vertex_pos);
	float diffuse = dot(n,ld);
	diffuse = clamp(diffuse,0,1);
	color.rgb = texture(tex, vertex_tex).rgb;
	//color.rgb = vec3(0.5);

	
	vec3 ambient = vec3(0.05f,0.05f,0.05f) * color.rgb;
	color.rgb *= diffuse*0.3;

	color.rgb += ambient;
	vec3 cd = normalize(campos-vertex_pos);
	vec3 h = normalize(cd+ld);
	float spec = dot(n,h);
	spec = clamp(spec,0,1);
	spec = pow(spec,30);
	color.rgb += vec3(1,1,1)*spec;

	for(int i = 0; i < NUMLIGHTS; i++){
		ld = normalize(lightpos[i] - vertex_pos);
		diffuse = dot(n,ld);
		diffuse = clamp(diffuse,0,1);
		float distance = length( lightpos[i] - vertex_pos);
		float attenuation = 1.0f / (1.0f + 0.9f * distance + 0.42f * (distance*distance));
		ambient = vec3(0.05f,0.05f,0.05f) * attenuation;
		color.rgb += diffuse*0.7 * attenuation;

		color.rgb += ambient;
		cd = normalize(campos-vertex_pos);
		vec3 reflect = reflect(n,ld);
		spec = dot(cd,reflect);
		spec = clamp(spec,0,1);
		spec = pow(spec,5);
		if (i ==21){
		color.rgb += lightcolor[4]*spec*attenuation*3;
		}
		else{
		color.rgb += lightcolor[i%4]*spec*attenuation*3;
		}
	}
	color.a = 1;

}

