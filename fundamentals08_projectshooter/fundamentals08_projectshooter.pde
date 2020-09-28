// StarSystem stars;
Game invadersOfSpace;

void setup() {
	surface.setLocation(10, 10);
	size(640, 480);
	frameRate(30);
	// stars = new StarSystem(new PVector(width/2, height/2));
	invadersOfSpace = new Game();
}

void draw() {
	// stars.drawBackground();
	background(0); //Basic background while building
	switch (invadersOfSpace.getState()) {
		case 0: invadersOfSpace.init(); break;
		case 1: invadersOfSpace.homeScreen(); break;
		case 2: invadersOfSpace.run(); break;
		case 3: invadersOfSpace.gameOver(); break;
	}
}