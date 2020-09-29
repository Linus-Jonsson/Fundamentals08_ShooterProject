StarSystem stars;
Game invadersOfSpace;


void setup() {
	surface.setLocation(10, 10);
	size(480, 640);
	frameRate(30);
	stars = new StarSystem(new PVector(width/2, height/2));
	invadersOfSpace = new Game();
}

void draw() {

	background(255);
	// Epic starfield goes here...

	stars.drawBackground();
	//background(0); //Basic background while building
	switch (invadersOfSpace.state) {
		case 0: invadersOfSpace.init(); break;
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
 }

