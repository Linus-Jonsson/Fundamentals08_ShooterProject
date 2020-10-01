class WallPiece extends GameObject {
	boolean alive;
	float diameter;
	color col;
	int damageLevel;
	ArrayList<PVector> damage;

	WallPiece(float x, float y, BoundingCircle bc, float dia) {
		super(x, y, bc);
		alive = true;
		diameter = dia;
		col = color(0, 57, 136);
		damageLevel = 0;
		damage = new ArrayList<PVector>();
	}

	void pixelDamage(int d) {
		for (int n = 0; n < d; n++) {
			float dx = pos.x - 5 + random(10);
			float dy = pos.y - 5 + random(10);
			damage.add(new PVector(dx, dy));
		}
	}

	void applyDamage() {
		switch (damageLevel++) {
			case 0: pixelDamage((int)random(5, 10)); break;
			case 1:	pixelDamage((int)random(5, 10)); break;
			case 2: pixelDamage((int)random(5, 10)); break;
			case 3: alive = false;
		}
	}

	void drawDamage() {
		for (PVector d : damage) {
			stroke(0,0,0);
			fill(0,0,0);
			strokeWeight(2);
			circle(d.x, d.y, 2);
		}
	}

	void draw() {
		if (alive) {
			rectMode(CENTER);
			stroke(col);
			fill(col);
			beginShape();
			vertex(pos.x+diameter/2, pos.y+diameter/2);
			vertex(pos.x-diameter/2, pos.y+diameter/2);
			vertex(pos.x-diameter/2, pos.y-diameter/1.3);
			vertex(pos.x-diameter/4, pos.y-diameter/1.7);
			vertex(pos.x, pos.y-diameter/2);
			vertex(pos.x+diameter/3, pos.y-diameter/1.9);
			vertex(pos.x+diameter/2, pos.y-diameter/1.3);
			endShape(CLOSE);
			drawDamage();
		}
	}

	void drawTopRow() {
		if (alive) {
			rectMode(CENTER);
			stroke(col);
			fill(col);
			square(pos.x, pos.y, diameter);
			drawDamage();			
		}
	}

	void drawLeftCorner() {
		if (alive) {
			stroke(col);
			fill(col);
			beginShape();
			vertex(pos.x+diameter/2, pos.y+diameter/2);
			vertex(pos.x-diameter/2, pos.y+diameter/2);
			vertex(pos.x-diameter/2, pos.y-diameter/2);
			vertex(pos.x+diameter/2, pos.y-diameter*1.5);
			endShape(CLOSE);
			drawDamage();			
		}
	}	

	void drawRightCorner() {
		if (alive) {
			stroke(col);
			fill(col);
			beginShape();
			vertex(pos.x+diameter/2, pos.y+diameter/2);
			vertex(pos.x-diameter/2, pos.y+diameter/2);
			vertex(pos.x-diameter/2, pos.y-diameter*1.5);
			vertex(pos.x+diameter/2, pos.y-diameter/2);
			endShape(CLOSE);
			drawDamage();						
		}
	}
}