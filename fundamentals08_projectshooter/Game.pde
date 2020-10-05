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

	PFont titleFont = createFont("Alien-Encounters-Italic.ttf", 80);
	PFont font = createFont("Futuristic Armour.otf", 22);
	
	FrameCounter fps = new FrameCounter();
	Time time = new Time();
	int score = 9999;
	int highScore;
	int state;
	int getReadyCounter = 0;
	boolean gameOver = false;

	Game() {
		shotsManager = new ShotsManager();
		playerManager = new PlayerManager(nPlayersX, nPlayersY);
		explosionsManager = new ExplosionsManager();
		wallManager = new WallManager(nWalls);
		enemyManager = new EnemyManager(nEnemies, shotsManager, wallManager);
		collisionManager = new CollisionManager(playerManager.getPlayers(),
												enemyManager.getEnemies(),
												shotsManager.getShots(),
												wallManager.getWalls(),
												explosionsManager);
	}
	
	boolean isGameOver() {
		return gameOver;
	}

	void splashScreen() {
		startScreen(titleFont, font);
	}

	boolean runningGetReady() {
		if (getReadyCounter > 0)
			return true;
		return false;
	}

	void getReady() {
		image(theMoon, 260, -480); 
		fill(255 - (255 - 56) * (500 - abs((millis() % 1000) - 500)) / 500,
			 255 - (255 - 4) * (500 - abs((millis() % 1000) - 500)) / 500,
			 255 - (255 - 191) * (500 - abs((millis() % 1000) - 500)) / 500);
		textSize(40);
		text("GET READY", width/2, height/2-20);
	}

	void run() {
		float delta_t = time.getDelta() * 0.05;
		//text("FPS: " + (int)fps.get(), 35, 15); // For debug purposes.
		scoreUpdate();

		graphicElements(score, font, gameOver);

		playerManager.update(delta_t);
		enemyManager.update(delta_t);
		shotsManager.update(delta_t);
		explosionsManager.update(delta_t);
		
		if (collisionManager.update(delta_t) || enemyManager.allDead())
			gameOver = true;

		wallManager.draw();
		playerManager.draw();
		enemyManager.draw();
		shotsManager.draw();
	}

	void scoreUpdate() {
		if (time.getAbsolute() % 100 <= 25)
			score -= 1;
		if (collisionManager.shipDestroyed == true) {
			score -= 100;
			collisionManager.shipDestroyed = false;
		}	
	}

	void gameOver() {
		if (enemyManager.allDead())
			winScreen(titleFont, font, score);
		else {
			run();
			gameOverScreen(titleFont, font);
		}
	}

	void move(int x, int y) {
		playerManager.setCurrentPlayer(x, y);
	}

	void shoot() {
		if (playerManager.clearShot() && playerManager.readyToShoot()) {
			float x = playerManager.getCurrent().pos.x;
			float y = playerManager.getCurrent().pos.y;
			shotsManager.spawn(x - 5, y, new BoundingCircle(0, 10, 2), new PVector(0, 3));
			shotsManager.spawn(x + 5, y, new BoundingCircle(0, 10, 2), new PVector(0, 3));
			soundEffect(3);
		}
	}
}