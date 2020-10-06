//
// Huvudansvarig: Linus Jonsson
//
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

	void spawn(PVector pos, color c, float lifeLength) {
		explosions.add(new Explosion(pos, c, lifeLength));
	}
}


class Explosion {
	Particle[] explosion = new Particle[100];
	PVector pos;
	float lifeLength;
	int deadParticles = 0;
	color col;
	
	Explosion (PVector _pos, color _c, float _lifeLength) {
		pos = new PVector(_pos.x, _pos.y);
		for (int i = 0; i < explosion.length; i++) {
			explosion[i] = new Particle(pos, _c);
		}
		lifeLength = _lifeLength;
	}

	void update(float delta_t) {
		for (int i = 0; i < explosion.length; i++) {
			if (explosion[i] == null) {
				continue;
			} else {
				explosion[i].update(delta_t);
			}
			if (explosion[i].isDone(lifeLength) == true) {
				explosion[i] = null;
				deadParticles++;
			}
		}
	}

	boolean isDone() {
		if (deadParticles > 70)
			return true;
		return false;
	}
}


class Particle {
	PVector pos;
	PVector vel = new PVector (random(-1, 1), random(-1, 1));
	PVector startPos = new PVector();	
	float speed = 1.2;
	float size = 1.5;
	color col;

	Particle (PVector _pos, color _col) {
		pos = new PVector(_pos.x, _pos.y);
		startPos.set(pos);
		if (_col == color(0, 0, 0))
			col = color(random(150, 256), random(150, 256), 255);
		else
			col = _col;
	}

	void update (float delta_t) {
		vel.mult(speed * delta_t);
		pos.add(vel);
		size = size * 0.99;
		noStroke();
		fill (col);
		ellipse (pos.x, pos.y, size, size);
	}

	boolean isDone(float lifeLength) {
		if (dist(pos.x, pos.y, startPos.x, startPos.y) > lifeLength)
			return true;
		else
			return false;
	}
}
