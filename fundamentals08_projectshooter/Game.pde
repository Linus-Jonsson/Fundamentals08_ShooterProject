class Game { 
	final int nPlayersX = 11;
	final int nPlayersY = 5;
	final int nEnemies = 1;
	PlayerManager playerManager;
	EnemyManager enemyManager;
	ShotsManager shotsManager;
	CollisionManager collisionManager;
	Time time;
	int state; // 0 = Init. 1 = Welcome screen. 2 = Running. 3 = Game Over
	int score; // a function of the number of surviving players and elapsed time.
	int highSchore; //
	
	Game() {
		time = new Time();
		state = 0;
		shotsManager = new ShotsManager();
		playerManager = new PlayerManager(nPlayersX, nPlayersY); //
		enemyManager = new EnemyManager(1);
		collisionManager = new CollisionManager(playerManager.getPlayers(),
												enemyManager.getEnemies(),
												shotsManager.getShots());
	}

	void init() {
		state = 1;
	}

	void splashScreen() {
		state = 2;
	}

	void run() {
		float delta_t = time.getDelta() * 0.05;

		playerManager.update(delta_t);
		enemyManager.update(delta_t);
		shotsManager.update(delta_t);
		collisionManager.update(delta_t);

		playerManager.draw();
		enemyManager.draw();
		shotsManager.draw();
	}

	void gameOver() {
		textAlign(width / 2, height / 2);
		stroke(0);
		fill(0);
		text("Game Over!", width, height);
	}

	void move(int x, int y) {
		playerManager.setCurrentPlayer(x, y);
	}

	void shoot() {
		if (playerManager.clearShot()) { // No other player ship is blocking the view.
			float x = playerManager.getCurrent().pos.x;
			float y = playerManager.getCurrent().pos.y;
			shotsManager.spawn(x, y, new PVector(0, 3));
			shotsManager.spawn(x + 10, y, new PVector(0, 3));
		}
	}
}