class Game { 
	final int nPlayersX = 11;
	final int nPlayersY = 5;
	final int nEnemies = 1;
	final int nWalls = 4;

	PlayerManager playerManager;
	EnemyManager enemyManager;
	ShotsManager shotsManager;
	CollisionManager collisionManager;
	ExplosionsManager explosionsManager;
	WallManager wallManager;

	Time time;
	int score; // a function of the number of surviving players and elapsed time.
	int highSchore; //
	int state;
	PFont titleFont = createFont("Alien-Encounters-Italic.ttf", 80);
	PFont font = createFont("Futuristic Armour.otf", 22);
	boolean gameOver;
	Enemy enemyLives = new Enemy(width/3.4, height*0.99, new BoundingCircle(0,0,10));
	
	Game() {
		time = new Time();
		shotsManager = new ShotsManager();
		playerManager = new PlayerManager(nPlayersX, nPlayersY); //
		explosionsManager = new ExplosionsManager();
		wallManager = new WallManager(nWalls);
		enemyManager = new EnemyManager(1, shotsManager, wallManager);
		collisionManager = new CollisionManager(playerManager.getPlayers(),
			enemyManager.getEnemies(),
			shotsManager.getShots(),
			wallManager.getWalls(),
			explosionsManager);
		gameOver = false;
	}
	
	boolean isGameOver() {return gameOver;}

	void splashScreen() {
		startScreen(titleFont, font);
	}

	void run() {
		float delta_t = time.getDelta() * 0.05;
		if (!gameOver) {
			enemyLives.drawLives();
			graphicElements(font);
		}

		playerManager.update(delta_t);
		enemyManager.update(delta_t);
		shotsManager.update(delta_t);
		explosionsManager.update(delta_t);
		
		if (collisionManager.update(delta_t)) { // Collision testing...
			gameOver = true;
		}

		playerManager.draw();
		enemyManager.draw();
		shotsManager.draw();
		wallManager.draw();
	}

	void gameOver() {
		if (gameOver) {
			gameOverScreen(titleFont, font);
		} else {
			winScreen(titleFont, font);
		}
		// Add code??: ..or Key ESC to quit
		// exit();
	}

	void move(int x, int y) {
		playerManager.setCurrentPlayer(x, y);
	}

	void shoot() {
		if (playerManager.clearShot() && playerManager.readyToShoot()) { // No other player ship is blocking the view.
			float x = playerManager.getCurrent().pos.x; 				 // and enough time has passed since the last shot.
			float y = playerManager.getCurrent().pos.y;
			shotsManager.spawn(x - 5, y, new BoundingCircle(0, 10, 2), new PVector(0, 3));
			shotsManager.spawn(x + 5, y, new BoundingCircle(0, 10, 2), new PVector(0, 3));
		}
	}
}