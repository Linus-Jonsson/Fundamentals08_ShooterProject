class Game { 
	final int nPlayersX = 11;
	final int nPlayersY = 5;
	final int nEnemies = 1;
	PlayerManager playerManager;
	EnemyManager enemyManager;
	Time time;
	int state; // 0 = Init. 1 = Welcome screen. 2 = Running. 3 = Game Over
	
	Game() {
		time = new Time();
		state = 0;
		playerManager = new PlayerManager(nPlayersX, nPlayersY); //
		enemyManager = new EnemyManager(1);
	}

	void init() {
		// Init everything, then change state to 1, Welcome Screen.
		// ...
		// (Add code)
		//
		state = 1;
	}

	void splashScreen() {
		// Add code...
		// Wait for user to start game by pressing a defined key
		// 
		// (Add code) 
		//
		// Then change to state = 2 
		state = 2;
	}

	void run() {
		float delta_t = time.getDelta() * 0.05;
		//gameObjects.update(delta_t);

		playerManager.update(delta_t);
		enemyManager.update(delta_t);

		playerManager.draw();
		enemyManager.draw();
	}

	void gameOver() {
		textAlign(width / 2, height / 2);
		stroke(0);
		fill(0);
		text("Game Over!", width, height);
		// Wait for user to quit or restart
		// 
		// (Add code)
		//
		// Then change to state 0 (init) or quit
	}

	void move(int x, int y) {
		playerManager.setCurrentPlayer(x, y);
	}
}