class Game { 
	final int nPlayersX = 11;
	final int nPlayersY = 5;
	final int nEnemies = 1;
	PlayerManager playerManager;
	EnemyManager enemyManager;
	ShotsManager shotsManager;
	CollisionManager collisionManager;
	// Explosion Testing:
	// Explosion explosion;
	// PVector tempPos;
	Time time;
	int score; // a function of the number of surviving players and elapsed time.
	int highSchore; //
	int state;
	PFont titleFont = createFont("Alien-Encounters-Italic.ttf", 80);
	PFont font = createFont("Futuristic Armour.otf", 22);
	boolean gameOver;

	
	Game() {
		time = new Time();
		shotsManager = new ShotsManager();
		playerManager = new PlayerManager(nPlayersX, nPlayersY); //
		enemyManager = new EnemyManager(1, shotsManager);
		collisionManager = new CollisionManager(playerManager.getPlayers(),
												enemyManager.getEnemies(),
												shotsManager.getShots());
		gameOver = false;
		// Explosion Testing:
		// tempPos = new PVector(width/2, height/2);
		// explosion = new Explosion(tempPos);
		// explosion.create();
	}
	
	boolean isGameOver() {return gameOver;}

	void splashScreen() {
		startScreen(titleFont, font);
	}

	void run() {
		float delta_t = time.getDelta() * 0.05;

		playerManager.update(delta_t);
		enemyManager.update(delta_t);
		shotsManager.update(delta_t);
		
		if (collisionManager.update(delta_t)) { // Collision testing...
			gameOver = true;
		}

		playerManager.draw();
		enemyManager.draw();
		shotsManager.draw();

		// Explosion Testing:
		// explosion.update(delta_t);
	}

	void gameOver() {
		textAlign(width / 2, height / 2);
		stroke(0);
		fill(0);
		text("Game Over!", width, height);
		//Add code: If "playerDead == true"
		gameOverScreen(titleFont, font);
		//else
		//winScreen(titleFont, font);
		// Add code: Key SPACE to state 0 (init)
		// state = 0;
		// Add code: ..or Key ESC to quit
		// exit();
	}

	void move(int x, int y) {
		playerManager.setCurrentPlayer(x, y);
	}

	void shoot() {
		if (playerManager.clearShot()) { // No other player ship is blocking the view.
			float x = playerManager.getCurrent().pos.x;
			float y = playerManager.getCurrent().pos.y;
			shotsManager.spawn(x - 5, y, new BoundingCircle(0, 10, 2), new PVector(0, 3));
			shotsManager.spawn(x + 5, y, new BoundingCircle(0, 10, 2), new PVector(0, 3));
		}
	}
}