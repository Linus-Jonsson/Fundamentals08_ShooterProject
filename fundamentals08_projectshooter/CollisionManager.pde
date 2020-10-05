class CollisionManager {
	Player[][] players;
	Enemy[] enemies;
	ArrayList<Shot> shots;
	Wall[] walls;
	ExplosionsManager explosionsManager;
	boolean shipDestroyed = false;

	CollisionManager(Player[][] _players, 
					 Enemy[] _enemies, 
					 ArrayList<Shot> _shots,
					 Wall[] _walls, 
					 ExplosionsManager _explosionsManager) {
		players = _players;
		enemies = _enemies;
		shots = _shots;
		walls = _walls;
		explosionsManager = _explosionsManager;
	}

	boolean update(float delta_t) {
		// Players against walls:
		for (int py = 0; py < players.length; py++) {
			for (int px = 0; px < players[0].length; px++) {
				for (int w = 0; w < walls.length; w++) {					
					for (int wp = 0; wp < walls[w].wall.length; wp++) {
						WallPiece wallPiece = walls[w].wall[wp];
						if (players[py][px].collides(wallPiece) && wallPiece.alive && players[py][px].alive) {
							players[py][px].alive = false;
							float explosionX = players[py][px].pos.x + players[py][px].boundingCircle.offset.x;						
							float explosionY = players[py][px].pos.y + players[py][px].boundingCircle.offset.y;
							if (players[py][px].isCurrent) {
								explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
								explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
								soundEffect(4);
								return true; // Game Over!
							} else {
								explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
								shipDestroyed = true;
								soundEffect(4);
								return false;
							}
						}
					}			
				}
			}
		}

		// Check all shots against players, enemies and walls
		for (int n = 0; n < shots.size(); n++) {
			Shot s = shots.get(n);
			// players:
			for (int py = 0; py < players.length; py++) {
				for (int px = 0; px < players[0].length; px++) {
					if (s.collides(players[py][px]) && players[py][px].alive && s.boundingCircle.offset.y == 0) {
						players[py][px].alive = false;
						shots.remove(n);
						float explosionX = players[py][px].pos.x + players[py][px].boundingCircle.offset.x;						
						float explosionY = players[py][px].pos.y + players[py][px].boundingCircle.offset.y;
						if (players[py][px].isCurrent) {
							explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
							explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
							soundEffect(5);
							return true; // Game Over!
						} else {
							explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
							shipDestroyed = true;
							soundEffect(4);
							return false;
						}
					} 
				}
			}
		
			// enemies:
			for (int ex = 0; ex < enemies.length; ex++) {
				if (s.collides(enemies[ex]) && s.boundingCircle.offset.y == 10 && enemies[ex].deathRotation == 0) {
					float explosionX = enemies[ex].pos.x + enemies[ex].boundingCircle.offset.x;						
					float explosionY = enemies[ex].pos.y + enemies[ex].boundingCircle.offset.y;
					explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);					
					enemies[ex].lostLife = true;
					if (enemies[ex].lives == 1) {
						soundEffect(2);
					} else {
						soundEffect(1);
					}
					shots.remove(n);					
					return false;
				}
			}

			// walls:
			for (int w = 0; w < walls.length; w++) {
				float x1 = walls[w].pos.x - walls[w].wallPieceDiameter / 2;
				float x2 = walls[w].pos.x + 5.5 * walls[w].wallPieceDiameter;
				float y = walls[w].pos.y - walls[w].wallPieceDiameter / 2; 
				
				if (!(s.pos.x >= (x1 - 1) && s.pos.x <= x2 && s.pos.y + s.boundingCircle.offset.y >= y)) {
					continue;
				}
				
				for (int wp = 0; wp < walls[w].wall.length; wp++) {
					WallPiece wallPiece = walls[w].wall[wp];
					if (wallPiece.alive && s.collides(wallPiece)) {
						explosionsManager.spawn(new PVector(s.pos.x, s.pos.y), color(0,80, 90), 6);
						explosionsManager.spawn(new PVector(s.pos.x, s.pos.y), color(0,160,180), 6);
						wallPiece.applyDamage();
						soundEffect(7);
						shots.remove(n);						
						return false;
					}
				}
			}

			// Explodes on line
			if (s.pos.y > height - 48) {
				explosionsManager.spawn(new PVector(s.pos.x, s.pos.y), color(0,160,180), 8);
				shots.remove(n);
			}

		}
		return false; // No game over!
	}
}