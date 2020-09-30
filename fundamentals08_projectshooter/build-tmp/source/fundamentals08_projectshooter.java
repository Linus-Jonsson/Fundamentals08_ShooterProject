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

// To fix:
// 
// BUG: 
// 1) can't select a different player when diagonal space between current
// and next
//
// 2) Shots go through the crabs and create TONS of particle systems
// that slow down the system, and create huge delta_t which mess up the
// looks of the explosions.
//
// döpa om radius to diameter 
//
// flytta murarna något till höger
//
// pos.x på väggarna ligger uppe till vänster med ett indrag på radius


Game invadersOfSpace;
StarSystem stars;
int state;
boolean firstTime;


public void setup() {
	// surface.setLocation(10, 10);
	((java.awt.Canvas) surface.getNative()).requestFocus();
	
	frameRate(30);
	state = 0; // Init.
	firstTime = true;
	stars = new StarSystem(new PVector(width/2, height/2));	
}

public void draw() {
	stars.drawBackground();
	switch (state) {
		case 0: 
			invadersOfSpace = new Game(); 
			if (firstTime) {
				state = 1;
				firstTime = false;
			} else 
				state = 2;
			break;
		case 1: 
			invadersOfSpace.splashScreen(); 
			break;
		case 2: 
			invadersOfSpace.run();
			if (invadersOfSpace.isGameOver())
			state = 3; 
			break;
		case 3: 
			invadersOfSpace.run();
			invadersOfSpace.gameOver(); 
			break;
	}
}

public void keyPressed() {
	if (keyCode == RIGHT) invadersOfSpace.move(1, 0);
  	if (keyCode == LEFT) invadersOfSpace.move(-1, 0);
  	if (keyCode == DOWN) invadersOfSpace.move(0, 1);
  	if (keyCode == UP) invadersOfSpace.move(0, -1);
  	if (key == 32) { // Spacebar
  		switch (state) {
  			case 1: state = 2; break;
  			case 2: invadersOfSpace.shoot(); break;
  			case 3: state = 0; break;
		}
  	}
}

class BoundingCircle {
	PVector offset;
	float radius;
	BoundingCircle(float x, float y, float r) {
		offset = new PVector(x, y);
		radius = r;
	}
}
// ska nog ej ha...
// Denna ska vi nog inte ha... vi har GameObject-klassen istället.
class CollisionManager {
	Player[][] players;
	Enemy[] enemies;
	ArrayList<Shot> shots;
	Wall[] walls;
	ExplosionsManager explosionsManager;

	CollisionManager(Player[][] _players, 
					 Enemy[] _enemies, 
					 ArrayList<Shot> _shots,
					 Wall[] _walls, 
					 ExplosionsManager _explosionsManager) {
		players = _players;
		enemies = _enemies;
		shots = _shots;
		walls = _walls;
		explosionsManager = _explosionsManager;
	}

	public boolean update(float delta_t) {
		// Check all shots against players, enemies and walls
		for (int n = 0; n < shots.size(); n++) {
			Shot s = shots.get(n);

			// players:
			for (int py = 0; py < players.length; py++) {
				for (int px = 0; px < players[0].length; px++) {
					if (s.collides(players[py][px]) && players[py][px].alive) {
						players[py][px].alive = false;
						shots.remove(n);
						float explosionX = players[py][px].pos.x + players[py][px].boundingCircle.offset.x;						
						float explosionY = players[py][px].pos.y + players[py][px].boundingCircle.offset.y;
						if (players[py][px].isCurrent) {
							explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 128, 255), 10);
							explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 64, 128), 10);
							return true; // Game Over!
						} else {
							explosionsManager.spawn(new PVector(explosionX, explosionY), color(255, 255, 255), 10);
							return false;
						}
					} 
				}
			}
		
			// enemies:
			for (int ex = 0; ex < enemies.length; ex++) {
				if (s.collides(enemies[ex])) {
					float explosionX = enemies[ex].pos.x + enemies[ex].boundingCircle.offset.x;						
					float explosionY = enemies[ex].pos.y + enemies[ex].boundingCircle.offset.y;
					explosionsManager.spawn(new PVector(explosionX, explosionY), color(255, 255, 255), 10);					
					shots.remove(n);					
					return false;
				}
			}

			// walls:
			for (int w = 0; w < walls.length; w++) {
				for (int wp = 0; wp < walls[w].wall.length; wp++) {
					WallPiece wallPiece = walls[w].wall[wp];
					if (wallPiece.alive && s.collides(wallPiece)) {
						wallPiece.alive = false;
						shots.remove(n);						
						return false;
					}
				}
			}
		}
		return false; // No game over!
	}
}
class Enemy extends GameObject {
	
