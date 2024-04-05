extends GutTest

var BigGrid
var big_grid: resource_pile

func before_all():
	BigGrid = load("res://scenes/BigGrid.tscn")
	
func before_each():
	big_grid = BigGrid.instantiate()
	get_node('/root/').add_child(big_grid)

func test_example_change():
	if(!big_grid.is_node_ready()):
		await big_grid.ready
	var resource_A = big_grid.get_resource("A")
	assert_not_null(resource_A)
	big_grid.apply_changes([{"id": "A","deltas": [1]}])
	assert_eq(resource_A.value, 1)

func test_example_change_that_fails():
	if(!big_grid.is_node_ready()):
		await big_grid.ready
	var resource_A = big_grid.get_resource("A")
	big_grid.apply_changes([{"id": "A","deltas": [-1, 2]}])
	assert_eq(resource_A.value, 0)

func after_each():
	big_grid.queue_free()

#var Bus
#var _bus: bus
#
#func before_all():
	#Bus = load("res://scripts/bus.gd")
#
#func before_each():
	#_bus = Bus.new()
#
#func test_bus_answer():
	#_bus.generate_problem()
	#print(str("stream: ", _bus.stream))
	#print(str("answer: ", _bus.answer))
	#assert_true(_bus.submit_answer(_bus.answer))
#
#func test_linear_pattern_problem():
	#_bus.generate_problem(bus.Problem_Types.PATTERN)
	#print(str("stream: ", _bus.stream))
	#print(str("answer: ", _bus.answer))
	#assert_true(_bus.submit_answer(_bus.answer))
#
#func test_linear_pattern_processing():
	#_bus.generate_problem(bus.Problem_Types.PATTERN)
	#var stream = _bus.stream
	#var answer = [stream[2] * 2 - stream[1]]
	#print(str("stream: ", _bus.stream))
	#print(str("answer: ", _bus.answer, " calculated answer: ", answer))
	#assert_true(_bus.submit_answer(answer))
#
#func after_each():
	#_bus.queue_free()
