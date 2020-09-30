StarSystem stars;
Game invadersOfSpace;
<<<<<<< Updated upstream
=======
int state;
>>>>>>> Stashed changes

void setup() {
	// surface.setLocation(10, 10);
	((java.awt.Canvas) surface.getNative()).requestFocus();
	size(480, 640);
	frameRate(30);
	state = 0; // Init.
}

void draw() {
	stars.drawBackground();
	switch (invadersOfSpace.state) {
		case 0: stars = new StarSystem(new PVector(width/2, height/2));
				invadersOfSpace = new Game(); 
				invadersOfSpace.state = 1;
				break;
		case 1: invadersOfSpace.splashScreen(); break;
		case 2: invadersOfSpace.run(); break;
		case 3: invadersOfSpace.gameOver(); break;
	}
}

void keyPressed() {
	if (keyCode == RIGHT) invadersOfSpace.move(1, 0);
  	if (keyCode == LEFT) invadersOfSpace.move(-1, 0);
  	if (keyCode == DOWN) invadersOfSpace.move(0, 1);
  	if (keyCode == UP) invadersOfSpace.move(0, -1);
  	if (key == 32) {
  		if (state == 1)
  			state = 2;
  		else if (state == 3)
  			state = 2;
  		else {
  			invadersOfSpace.shoot(); // 32 = space
  		}
  	}
 }

