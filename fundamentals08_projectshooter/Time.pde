class Time {
	long initTime;
	long lastTime;
	
	Time() {
		initTime = millis();
		lastTime = millis();
	}

	long getAbsolute() {
		return millis() - initTime;
	}

	float getDelta() {
		float delta_t = (millis() - lastTime);
		lastTime = millis();
		return delta_t;
	}

	void pause(long p) {
		long t = millis();
		while ((millis() - t) < p);
	}
}
