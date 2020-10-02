class StarSystem {
	ArrayList<Star> stars;
	PVector origin;
	boolean startOffRun = true;
	int acceleration = 0;
	boolean haveAccelerated = false;

	StarSystem(PVector position) {
		stars = new ArrayList<Star>(1000);
		origin = position.copy();
	}

	void drawBackground() {
		background(0);
		if (startOffRun) {
			startOffRun = false;
			for (int n = 0; n < 1000; n++) {
				addStars();
				run(false);
			}
		}
		else {
			addStars();
			run(true);
		}
	}

	boolean haveAccelerated() {
		if (haveAccelerated && acceleration == 0) {
			startOffRun = true;
			return true;
		}
		else 
			return false;
	}

	void accelerate() {
		for (Star star : stars)
			star.velocity.mult(10);
		acceleration = 80;
	}

	void addStars() {
		if (acceleration > 0)
			for (int n = 0; n < 5; n++)
				stars.add(new Star(origin, acceleration));
		else 
			stars.add(new Star(origin, acceleration));
	}

	void run(boolean draw) {
		if (acceleration > 0) {
			acceleration--;
			haveAccelerated = true;
		}

		for (int i = stars.size()-1; i >= 0; i--) {
			Star s = stars.get(i);
			s.run(draw, acceleration);
			if (s.isDead()) {
				stars.remove(i);
			}
		}
	}
}

class Star {
	PVector position;
	PVector velocity;
	float size;
	float lifespan;

	Star(PVector pos, int acceleration) {
		velocity = new PVector(random(-1, 1), random(-1, 1));
		if (acceleration > 0)
			velocity.mult(10);
		position = pos.copy();
		size = random(0.4, 0.8);
		lifespan = 255.0;
	}
	void run(boolean draw, int acceleration) {
		update();
		if (draw)
			display(acceleration);
	}
	void update() {
		position.add(velocity);
		lifespan -= 0.3;
	}
	void display(int acceleration) {
		if (acceleration > 0) {
			stroke(255, 255);
			fill(255, 255);
		} else {
			stroke(255, 255-lifespan);
			fill(255, 255-lifespan);
		}
		ellipse(position.x, position.y, size, size);
	}
	boolean isDead() {
		if (lifespan < 0.0) {
			return true;
		} else {
			return false;
		}
	}
}