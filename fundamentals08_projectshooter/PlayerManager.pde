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
				players[y][x].vel.x = -1;
				players[y][x].vel.y = 0;
			}
		}
	}

	Player[][] getPlayers() {
		return players;
	}

	void setCurrentPlayer(int x, int y) {
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
			currentX = tmpX;
			currentY = tmpY;
		}
	}

	void draw() {
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


	Player getCurrent() {
		return players[currentY][currentX];
	}

	boolean clearShot() {
		for (int yTmp = currentY + 1; yTmp < rows; yTmp++) {
			if (players[yTmp][currentX].alive)
				return false;
		}
		return true;
	}
}