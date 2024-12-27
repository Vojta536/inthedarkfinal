shader_type canvas_item;
    float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void fragment(){
  COLOR = vec4(rand(vec2(TIME,UV.x+UV.y)) ,rand(vec2(TIME,UV.x+UV.y)),rand(vec2(TIME,UV.x+UV.y)),     0.2);
}
