class EnemyManager {
	Enemy[] enemies;
	int nEnemies;
	ShotsManager shotsManager;
	WallManager wallManager;
	int aiClock;

	EnemyManager(int _nEnemies, ShotsManager _shotsManager, WallManager _wallManager) {
		nEnemies = _nEnemies;
		enemies = new Enemy[nEnemies];
		for (int n = 0; n < nEnemies; n++)
			enemies[n] = new Enemy(width / 2, height * 0.89, new BoundingCircle(0, 0, 35));
		shotsManager = _shotsManager;
		wallManager = _wallManager;
		int aiClock = 30;
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

	void draw() {
		for (int n = 0; n < nEnemies; n++) {
			enemies[n].draw();
		}
	}

	void update(float delta_t) {
		for (Enemy e : enemies) {
			if (e.lostLife && e.deathRotation == 0) {
				e.lostLife = false;
				e.lives--;
				e.deathRotation = 6.28;
				println("Crab lives: " + e.lives);
			}

			if (e.deathRotation > 0) {
				e.deathRotation -= delta_t * 0.1;
			} else {
				e.deathRotation = 0;
			}

			e.transform(delta_t);

			if (e.pos.x < 20 || e.pos.x > width - 20) 
				e.pos.x -= e.vel.x * delta_t;
			if ((int)random(100) == 0)
				e.vel.x = -1;
			if ((int)random(100) == 0) 
				e.vel.x = 1;
				
			if (e.vel.x == 1)
				e.walkingRotation = 0.4 - random(0.2, 0.3);
			if (e.vel.x == -1)
				e.walkingRotation = -0.4 + random(0.2, 0.3);


			if ((int)random(10) == 0) {
				if (e.readyToShoot()) {
					boolean behindWall = false;
					for (int w = 0; w < wallManager.getWalls().length; w++) {
						float x1 = wallManager.getWalls()[w].pos.x - wallManager.getWalls()[w].wallPieceDiameter/2;
						float x2 = wallManager.getWalls()[w].pos.x + 
								   wallManager.getWalls()[w].wallPieceDiameter/2 + 
								   5 * wallManager.getWalls()[w].wallPieceDiameter;
						if (e.pos.x >= (x1 - 1) && e.pos.x <= (x2 + 1)) {
							behindWall = true;
							break;
						}		   
					}
					if (!behindWall)
						shotsManager.spawn(e.pos.x, e.pos.y - 15, new BoundingCircle(0, 0, 2), new PVector(0, -3));
				}
			}

			float closestX = 0, closestY = 10000;
			for (Shot s : shotsManager.getShots()) {
				if (s.boundingCircle.offset.y > 0) {
					if (s.pos.y < e.pos.y) {
						if (e.pos.y - s.pos.y < closestY) {
							closestY = e.pos.y - s.pos.y;
							closestX = s.pos.x;
						}
					}			
				}
			}
			
			//aiClock
			/*if (e.pos.x < closestX) {
				e.vel.x = -1;
				clock = 20 + random(100);
			}
			else if (e.pos.x > closestX) {
				e.vel.x = 1;		
				clock = 20 + random(100);
			}*/
		}
	}
}