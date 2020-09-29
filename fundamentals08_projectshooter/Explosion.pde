class Explosion {
  Particle[] explosion = new Particle[100];
  PVector pos;

  Explosion (PVector _pos) {
    pos = new PVector(_pos.x, _pos.y);
  }
  
  void create() {
    for (int i=0; i<explosion.length; i++) {
      explosion[i] = new Particle(pos);
    }
  }

  void update(float delta_t) {
    for (int i=0; i<explosion.length; i++) {
      if (explosion[i].size <= 0) {
        continue;
      } else {
        explosion[i].update(delta_t);
      }
    }
  }
}

class Particle {
  PVector pos = new PVector();
  PVector vel;
  float speed = 0.61;
  float size = 6;

  Particle (PVector _pos) {
    pos.set(_pos);
    vel = new PVector (random (-1,1), random (-1,1));
  }

  void update (float delta_t) {
    vel.mult(speed*delta_t);
    pos.add(vel);
    size -= 0.19;
    fill (255);
    ellipse (pos.x, pos.y, size, size);
  }
}
