//
// Huvudansvarig: Andreas Collvin
//
class GameObject {
	PVector pos, vel;
	BoundingCircle boundingCircle;
	boolean alive;

	GameObject (float x, float y, BoundingCircle bc) {
		pos = new PVector(x, y);
		vel = new PVector(0, 0);
		boundingCircle = bc;
		alive = true;
	}

	void transform(float delta_t) {
		pos.x += vel.x * delta_t;
		pos.y += vel.y * delta_t;
	}

	boolean collides(GameObject g) {
		if (!alive || !g.alive)
			return false;
		float dx = (pos.x + boundingCircle.offset.x) - (g.pos.x + g.boundingCircle.offset.x);
		float dy = (pos.y + boundingCircle.offset.y) - (g.pos.y + g.boundingCircle.offset.y);
		if (sqrt(dx * dx + dy * dy) <= (boundingCircle.diameter / 2 + g.boundingCircle.diameter / 2))
			return true;
		return false;
	}

	void drawBoundingCircle() {
		stroke(255, 0, 0);
		fill(0, 0, 0);
		circle(pos.x + boundingCircle.offset.x, pos.y + boundingCircle.offset.y, boundingCircle.diameter);
	}
}