//
// Huvudansvarig: Andreas Collvin
//
class Time {
	long initTime = millis();
	long lastTime = millis();

	long getAbsolute() {
		return millis() - initTime;
	}

	float getDelta() {
		float delta_t = (millis() - lastTime);
		lastTime = millis();
		return delta_t;
	}

	void pause(long pauseTime) {
		long t = millis();
		while ((millis() - t) < pauseTime);
	}
}
