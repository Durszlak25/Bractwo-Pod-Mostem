extends Control

signal close_options

@onready var back_button = $OptionsBackButton
@onready var resolution_button = $VBoxContainer/HBoxContainer/ResolutionOptionButton
@onready var fullscreen_button = $VBoxContainer/HBoxContainer2/FullscreenButton 
@onready var vsync_button = $VBoxContainer/HBoxContainer3/VSyncButton 

const RESOLUTIONS: Dictionary = {
	"3840 x 2160" : Vector2i(3840, 2160),
	"2560 x 1440": Vector2i(2560,1440),
	"1920 x 1080": Vector2i(1920, 1080),
	"1280 x 720": Vector2i(1280, 720),
	"1152 x 648": Vector2i(1152, 648)
}

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	
	add_resolutions_to_button()
	
	var current_size = get_window().size
	var index = 0
	for res_string in RESOLUTIONS:
		if RESOLUTIONS[res_string] == current_size:
			resolution_button.selected = index
			break 
		index += 1

	var mode = get_window().mode
	if mode == Window.MODE_FULLSCREEN or mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
		fullscreen_button.button_pressed = true
	else:
		fullscreen_button.button_pressed = false
		
	var current_vsync = DisplayServer.window_get_vsync_mode()
	vsync_button.button_pressed = (current_vsync == DisplayServer.VSYNC_ENABLED)

	resolution_button.item_selected.connect(_on_resolution_selected)
	fullscreen_button.toggled.connect(_on_fullscreen_toggled)
	vsync_button.toggled.connect(_on_vsync_toggled)

func add_resolutions_to_button():
	for res_string in RESOLUTIONS:
		resolution_button.add_item(res_string)


#FIXME not changing game window size
func _on_resolution_selected(index: int):
	var selected_text = resolution_button.get_item_text(index)
	var target_size = RESOLUTIONS[selected_text]
	
	get_window().size = target_size
	get_window().move_to_center()

func _on_fullscreen_toggled(toggled_on: bool):
	if toggled_on:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
		get_window().move_to_center() 


func _on_vsync_toggled(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_back_pressed():
	visible = false
	close_options.emit()
