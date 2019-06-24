shader_type canvas_item;

uniform vec4 color : hint_color = vec4(0.33, 0.15, 0.82, 0.5);
uniform vec2 screenDim = vec2(640, 360);
uniform int octaves = 4;

// hash based 3d value noise
// function taken from https://www.shadertoy.com/view/XslGRr
// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// ported from GLSL to HLSL

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( vec3 x )
{
    // The noise function returns a value in the range -1.0f -> 1.0f

    vec3 p = floor(x);
    vec3 f = fract(x);

    f       = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;

    return mix(mix(mix( hash(n+0.0), hash(n+1.0),f.x),
                   mix( hash(n+57.0), hash(n+58.0),f.x),f.y),
               mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                   mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
}
/*
float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56, 78)) * 1000.0) * 1000.0);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}*/

//Fractional brownian motion
float fbm(vec2 coord){
	float val = 0.0;
	float scale = 0.5;
	for(int i = 0; i < octaves; i++){
		val += noise(vec3(coord, 0.0))*scale;
		coord *= 2.0;
		scale*=0.5;
	}
	return val;
}

float band(float val, float numBands){
	return floor(val*numBands)/numBands;
}
vec2 band2(vec2 val, vec2 numBands){
	return vec2(band(val.x, numBands.x), band(val.y, numBands.y));
}
void fragment(){
	COLOR.rgb = color.rgb;
	vec2 coord = UV*5.0;//band2(SCREEN_UV*20.0, screenDim);
	//moving
	vec2 motion = vec2( fbm( coord+vec2(TIME*0.5, TIME*-0.5)));
	float final = fbm(coord+motion);
	
	COLOR.a = final*color.a;//fbm(UV*10.0);
}