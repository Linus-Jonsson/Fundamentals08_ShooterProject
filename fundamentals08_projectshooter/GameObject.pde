class GameObject {
	PVector pos, vel;
	BoundingBox boundingBox;  // Radius of bounding circle. Used for collision detection.

	GameObject (float x, float y) {
		pos = new PVector(x, y);
		vel = new PVector(0, 0);
		boundingBox = new BoundingBox();
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

	//boolean 
}