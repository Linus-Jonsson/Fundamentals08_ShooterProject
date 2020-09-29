class Player extends GameObject {

	Player(float x, float y) {
		super(x, y);
	}

	void draw(boolean highlight) {
		if (highlight) {
			stroke(255, 255, 0);
			fill(255, 255, 0);			
		} else {
			stroke(0, 255, 0);
			fill(0, 255, 0);
		}
		circle(pos.x, pos.y, 20);
	}
}