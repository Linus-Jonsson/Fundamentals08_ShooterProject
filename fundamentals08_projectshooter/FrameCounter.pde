//
// Huvudansvarig: Andreas Collvin
//
class FrameCounter {
	float frames = 0;
	float startTime = millis();
	float fps;
	
	float get() {
		frames++;
		if (millis() - startTime > 1000) {
			fps = (frames / (millis() - startTime)) * 1000;
			startTime = millis();
			frames = 0;
		} 
		return fps;		
	}
}