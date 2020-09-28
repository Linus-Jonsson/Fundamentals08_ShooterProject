class BoundingBox {
	int x, y, w, h;

	draw(void) {
		strokeWidth(1);
		stroke(255, 0, 0);
		rect(x, y, w, h);
	}
}