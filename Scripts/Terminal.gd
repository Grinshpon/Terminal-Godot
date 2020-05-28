extends MeshInstance

export var width := 280
export var height := 192
onready var bits := width*height

const pix_on := Color(0.0,1.0,0.0)
const pix_off := Color(0.0,0.0,0.0)

var vram: BitMap
#var text: PoolIntArray # ascii encoded
var buf: Image #buffer
var con: ImageTexture #console
const format:int = Image.FORMAT_RGB8

## To improve performance, instead of drawing every row each frame, it will only draw every other row, alternating
## the starting row (0 or 1) based on whether skip_rows is false or true
var skip_rows := false

## Another optimization, is to limit the framerate of the virtual console,
## so that it does not update every _process.
## Must be smaller than the game's base framerate
var hertz := 40.0 #try 24, 30, 40, 48, 59
onready var frame_rate := 1.0/hertz
onready var frame_tick := 0.0

export var cursor: Vector2
var show_cursor := true
var blink := 0.0

func _ready() -> void:
  mesh.size.x = float(width)/height
  print(width, "x", height, ", ", float(width)/height, ", ", bits)
  vram = BitMap.new()
  vram.create(Vector2(width,height))
  buf = Image.new()
  #buf.create_from_data(320,200,false,format,vram)
  buf.create(width,height,false,format)
  #buf.decompress()
  con = ImageTexture.new()
  #con.create_from_image(buf,0)
  con.create(width,height,format,0)
  get_surface_material(0).albedo_texture = con
  print("ready")

func clear() -> void:
  for y in range(height):
    for x in range(0,width,2):
      buf.set_pixel(x+int(skip_rows),y,pix_off)

func set_pixel(x: int, y: int) -> void:
  buf.set_pixel(x,y,pix_on)

func init_draw() -> void:
  skip_rows = !skip_rows
  buf.lock()
  #clear()

func close_draw() -> void:
  for y in range(height):
    for x in range(0,width,2):
      if vram.get_bit(Vector2(x+int(skip_rows),y)):
        buf.set_pixel(x+int(skip_rows),y,pix_on)
      else:
        buf.set_pixel(x+int(skip_rows),y,pix_off)
  buf.unlock()
  con.set_data(buf)

func _process(dt: float) -> void:
  blink += dt
  if blink >= 1.0:
    blink = 0.0
    show_cursor = !show_cursor
  frame_tick += dt
  if frame_tick >= frame_rate:
    frame_tick = 0.0
    init_draw()
    draw()
    close_draw()
  
func draw() -> void:
  draw_cursor(show_cursor)

func draw_cursor(show: bool) -> void:
  var cx := int(cursor.x)
  var cy := int(cursor.y)
  for px in range(5):
    for py in range(8):
      vram.set_bit(Vector2(cx+px,cy+py),show)
      #set_pixel(px+cx,py+cy)
