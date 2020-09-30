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
  float speed = 0.45;
  float size = 6;

  Particle (PVector _pos) {
    pos.set(_pos);
    vel = new PVector (random (-1,1), random (-1,1));
  }

  void update (float delta_t, color c) {
    vel.mult(speed*delta_t);
    pos.add(vel);
    size = size * 0.9;
    fill (c);
    stroke (c);
    ellipse (pos.x, pos.y, size, size);
  }
}
