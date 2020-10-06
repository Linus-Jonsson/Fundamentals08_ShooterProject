//
// Huvudansvarig: 50/50
//
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
	SoundManager soundManager;

	PFont titleFont = createFont("Alien-Encounters-Italic.ttf", 80);
	PFont font = createFont("Futuristic Armour.otf", 22);
	
	FrameCounter fps = new FrameCounter();
	Time time = new Time();
	PImage theMoon = loadImage("moon.png");
	int score = 9999;
	int highScore;
	int state;
	int getReadyCounter = 0;

	boolean gameOver = false;

	Game(SoundManager _soundManager) {
		soundManager = _soundManager;
		shotsManager = new ShotsManager();
		playerManager = new PlayerManager(nPlayersX, nPlayersY);
		explosionsManager = new ExplosionsManager();
		wallManager = new WallManager(nWalls);
		enemyManager = new EnemyManager(nEnemies, shotsManager, wallManager);
		collisionManager = new CollisionManager(this);
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

	GameState run() {
		float delta_t = time.getDelta() * 0.05;

		scoreUpdate();

		graphicElements(score, font, gameOver, theMoon);

		playerManager.update(delta_t);
		enemyManager.update(delta_t);
		shotsManager.update(delta_t);
		explosionsManager.update(delta_t);
		
		if (collisionManager.update(delta_t) || enemyManager.allDead()) {
			gameOver = true;
			return GameState.GameOver;
		}

		wallManager.draw();
		playerManager.draw();
		enemyManager.draw();
		shotsManager.draw();
		
		return GameState.Run;
	}

	void scoreUpdate() {
		if (time.getAbsolute() % 100 <= 25)
			score -= 1;
		if (collisionManager.shipDestroyed == true) {
			score -= 150;
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
			soundManager.soundEffect(2);
		}
	}

	GameState splashScreen(StarSystem stars) {
		if (invadersOfSpace.getReadyCounter == 0) {
			startScreen(titleFont, font);
		}
		
		if (invadersOfSpace.getReadyCounter == 0 && stars.haveAccelerated()) {
			invadersOfSpace.getReadyCounter = 170;
		}

		if (invadersOfSpace.getReadyCounter > 0) {
			invadersOfSpace.getReady();
			if (--invadersOfSpace.getReadyCounter == 0)
				return GameState.Run;
		}
		return GameState.SplashScreen;
	}

	GameState init(Initialized initialized) {
		if (!initialized.hasBeen) {
			initialized.hasBeen = true;
			return GameState.SplashScreen;
		} else {
			return GameState.Run;
		}
	}
}

class Initialized {
	boolean hasBeen = false;
}	
