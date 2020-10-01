// To fix:
// 
// States -
//
// 1) svart skärm
// 2) från centrum och utåt
// 3) ladda musik i bakgrunden
// 4) när stjärnorna börjar bli fulltaliga
// 5) start screen kommer tillsammans med musiken
//
// Optimera kollision mot väggarna (övergripande kollision)
// pos.x på väggarna ligger uppe till vänster med ett indrag på radius (diameter/2)
import processing.sound.*;


//SoundFile ducktales;
Game invadersOfSpace;
StarSystem stars;
int state;
boolean firstTime;
//Sound s;

void setup() {
	//ducktales = new SoundFile(this, "DuckTales.mp3");
	surface.setLocation(10, 10);
	((java.awt.Canvas) surface.getNative()).requestFocus();
	size(480, 640);
	frameRate(30);
	state = 0; // Init.
	firstTime = true;
	stars = new StarSystem(new PVector(width/2, height/2));	
	//s = new Sound(this);
	//s.volume(0.1);
	//ducktales.loop();			
}

void draw() {
	stars.drawBackground();
	switch (state) {
		case 0: 
		invadersOfSpace = new Game(); 
		if (firstTime) {
			state = 1;
			firstTime = false;
		} else 
		state = 2;
		break;
		case 1: 
		invadersOfSpace.splashScreen(); 
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
  	if (key == 32) { // Spacebar
  		switch (state) {
  			case 1: state = 2; break;
  			case 2: invadersOfSpace.shoot(); break;
  			case 3: state = 0; break;
  		}
  	}
  }