	Enemy(float x, float y, BoundingCircle bc) {
		super(x, y, bc);
	}

	public void draw() {
		//drawBoundingCircle();
		float size = 10;
		
		pushMatrix();
		translate(pos.x, pos.y);
		noStroke();

		beginShape(TRIANGLES);
		push();
		translate(-size*0.1f, size*0.03f);
		fill(255);
		vertex(-size, 0);
		vertex(-size*2.2f, -size*0.3f);
		vertex(-size*1.8f, -size*0.5f);
		vertex(-size*2.2f, -size*0.3f);
		vertex(-size*1.8f, -size*0.3f);
		vertex(-size*1.1f, -size*1.4f);
		vertex(-size, 0);
		vertex(-size*2.1f, size*0.7f);
		vertex(-size*1.8f, size*0.8f);
		vertex(-size*2.1f, size*0.7f);
		vertex(-size*1.8f, size*0.6f);
		vertex(-size*0.6f, size*1.4f);
		pop();
		push();
		translate(-size*0.1f, size*0.05f);
		vertex(size, 0);
		vertex(size*2.2f, -size*0.3f);
		vertex(size*1.8f, -size*0.5f);
		vertex(size*2.2f, -size*0.3f);
		vertex(size*1.8f, -size*0.3f);
		vertex(size*1.1f, -size*1.4f);
		vertex(size, 0);
		vertex(size*2.1f, size*0.7f);
		vertex(size*1.8f, size*0.8f);
		vertex(size*2.1f, size*0.7f);
		vertex(size*1.8f, size*0.6f);
		vertex(size*0.6f, size*1.4f);
		pop();
		endShape();

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
		vertex(-size, 0);
		vertex(-size*2.1f, size*0.7f);
		vertex(-size*1.8f, size*0.8f);
		vertex(-size*2.1f, size*0.7f);
		vertex(-size*1.8f, size*0.6f);
		vertex(-size*0.6f, size*1.4f);
		vertex(size, 0);
		vertex(size*2.1f, size*0.7f);
		vertex(size*1.8f, size*0.8f);
		vertex(size*2.1f, size*0.7f);
		vertex(size*1.8f, size*0.6f);
		vertex(size*0.6f, size*1.4f);
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
	ShotsManager shotsManager;

	EnemyManager(int _nEnemies, ShotsManager _shotsManager) {
		nEnemies = _nEnemies;
		enemies = new Enemy[nEnemies];
		for (int n = 0; n < nEnemies; n++)
			enemies[n] = new Enemy(width / 2, height * 0.9f, new BoundingCircle(0, 0, 35));
		shotsManager = _shotsManager;
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

			if (e.pos.x < 20 || e.pos.x > width - 20) 
				e.pos.x -= e.vel.x * delta_t;
			if ((int)random(100) == 0) 
				e.vel.x = -1;
			if ((int)random(100) == 0) 
				e.vel.x = 1;
			if ((int)random(100) == 0) 
				shotsManager.spawn(e.pos.x, e.pos.y - 15, new BoundingCircle(0, 0, 2), new PVector(0, -3));
		}
	}
}
class ExplosionsManager {
  ArrayList<Explosion> explosions;

  ExplosionsManager() {
    explosions = new ArrayList<Explosion>(10);
  }

  public ArrayList<Explosion> getExplosions() {
    return explosions;
  }

  public void update(float delta_t) {
    for (int e = 0; e < explosions.size(); e++) {
      explosions.get(e).update(delta_t);
      if (explosions.get(e).isDone())
        explosions.remove(e);
    }
  }

  public void spawn(PVector pos, int c, int clock) {
    explosions.add(new Explosion(pos, c, clock));
  }
}


class Explosion {
  Particle[] explosion = new Particle[100];
  PVector pos;
  int lifeClock;
  int c;

  Explosion (PVector _pos, int _c, int clock) {
    pos = new PVector(_pos.x, _pos.y);
    c = _c;
    for (int i=0; i<explosion.length; i++) {
      explosion[i] = new Particle(pos);
    }
    lifeClock = clock;
  }

  public void update(float delta_t) {
    for (int i=0; i<explosion.length; i++) {
      if (explosion[i].size <= 0) {
        continue;
      } else {
        explosion[i].update(delta_t, c);
      }
    }
  }

  public boolean isDone() {
    if (lifeClock-- == 0)
      return true;
    return false;
  }
}



class Particle {
  PVector pos = new PVector();
  PVector vel;
  float speed = 0.45f;
  float size = 6;

  Particle (PVector _pos) {
    pos.set(_pos);
    vel = new PVector (random (-1,1), random (-1,1));
  }

