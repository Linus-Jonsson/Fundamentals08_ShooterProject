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

	background(255);
	// Epic starfield goes here...
	switch (invadersOfSpace.state) {

	// stars.drawBackground();
	background(0); //Basic background while building
	switch (invadersOfSpace.getState()) {

		case 0: invadersOfSpace.init(); break;
		case 1: invadersOfSpace.splashScreen(); break;
		case 2: invadersOfSpace.run(); break;
		case 3: invadersOfSpace.gameOver(); break;
	}
}


void keyPressed()
{
  if (keyCode == RIGHT) invadersOfSpace.move(1, 0);
  if (keyCode == LEFT) invadersOfSpace.move(-1, 0);
  if (keyCode == DOWN) invadersOfSpace.move(0, 1);
  if (keyCode == UP) invadersOfSpace.move(0, -1);
}

/*
boolean keys[4];
	keys[0] = false;
  	keys[1] = false;
  	keys[2] = false;
  	keys[3] = false;
  
void getInput() {
	if (keys[0] == true) man.acc.x += 300; 
	if (keys[1] == true) man.acc.x -= 300; 
	if (keys[2] == true) man.acc.y += 300;
	if (keys[3] == true) man.acc.y -= 300; 	
}

void keyPressed()
{
  if (keyCode == RIGHT) keys[0] = true;
  if (keyCode == LEFT) keys[1] = true;
  if (keyCode == DOWN) keys[2] = true;
  if (keyCode == UP) keys[3] = true;
}

void keyReleased()
{
  if (keyCode == RIGHT) keys[0] = false;
  if (keyCode == LEFT) keys[1] = false;
  if (keyCode == DOWN) keys[2] = false;
  if (keyCode == UP) keys[3] = false;
  if (key == 'g') gravity = !gravity; //keys[4] = false;
} */