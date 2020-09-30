class Player extends GameObject {
	boolean alive;
	boolean isCurrent;
	
	Player(float x, float y, BoundingCircle bc) {
		super(x, y, bc);
		alive = true;
		isCurrent = false;
	}

	void draw(boolean highlight) {
		//drawBoundingCircle();
		float size = 10;
		int nonHighlightAlpha = 100;
		
		pushMatrix();
  		translate(pos.x, pos.y);

  		int r = (int)random(255);
  		stroke(0, r, r);
  		line (-1, -23, 0, -23 - (int)random(4));
  		r = (int)random(255);
  		stroke(0, r, r);
  		line (1, -23, 0, -23 - (int)random(4));
  		r = (int)random(255);
  		stroke(0, r, r);
  		line (1, -23, 0, -23 - (int)random(4));

		beginShape(QUADS);
		noStroke();
		
		if (!highlight)
			fill(255, 100, 20, nonHighlightAlpha);
		else 
			fill(255, 100, 20, 255);

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
		if (!highlight)
			fill(255, 170, 40, nonHighlightAlpha);
		else
			fill(255, 170, 40, 255);
		vertex(-size*0.9, -size*0.75);
		vertex(-size*1.4, -size*1.8);
		vertex(-size*0.4, -size*1.8);
		vertex(size*0.9, -size*0.75);
		vertex(size*1.4, -size*1.8);
		vertex(size*0.4, -size*1.8);
		vertex(0, 0);
		vertex(-size, -size*2);
		vertex(size, -size*2);
		if (!highlight)
			fill(255, 220, 120, nonHighlightAlpha);
		else
			fill(255, 220, 120, 255);
		vertex(0, -size*0.7);
		vertex(-size*0.4, -size*1.5);
		vertex(size*0.4, -size*1.5);
		endShape();

		beginShape(LINES);
		strokeWeight(size * 0.1);
		
		if (!highlight) 
			stroke(nonHighlightAlpha);
		else
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
		popMatrix();
	}	
}