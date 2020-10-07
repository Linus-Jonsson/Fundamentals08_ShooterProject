//
// Huvudansvarig: Andreas Collvin
//
class EnemyManager {
	Enemy[] enemies;
	int nEnemies;
	ShotsManager shotsManager;
	WallManager wallManager;

	EnemyManager(int _nEnemies, ShotsManager _shotsManager, WallManager _wallManager) {
		nEnemies = _nEnemies;
		enemies = new Enemy[nEnemies];
		for (int n = 0; n < nEnemies; n++) {
			enemies[n] = new Enemy(width / 2+random(100), height * 0.885, new BoundingCircle(0, 0, 35));
		}
		shotsManager = _shotsManager;
		wallManager = _wallManager;
	}

	void update(float delta_t) {
		for (Enemy e : enemies) {
			deathRotation(e, delta_t);
			e.transform(delta_t);
			if (e.pos.x < 25 || e.pos.x > width - 25) {
				e.pos.x -= e.vel.x * delta_t; 
				e.vel.x = -e.vel.x;			
			}

			e.walkingRotation -= e.walkingRotationVel;
			if (e.walkingRotation >= 0.1 || e.walkingRotation <= -0.1) {
				e.walkingRotationVel *= -1;
			}

			Shot s = closestShot(e);
			if (!evadingClosestShot(e, s, delta_t)) {
				if (distanceToShot(e, s) < 20 + (int)random(100)) {
					if ((int)random(10) == 0) {
						e.vel.x = -e.vel.x;	
						e.walkTime = 40;	
					}
				}
			}
				
			if (e.walkTime-- == 0) {
				e.walkTime = 40 + (int)random(200);
				if ((int)random(5) == 0)
					e.vel.x = -1;
				if ((int)random(5) == 0)	
					e.vel.x = 1;
			}

			if (e.readyToShoot() && !behindWall(e))
				shotsManager.spawn(e.pos.x, e.pos.y - 15, new BoundingCircle(0, 0, 2), new PVector(0, -3));
		}
	}

	void draw() {
		for (int n = 0; n < nEnemies; n++) {
			enemies[n].draw();
			if (enemies[n].lives >= 2) {
				enemies[n].drawLives(enemies[n].lives);
			}
		}
	}


	Enemy[] getEnemies() {
		return enemies;
	}

	boolean allDead() {
		for (int n = 0; n < nEnemies; n++)
			if (enemies[n].lives > 0)
				return false;
		return true;
	}

	boolean behindWall(Enemy e) {
		for (int w = 0; w < wallManager.getWalls().length; w++) {
			float x1 = wallManager.getWalls()[w].pos.x - wallManager.getWalls()[w].wallPieceDiameter / 2;
			float x2 = wallManager.getWalls()[w].pos.x + 
					   wallManager.getWalls()[w].wallPieceDiameter * 5.5;
			if (e.pos.x >= (x1 - 1) && e.pos.x <= (x2 + 1)) 
				return true;
		}
		return false;
	}

	boolean evadingClosestShot(Enemy e, Shot s, float delta_t) {
		if (s.pos.x == 9999)
			return true;
		float dx1 = e.pos.x - s.pos.x;
		float dy1 = e.pos.y - s.pos.y;
		float dx2 = (e.pos.x + e.vel.x * delta_t) - (s.pos.x);
		float dy2 = (e.pos.y + e.vel.y * delta_t) - (s.pos.y);
		float d1 = sqrt((dx1 * dx1) + (dy1 * dy1));
		float d2 = sqrt((dx2 * dx2) + (dy2 * dy2));
		if (d2 > d1)
			return true;
		return false;
	}

	float distanceToShot(Enemy e, Shot s) {
		float dx = e.pos.x - s.pos.x;
		float dy = e.pos.y - s.pos.y;
		return sqrt(dx * dx + dy * dy);
	}

	Shot closestShot(Enemy e) {
		Shot closest = new Shot(9999, 9999, new BoundingCircle(0, 0, 0), new PVector(0, 0)); 
		for (Shot s : shotsManager.getShots()) {
			if (s.boundingCircle.offset.y > 0) {
				if (s.pos.y < e.pos.y + e.boundingCircle.diameter / 2) {
					float dx = s.pos.x - e.pos.x;
					float dy = (s.pos.y + s.boundingCircle.offset.y) - e.pos.y;
					float dx2 = closest.pos.x - e.pos.x;
					float dy2 = closest.pos.y - e.pos.y;

					if (sqrt(dx * dx + dy * dy) < sqrt(dx2 * dx2 + dy2 * dy2))
						closest = s;
				}			
			}			
		}
		return closest;
	}

	void deathRotation(Enemy e, float delta_t) {
		if (e.lostLife && e.deathRotation == 0) {
			e.lostLife = false;
			e.lives--;
			e.deathRotation = 6.28;
		}
		if (e.deathRotation > 0) {
			e.deathRotation -= delta_t * 0.1;
		}
		else {		
			e.deathRotation = 0;
		}
	}
}