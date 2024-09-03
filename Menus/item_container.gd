extends GridContainer

var items : Array
var states : Array

func sort_items():
	items.clear()
	states.clear()
	
	for child in get_children():
		items.append(child)
		states.append(child.button_pressed)
	
	_sort_checked_items()
	
	for i in range(items.size()):
		#items[i].get_parent().remove_child(items[i])
		#add_child(items[i])
		move_child(items[i], i)


func _sort_checked_items():
	for i in range(items.size()-1):
		var a = items[i]
		var b = items[i+1]
		var a_state = states[i]
		var b_state = states[i+1]
		
		if a_state:
			items[i] = b
			items[i+1] = a
			states[i] = b_state
			states[i+1] = a_state
