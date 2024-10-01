shader_type spatial;

render_mode unshaded, fog_disabled;

uniform sampler2D albedoTex;

void vertex() {
	float ambient = 0.2f;
	float diff = max(dot(MODEL_NORMAL_MATRIX*NORMAL, vec3(0.0, 1.0, 0.0)),0.0f);
	
	float lightIntensity = max(ambient + diff, 0.0f);
	COLOR = vec4(lightIntensity, lightIntensity, lightIntensity, 1.0f);
}

void fragment() {
	// Texture
	vec4 textureColor = texture(albedoTex, UV);

	// Discard fragment when alpha is low
	if (textureColor.a < 0.2f) {
		discard;
	}

	// Position of fragment
	vec4 pos4 = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 pos = vec3(pos4.x, pos4.y, pos4.z);

	// lighting based on height
	float lightMult = 0.0f;
	const float HEIGHT_THRESHOLD = 3.0f;
	if (pos.y < HEIGHT_THRESHOLD) {
		lightMult = HEIGHT_THRESHOLD - pos.y;
		lightMult = clamp(lightMult, 0.0, 1.0);
	}
	
	// Bottom light color
	vec3 bottomLight = vec3(0.788,0.717,0.588);
	// Overlay light
	vec3 light = mix(vec3(1.0), bottomLight, lightMult);
	

	ALBEDO = texture(albedoTex, UV).rgb * COLOR.rgb * light;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