  public void update (float delta_t, int c) {
    vel.mult(speed*delta_t);
    pos.add(vel);
    size = size * 0.9f;
    fill (c);
    stroke (c);
    ellipse (pos.x, pos.y, size, size);
  }
}
class Game { 
	final int nPlayersX = 11;
	final int nPlayersY = 5;
	final int nEnemies = 1;
	final int nWalls = 4;

	PlayerManager playerManager;
	EnemyManager enemyManager;
	ShotsManager shotsManager;
	CollisionManager collisionManager;
	ExplosionsManager explosionsManager;
	WallManager wallManager;

	Time time;
	int score; // a function of the number of surviving players and elapsed time.
	int highSchore; //
	int state;
	PFont titleFont = createFont("Alien-Encounters-Italic.ttf", 80);
	PFont font = createFont("Futuristic Armour.otf", 22);
	boolean gameOver;
	
	Game() {
		time = new Time();
		shotsManager = new ShotsManager();
		playerManager = new PlayerManager(nPlayersX, nPlayersY); //
		enemyManager = new EnemyManager(1, shotsManager);
		explosionsManager = new ExplosionsManager();
		wallManager = new WallManager(nWalls);
		collisionManager = new CollisionManager(playerManager.getPlayers(),
												enemyManager.getEnemies(),
												shotsManager.getShots(),
												wallManager.getWalls(),
												explosionsManager);

		gameOver = false;
	}
	
	public boolean isGameOver() {return gameOver;}

	public void splashScreen() {
		startScreen(titleFont, font);
	}

	public void run() {
		float delta_t = time.getDelta() * 0.05f;

		playerManager.update(delta_t);
		enemyManager.update(delta_t);
		shotsManager.update(delta_t);
		explosionsManager.update(delta_t);
		
		if (collisionManager.update(delta_t)) { // Collision testing...
			gameOver = true;
		}

		playerManager.draw();
		enemyManager.draw();
		shotsManager.draw();
		wallManager.draw();

		// Explosion Testing:
		// explosion.update(delta_t);
	}

	public void gameOver() {
		textAlign(width / 2, height / 2);
		stroke(0);
		fill(0);
		text("Game Over!", width, height);
		//Add code: If "playerDead == true"
		gameOverScreen(titleFont, font);
		//else
		//winScreen(titleFont, font);
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
			shotsManager.spawn(x - 5, y, new BoundingCircle(0, 10, 2), new PVector(0, 3));
			shotsManager.spawn(x + 5, y, new BoundingCircle(0, 10, 2), new PVector(0, 3));
		}
	}
}
class GameObject {
	PVector pos, vel;
	BoundingCircle boundingCircle;


	GameObject (float x, float y, BoundingCircle bc) {
		pos = new PVector(x, y);
		vel = new PVector(0, 0);
		boundingCircle = bc;
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

	public boolean collides(GameObject g) {
		float dx = (pos.x + boundingCircle.offset.x) - (g.pos.x + g.boundingCircle.offset.x);
		float dy = (pos.y + boundingCircle.offset.y) - (g.pos.y + g.boundingCircle.offset.y);
		/*stroke(255, 0, 0);
		line (pos.x + boundingCircle.offset.x,
			  pos.y + boundingCircle.offset.y,
			  g.pos.x + g.boundingCircle.offset.x,
			  g.pos.y + g.boundingCircle.offset.y);*/
		if (sqrt(dx * dx + dy * dy) <= (boundingCircle.radius / 2 + g.boundingCircle.radius / 2))
			return true;
		return false;
	}

	public void drawBoundingCircle() {
		stroke(255, 0, 0);
		fill(0, 0, 0);
		circle(pos.x + boundingCircle.offset.x, pos.y + boundingCircle.offset.y, boundingCircle.radius);
	}
}
// tas bort?
class Player extends GameObject {
	boolean alive;
	boolean isCurrent;
	
	Player(float x, float y, BoundingCircle bc) {
		super(x, y, bc);
		alive = true;
		isCurrent = false;
	}

