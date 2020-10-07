//
// Huvudansvarig: Andreas Collvin
//
class SoundManager {
	AudioPlayer theme;
	AudioSample[] duckTales;
	boolean soundOn;

	SoundManager(boolean sound) {
		soundOn = sound;
		theme = minim.loadFile("DuckTales.mp3", 10000);
		duckTales = new AudioSample[10];
		duckTales[0] = minim.loadSample("crabHit.wav", 512);
		duckTales[1] = minim.loadSample("crabDies.wav", 512);
		duckTales[2] = minim.loadSample("fire.wav", 512);
		duckTales[3] = minim.loadSample("playerHit.wav", 512);
		duckTales[4] = minim.loadSample("playerDead.wav", 512);
		duckTales[5] = minim.loadSample("restart.wav", 512);
		duckTales[6] = minim.loadSample("wallHit.wav", 512);
		if (soundOn) {
			theme.loop();
			theme.play();
		}
	}

	void soundEffect(int index) {
		if (soundOn)
			duckTales[index].trigger();
	}
}