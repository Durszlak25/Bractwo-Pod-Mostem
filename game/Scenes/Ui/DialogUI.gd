extends CanvasLayer
@onready var panel = $Panel
@onready var Npc_text = $Panel/Npc_text
@onready var Npc_name = $Panel/Npc_name

var _tween: Tween
var _panel_target_pos: Vector2

func _ready() -> void:
	visible = false
	_panel_target_pos = panel.position
	
func show_dialog(npc_name: String, text:String):
	Npc_name.text = npc_name
	Npc_text.text = text
	visible = true
	#tween deleting
	if _tween:
		_tween.kill()
	
	var start_pos = _panel_target_pos + Vector2(0, panel.size.y)
	panel.position = start_pos
	
	#new tween creation
	_tween = get_tree().create_tween()
	_tween.tween_property(panel,"position", _panel_target_pos, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	
func hide_dialog():
	visible = false
