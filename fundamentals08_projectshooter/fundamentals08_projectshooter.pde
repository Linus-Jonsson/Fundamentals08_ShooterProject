// To fix:
// 
// Se till att ev. Hi-Score sparas till nästa runda
//
// Current ship color
 

import processing.sound.*;

SoundFile[] ducktales;
Sound sound;
boolean soundOn = true;
Game invadersOfSpace;
StarSystem stars;
int state;
boolean firstTime;
int highScore;

void setup() {
	if (soundOn) {
		ducktales = new SoundFile[10];
		ducktales[0] = new SoundFile(this, "DuckTales.mp3");
		ducktales[1] = new SoundFile(this, "crabHit.wav");
		ducktales[2] = new SoundFile(this, "crabDies.wav");
		ducktales[3] = new SoundFile(this, "fire.wav");
		ducktales[4] = new SoundFile(this, "playerHit.wav");
		ducktales[5] = new SoundFile(this, "playerDead.wav");
		ducktales[6] = new SoundFile(this, "restart.wav");
		ducktales[7] = new SoundFile(this, "wallHit.wav");	
	}

	surface.setLocation(10, 10);
	((java.awt.Canvas) surface.getNative()).requestFocus();
	size(480, 640);
	frameRate(60);

	state = 0; // Init.
	firstTime = true;
	stars = new StarSystem(new PVector(width / 2, height / 2));	
	highScore = 0;

	if (soundOn) {
		sound = new Sound(this);
		sound.volume(0.1);
		ducktales[0].loop();
	}
}

void draw() {
	stars.drawBackground();
	switch (state) {
		case 0: 
			invadersOfSpace = new Game(highScore); 
			if (firstTime) {
				state = 1;
				firstTime = false;
			} else 
			state = 2;
			break;
		case 1: 
			if (invadersOfSpace.getReadyCounter == 0)
				invadersOfSpace.splashScreen(); 
			if (invadersOfSpace.getReadyCounter == 0 && stars.haveAccelerated())
				invadersOfSpace.getReadyCounter = 170;
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
			invadersOfSpace.run();
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
	if (key == 32) { // Spacebar
		switch (state) {
			case 1: stars.accelerate(); 
					soundEffect(6); break;
			case 2: invadersOfSpace.shoot(); break;
		}
	}
}

void soundEffect(int n) {
	if (soundOn) {
		ducktales[n].play();
	}
}