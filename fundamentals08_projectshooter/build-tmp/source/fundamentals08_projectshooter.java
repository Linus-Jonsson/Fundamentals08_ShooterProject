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

// test :D

public void setup() {
	surface.setLocation(10, 10);
	
	frameRate(30);
	stars = new StarSystem(new PVector(width/2, height/2));
	// invadersOfSpace = new Game();
}

public void draw() {
	starfieldBackground();
	// Epic starfield goes here...
	// switch (invadersOfSpace.getState()) {
	// 	case 0: invadersOfSpace.init(); break;
	// 	case 1: invadersOfSpace.homeScreen(); break;
	// 	case 2: invadersOfSpace.run(); break;
	// 	case 3: invadersOfSpace.gameOver(); break;
	// }
}
// class BoundingBox {
// 	int x, y, w, h;

// 	void draw() {
// 		strokeWidth(1);
// 		stroke(255, 0, 0);
// 		rect(x, y, w, h);
// 	}
// }
class Bullet extends GameObject {
	
}
// Denna ska vi nog inte ha... vi har GameObject-klassen istället.
class Enemy {
	
}
// Invaders of space? =)

class Game { 
	int state; // 0 = Init. 1 = Welcome screen. 2 = Running. 3 = Game Over

	public int getState() {return state;}

	public void init() {
	}

	public void welcomeScreen() {
	}

	public void run() {
	}

	public void gameOver() {
	}
}
class GameObject {
	PVector pos, vel;
	BoundingBox boundingBox;  // Radius of bounding circle. Used for collision detection.

	GameObject () {
		pos = new PVector();
		vel = new PVector();
		size = -1;
		println("creation of new Game Object");
	}

	public boolean collide(GameObject other) {
		if (overlap(this, other))
			return true;
		return false;
	}

	public void draw() {
	}
}
class Player extends GameObject {

	Player() {
		super();
	}
}
class PlayerManager {
	
}
public void starfieldBackground() {
  background(0);
  stars.addStars();
  stars.run();
}

class StarSystem {
  ArrayList<Star> stars;
  PVector origin;

  StarSystem(PVector position) {
    stars = new ArrayList<Star>();
    origin = position.copy();
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

  Star(PVector l) {
    velocity = new PVector(random(-1, 1), random(-1, 1));
    position = l.copy();
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
  public void settings() { 	size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "fundamentals08_projectshooter" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
