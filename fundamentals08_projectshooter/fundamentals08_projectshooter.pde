// -------------------------------------------------------------------
//
// Invaders of Space - Game Creator Programmer, Yrgo 2020
//	
//		Linus Jonsson & Andreas Collvin
//
// -------------------------------------------------------------------
//
// Linus har lagt krutet på grafik och specialeffekter,
// med huvudfokus på följande filer:
// 
//		Enemy, Player, Splashes, StarfieldBackground, Explosion
//		WallManager, WallPiece
//
// Det enda i grafikväg som vi inte har skapat är månen och fonterna.
//
// Andreas har inriktat sig på spelmotorn,
// allmän struktur och kollisionsdetektering, med
// huvudfokus på följande filer:
//
//		CollisionManager, EnemyManager, PlayerManager, ShotsManager,
//		Game och fundamentals08_projectshooter
//
// Credits: 
//
//		Music - Laura Platt and Pascal Michael Stiefel 
//				https://www.youtube.com/watch?v=BoH89vxiQDk
//
//		Sound Effects - Duck Tales (NES Game)
//
//		Moon Picture - https://pnghunter.com/png/moon-23/
// -------------------------------------------------------------------

import ddf.minim.*;
Minim minim;
AudioPlayer theme;
AudioSample[] duckTales;

PImage theMoon;

Game invadersOfSpace;
StarSystem stars;
boolean soundOn = true;
boolean firstTime = true;
int highScore = 0;
enum GameState {Init, StartScreen, Run, GameOver;}
GameState state = GameState.Init;

void setup() {
	if (soundOn) {
		minim = new Minim(this);
		duckTales = new AudioSample[10];
		theme = minim.loadFile("DuckTales.mp3", 10000);
		duckTales[0] = minim.loadSample("crabHit.wav", 512);
		duckTales[1] = minim.loadSample("crabDies.wav", 512);
		duckTales[2] = minim.loadSample("fire.wav", 512);
		duckTales[3] = minim.loadSample("playerHit.wav", 512);
		duckTales[4] = minim.loadSample("playerDead.wav", 512);
		duckTales[5] = minim.loadSample("restart.wav", 512);
		duckTales[6] = minim.loadSample("wallHit.wav", 512);	
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
		case Init: 
			invadersOfSpace = new Game(); 
			if (firstTime) {
				state = GameState.StartScreen;
				firstTime = false;
			} else {
				state = GameState.Run;
			}
			break;

		case StartScreen: 
			if (invadersOfSpace.getReadyCounter == 0) {
				invadersOfSpace.splashScreen(); 
			}
			if (invadersOfSpace.getReadyCounter == 0 && stars.haveAccelerated()) {
				invadersOfSpace.getReadyCounter = 170;
			}
			if (invadersOfSpace.getReadyCounter > 0) {
				invadersOfSpace.getReady();
				if (--invadersOfSpace.getReadyCounter == 0)
					state = GameState.Run;
			}
			break;

		case Run: 
			invadersOfSpace.run();
			if (invadersOfSpace.isGameOver())
				state = GameState.GameOver; 
			break;

		case GameOver: 
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
		if (state == GameState.GameOver) {
			state = GameState.Init;
			soundEffect(5);
		}
	}
	if (key == 32) {
		if (!invadersOfSpace.runningGetReady() && stars.acceleration == 0) { 
			switch (state) {
				case StartScreen:
					stars.accelerate(); 
					soundEffect(5); 
					break;
				case Run:
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
