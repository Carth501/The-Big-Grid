extends Label

var duration := 2.0
var speed = 22

func _physics_process(delta):
	position.y += speed * delta

func _ready():
	var timer = Timer.new()
	timer.wait_time = duration
	timer.timeout.connect(end)
	add_child(timer)
	timer.start()

func end():
	queue_free()
