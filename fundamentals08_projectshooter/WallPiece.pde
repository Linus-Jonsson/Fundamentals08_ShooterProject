class WallPiece extends GameObject {
	boolean alive;
	float diameter;
	color col;

	WallPiece(float x, float y, BoundingCircle bc, float dia) {
		super(x, y, bc);
		alive = true;
		diameter = dia;
		col = color(0, 255, 0); //NOT final color!
	}

	void draw() {
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
	}

	void drawTopRow() {
		rectMode(CENTER);
		stroke(col);
		fill(col);
		square(pos.x, pos.y, diameter);
	}

	void drawLeftCorner() {
		stroke(col);
		fill(col);
		beginShape();
		vertex(pos.x+diameter/2, pos.y+diameter/2);
		vertex(pos.x-diameter/2, pos.y+diameter/2);
		vertex(pos.x-diameter/2, pos.y-diameter/2);
		vertex(pos.x+diameter/2, pos.y-diameter*1.5);
		endShape(CLOSE);
	}	

	void drawRightCorner() {
		stroke(col);
		fill(col);
		beginShape();
		vertex(pos.x+diameter/2, pos.y+diameter/2);
		vertex(pos.x-diameter/2, pos.y+diameter/2);
		vertex(pos.x-diameter/2, pos.y-diameter*1.5);
		vertex(pos.x+diameter/2, pos.y-diameter/2);
		endShape(CLOSE);
	}
}