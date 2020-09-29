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

	void setCurrentPlayer(int x, int y) {
		currentX += x;
		currentY += y;
	}

	void draw() {
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

	void update(float delta_t) {
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

	void changeDirection(float delta_t) {
		for (int y = 0; y < rows; y++) {
			for (int x = 0; x < cols; x++) {
				players[y][x].pos.x -= players[y][x].vel.x * delta_t;
				players[y][x].pos.y += 20;
				players[y][x].vel.x = -players[y][x].vel.x;
			}
		}				
	}
}