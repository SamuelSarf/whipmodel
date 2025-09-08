extends Node2D

@export var num_links: int = 5
@export var tot_length: float = 100.0
@export var link_width: float = 20.0
@export var start_position: Vector2 = Vector2(500, 300)
@export var handle: Node2D
var links: Array = []

func _ready():
	create_chain()

func create_chain():
	var link_length = tot_length / num_links
	var previous_link: RigidBody2D = null
	
	for i in range(num_links):
		var link = preload("res://link.tscn").instantiate()
		link.length = link_length
		link.width = link_width
		#link.color = Color.from_hsv(float(i) / num_links, 0.8, 0.8)
		link.color = Color(0,0,1)
		
		# Position the link
		if previous_link:
			# Position this link's top at the previous link's bottom
			link.position = previous_link.position + previous_link.get_bottom_connection_point() - link.get_top_connection_point()
		
		# Make the first link static so the chain doesn't fall
		if i == 0:
			#var transform = RemoteTransform2D.new()
			#transform.remote_path = handle.get_path()
			#transform.update_position = true
			#transform.update_rotation = true
			#link.add_child(transform)
			link.handle = handle
		add_child(link)
		links.append(link)
		
		# Create pin joint if not the first link
		if previous_link:
			create_pin_joint(previous_link, link)
		
		previous_link = link

func create_pin_joint(link_a: RigidBody2D, link_b: RigidBody2D):
	var joint = PinJoint2D.new()
	
	# Set the nodes to connect
	joint.node_a = link_a.get_path()
	joint.node_b = link_b.get_path()
	
	# Position the joint at the bottom of link_a (which should connect to top of link_b)
	joint.position = link_a.get_bottom_connection_point()
	
	# Add some stiffness to prevent too much wobbling
	joint.softness = 0.1
	
	link_a.add_child(joint)

func apply_torque_to_link(link_index: int, torque_force: float):
	if link_index >= 0 and link_index < links.size():
		links[link_index].apply_torque(torque_force)

func _input(event):
	if event.is_action_pressed("ui_left"):
		apply_torque_to_link(2, 1000.0)  # Apply torque to third link
	if event.is_action_pressed("ui_right"):
		apply_torque_to_link(2, -1000.0)
	if event.is_action_pressed("ui_up"):
		apply_torque_to_link(1, 800.0)   # Apply torque to second link
	if event.is_action_pressed("ui_down"):
		apply_torque_to_link(1, -800.0)

# Optional: Draw debug lines to see connection points
func _draw():
	for link in links:
		if is_instance_valid(link):
			# Draw top connection point
			draw_circle(link.position + link.get_top_connection_point(), 5, Color.RED)
			# Draw bottom connection point
			draw_circle(link.position + link.get_bottom_connection_point(), 5, Color.BLUE)
