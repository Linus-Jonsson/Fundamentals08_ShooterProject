class EnemyManager {
	Enemy[] enemies;
	int nEnemies;

	EnemyManager(int _nEnemies) {
		nEnemies = _nEnemies;
		enemies = new Enemy[nEnemies];
		for (int n = 0; n < nEnemies; n++)
			enemies[n] = new Enemy(width / 2, height * 0.9);
	}

	void draw() {
		for (int n = 0; n < nEnemies; n++) {
				enemies[n].draw();
		}
	}

	void update(float delta_t) {
		for (Enemy e : enemies) {
			e.transform(delta_t);
		}
	}
}