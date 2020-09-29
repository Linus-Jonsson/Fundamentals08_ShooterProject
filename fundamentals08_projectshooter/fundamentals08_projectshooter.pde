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

//ENEMY (CRAB)
PVector pos;
float size = 50;

void drawEnemy(PVector pos) {
  translate(pos.x, pos.y);
  noStroke();

  beginShape(TRIANGLES);
  fill(20, 40, 255);
  vertex(-size, 0);
  vertex(-size*2.2, -size*0.3);
  vertex(-size*1.8, -size*0.5);
  vertex(-size*2.2, -size*0.3);
  vertex(-size*1.8, -size*0.3);
  vertex(-size*1.1, -size*1.4);
  vertex(size, 0);
  vertex(size*2.2, -size*0.3);
  vertex(size*1.8, -size*0.5);
  vertex(size*2.2, -size*0.3);
  vertex(size*1.8, -size*0.3);
  vertex(size*1.1, -size*1.4);
  endShape();

  fill(255);
  ellipse(-size*0.05, size*0.05, size*3.05, size*2.05);
  ellipse(-size*0.55, -size*0.45, size*0.65, size*0.45);
  ellipse(size*0.55, -size*0.45, size*0.65, size*0.45);
  fill(40, 100, 255);
  ellipse(0, 0, size*3, size*2);
  fill(255);
  ellipse(-size*0.52, -size*0.48, size*0.63, size*0.43);
  ellipse(size*0.48, -size*0.48, size*0.63, size*0.43);
  fill(20, 40, 255);
  ellipse(-size*0.5, -size*0.5, size*0.6, size*0.4);
  ellipse(size*0.5, -size*0.5, size*0.6, size*0.4);
  fill(0);
  ellipse(-size*0.5, -size*0.55, size*0.3, size*0.2);
  ellipse(size*0.5, -size*0.55, size*0.3, size*0.2);
  fill(255);
  ellipse(-size*0.56, -size*0.58, size*0.12, size*0.08);
  ellipse(size*0.44, -size*0.58, size*0.12, size*0.08);
}

//PLAYERSHIP
PVector pos;
float size = 20;

void drawPlayerShip(PVector pos) {
  translate(pos.x, pos.y);

  beginShape(QUADS);
  noStroke();
  fill(255, 100, 20);
  vertex(-size*0.7, -size*0.5);
  vertex(-size*0.6, -size*0.5);
  vertex(-size*0.6, -size*2.1);
  vertex(-size*0.7, -size*2.1);
  vertex(size*0.7, -size*0.5);
  vertex(size*0.6, -size*0.5);
  vertex(size*0.6, -size*2.1);
  vertex(size*0.7, -size*2.1);
  vertex(-size*0.35, -size*2);
  vertex(-size*0.4, -size*2.15);
  vertex(size*0.4, -size*2.15);
  vertex(size*0.35, -size*2);
  endShape();

  beginShape(TRIANGLES);
  noStroke();
  fill(255, 170, 40);
  vertex(-size*0.9, -size*0.75);
  vertex(-size*1.4, -size*1.8);
  vertex(-size*0.4, -size*1.8);
  vertex(size*0.9, -size*0.75);
  vertex(size*1.4, -size*1.8);
  vertex(size*0.4, -size*1.8);
  vertex(0, 0);
  vertex(-size, -size*2);
  vertex(size, -size*2);
  fill(255, 220, 120);
  vertex(0, -size*0.7);
  vertex(-size*0.4, -size*1.5);
  vertex(size*0.4, -size*1.5);
  endShape();

  beginShape(LINES);
  strokeWeight(3);
  stroke(255);
  vertex(-size*0.02, -size*0.06);
  vertex(-size*0.65, -size*1.35);
  vertex(-size*0.95, -size*0.8);
  vertex(-size*1.4, -size*1.75);
  vertex(size*0.85, -size*0.8);
  vertex(size*0.65, -size*1.25);
  vertex(0, -size*0.75);
  vertex(-size*0.4, -size*1.45);
  endShape();
}