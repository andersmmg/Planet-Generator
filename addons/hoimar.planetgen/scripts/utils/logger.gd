class_name Logger2
## A simple logger class.

class Standard:
	var _context := ""
	
	
	func _init(context):
		_context = context
	
	
	## Logs a debug message.
	func debug(msg: String):
		pass
	
	
	## Logs a warning message.
	func warn(msg: String):
		push_warning("[WARNING] %s: %s" % [_context, msg])
	
	
	## Logs an error message.
	func error(msg: String):
		push_error("[ERROR] %s: %s" % [_context, msg])


class Verbose extends Standard:
	func _init(context: String):
		super(context)
		pass
	
	
	func debug(msg: String):
		print("[DEBUG] %s: %s" % [_context , msg])


## Returns a logger for the given context.
static func get_for(owner: Object) -> Standard:
	var context = owner.get_script().resource_path.get_file()
	if OS.is_stdout_verbose():
		return Verbose.new(context)
	return Standard.new(context)
