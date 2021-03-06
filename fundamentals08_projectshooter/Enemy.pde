//
// Huvudansvarig: Linus Jonsson
//
class Enemy extends GameObject {
	color col = color(84, 23, 243);
	color colDark = color(56, 4, 191);
	color colBright = color(39, 3, 132);
	int lives = 3;
	int time = millis();
	int walkTime = 20;
	float size = 10;
	float deathRotation = 0;
	float walkingRotation = 0;
	float walkingRotationVel = 0.02;
	boolean lostLife = false;

	Enemy(float x, float y, BoundingCircle bc) {
		super(x, y, bc);
		vel.x = -1;
	}

	boolean readyToShoot() {
		if (lives > 0 && millis() - time > 400) {
			time = millis();
			return true;
		}
		return false;
	}

	void draw() {
		if (lives > 0) {
			push();
			translate(pos.x, pos.y);
			if (deathRotation > 0) {
				rotate(deathRotation);
				scale(1 + (3.14 - abs(deathRotation - 3.14)) / 3);
			}
			else {
				rotate(walkingRotation);
			}
			enemyShape();
			pop();
		}			
	}

	void drawLives(int lives) {
		push();
		scale(0.6);
		translate(50 / 0.6, height * 0.952 / 0.6);
		if (lives >= 2) {
			enemyShape();
			if (lives == 3) {
				translate(60, 0);
				enemyShape();
			}
		}
		pop();
	}

	void enemyShape() {
		noStroke();
		beginShape(TRIANGLES);
		fill(255);
		vertex(-size * 1.2, 0);
		vertex(-size * 2.3, -size * 0.3);
		vertex(-size * 1.9, -size * 0.5);
		vertex(-size * 2.3, -size * 0.3);
		vertex(-size * 1.8, -size * 0.3);
		vertex(-size * 1.1, -size * 1.4);
		vertex(size * 0.9, 0);
		vertex(size * 1.9, -size * 0.3);
		vertex(size * 1.7, -size * 0.5);
		vertex(size * 2.0, -size * 0.3);
		vertex(size * 1.7, -size * 0.3);
		vertex(size * 1.1, -size * 1.4);
		vertex(-size, 0);
		vertex(-size * 2.3, size * 0.3);
		vertex(-size * 1.9, size * 0.5);
		vertex(-size * 2.3, size * 0.3);
		vertex(-size * 1.9, size * 0.3);
		vertex(-size * 1.8, size * 1.3);
		vertex(-size, 5);
		vertex(-size * 1.7, size * 0.7);
		vertex(-size * 1.5, size * 0.9);
		vertex(-size * 1.7, size * 0.8);
		vertex(-size * 1.5, size * 0.6);
		vertex(-size * 1.2, size * 1.4);
		vertex(size * 0.9, 0);
		vertex(size * 2.2, size * 0.3);
		vertex(size * 1.8, size * 0.5);
		vertex(size * 2.2, size * 0.3);
		vertex(size * 1.8, size * 0.3);
		vertex(size * 1.6, size * 1.3);
		vertex(size, 11);
		vertex(size * 1.6, size * 0.7);
		vertex(size * 1.4, size * 0.9);
		vertex(size * 1.6, size * 0.7);
		vertex(size * 1.3, size * 0.7);
		vertex(size * 1.1, size * 1.4);
		endShape();
		beginShape(TRIANGLES);
		fill(colDark);
		vertex(-size, 0);
		vertex(-size * 2.2, -size * 0.3);
		vertex(-size * 1.8, -size * 0.5);
		vertex(-size * 2.2, -size * 0.3);
		vertex(-size * 1.8, -size * 0.3);
		vertex(-size * 1.1, -size * 1.4);
		vertex(size, 0);
		vertex(size * 2.2, -size * 0.3);
		vertex(size * 1.8, -size * 0.5);
		vertex(size * 2.2, -size * 0.3);
		vertex(size * 1.8, -size * 0.3);
		vertex(size * 1.1, -size * 1.4);
		vertex(-size, 0);
		vertex(-size * 2.2, size * 0.3);
		vertex(-size * 1.9, size * 0.5);
		vertex(-size * 2.2, size * 0.3);
		vertex(-size * 1.9, size * 0.3);
		vertex(-size * 1.8, size * 1.3);
		vertex(-size, 4);
		vertex(-size * 1.7, size * 0.7);
		vertex(-size * 1.5, size * 0.9);
		vertex(-size * 1.7, size * 0.7);
		vertex(-size * 1.5, size * 0.6);
		vertex(-size * 1.2, size * 1.4);
		vertex(size, 0);
		vertex(size * 2.2, size * 0.3);
		vertex(size * 1.9, size * 0.5);
		vertex(size * 2.2, size * 0.3);
		vertex(size * 1.9, size * 0.3);
		vertex(size * 1.6, size * 1.3);
		vertex(size, 11);
		vertex(size * 1.6, size * 0.7);
		vertex(size * 1.4, size * 0.9);
		vertex(size * 1.6, size * 0.7);
		vertex(size * 1.4, size * 0.6);
		vertex(size * 1.1, size * 1.4);
		endShape();
		fill(255);
		ellipse(-size * 0.07, size * 0.07, size * 3.05, size * 2.05);
		fill(col);
		ellipse(0, 0, size * 3, size * 2);
		fill(255);
		ellipse(-size * 0.52, -size * 0.48, size * 0.63, size * 0.43);
		ellipse(size * 0.48, -size * 0.48, size * 0.63, size * 0.43);
		fill(colBright);
		ellipse(-size * 0.5, -size * 0.5, size * 0.6, size * 0.4);
		ellipse(size * 0.5, -size * 0.5, size * 0.6, size * 0.4);
		fill(0);
		ellipse(-size * 0.5, -size * 0.55, size * 0.3, size * 0.2);
		ellipse(size * 0.5, -size * 0.55, size * 0.3, size * 0.2);
		fill(255);
		ellipse(-size * 0.56, -size * 0.58, size * 0.12, size * 0.08);
		ellipse(size * 0.44, -size * 0.58, size * 0.12, size * 0.08);
	}
}