	public void draw(boolean highlight) {
		//drawBoundingCircle();
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
										   (height / 2) - rows * 25 + y * 35, new BoundingCircle(0, -12, 25));
				players[y][x].vel.x = -0.1f;
				players[y][x].vel.y = 0;
			}
		}
		players[4][6].alive = false;
		players[3][7].alive = false;
		players[2][9].alive = false;
		players[1][10].alive = false;

		players[currentY][currentX].isCurrent = true;
	}

	public Player[][] getPlayers() {
		return players;
	}

	public void setCurrentPlayer(int x, int y) {
		players[currentY][currentX].isCurrent = false;
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
			// find closest one along the vector
			currentX = tmpX;
			currentY = tmpY;
			int shortestX = currentX;
			int shortestY = currentY;
			float shortestLength = 100000;
			do {
				currentX += x;
				currentY += y;
				for (int yc = 0; yc < rows; yc++) {
					for (int xc = 0; xc < cols; xc++) {
						float dist = 10000000;
						float dx, dy;
						dx = xc - currentX;
						dy = yc - currentY;
						if (players[yc][xc].alive) {
							if (sqrt(dx * dx + dy * dy) < shortestLength) {
								shortestLength = sqrt(dx * dx + dy * dy);
								shortestX = xc;
								shortestY = yc;
							}
						}
					}
				}
				if (currentX < 0 || currentX > cols - 1 || 
					currentY < 0 || currentY > rows - 1) {
					currentX -= x;
					currentY -= y;
					break;
				}
			} while (!players[currentY][currentX].alive);
			currentX = shortestX;
			currentY = shortestY;
		}

		// Didn't find a new player to highlight?
		// Then we revert back to the initial one.
		if (!players[currentY][currentX].alive) {
			currentX = tmpX;
			currentY = tmpY;
		}

		players[currentY][currentX].isCurrent = true;
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

	public void spawn(float x, float y, BoundingCircle bc, PVector vel) {
		shots.add(new Shot(x, y, bc, vel));
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
	Shot(float x, float y, BoundingCircle bc, PVector _vel) {
		super (x, y, bc);
		vel = _vel.copy();
	}

	public void draw() {
		stroke(0, 200, 255);
		fill(0, 200, 255);
		rect (pos.x, pos.y, 2, 10);
	}
}



public void startScreen(PFont titleFont, PFont font) {	
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

	public void gameOverScreen(PFont titleFont, PFont font) {	
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

	public void winScreen(PFont titleFont, PFont font) {	
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
class StarSystem {
  ArrayList<Star> stars;
  PVector origin;
  boolean startOffRun;

  StarSystem(PVector position) {
    stars = new ArrayList<Star>(1000);
    origin = position.copy();
    startOffRun = true;
  }

  public void drawBackground() {
    background(0);
    if (startOffRun) {
    	startOffRun = false;
    	for (int n = 0; n < 1000; n++) {
    		addStars();
    		run(false);
    	}
    }
    else {
    	addStars();
    	run(true);
    }
  }

  public void addStars() {
    stars.add(new Star(origin));
  }

  public void run(boolean draw) {
    for (int i = stars.size()-1; i >= 0; i--) {
      Star s = stars.get(i);
      s.run(draw);
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
  public void run(boolean draw) {
    update();
    if (draw)
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
class WallManager {
  Wall[] walls;
  int nWalls;

  WallManager(int _nWalls) {
    nWalls = _nWalls;
    walls = new Wall[nWalls];
    for (int i=0; i<nWalls; i++) {
      walls[i] = new Wall(new PVector(width/9+(width/9*2*i), height*0.78f));
    }
  }

  public Wall[] getWalls() {
    return walls;
  }

  public void draw() {
      for (int i=0; i<nWalls; i++) {
          for (int j=0; j<walls[i].wall.length; j++) {
        if (walls[i].wall[j] == null) {
          println("i:"+i);
          continue;
        } else {
          walls[i].wall[j].draw();
        }      
      }
    }
  }
}


class Wall {
  WallPiece[] wall;
  int nPieces = 20;
  PVector pos;
  float wallPieceRadius = 10;

  Wall (PVector _pos) {
    wall = new WallPiece[nPieces];
    pos = new PVector(_pos.x, _pos.y);
    for (int i=0; i<nPieces/4; i++) {
      for (int j=0; j<nPieces/5; j++)
        if (i*4+j == 0) {
          wall[i*4+j] = new WallPiece(pos.x+wallPieceRadius*5, pos.y+wallPieceRadius, new BoundingCircle(0, 0, wallPieceRadius));
        } else if (i*4+j == 11) {
          wall[i*4+j] = new WallPiece(pos.x+wallPieceRadius*2.5f*i, pos.y+wallPieceRadius*j-wallPieceRadius, new BoundingCircle(0, 0, wallPieceRadius));
        } else if (i*4+j == 15) {
          wall[i*4+j] = new WallPiece(pos.x+wallPieceRadius*5/3*i, pos.y+wallPieceRadius*j, new BoundingCircle(0, 0, wallPieceRadius));
        } else {
          wall[i*4+j] = new WallPiece(pos.x+wallPieceRadius*i, pos.y+wallPieceRadius*j, new BoundingCircle(0, 0, wallPieceRadius));
        }
      }
    }
  }
class WallPiece extends GameObject {
	boolean alive;

	WallPiece(float x, float y, BoundingCircle bc) {
		super(x, y, bc);

		alive = true;
	}

	public void draw() {
		if (alive) {
			noStroke();
			fill(255);
			ellipse(pos.x, pos.y, boundingCircle.radius, boundingCircle.radius);
		}

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
