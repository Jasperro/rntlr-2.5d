extends Node

var shootAnimator;
var shootTimeout; 
var isShooting; 
var shootRaycast;
	
#var bloodParticles = preload("res://Scenes/blood.tscn");

func _ready():
	#shootAnimator = self.get_node("AnimationPlayer");
	#shootAnimator.connect("finished",self,"on_finished");
	#shootAnimator.play("IDLE");
	#shootAnimator.get_animation("IDLE").set_loop(true); 
	#shootAnimator.get_animation("FIRE").set_loop(true); 
	
	shootTimeout = 0.0; 
	isShooting = false; 
	
	shootRaycast = self.get_node("RayCast");
	print(shootRaycast.transform.origin);
	
		
func _input(event):
	if(event is InputEventMouseButton):
		if(event.is_pressed() && event.button_index == BUTTON_LEFT && !isShooting):
			isShooting = true ;
			
	if(!event.is_pressed() && isShooting):
			isShooting = false;				
		
		
	
	
func _process(delta):
	if(shootTimeout > 0.0):
		shootTimeout -= delta;

func _physics_process(delta):
	if(shootTimeout <= 0.0 && isShooting):
		weaponShoot();
	
			
func weaponShoot():
	if(!isShooting):
		return; 
		
	shootTimeout = 0.1;
	#shootAnimator.play("FIRE"); 
	
	if(shootRaycast.is_colliding()):
		var shootObject = shootRaycast.get_collider() ; 
		#print(shootObject.tag)
		if(shootObject.get("tag")):
			print("Pew!");
		else:
			print("Missed!")