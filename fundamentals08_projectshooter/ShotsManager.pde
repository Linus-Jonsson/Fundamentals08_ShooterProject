//
// Huvudansvarig: Andreas Collvin
//
class ShotsManager {
	ArrayList<Shot> shots;
	
	ShotsManager() {
		shots = new ArrayList<Shot>(100);
	}

	ArrayList<Shot> getShots() {
		return shots;
	}

	void spawn(float x, float y, BoundingCircle bc, PVector vel) {
		shots.add(new Shot(x, y, bc, vel));
	}

	void update(float delta_t) {
		for (Shot s : shots)
			s.transform(delta_t);
	}

	void draw() {
		for (Shot s : shots)
			s.draw();
	}
}


class Shot extends GameObject {
	Shot(float x, float y, BoundingCircle bc, PVector _vel) {
		super (x, y, bc);
		vel = _vel.copy();
	}

	void draw() {
		stroke(200, 200, 200);
		fill(200, 200, 200);
		rect (pos.x, pos.y, 2, 10);
	}
}