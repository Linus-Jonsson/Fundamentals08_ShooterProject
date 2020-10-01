class BoundingCircle {
	PVector offset;
	float diameter;
	BoundingCircle(float x, float y, float _diameter) {
		offset = new PVector(x, y);
		diameter = _diameter;
	}
}