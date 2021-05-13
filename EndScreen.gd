extends RichTextLabel

var points_string = "POINTS: {points}"

func _process(_delta):
	var formatted_points_string = points_string.format({"points": Global.points})
	text = formatted_points_string
