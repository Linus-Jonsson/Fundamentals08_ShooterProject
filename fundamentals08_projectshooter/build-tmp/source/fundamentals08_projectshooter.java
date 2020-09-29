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
	surface.setLocation(10, 10);
	
	frameRate(30);
	stars = new StarSystem(new PVector(width/2, height/2));
	invadersOfSpace = new Game();
}

public void draw() {

	background(255);
	// Epic starfield goes here...

	stars.drawBackground();
	//background(0); //Basic background while building
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
 }

class BoundingBox {
	int x, y, w, h;

	public void draw() {
		strokeWeight(1);
		stroke(255, 0, 0);
		rect(x, y, w, h);
	}
}
class Bullet extends GameObject {
	Bullet(float x, float y) {
		super(x, y);
	}
}
// Denna ska vi nog inte ha... vi har GameObject-klassen istället.
class Enemy extends GameObject {
	
	Enemy(float x, float y) {
		super(x, y);
	}

	public void draw() {
		stroke(255, 0, 0);
		fill(255, 0, 0);
		circle(pos.x, pos.y, 20);
	}

	// ska se skottet när det är nära
	// 

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

	public void draw() {
		for (int n = 0; n < nEnemies; n++) {
				enemies[n].draw();
		}
	}

	public void update(float delta_t) {
		for (Enemy e : enemies) {
			e.transform(delta_t);
		}
	}
}
class Game { 
	final int nPlayersX = 11;
	final int nPlayersY = 5;
	final int nEnemies = 1;
	PlayerManager playerManager;
	EnemyManager enemyManager;
	Time time;
	int state; // 0 = Init. 1 = Welcome screen. 2 = Running. 3 = Game Over
	int score; // a function of the number of surviving players and elapsed time.
	int highSchore; //
	
	Game() {
		time = new Time();
		state = 0;
		playerManager = new PlayerManager(nPlayersX, nPlayersY); //
		enemyManager = new EnemyManager(1);
	}

	public void init() {
		// Init everything, then change state to 1, Welcome Screen.
		// ...
		// (Add code)
		//
		state = 1;
	}

	public void splashScreen() {
		// Add code...
		// Wait for user to start game by pressing a defined key
		// 
		// (Add code) 
		//
		// Then change to state = 2 
		state = 2;
	}

	public void run() {
		float delta_t = time.getDelta() * 0.05f;
		//gameObjects.update(delta_t);

		playerManager.update(delta_t);
		enemyManager.update(delta_t);

		playerManager.draw();
		enemyManager.draw();
	}

	public void gameOver() {
		textAlign(width / 2, height / 2);
		stroke(0);
		fill(0);
		text("Game Over!", width, height);
		// Wait for user to quit or restart
		// 
		// (Add code)
		//
		// Then change to state 0 (init) or quit
	}

	public void move(int x, int y) {
		playerManager.setCurrentPlayer(x, y);
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
		gameObjects.add(this);
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
}
GameObjectsManager gameObjects = new GameObjectsManager();

class GameObjectsManager {
	ArrayList<GameObject> gameObjects; // players, enemy, bullets, etc.

	GameObjectsManager() {
		gameObjects = new ArrayList<GameObject>(200);
	}

	public void add(GameObject go) {
		gameObjects.add(go);
	}
}
class Player extends GameObject {

	Player(float x, float y) {
		super(x, y);
	}

	public void draw(boolean highlight) {
		if (highlight) {
			stroke(255, 255, 0);
			fill(255, 255, 0);			
		} else {
			stroke(0, 255, 0);
			fill(0, 255, 0);
		}
		circle(pos.x, pos.y, 20);
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
				players[y][x] = new Player((width / 2) - (cols / 2) * 25 + x * 25, 
										   (height / 2) - rows * 25 + y * 25);
				players[y][x].vel.x = -1;
				players[y][x].vel.y = 0;
			}
		}
	}

	public void setCurrentPlayer(int x, int y) {
		currentX += x;
		currentY += y;
	}

	public void draw() {
		boolean highlight = false;
		for (int y = 0; y < rows; y++) {
			for (int x = 0; x < cols; x++) {
				if (x == currentX && y == currentY)
					highlight = true;
				else 
					highlight = false;
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
