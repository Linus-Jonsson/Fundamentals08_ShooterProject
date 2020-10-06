//
// Huvudansvarig: Linus Jonsson
//
class WallPiece extends GameObject {
	boolean alive = true;
	float diameter;
	color col = color(0, 160, 180);
	color colDark = color(0, 80, 90);
	int damageLevel = 0;
	ArrayList<PVector> damage = new ArrayList<PVector>();

	WallPiece(float x, float y, BoundingCircle bc, float _diameter) {
		super(x, y, bc);
		diameter = _diameter;
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
			case 0: pixelDamage((int)random(7, 14)); break;
			case 1: alive = false; break;
		}
	}

	void drawDamage() {
		for (PVector d : damage) {
			stroke(0, 0, 0);
			fill(0, 0, 0);
			strokeWeight(2);
			circle(d.x, d.y, 2);
			strokeWeight(1);
		}
	}

	void draw() {
		if (alive) {
			rectMode(CENTER);
			strokeWeight(0.8);
			stroke(colDark);
			fill(col);
			beginShape();
			vertex(pos.x + diameter / 2, pos.y + diameter / 2);
			vertex(pos.x - diameter / 2, pos.y + diameter / 2);
			vertex(pos.x - diameter / 2, pos.y - diameter / 1.3);
			vertex(pos.x - diameter / 4, pos.y - diameter / 1.7);
			vertex(pos.x, pos.y - diameter / 2);
			vertex(pos.x + diameter / 3, pos.y - diameter / 1.9);
			vertex(pos.x + diameter / 2, pos.y - diameter / 1.3);
			endShape(CLOSE);
			drawDamage();
		}
	}

	void drawTopRow() {
		if (alive) {
			rectMode(CENTER);
			strokeWeight(0.8);
			stroke(colDark);
			fill(col);
			square(pos.x, pos.y, diameter);
			drawDamage();
		}
	}

	void drawLeftCorner() {
		if (alive) {
			strokeWeight(0.8);
			stroke(colDark);
			fill(col);
			beginShape();
			vertex(pos.x + diameter / 2, pos.y + diameter / 2);
			vertex(pos.x - diameter / 2, pos.y + diameter / 2);
			vertex(pos.x - diameter / 2, pos.y - diameter / 2);
			vertex(pos.x + diameter / 2, pos.y - diameter * 1.5);
			endShape(CLOSE);
			drawDamage();
		}
	}	

	void drawRightCorner() {
		if (alive) {
			strokeWeight(0.8);
			stroke(colDark);
			fill(col);
			beginShape();
			vertex(pos.x + diameter / 2, pos.y + diameter / 2);
			vertex(pos.x - diameter / 2, pos.y + diameter / 2);
			vertex(pos.x - diameter / 2, pos.y - diameter * 1.5);
			vertex(pos.x + diameter / 2, pos.y - diameter / 2);
			endShape(CLOSE);
			drawDamage();
		}
	}
}