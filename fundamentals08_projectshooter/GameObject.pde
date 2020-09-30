class GameObject {
	PVector pos, vel;
	BoundingCircle boundingCircle;


	GameObject (float x, float y, BoundingCircle bc) {
		pos = new PVector(x, y);
		vel = new PVector(0, 0);
		boundingCircle = bc;
		println("creation of new Game Object");
	}

	boolean collideWall() {
		float SIZE = 20; // Change later... 
		if ((pos.x - SIZE / 2 < 0) || (pos.x > width - SIZE / 2))
			return true;
		return false;
	}

	void transform(float delta_t) {
		pos.x += vel.x * delta_t;
		pos.y += vel.y * delta_t;
	}

<<<<<<< Updated upstream
	//boolean
=======
	boolean collides(GameObject g) {
		float dx = (pos.x + boundingCircle.offset.x) - (g.pos.x + g.boundingCircle.offset.x);
		float dy = (pos.y + boundingCircle.offset.y) - (g.pos.y + g.boundingCircle.offset.y);
		/*stroke(255, 0, 0);
		line (pos.x + boundingCircle.offset.x,
			  pos.y + boundingCircle.offset.y,
			  g.pos.x + g.boundingCircle.offset.x,
			  g.pos.y + g.boundingCircle.offset.y);*/
		if (sqrt(dx * dx + dy * dy) <= (boundingCircle.radius / 2 + g.boundingCircle.radius / 2))
			return true;
		return false;
	}

	void drawBoundingCircle() {
		stroke(255, 0, 0);
		fill(0, 0, 0);
		circle(pos.x + boundingCircle.offset.x, pos.y + boundingCircle.offset.y, boundingCircle.radius);
	}
>>>>>>> Stashed changes
}