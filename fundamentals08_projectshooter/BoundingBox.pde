class BoundingBox {
	int x, y, w, h;

	void draw() {
		strokeWeight(1);
		stroke(255, 0, 0);
		rect(x, y, w, h);
	}
}