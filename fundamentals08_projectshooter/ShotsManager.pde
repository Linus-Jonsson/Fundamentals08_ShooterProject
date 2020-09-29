class ShotsManager {
	ArrayList<Shot> shots;
	ShotsManager() {
		shots = new ArrayList<Shot>(100);
	}

	ArrayList<Shot> getShots() {
		return shots;
	}

	void spawn(float x, float y, PVector vel) {
		shots.add(new Shot(x, y, vel));
	}

	void update(float delta_t) {
		for (Shot s : shots) {
			s.transform(delta_t);
		}
	}

	void draw() {
		for (Shot s : shots) {
			s.draw();
		}
	}
}

class Shot extends GameObject {
	Shot(float x, float y, PVector _vel) {
		super (x, y);
		vel = _vel.copy();
	}

	void draw() {
		stroke(0, 200, 255);
		fill(0, 200, 255);
		rect (pos.x, pos.y, 2, 10);
	}
}



