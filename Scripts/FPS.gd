extends Label

const TIMER := 1.0
var count := 0.0

func _ready() -> void:
  set_text("FPS: " + str(Engine.get_frames_per_second()))

func _process(dt: float) -> void:
  count += dt
  if count >= TIMER:
    count = 0.0
    set_text("FPS: " + str(Engine.get_frames_per_second()))
