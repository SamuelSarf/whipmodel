extends HSlider

func _ready():
	value_changed.connect(_on_value_changed)

func _on_value_changed(value: float):
	# Emit the global signal
	SignalBus.slider_value_changed.emit(value)
