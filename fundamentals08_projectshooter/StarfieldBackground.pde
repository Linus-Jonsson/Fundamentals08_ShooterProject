class StarSystem {
	ArrayList<Star> stars;
	PVector origin;
	boolean startOffRun;

	StarSystem(PVector position) {
		stars = new ArrayList<Star>(1000);
		origin = position.copy();
		startOffRun = true;
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

	void addStars() {
		stars.add(new Star(origin));
	}

	void run(boolean draw) {
		for (int i = stars.size()-1; i >= 0; i--) {
			Star s = stars.get(i);
			s.run(draw);
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

	Star(PVector pos) {
		velocity = new PVector(random(-1, 1), random(-1, 1));
		position = pos.copy();
		size = random(0.4, 0.8);
		lifespan = 255.0;
	}
	void run(boolean draw) {
		update();
		if (draw)
			display();
	}
	void update() {
		position.add(velocity);
		lifespan -= 0.3;
	}
	void display() {
		stroke(255, 255-lifespan);
		fill(255, 255-lifespan);
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