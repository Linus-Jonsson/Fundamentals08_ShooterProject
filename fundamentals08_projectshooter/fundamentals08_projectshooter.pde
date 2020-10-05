import ddf.minim.*;
Minim minim;
AudioPlayer theme;
AudioSample[] duckTales;

PImage theMoon;

Game invadersOfSpace;
StarSystem stars;
boolean soundOn = true;
boolean firstTime = true;
int state = 0;
int highScore = 0;

void setup() {
	if (soundOn) {
		minim = new Minim(this);
		duckTales = new AudioSample[10];
		theme = minim.loadFile("DuckTales.mp3", 10000);
		duckTales[1] = minim.loadSample("crabHit.wav", 512);
		duckTales[2] = minim.loadSample("crabDies.wav", 512);
		duckTales[3] = minim.loadSample("fire.wav", 512);
		duckTales[4] = minim.loadSample("playerHit.wav", 512);
		duckTales[5] = minim.loadSample("playerDead.wav", 512);
		duckTales[6] = minim.loadSample("restart.wav", 512);
		duckTales[7] = minim.loadSample("wallHit.wav", 512);	
		theme.loop(10);
		theme.play();
	}

	((java.awt.Canvas) surface.getNative()).requestFocus();
	size(480, 640);
	frameRate(60);
	theMoon = loadImage("moon.png");
	stars = new StarSystem(new PVector(width / 2, height / 2));	
}

void draw() {
	background(0);
	stars.drawBackground();

	switch (state) {
		case 0: 
			invadersOfSpace = new Game(); 
			if (firstTime) {
				state = 1;
				firstTime = false;
			} else {
				state = 2;
			}
			break;

		case 1: 
			if (invadersOfSpace.getReadyCounter == 0) {
				invadersOfSpace.splashScreen(); 
			}
			if (invadersOfSpace.getReadyCounter == 0 && stars.haveAccelerated()) {
				invadersOfSpace.getReadyCounter = 170;
			}
			if (invadersOfSpace.getReadyCounter > 0) {
				invadersOfSpace.getReady();
				if (--invadersOfSpace.getReadyCounter == 0)
					state = 2;
			}
			break;

		case 2: 
			invadersOfSpace.run();
			if (invadersOfSpace.isGameOver())
				state = 3; 
			break;

		case 3: 
			invadersOfSpace.gameOver(); 
			break;
	}
}

void keyPressed() {
	if (keyCode == RIGHT) invadersOfSpace.move(1, 0);
	if (keyCode == LEFT) invadersOfSpace.move(-1, 0);
	if (keyCode == DOWN) invadersOfSpace.move(0, 1);
	if (keyCode == UP) invadersOfSpace.move(0, -1);
	if (keyCode == ENTER) {
		if (state == 3) {
			state = 0;
			soundEffect(6);
		}
	}
	if (key == 32) {
		if (!invadersOfSpace.runningGetReady() && stars.acceleration == 0) { 
			switch (state) {
				case 1:
					stars.accelerate(); 
					soundEffect(6); 
					break;
				case 2:
					invadersOfSpace.shoot();
					break;
			}
		}
	}
}

void soundEffect(int n) {
	if (soundOn)
		duckTales[n].trigger();
}
