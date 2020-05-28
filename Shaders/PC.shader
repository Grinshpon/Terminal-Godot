shader_type canvas_item;

uniform bool screen_on = true;
uniform vec2 cursor;

const vec4 pix_off = vec4(0, 0, 0, 1.0);
const vec4 pix_on = vec4(0, 1.0, 0, 1.0);

void fragment() {
  if (screen_on) {
    int px = int(UV.x*320.0);
    int py = int(UV.y*300.0);
    int cx = int(cursor.x);
    int cy = int(cursor.y);
    int dh = px-cx;
    int dv = py-cy;
    if ((int(TIME) % 3 == 0) && dh >= 0 && dh < 5 && dv >= 0 && dv < 8) {
      COLOR = pix_on;
    }
//    if ((int(TIME) % 3 == 0) && dh == 0 && dv == 0) {
//      COLOR = pix_on;
//    }
  }
}