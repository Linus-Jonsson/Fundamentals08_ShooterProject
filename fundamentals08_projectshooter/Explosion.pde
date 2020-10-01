class ExplosionsManager {
  ArrayList<Explosion> explosions;

  ExplosionsManager() {
    explosions = new ArrayList<Explosion>(10);
  }

  ArrayList<Explosion> getExplosions() {
    return explosions;
  }

  void update(float delta_t) {
    for (int e = 0; e < explosions.size(); e++) {
      explosions.get(e).update(delta_t);
      if (explosions.get(e).isDone())
        explosions.remove(e);
    }
  }

  void spawn(PVector pos, color c, int clock) {
    explosions.add(new Explosion(pos, c, clock));
  }
}


class Explosion {
  Particle[] explosion = new Particle[100];
  PVector pos;
  int lifeClock;
  color c;

  Explosion (PVector _pos, color _c, int clock) {
    pos = new PVector(_pos.x, _pos.y);
    c = _c;
    for (int i=0; i<explosion.length; i++) {
      explosion[i] = new Particle(pos);
    }
    lifeClock = clock;
  }

  void update(float delta_t) {
    for (int i=0; i<explosion.length; i++) {
      if (explosion[i].size <= 0) {
        continue;
      } else {
        explosion[i].update(delta_t, c);
      }
    }
  }

  boolean isDone() {
    if (lifeClock-- == 0)
      return true;
    return false;
  }
}

class Particle {
  PVector pos = new PVector();
  PVector vel;
  color col;
  float speed = 0.7;
  float size = 4;

  Particle (PVector _pos) {
    pos.set(_pos);
    vel = new PVector (random (-1,1), random (-1,1));
    col = color(random(125, 256), random(125, 256), 255); //Not in use now
  }

  void update (float delta_t, color c) {
    vel.mult(speed*delta_t);
    pos.add(vel);
    size = size * 0.8;
    fill (c);
    ellipse (pos.x, pos.y, size, size);
  }
}
