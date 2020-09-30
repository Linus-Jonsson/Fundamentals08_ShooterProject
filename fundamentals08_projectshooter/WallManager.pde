class WallManager {
  Wall[] walls;
  int nWalls;

  WallManager(int _nWalls) {
    nWalls = _nWalls;
    walls = new Wall[nWalls];
    for (int i=0; i<nWalls; i++) {
      walls[i] = new Wall(new PVector(width/9+(width/9*2*i), height*0.78));
    }
  }

  Wall[] getWalls() {
    return walls;
  }

  void draw() {
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
          wall[i*4+j] = new WallPiece(pos.x+wallPieceRadius*2.5*i, pos.y+wallPieceRadius*j-wallPieceRadius, new BoundingCircle(0, 0, wallPieceRadius));
        } else if (i*4+j == 15) {
          wall[i*4+j] = new WallPiece(pos.x+wallPieceRadius*5/3*i, pos.y+wallPieceRadius*j, new BoundingCircle(0, 0, wallPieceRadius));
        } else {
          wall[i*4+j] = new WallPiece(pos.x+wallPieceRadius*i, pos.y+wallPieceRadius*j, new BoundingCircle(0, 0, wallPieceRadius));
        }
      }
    }
  }
