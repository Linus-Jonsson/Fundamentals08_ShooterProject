class WallPiece extends GameObject {
	boolean alive;

	WallPiece(float x, float y, BoundingCircle bc) {
		super(x, y, bc);

		alive = true;
	}

	void draw() {
		if (alive) {
			noStroke();
			fill(255);
			ellipse(pos.x, pos.y, boundingCircle.radius, boundingCircle.radius);
		}

	}
}