void startScreen(PFont titleFont, PFont font) {	
		textFont(titleFont);
		fill(255);
		textSize(80);
		textAlign(LEFT);
		text("INV", 10, height/2-40);
		text("ADERS", 125, height/2-40);
		textAlign(RIGHT);
		text("OF SPACE", width-30, height/2+40);
		textFont(font);
		textSize(24);
		textAlign(CENTER);
		text("Press SPACE to start", width/2, height/2+90);
		beginShape();
		strokeWeight(2.5);
		stroke(20, 40, 205);
		noFill();
		vertex(30, 210);
		vertex(30, 30);
		vertex(width-30, 30);
		vertex(width-30, 290);
		endShape();
		beginShape();
		vertex(30, 295);
		vertex(30, height-30);
		vertex(width-30, height-30);
		vertex(width-30, 375);
		endShape();
		beginShape();
		strokeWeight(1.5);
		stroke(225, 150, 10);
		noFill();
		vertex(45, 210);
		vertex(45, 45);
		vertex(width-45, 45);
		vertex(width-45, 290);
		endShape();
		beginShape();
		vertex(45, 295);
		vertex(45, height-45);
		vertex(width-45, height-45);
		vertex(width-45, 375);
		endShape();
	}	

	void gameOverScreen(PFont titleFont, PFont font) {	
		textFont(titleFont);
		fill(255);
		textAlign(CENTER);
		textSize(120);
		text("GAME ", width/2, height/2-40);
		text("OVER ", width/2, height/2+70);
		textFont(font);
		textSize(20);
		text("Press SPACE to play again", width/2, height/2+120);
		text("Or ESC to quit", width/2, height/2+150);
		beginShape();
		strokeWeight(2.5);
		stroke(20, 40, 205);
		noFill();
		vertex(30, 30);
		vertex(width-30, 30);
		vertex(width-30, height-30);
		vertex(30, height-30);
		endShape(CLOSE);
		beginShape();
		strokeWeight(1.5);
		stroke(225, 150, 10);
		noFill();
		vertex(45, 45);
		vertex(width-45, 45);
		vertex(width-45, height-45);
		vertex(45, height-45);
		endShape(CLOSE);
	}	

	void winScreen(PFont titleFont, PFont font) {	
		textFont(titleFont);
		fill(255);
		textAlign(CENTER);
		textSize(60);
		//TODO - Not final text!
		text("Congratz! ", width/2, height/2-80);
		textSize(30);
		text("YOUR", width/2, height/2-30);
		text("SCORE:", width/2, height/2);
		textSize(100);
		//TODO - Add int score!! (+Celebratory Effect?!?)
		text("1000 ", width/2, height/2+90);
		textFont(font);
		textSize(20);
		text("Press SPACE to play again", width/2, height/2+170);
		text("Or ESC to quit", width/2, height/2+200);
		beginShape();
		strokeWeight(2.5);
		stroke(20, 40, 205);
		noFill();
		vertex(30, 30);
		vertex(width-30, 30);
		vertex(width-30, height-30);
		vertex(30, height-30);
		endShape(CLOSE);
		beginShape();
		strokeWeight(1.5);
		stroke(225, 150, 10);
		noFill();
		vertex(45, 45);
		vertex(width-45, 45);
		vertex(width-45, height-45);
		vertex(45, height-45);
		endShape(CLOSE);
	}	