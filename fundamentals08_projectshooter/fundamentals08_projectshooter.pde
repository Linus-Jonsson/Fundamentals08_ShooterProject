Game invadersOfSpace;

// test :D

void setup() {
	surface.setLocation(10, 10);
	size(640, 480);
	frameRate(30);

	invadersOfSpace = new Game();
}

void draw() {
	background(255);
	// Epic starfield goes here...
	switch (invadersOfSpace.getState()) {
		case 0: invadersOfSpace.init(); break;
		case 1: invadersOfSpace.homeScreen(); break;
		case 2: invadersOfSpace.run(); break;
		case 3: invadersOfSpace.gameOver(); break;
	}
}