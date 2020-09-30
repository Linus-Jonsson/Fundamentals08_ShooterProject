// To fix:
// 
// BUG: 
// 1) can't select a different player when diagonal space between current
// and next
//
// 2) Shots go through the crabs and create TONS of particle systems
// that slow down the system, and create huge delta_t which mess up the
// looks of the explosions.
//
// döpa om radius to diameter 
//
// flytta murarna något till höger (CHECK!//Linus)
//
// pos.x på väggarna ligger uppe till vänster med ett indrag på radius (diameter/2)


Game invadersOfSpace;
StarSystem stars;
int state;
boolean firstTime;

void setup() {
	surface.setLocation(10, 10);
	((java.awt.Canvas) surface.getNative()).requestFocus();
	size(480, 640);
	frameRate(30);
	state = 0; // Init.
	firstTime = true;
	stars = new StarSystem(new PVector(width/2, height/2));	
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

