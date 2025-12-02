extends Node2D

var player_in_range = false;
var player_is = null
var talking = false
var line_index = 1

@export var npc_name = "Bezdommny"
@export var dialog_lines = [
	"Test1",
	"Test2",
	"Cipek bierze w dupe"
]
@onready var e_hint = $Ehint
@export var dialog_ui_path: NodePath
var e_hint_base_y: float
var e_hint_time: float = 0.0
var dialog_ui


func _ready() -> void:
	dialog_ui = get_node(dialog_ui_path)
	if dialog_ui_path != NodePath():
		dialog_ui = get_node(dialog_ui_path)
	if e_hint:
		e_hint_base_y = e_hint.position.y
		e_hint.visible = false 
func _process(_delta: float) -> void:
	#z_index = int(global_position.y)
	if player_in_range and Input.is_action_just_pressed("interact"):
		if not talking:
			start_dialog()
	if talking and Input.is_action_just_pressed("ui_accept"):
		next_line()
			
	if e_hint and e_hint.visible:
		e_hint_time += _delta
		var offset = sin(e_hint_time* 3.0) * 4.0
		e_hint.position.y = e_hint_base_y + offset
		
func start_dialog():
	if dialog_ui == null:
		return 
	talking = true
	line_index = 0
	dialog_ui.show_dialog(npc_name, dialog_lines[line_index])
	if player_is:
		player_is.can_move = false
		
func next_line():
	line_index+=1
	if  line_index >= dialog_lines.size():
		end_dialog()
	else:
		dialog_ui.show_dialog(npc_name, dialog_lines[line_index])
		
func end_dialog():
	talking = false
	line_index = -1
	if dialog_ui:
		dialog_ui.hide_dialog()
	if player_is:
		player_is.can_move = true
		
#func _on_chat_detecion_entered(body):
	#if body.is_in_group("player"):
		#player_in_range = true
		#player_is = body
#func _on_body_exited(body):
	#if body.is_in_group("player"):
		#player_in_range = false
		#player_is = null
		#end_dialog();


func _on_chat_detecion_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("wszedl gracz")
		player_in_range = true
		player_is = body
		if e_hint:
			e_hint.visible = true


func _on_chat_detecion_body_exited(body: Node2D) -> void:
		if body.is_in_group("player"):
			print("wyszedl gracz")
			player_in_range = false
			player_is = null
			if e_hint:
				e_hint.visible = false
			end_dialog();
