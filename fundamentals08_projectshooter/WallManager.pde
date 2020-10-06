//
// Huvudansvarig: Linus Jonsson
//
class WallManager {
	Wall[] walls;
	int nWalls;

	WallManager(int _nWalls) {
		nWalls = _nWalls;
		walls = new Wall[nWalls];
		for (int i=0; i<nWalls; i++)
			walls[i] = new Wall(new PVector(width / 8.5 + (width / 9 * 2 * i), height * 0.78));
	}

	Wall[] getWalls() {
		return walls;
	}

	void draw() {
		for (int i = 0; i < nWalls; i++) {
			for (int j = 0; j < walls[i].wall.length; j++) {
				if (walls[i].wall[j].alive == false) {
					continue;
				}
				if (j == 4 || j == 8 || j == 12 || j == 16) {
					walls[i].wall[j].drawTopRow();          
				} else if (j == 1) {
					walls[i].wall[j].drawLeftCorner();
				} else if (j == 0) {
					walls[i].wall[j].drawRightCorner();
				} else {
					walls[i].wall[j].draw();
				}
			}
		}
	}
}

class Wall {
	WallPiece[] wall;
	PVector pos;
	int nPieces = 20;
	float wallPieceDiameter = 10;

	Wall (PVector _pos) {
		wall = new WallPiece[nPieces];
		pos = new PVector(_pos.x, _pos.y);
		for (int i = 0; i < nPieces / 4; i++) {
			for (int j = 0; j < nPieces / 5; j++)
				if (i * 4 + j == 0) {
					wall[i * 4 + j] = new WallPiece(pos.x + wallPieceDiameter * 5, pos.y + wallPieceDiameter,
													new BoundingCircle(0, 0, wallPieceDiameter), wallPieceDiameter);
				} else if (i * 4 + j == 11) {
					wall[i * 4 + j] = new WallPiece(pos.x + wallPieceDiameter * 2.5 * i,
													pos.y + wallPieceDiameter * j - wallPieceDiameter,
													new BoundingCircle(0, 0, wallPieceDiameter), wallPieceDiameter);
				} else if (i * 4 + j == 15) {
					wall[i * 4 + j] = new WallPiece(pos.x + wallPieceDiameter * 5 / 3 * i, pos.y + wallPieceDiameter * j,
													new BoundingCircle(0, 0, wallPieceDiameter), wallPieceDiameter);
				} else {
					wall[i * 4 + j] = new WallPiece(pos.x + wallPieceDiameter * i, pos.y + wallPieceDiameter * j,
													new BoundingCircle(0, 0, wallPieceDiameter), wallPieceDiameter);
				}
			}
		}
	}
