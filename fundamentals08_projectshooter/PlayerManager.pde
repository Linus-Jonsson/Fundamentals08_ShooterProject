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
				players[y][x].vel.x = -0.1;
				players[y][x].vel.y = 0;
			}
		}
		players[4][6].alive = false;
		players[3][7].alive = false;
		players[2][9].alive = false;
		players[1][10].alive = false;

		players[currentY][currentX].isCurrent = true;
	}

	Player[][] getPlayers() {
		return players;
	}

	void setCurrentPlayer(int x, int y) {
		if (x == 0 && y == 0)
			return;
		else if (currentX + x < 0 || currentX + x > cols - 1 || 
		 	     currentY + y < 0 || currentY + y > rows - 1) {
			return;
		}
		else {				
			players[currentY][currentX].isCurrent = false;
		}

		// find closest one along the vector +/- specified degree (up to 180)
		// cast two rays: 
		float initAngle = atan2(y, x);
		float rayLength = sqrt(players.length * players.length + players[0].length * players[0].length) + 3;
		int xRay, yRay;
		for (float angle = 0; angle <= 3.1415; angle += 3.1415 / 180) {
			for (float dir = -1; dir < 3; dir += 2)	{
				for (int l = 0; l < (int)rayLength; l++) {
					xRay = (int)(cos(initAngle + angle * dir) * l);
					yRay = (int)(sin(initAngle + angle * dir) * l);
					if (currentX+xRay < 0 || currentX+xRay > cols - 1 || 
						currentY+yRay < 0 || currentY+yRay > rows - 1) {
						break;
					}
					if (!(xRay == 0 && yRay == 0) && players[currentY + yRay][currentX + xRay].alive) {
						currentX += xRay;
						currentY += yRay;
						players[currentY][currentX].isCurrent = true;
						return;
					}
				}
			}
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