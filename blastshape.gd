extends Polygon2D

func _ready():
    hide()

func _on_Player_draw_blastshape():
    show()

func _on_Player_activate_blast():
    hide()