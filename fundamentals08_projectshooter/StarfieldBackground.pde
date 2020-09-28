class StarSystem {
  ArrayList<Star> stars;
  PVector origin;

  StarSystem(PVector position) {
    stars = new ArrayList<Star>();
    origin = position.copy();
  }

  void drawBackground() {
    background(0);
    stars.addStars();
    stars.run();
  }

  void addStars() {
    stars.add(new Star(origin));
  }

  void run() {
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
    size = random(0.4, 0.8);
    lifespan = 255.0;
  }
  void run() {
    update();
    display();
  }
  void update() {
    position.add(velocity);
    lifespan -= 0.3;
  }
  void display() {
    stroke(255, 255-lifespan);
    fill(255, 255-lifespan);
    ellipse(position.x, position.y, size, size);
  }
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}