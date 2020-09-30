class BoundingCircle {
	PVector offset;
	float radius;
	BoundingCircle(float x, float y, float r) {
		offset = new PVector(x, y);
		radius = r;
	}
}