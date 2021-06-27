extends HSlider

var count

func _ready():
	count = get_child(0)

func _process(_delta):
	count.text = str(value)
