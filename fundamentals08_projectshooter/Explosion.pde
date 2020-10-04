class ExplosionsManager {
	ArrayList<Explosion> explosions;

	ExplosionsManager() {
		explosions = new ArrayList<Explosion>(10);
	}

	ArrayList<Explosion> getExplosions() {
		return explosions;
	}

	void update(float delta_t) {
		for (int e = 0; e < explosions.size(); e++) {
			explosions.get(e).update(delta_t);
			if (explosions.get(e).isDone())
				explosions.remove(e);
		}
	}

	void spawn(PVector pos, color c, int clock) {
		explosions.add(new Explosion(pos, c, clock));
	}
}


class Explosion {
	Particle[] explosion = new Particle[100];
	PVector pos;
	int lifeClock;
  	color col;
	
	Explosion (PVector _pos, color _c, int clock) {
		pos = new PVector(_pos.x, _pos.y);
		for (int i=0; i<explosion.length; i++) {
			explosion[i] = new Particle(pos, _c);
		}
		lifeClock = clock;
	}

	void update(float delta_t) {
		for (int i=0; i<explosion.length; i++) {
			if (explosion[i].size <= 0) {
				continue;
			} else {
				explosion[i].update(delta_t);
			}
		}
	}

	boolean isDone() {
		if (lifeClock-- == 0)
			return true;
		return false;
	}
}

class Particle {
	PVector pos = new PVector();
	PVector vel;
	color col;
	float speed = 1.05;
	float size = 2;

	Particle (PVector _pos, color _col) {
		pos.set(_pos);
		vel = new PVector (random (-1,1), random (-1,1));
		if (_col == color(0, 0, 0))
      		col = color(random(125, 256), random(125, 256), 255);
    	else
      	col = _col;
	}

	void update (float delta_t) {
		vel.mult(speed*delta_t);
		pos.add(vel);
		size = size * 0.9;
		noStroke();
		fill (col);
		ellipse (pos.x, pos.y, size, size);
	}
}
