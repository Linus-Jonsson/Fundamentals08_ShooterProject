class Enemy extends GameObject {
	
	Enemy(float x, float y, BoundingCircle bc) {
		super(x, y, bc);
	}

	void draw() {
<<<<<<< Updated upstream
		float size = 8;
=======
		//drawBoundingCircle();
		float size = 10;
>>>>>>> Stashed changes
		
		pushMatrix();
		translate(pos.x, pos.y);
		noStroke();

		beginShape(TRIANGLES);
		push();
		translate(-size*0.1, size*0.03);
		fill(255);
		vertex(-size, 0);
		vertex(-size*2.2, -size*0.3);
		vertex(-size*1.8, -size*0.5);
		vertex(-size*2.2, -size*0.3);
		vertex(-size*1.8, -size*0.3);
		vertex(-size*1.1, -size*1.4);
		vertex(-size, 0);
		vertex(-size*2.1, size*0.7);
		vertex(-size*1.8, size*0.8);
		vertex(-size*2.1, size*0.7);
		vertex(-size*1.8, size*0.6);
		vertex(-size*0.6, size*1.4);
		pop();
		push();
		translate(-size*0.1, size*0.05);
		vertex(size, 0);
		vertex(size*2.2, -size*0.3);
		vertex(size*1.8, -size*0.5);
		vertex(size*2.2, -size*0.3);
		vertex(size*1.8, -size*0.3);
		vertex(size*1.1, -size*1.4);
		vertex(size, 0);
		vertex(size*2.1, size*0.7);
		vertex(size*1.8, size*0.8);
		vertex(size*2.1, size*0.7);
		vertex(size*1.8, size*0.6);
		vertex(size*0.6, size*1.4);
		pop();
		endShape();

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
		vertex(-size, 0);
		vertex(-size*2.1, size*0.7);
		vertex(-size*1.8, size*0.8);
		vertex(-size*2.1, size*0.7);
		vertex(-size*1.8, size*0.6);
		vertex(-size*0.6, size*1.4);
		vertex(size, 0);
		vertex(size*2.1, size*0.7);
		vertex(size*1.8, size*0.8);
		vertex(size*2.1, size*0.7);
		vertex(size*1.8, size*0.6);
		vertex(size*0.6, size*1.4);
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
		popMatrix();
	}
}