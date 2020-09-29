class Enemy extends GameObject {
	
	Enemy(float x, float y) {
		super(x, y);
	}

	void draw() {
		stroke(255, 0, 0);
		fill(255, 0, 0);
		circle(pos.x, pos.y, 20);
	}
}