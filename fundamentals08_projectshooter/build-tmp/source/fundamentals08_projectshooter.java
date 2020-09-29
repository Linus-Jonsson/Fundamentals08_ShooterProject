import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class fundamentals08_projectshooter extends PApplet {

StarSystem stars;
Game invadersOfSpace;

public void setup() {
	//  surface.setLocation(10, 10);
	((java.awt.Canvas) surface.getNative()).requestFocus();
	
	frameRate(30);
	stars = new StarSystem(new PVector(width/2, height/2));
	invadersOfSpace = new Game();
}

public void draw() {
	stars.drawBackground();
	switch (invadersOfSpace.state) {
		case 0: invadersOfSpace.init(); break;
		case 1: invadersOfSpace.splashScreen(); break;
		case 2: invadersOfSpace.run(); break;
		case 3: invadersOfSpace.gameOver(); break;
	}
}

public void keyPressed() {
	if (keyCode == RIGHT) invadersOfSpace.move(1, 0);
  	if (keyCode == LEFT) invadersOfSpace.move(-1, 0);
  	if (keyCode == DOWN) invadersOfSpace.move(0, 1);
  	if (keyCode == UP) invadersOfSpace.move(0, -1);
  	if (key == 32) invadersOfSpace.shoot(); // 32 = space
 }

class BoundingBox {
	int x, y, w, h;

	public void draw() {
		strokeWeight(1);
		stroke(255, 0, 0);
		rect(x, y, w, h);
	}
}
// ska nog ej ha...
// Denna ska vi nog inte ha... vi har GameObject-klassen istället.
class CollisionManager {
	Player[][] players;
	Enemy[] enemies;
	ArrayList<Shot> shots;

	CollisionManager(Player[][] _players, Enemy[] _enemies, ArrayList<Shot> _shots) {
		players = _players;
		enemies = _enemies;
		shots = _shots;
	}

	public void update(float delta_t) {
		// Check all shots against players, enemies and shields
		for (int n = 0; n < shots.size(); n++) {
			//if (shots.get(n).pos.y > 640)
			
		}
	}
}
class Enemy extends GameObject {
	
	Enemy(float x, float y) {
		super(x, y);
	}

	public void AI(float delta_t) {
		// A.I. stuff, arite!
		if (pos.x < 20 || pos.x > width - 20) {
			pos.x -= vel.x * delta_t;
		}

		if ((int)random(100) == 0) {
			vel.x = -1;
		}
		if ((int)random(100) == 0) {
			vel.x = 1;
		}
	}


	public void draw() {
		float size = 10;
		
		pushMatrix();
		translate(pos.x, pos.y);
		noStroke();

		beginShape(TRIANGLES);
		fill(20, 40, 255);
		vertex(-size, 0);
		vertex(-size*2.2f, -size*0.3f);
		vertex(-size*1.8f, -size*0.5f);
		vertex(-size*2.2f, -size*0.3f);
		vertex(-size*1.8f, -size*0.3f);
		vertex(-size*1.1f, -size*1.4f);
		vertex(size, 0);
		vertex(size*2.2f, -size*0.3f);
		vertex(size*1.8f, -size*0.5f);
		vertex(size*2.2f, -size*0.3f);
		vertex(size*1.8f, -size*0.3f);
		vertex(size*1.1f, -size*1.4f);
		endShape();

		fill(255);
		ellipse(-size*0.05f, size*0.05f, size*3.05f, size*2.05f);
		ellipse(-size*0.55f, -size*0.45f, size*0.65f, size*0.45f);
		ellipse(size*0.55f, -size*0.45f, size*0.65f, size*0.45f);
		fill(40, 100, 255);
		ellipse(0, 0, size*3, size*2);
		fill(255);
		ellipse(-size*0.52f, -size*0.48f, size*0.63f, size*0.43f);
		ellipse(size*0.48f, -size*0.48f, size*0.63f, size*0.43f);
		fill(20, 40, 255);
		ellipse(-size*0.5f, -size*0.5f, size*0.6f, size*0.4f);
		ellipse(size*0.5f, -size*0.5f, size*0.6f, size*0.4f);
		fill(0);
		ellipse(-size*0.5f, -size*0.55f, size*0.3f, size*0.2f);
		ellipse(size*0.5f, -size*0.55f, size*0.3f, size*0.2f);
		fill(255);
		ellipse(-size*0.56f, -size*0.58f, size*0.12f, size*0.08f);
		ellipse(size*0.44f, -size*0.58f, size*0.12f, size*0.08f);
		popMatrix();
	}
}
class EnemyManager {
	Enemy[] enemies;
	int nEnemies;

	EnemyManager(int _nEnemies) {
		nEnemies = _nEnemies;
		enemies = new Enemy[nEnemies];
		for (int n = 0; n < nEnemies; n++)
			enemies[n] = new Enemy(width / 2, height * 0.9f);
	}

	public Enemy[] getEnemies() {
		return enemies;
	}

	public void draw() {
		for (int n = 0; n < nEnemies; n++) {
			enemies[n].draw();
		}
	}

	public void update(float delta_t) {
		for (Enemy e : enemies) {
			e.transform(delta_t);
			e.AI(delta_t);
		}
	}
}
class Game { 
	final int nPlayersX = 11;
	final int nPlayersY = 5;
	final int nEnemies = 1;
	PlayerManager playerManager;
	EnemyManager enemyManager;
	ShotsManager shotsManager;
	CollisionManager collisionManager;
	Time time;
	int state; // 0 = Init. 1 = Welcome screen. 2 = Running. 3 = Game Over
	int score; // a function of the number of surviving players and elapsed time.
	int highScore; //
	PFont titleFont = createFont("Alien-Encounters-Italic.ttf", 80);
	PFont font = createFont("Futuristic Armour.otf", 22);

	Game() {
		time = new Time();
		state = 0;
		shotsManager = new ShotsManager();
		state = 2;
		playerManager = new PlayerManager(nPlayersX, nPlayersY); //
		enemyManager = new EnemyManager(1);
		collisionManager = new CollisionManager(playerManager.getPlayers(),
												enemyManager.getEnemies(),
												shotsManager.getShots());
	}

	public void init() {
		state = 1;
	}

	public void splashScreen() {
		state = 2;
		startScreen();
		// Add code: Key SPACE to change to state = 2 
		//state = 2;
	}

	public void run() {
		float delta_t = time.getDelta() * 0.05f;

		playerManager.update(delta_t);
		enemyManager.update(delta_t);
		shotsManager.update(delta_t);
		collisionManager.update(delta_t);

		playerManager.draw();
		enemyManager.draw();
		shotsManager.draw();
	}

	public void gameOver() {
		textAlign(width / 2, height / 2);
		stroke(0);
		fill(0);
		text("Game Over!", width, height);
		//Add code: If "playerDead == true"
		//gameOverScreen();
		//else
		winScreen();
		// Add code: Key SPACE to state 0 (init)
		// state = 0;
		// Add code: ..or Key ESC to quit
		// exit();
	}

	public void move(int x, int y) {
		playerManager.setCurrentPlayer(x, y);
	}

	public void shoot() {
		if (playerManager.clearShot()) { // No other player ship is blocking the view.
			float x = playerManager.getCurrent().pos.x;
			float y = playerManager.getCurrent().pos.y;
			shotsManager.spawn(x, y, new PVector(0, 3));
			shotsManager.spawn(x + 10, y, new PVector(0, 3));
		}
	}

	public void startScreen() {	
		textFont(titleFont);
		fill(255);
		textSize(80);
		textAlign(LEFT);
		text("INV", 10, height/2-40);
		text("ADERS", 125, height/2-40);
		textAlign(RIGHT);
		text("OF SPACE", width-30, height/2+40);
		textFont(font);
		textSize(24);
		textAlign(CENTER);
		text("Press SPACE to start", width/2, height/2+90);
		beginShape();
		strokeWeight(2.5f);
		stroke(20, 40, 205);
		noFill();
		vertex(30, 210);
		vertex(30, 30);
		vertex(width-30, 30);
		vertex(width-30, 290);
		endShape();
		beginShape();
		vertex(30, 295);
		vertex(30, height-30);
		vertex(width-30, height-30);
		vertex(width-30, 375);
		endShape();
		beginShape();
		strokeWeight(1.5f);
		stroke(225, 150, 10);
		noFill();
		vertex(45, 210);
		vertex(45, 45);
		vertex(width-45, 45);
		vertex(width-45, 290);
		endShape();
		beginShape();
		vertex(45, 295);
		vertex(45, height-45);
		vertex(width-45, height-45);
		vertex(width-45, 375);
		endShape();
	}	

	public void gameOverScreen() {	
		textFont(titleFont);
		fill(255);
		textAlign(CENTER);
		textSize(120);
		text("GAME ", width/2, height/2-40);
		text("OVER ", width/2, height/2+70);
		textFont(font);
		textSize(20);
		text("Press SPACE to play again", width/2, height/2+120);
		text("Or ESC to quit", width/2, height/2+150);
		beginShape();
		strokeWeight(2.5f);
		stroke(20, 40, 205);
		noFill();
		vertex(30, 30);
		vertex(width-30, 30);
		vertex(width-30, height-30);
		vertex(30, height-30);
		endShape(CLOSE);
		beginShape();
		strokeWeight(1.5f);
		stroke(225, 150, 10);
		noFill();
		vertex(45, 45);
		vertex(width-45, 45);
		vertex(width-45, height-45);
		vertex(45, height-45);
		endShape(CLOSE);
	}	

	public void winScreen() {	
		textFont(titleFont);
		fill(255);
		textAlign(CENTER);
		textSize(60);
		//TODO - Not final text!
		text("Congratz! ", width/2, height/2-80);
		textSize(30);
		text("YOUR", width/2, height/2-30);
		text("SCORE:", width/2, height/2);
		textSize(100);
		//TODO - Add int score!! (+Celebratory Effect?!?)
		text("1000 ", width/2, height/2+90);
		textFont(font);
		textSize(20);
		text("Press SPACE to play again", width/2, height/2+170);
		text("Or ESC to quit", width/2, height/2+200);
		beginShape();
		strokeWeight(2.5f);
		stroke(20, 40, 205);
		noFill();
		vertex(30, 30);
		vertex(width-30, 30);
		vertex(width-30, height-30);
		vertex(30, height-30);
		endShape(CLOSE);
		beginShape();
		strokeWeight(1.5f);
		stroke(225, 150, 10);
		noFill();
		vertex(45, 45);
		vertex(width-45, 45);
		vertex(width-45, height-45);
		vertex(45, height-45);
		endShape(CLOSE);
	}	
}
class GameObject {
	PVector pos, vel;
	BoundingBox boundingBox;  // Radius of bounding circle. Used for collision detection.

	GameObject (float x, float y) {
		pos = new PVector(x, y);
		vel = new PVector(0, 0);
		boundingBox = new BoundingBox();
		println("creation of new Game Object");
	}

	public boolean collideWall() {
		float SIZE = 20; // Change later... 
		if ((pos.x - SIZE / 2 < 0) || (pos.x > width - SIZE / 2))
			return true;
		return false;
	}

	public void transform(float delta_t) {
		pos.x += vel.x * delta_t;
		pos.y += vel.y * delta_t;
	}

	//boolean 
}
// tas bort?
class Player extends GameObject {
	boolean alive;
	
	Player(float x, float y) {
		super(x, y);
		alive = true;
	}

	public void draw(boolean highlight) {
		float size = 10;
		int nonHighlightAlpha = 100;
		
		pushMatrix();
  		translate(pos.x, pos.y);
		
  		int r = (int)random(255);
  		stroke(0, r, r);
  		line (-1, -23, 0, -23 - (int)random(4));
  		r = (int)random(255);
  		stroke(0, r, r);
  		line (1, -23, 0, -23 - (int)random(4));
  		r = (int)random(255);
  		stroke(0, r, r);
  		line (1, -23, 0, -23 - (int)random(4));

		beginShape(QUADS);
		noStroke();
		
		if (!highlight)
			fill(255, 100, 20, nonHighlightAlpha);
		else 
			fill(255, 100, 20, 255);

		vertex(-size*0.7f, -size*0.5f);
		vertex(-size*0.6f, -size*0.5f);
		vertex(-size*0.6f, -size*2.1f);
		vertex(-size*0.7f, -size*2.1f);
		vertex(size*0.7f, -size*0.5f);
		vertex(size*0.6f, -size*0.5f);
		vertex(size*0.6f, -size*2.1f);
		vertex(size*0.7f, -size*2.1f);
		vertex(-size*0.35f, -size*2);
		vertex(-size*0.4f, -size*2.15f);
		vertex(size*0.4f, -size*2.15f);
		vertex(size*0.35f, -size*2);
		endShape();

		beginShape(TRIANGLES);
		noStroke();
		if (!highlight)
			fill(255, 170, 40, nonHighlightAlpha);
		else
			fill(255, 170, 40, 255);
		vertex(-size*0.9f, -size*0.75f);
		vertex(-size*1.4f, -size*1.8f);
		vertex(-size*0.4f, -size*1.8f);
		vertex(size*0.9f, -size*0.75f);
		vertex(size*1.4f, -size*1.8f);
		vertex(size*0.4f, -size*1.8f);
		vertex(0, 0);
		vertex(-size, -size*2);
		vertex(size, -size*2);
		if (!highlight)
			fill(255, 220, 120, nonHighlightAlpha);
		else
			fill(255, 220, 120, 255);
		vertex(0, -size*0.7f);
		vertex(-size*0.4f, -size*1.5f);
		vertex(size*0.4f, -size*1.5f);
		endShape();

		beginShape(LINES);
		strokeWeight(size * 0.1f);
		
		if (!highlight) 
			stroke(nonHighlightAlpha);
		else
			stroke(255);
		vertex(-size*0.02f, -size*0.06f);
		vertex(-size*0.65f, -size*1.35f);
		vertex(-size*0.95f, -size*0.8f);
		vertex(-size*1.4f, -size*1.75f);
		vertex(size*0.85f, -size*0.8f);
		vertex(size*0.65f, -size*1.25f);
		vertex(0, -size*0.75f);
		vertex(-size*0.4f, -size*1.45f);
		endShape();	
		popMatrix();
	}	
}
class PlayerManager {
	Player[][] players;
	int rows, cols;
	int currentX, currentY;	

	PlayerManager(int _cols, int _rows) {
		rows = _rows;
		cols = _cols;
		currentX = cols /  2;
		currentY = rows - 1;
		players = new Player[rows][cols];
		for (int y = 0; y < rows; y++) {
			for (int x = 0; x < cols; x++) {
				players[y][x] = new Player((width / 2) - (cols / 2) * 35 + x * 35, 
										   (height / 2) - rows * 25 + y * 35);
				players[y][x].vel.x = -1;
				players[y][x].vel.y = 0;
			}
		}

		players[4][4].alive = false;
		players[0][0].alive = false;
		players[3][10].alive = false;
	}

	public Player[][] getPlayers() {
		return players;
	}

	public void setCurrentPlayer(int x, int y) {
		int tmpX = currentX;
		int tmpY = currentY;
		do {
			currentX += x;
			currentY += y;
			if (currentX < 0 || currentX > cols - 1 || 
				currentY < 0 || currentY > rows - 1) {
				currentX -= x;
				currentY -= y;
				break;
			}
		} while (!players[currentY][currentX].alive);
		if (!players[currentY][currentX].alive) {
			currentX = tmpX;
			currentY = tmpY;
		}
	}

	public void draw() {
		boolean highlight = false;
		for (int y = 0; y < rows; y++) {
			for (int x = 0; x < cols; x++) {
				if (x == currentX && y == currentY)
					highlight = true;
				else 
					highlight = false;
				if (players[y][x].alive)
					players[y][x].draw(highlight);
			}
		}
	}

	public void update(float delta_t) {
		// Move all the players
		for (int y = 0; y < rows; y++) {
			for (int x = 0; x < cols; x++) {
				players[y][x].transform(delta_t);
			}
		}		

		// Collide against walls:
		for (int y = 0; y < rows; y++) {
			for (int x = 0; x < cols; x++) {
				if (players[y][x].collideWall()) {
					changeDirection(delta_t);
					return;
				}
			}
		}				
	}

	public void changeDirection(float delta_t) {
		for (int y = 0; y < rows; y++) {
			for (int x = 0; x < cols; x++) {
				players[y][x].pos.x -= players[y][x].vel.x * delta_t;
				players[y][x].pos.y += 20;
				players[y][x].vel.x = -players[y][x].vel.x;
			}
		}				
	}


	public Player getCurrent() {
		return players[currentY][currentX];
	}

	public boolean clearShot() {
		for (int yTmp = currentY + 1; yTmp < rows; yTmp++) {
			if (players[yTmp][currentX].alive)
				return false;
		}
		return true;
	}
}
class ShotsManager {
	ArrayList<Shot> shots;
	
	ShotsManager() {
		shots = new ArrayList<Shot>(100);
	}

	public ArrayList<Shot> getShots() {
		return shots;
	}

	public void spawn(float x, float y, PVector vel) {
		shots.add(new Shot(x, y, vel));
	}

	public void update(float delta_t) {
		for (Shot s : shots) {
			s.transform(delta_t);
		}
	}

	public void draw() {
		for (Shot s : shots) {
			s.draw();
		}
	}
}

class Shot extends GameObject {
	Shot(float x, float y, PVector _vel) {
		super (x, y);
		vel = _vel.copy();
	}

	public void draw() {
		stroke(0, 200, 255);
		fill(0, 200, 255);
		rect (pos.x, pos.y, 2, 10);
	}
}



class StarSystem {
  ArrayList<Star> stars;
  PVector origin;

  StarSystem(PVector position) {
    stars = new ArrayList<Star>();
    origin = position.copy();
  }

  public void drawBackground() {
    background(0);
    addStars();
    run();
  }

  public void addStars() {
    stars.add(new Star(origin));
  }

  public void run() {
    for (int i = stars.size()-1; i >= 0; i--) {
      Star s = stars.get(i);
      s.run();
      if (s.isDead()) {
        stars.remove(i);
      }
    }
  }
}

class Star {
  PVector position;
  PVector velocity;
  float size;
  float lifespan;

  Star(PVector pos) {
    velocity = new PVector(random(-1, 1), random(-1, 1));
    position = pos.copy();
    size = random(0.4f, 0.8f);
    lifespan = 255.0f;
  }
  public void run() {
    update();
    display();
  }
  public void update() {
    position.add(velocity);
    lifespan -= 0.3f;
  }
  public void display() {
    stroke(255, 255-lifespan);
    fill(255, 255-lifespan);
    ellipse(position.x, position.y, size, size);
  }
  public boolean isDead() {
    if (lifespan < 0.0f) {
      return true;
    } else {
      return false;
    }
  }
}
class Time {
  long initTime;
  long lastTime;
  
  Time() {
    initTime = millis();
    lastTime = millis();
  }

  public long getAbsolute() {
    return millis() - initTime;
  }

  public float getDelta() {
    float delta_t = (millis() - lastTime);
    lastTime = millis();
    return delta_t;
  }

  public void pause(long p) {
    long t = millis();
    while ((millis() - t) < p);
  }
}
  public void settings() { 	size(480, 640); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "fundamentals08_projectshooter" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
