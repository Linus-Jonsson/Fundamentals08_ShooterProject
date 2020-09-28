class BoundingBox {
	int x, y, w, h;

	void draw() {
		strokeWidth(1);
		stroke(255, 0, 0);
		rect(x, y, w, h);
	}
}