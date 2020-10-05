void graphicElements(int score, PFont font, boolean gameOver) {
	image(theMoon, 260, -480); 
	if (gameOver)
		return;
	strokeWeight(2);
	stroke(0,80, 90);
	line(35, height * 0.93, width - 35, height * 0.93);
	textAlign(RIGHT);
	fill(255);
	textFont(font, 22);
	text("CREDIT  00", width - 35, height * 0.96);
	text("HI-SCORE  " + highScore, width - 35, 40);
	textAlign(LEFT);
	text("SCORE  " + score, 35, 40);
}

void startScreen(PFont titleFont, PFont font) {	
	textFont(titleFont);
	fill(255);
	textSize(80);
	textAlign(LEFT);
	text("INV", 10, height / 2 - 40);
	text("ADERS", 125, height / 2 - 40);
	textAlign(RIGHT);
	text("OF SPACE", width - 30, height / 2 + 40);
	textFont(font);
	textSize(24);
	textAlign(CENTER);
	fill(255 - (255 - 56) * (500 - abs((millis() % 1000) - 500)) / 500,
		 255 - (255 - 4) * (500 - abs((millis() % 1000) - 500)) / 500,
		 255 - (255 - 191) * (500 - abs((millis() % 1000) - 500)) / 500);
	text("Press SPACE to start", width / 2, height / 2 + 90);
	beginShape();
	strokeWeight(2.5);
	stroke(56, 4, 191);
	noFill();
	vertex(30, 210);
	vertex(30, 30);
	vertex(width - 30, 30);
	vertex(width - 30, 290);
	endShape();
	beginShape();
	vertex(30, 295);
	vertex(30, height - 30);
	vertex(width - 30, height - 30);
	vertex(width - 30, 375);
	endShape();
	beginShape();
	strokeWeight(1.5);
	stroke(255, 174, 0);
	noFill();
	vertex(45, 210);
	vertex(45, 45);
	vertex(width - 45, 45);
	vertex(width - 45, 290);
	endShape();
	beginShape();
	vertex(45, 295);
	vertex(45, height - 45);
	vertex(width - 45, height - 45);
	vertex(width - 45, 375);
	endShape();
}	

void gameOverScreen(PFont titleFont, PFont font) {	
	noStroke();
	fill(0, 150);
	rectMode(CENTER);
	rect(width / 2, height / 2, width, height);
	textFont(titleFont);
	fill(255);
	textAlign(CENTER);
	textSize(120);
	text("GAME ", width / 2, height / 2 - 40);
	text("OVER ", width / 2, height / 2 + 70);
	textFont(font);
	textSize(20);
	text("Press ENTER to play again", width / 2, height / 2 + 120);
	text("Or ESC to quit", width / 2, height / 2 + 150);
	frame();
}	

void winScreen(PFont titleFont, PFont font, int score) {	
	noStroke();
	fill(0, 150);
	rectMode(CENTER);
	rect(width / 2, height / 2, width, height);
	if (frameCount % 30 == 0) {
		invadersOfSpace.explosionsManager.spawn(new PVector(random(80, width-80), random(80, height-80)),
												color(random(80, 256), random(80, 256), random(80, 256)), random(20, 60));
	}
	invadersOfSpace.explosionsManager.update(invadersOfSpace.time.getDelta() * 0.05);
	textFont(titleFont);
	fill(255 - (255 - 56) * (500 - abs((millis() % 1000) - 500)) / 500,
		 255 - (255 - 4) * (500 - abs((millis() % 1000) - 500)) / 500,
		 255 - (255 - 191) * (500 - abs((millis() % 1000) - 500)) / 500);
	textAlign(CENTER);
	textSize(80);
	text("VICTORY! ", width / 2 - 5, height / 2 - 80);
	fill(255);
	textSize(26);
	text(" SCORE:", width / 2, height / 2 - 24);
	textSize(60);
	text(score + " ", width / 2, height / 2 + 30);
	textFont(font);
	textSize(20);
	text("Press ENTER to play again", width / 2, height / 2 + 105);
	text("Or ESC to quit", width / 2, height / 2 + 135);
	frame();
	if (score > highScore)
		highScore = score;
}	

void frame() {
	beginShape();
	strokeWeight(2.5);
	stroke(20, 40, 205);
	noFill();
	vertex(30, 30);
	vertex(width - 30, 30);
	vertex(width - 30, height - 30);
	vertex(30, height - 30);
	endShape(CLOSE);
	beginShape();
	strokeWeight(1.5);
	stroke(225, 150, 10);
	noFill();
	vertex(45, 45);
	vertex(width - 45, 45);
	vertex(width - 45, height - 45);
	vertex(45, height - 45);
	endShape(CLOSE);
}