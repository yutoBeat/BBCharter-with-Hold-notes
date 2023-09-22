extends Control

@onready var file_drop_parser = preload("res://src/rf_drag_and_drop.gd").new()
#@onready var timeline = $Timeline/NoteTimeline

func _ready():
	get_window().min_size = Vector2i(228, 128)
	
	print(DisplayServer.screen_get_size())
	if DisplayServer.screen_get_size() > Vector2i(1920, 1080):
		get_window().size = Vector2i(1920, 1080)
		get_window().position.x -= 320
		get_window().position.y -= 180
	
	get_viewport().files_dropped.connect(on_files_dropped)
	
	#Timeline.note_timeline = timeline
	

func on_files_dropped(files):
	file_drop_parser.get_file_type(files)

func _input(event):
	if Popups.open or Global.lock_timeline: return
	
	if event.is_action_pressed("project_new"):
		Global.file_dialog.new_project_dialog()
	if event.is_action_pressed("project_open"):
		Global.file_dialog.open_project_dialog()
	if event.is_action_pressed("project_reload") and Save.project_dir != "":
		Save.load_project(Save.project_dir)
	if event.is_action_pressed("project_save"):
		Save.save_project()
	if event.is_action_pressed("fullscreen"):
		if get_window().mode == get_window().MODE_WINDOWED:
			get_window().mode = get_window().MODE_FULLSCREEN
		else:
			get_window().mode = get_window().MODE_WINDOWED
	if event.is_action_pressed("open_project_dir"):
		open_uri(Save.project_dir)
	if event.is_action_pressed("open_note_file"):
		open_uri(Save.project_dir + "/config/notes.cfg")
	if event.is_action_pressed("open_keyframes_file"):
		open_uri(Save.project_dir + "/config/keyframes.cfg")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if Global.project_loaded and !Global.project_saved:
			Popups.reveal(Popups.QUIT)
		else:
			get_tree().quit()

func open_uri(uri: String):
	if OS.get_name() == "macOS": uri = "file:" + uri
	OS.shell_open(uri)
