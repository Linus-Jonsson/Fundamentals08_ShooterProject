class EnemyManager {
	Enemy[] enemies;
	int nEnemies;
	ShotsManager shotsManager;

	EnemyManager(int _nEnemies, ShotsManager _shotsManager) {
		nEnemies = _nEnemies;
		enemies = new Enemy[nEnemies];
		for (int n = 0; n < nEnemies; n++)
			enemies[n] = new Enemy(width / 2, height * 0.9, new BoundingCircle(0, 0, 35));
		shotsManager = _shotsManager;
	}

	Enemy[] getEnemies() {
		return enemies;
	}

	void draw() {
		for (int n = 0; n < nEnemies; n++) {
			enemies[n].draw();
		}
	}

	void update(float delta_t) {
		for (Enemy e : enemies) {
			e.transform(delta_t);

			if (e.pos.x < 20 || e.pos.x > width - 20) 
				e.pos.x -= e.vel.x * delta_t;
			if ((int)random(100) == 0) 
				e.vel.x = -1;
			if ((int)random(100) == 0) 
				e.vel.x = 1;
			if ((int)random(100) == 0) 
				shotsManager.spawn(e.pos.x, e.pos.y - 15, new BoundingCircle(0, 0, 2), new PVector(0, -3));
		}
	}
}