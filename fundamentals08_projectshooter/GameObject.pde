class GameObject {
	PVector pos, vel;
	BoundingBox boundingBox;  // Radius of bounding circle. Used for collision detection.

	GameObject () {
		pos = new PVector();
		vel = new PVector();
		size = -1;
		println("creation of new Game Object");
	}

	boolean collide(GameObject other) {
		if (overlap(this, other))
			return true;
		return false;
	}

	void draw() {
	}
}