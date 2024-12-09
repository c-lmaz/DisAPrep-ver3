extends ScrollContainer

@onready var scroll_cont = $"."
@onready var scroll_bar = scroll_cont.get_v_scroll_bar()

var scrollbar_max_val = 0


func _ready():
	scroll_bar.connect("changed", _on_scroll_bar_changed)


func _on_scroll_bar_changed():
	if scrollbar_max_val != scroll_bar.max_value:
		scrollbar_max_val = scroll_bar.max_value
		scroll_cont.scroll_vertical = scrollbar_max_val
