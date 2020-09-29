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
	int highScore; //
	PFont titleFont = createFont("Alien-Encounters-Italic.ttf", 80);
	PFont font = createFont("Futuristic Armour.otf", 22);

	Game() {
		time = new Time();
		state = 0;
		shotsManager = new ShotsManager();
		state = 1;
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
		startScreen();
		// Add code: Key SPACE to change to state = 2 
		//state = 2;
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
		//Add code: If "playerDead == true"
		//gameOverScreen();
		//else
		winScreen();
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
			shotsManager.spawn(x, y, new PVector(0, 3));
			shotsManager.spawn(x + 10, y, new PVector(0, 3));
		}
	}

	void startScreen() {	
		textFont(titleFont);
		fill(255);
		textSize(80);
		textAlign(LEFT);
		text("INV", 10, height/2-40);
		text("ADERS", 125, height/2-40);
		textAlign(RIGHT);
		text("OF SPACE", width-30, height/2+40);
		textFont(font);
		textSize(24);
		textAlign(CENTER);
		text("Press SPACE to start", width/2, height/2+90);
		beginShape();
		strokeWeight(2.5);
		stroke(20, 40, 205);
		noFill();
		vertex(30, 210);
		vertex(30, 30);
		vertex(width-30, 30);
		vertex(width-30, 290);
		endShape();
		beginShape();
		vertex(30, 295);
		vertex(30, height-30);
		vertex(width-30, height-30);
		vertex(width-30, 375);
		endShape();
		beginShape();
		strokeWeight(1.5);
		stroke(225, 150, 10);
		noFill();
		vertex(45, 210);
		vertex(45, 45);
		vertex(width-45, 45);
		vertex(width-45, 290);
		endShape();
		beginShape();
		vertex(45, 295);
		vertex(45, height-45);
		vertex(width-45, height-45);
		vertex(width-45, 375);
		endShape();
	}	

	void gameOverScreen() {	
		textFont(titleFont);
		fill(255);
		textAlign(CENTER);
		textSize(120);
		text("GAME ", width/2, height/2-40);
		text("OVER ", width/2, height/2+70);
		textFont(font);
		textSize(20);
		text("Press SPACE to play again", width/2, height/2+120);
		text("Or ESC to quit", width/2, height/2+150);
		beginShape();
		strokeWeight(2.5);
		stroke(20, 40, 205);
		noFill();
		vertex(30, 30);
		vertex(width-30, 30);
		vertex(width-30, height-30);
		vertex(30, height-30);
		endShape(CLOSE);
		beginShape();
		strokeWeight(1.5);
		stroke(225, 150, 10);
		noFill();
		vertex(45, 45);
		vertex(width-45, 45);
		vertex(width-45, height-45);
		vertex(45, height-45);
		endShape(CLOSE);
	}	

	void winScreen() {	
		textFont(titleFont);
		fill(255);
		textAlign(CENTER);
		textSize(60);
		//TODO - Not final text!
		text("Congratz! ", width/2, height/2-80);
		textSize(30);
		text("YOUR", width/2, height/2-30);
		text("SCORE:", width/2, height/2);
		textSize(100);
		//TODO - Add int score!! (+Celebratory Effect?!?)
		text("1000 ", width/2, height/2+90);
		textFont(font);
		textSize(20);
		text("Press SPACE to play again", width/2, height/2+170);
		text("Or ESC to quit", width/2, height/2+200);
		beginShape();
		strokeWeight(2.5);
		stroke(20, 40, 205);
		noFill();
		vertex(30, 30);
		vertex(width-30, 30);
		vertex(width-30, height-30);
		vertex(30, height-30);
		endShape(CLOSE);
		beginShape();
		strokeWeight(1.5);
		stroke(225, 150, 10);
		noFill();
		vertex(45, 45);
		vertex(width-45, 45);
		vertex(width-45, height-45);
		vertex(45, height-45);
		endShape(CLOSE);
	}	
}