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
//		SoundManager, fundamentals08_projectshooter, GameObject
//		BoundingCircle, Time, FrameCounter
//
// Delat ansvar för Game.pde.
//
// Credits: 
//
//		Music - Laura Platt and Pascal Michael Stiefel 
//				https://www.youtube.com/watch?v=BoH89vxiQDk
//
//		Sound Effects - Duck Tales (NES Game)
//
//		Moon Picture - https://pnghunter.com/png/moon-23/
//
// -------------------------------------------------------------------

import ddf.minim.*;
Minim minim;

Game invadersOfSpace;
SoundManager soundManager;
StarSystem stars;
enum GameState {Init, SplashScreen, Run, GameOver;}
GameState state = GameState.Init;
Initialized isInitialized;
int highScore = 0;

void setup() {
	((java.awt.Canvas) surface.getNative()).requestFocus();
	size(480, 640);
	frameRate(60);

	minim = new Minim(this);
	soundManager = new SoundManager(true);
	stars = new StarSystem(new PVector(width / 2, height / 2));	
	isInitialized = new Initialized();
}


void draw() {
	background(0);
	stars.drawBackground();

	switch (state) {
		case Init: 
			invadersOfSpace = new Game(soundManager); 
			state = invadersOfSpace.init(isInitialized);
			break;

		case SplashScreen: 
			state = invadersOfSpace.splashScreen(stars);
			break;

		case Run: 
			state = invadersOfSpace.run();
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
			soundManager.soundEffect(5);
		}
	}
	if (key == 32) {
		if (!invadersOfSpace.runningGetReady() && stars.acceleration == 0) { 
			switch (state) {
				case SplashScreen:
					stars.accelerate(); 
					soundManager.soundEffect(5); 
					break;
				case Run:
					invadersOfSpace.shoot();
					break;
			}
		}
	}
}