class Player extends GameObject {
	float size = 10;
	boolean alive;
	boolean isCurrent;
	color col = color(255, 174, 0);
	color colDark = color(192, 132, 0);
	color colBright = color(255, 200, 82);
	boolean highlight;
	
	Player(float x, float y, BoundingCircle bc) {
		super(x, y, bc);
		alive = true;
		isCurrent = false;
	}

	boolean collideWall() {
		if (alive) {
			if ((pos.x - size * 1.5 < 0) || (pos.x > width - size * 1.5))
				return true;
		}
		return false;
	}

	void draw(boolean _highlight) {
		highlight = _highlight;
		push();
		translate(pos.x, pos.y);
		shipBurner();
		playerShape();	
	}

	void shipBurner() {
		int r = (int)random(255);
		stroke(0, r, r);
		line (-1, -23, 0, -23 - (int)random(5));
		r = (int)random(255);
		stroke(0, r, r);
		line (1, -23, 0, -23 - (int)random(5));
		r = (int)random(255);
		stroke(0, r, r);
		line (1, -23, 0, -23 - (int)random(5));
		r = (int)random(255);
		stroke(0, r, r);
		line (1, -23, 0, -23 - (int)random(5));
	}

	void playerShape() {
		beginShape(QUADS);
		noStroke();
		fill(255);
		vertex(-size * 0.7, -size * 0.5);
		vertex(-size * 0.6, -size * 0.5);
		vertex(-size * 0.6, -size * 2.1);
		vertex(-size * 0.7, -size * 2.1);
		vertex(size * 0.7, -size * 0.5);
		vertex(size * 0.6, -size * 0.5);
		vertex(size * 0.6, -size * 2.1);
		vertex(size * 0.7, -size * 2.1);
		vertex(-size * 0.35, -size * 2);
		vertex(-size * 0.4, -size * 2.15);
		vertex(size * 0.4, -size * 2.15);
		vertex(size * 0.35, -size * 2);
		endShape();
		beginShape(TRIANGLES);
		if (!highlight) {
			fill(colDark);
		} else {
			fill(255);
			stroke(col);
			strokeWeight(0.8);
		} 
		vertex(-size * 0.9, -size * 0.75);
		vertex(-size * 1.4, -size * 1.8);
		vertex(-size * 0.4, -size * 1.8);
		vertex(size * 0.9, -size * 0.75);
		vertex(size * 1.4, -size * 1.8);
		vertex(size * 0.4, -size * 1.8);
		if (!highlight) {
			fill(col);
		} else {
			fill(255);
		} 
		noStroke();
		vertex(0, 0);
		vertex(-size, -size * 2);
		vertex(size, -size * 2);
		fill(colBright);
		vertex(0, -size * 0.7);
		vertex(-size * 0.4, -size * 1.5);
		vertex(size * 0.4, -size * 1.5);
		endShape();
		beginShape(LINES);
		strokeWeight(size * 0.12);
		stroke(255);
		vertex(-size * 0.02, -size * 0.06);
		vertex(-size * 0.65, -size * 1.35);
		vertex(-size * 0.95, -size * 0.8);
		vertex(-size * 1.4, -size * 1.75);
		vertex(size * 0.85, -size * 0.8);
		vertex(size * 0.65, -size * 1.25);
		vertex(0, -size * 0.75);
		vertex(-size * 0.4, -size * 1.45);
		endShape();
		pop();
	}
}
