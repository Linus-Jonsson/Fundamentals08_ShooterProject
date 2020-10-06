//
// Huvudansvarig: Andreas Collvin
//
class CollisionManager {
	boolean shipDestroyed = false;
	Player[][] players;
	Enemy[] enemies;
	ArrayList<Shot> shots;
	Wall[] walls;
	ExplosionsManager explosionsManager;

	CollisionManager(Game game) {
		players = game.playerManager.getPlayers();
		enemies = game.enemyManager.getEnemies();
		shots = game.shotsManager.getShots();
		walls = game.wallManager.getWalls();
		explosionsManager = game.explosionsManager;
	}

	// Returns true if current player died.
	boolean update(float delta_t) {
		for (int py = 0; py < players.length; py++) {
			for (int px = 0; px < players[0].length; px++) {
				if (playerVsWall(players[py][px]))
					return true;
				if (playerVsEnemies(players[py][px]))
					return true;
				if (playerVsBaseline(players[py][px]))
					return true;
			}
		}	

		for (int nShot = 0; nShot < shots.size(); nShot++) {
			switch (armadaVsShot(nShot)) {
				case 1: continue; 
				case 2: return true;
			}

			if (enemiesVsShot(nShot))
				continue;
			
			if (wallsVsShots(nShot))
				continue;
		
			if (baselineVsShot(nShot))
				continue;
		}
		return false; 
	}

	boolean playerVsEnemies(Player player) {
		for (int ex = 0; ex < enemies.length; ex++) {
			if (player.collides(enemies[ex]) && player.alive && enemies[ex].lives > 0) {
				player.alive = false;
				float explosionX = player.pos.x + player.boundingCircle.offset.x;						
				float explosionY = player.pos.y + player.boundingCircle.offset.y;
				if (player.isCurrent) {
					explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
					explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
					soundManager.soundEffect(3);
					return true;
				} else {
					explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
					shipDestroyed = true;
					soundManager.soundEffect(3);
				}
			}
		}
		return false;
	}

	boolean playerVsBaseline(Player player) {
		if (player.pos.y > height - 48 && player.alive) {
			player.alive = false;
			float explosionX = player.pos.x + player.boundingCircle.offset.x;						
			float explosionY = player.pos.y + player.boundingCircle.offset.y;
			if (player.isCurrent) {
				explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
				explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
				soundManager.soundEffect(3);
				return true;
			} else {
				explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
				shipDestroyed = true;
				soundManager.soundEffect(3);
			}
		}
		return false;
	}

	boolean playerVsWall(Player player) {
		for (int w = 0; w < walls.length; w++) {
			for (int wp = 0; wp < walls[w].wall.length; wp++) {
				WallPiece wallPiece = walls[w].wall[wp];
				if (player.collides(wallPiece) && wallPiece.alive && player.alive) {
					player.alive = false;
					float explosionX = player.pos.x + player.boundingCircle.offset.x;						
					float explosionY = player.pos.y + player.boundingCircle.offset.y;
					if (player.isCurrent) {
						explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
						explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
						soundManager.soundEffect(3);
						return true; 
					} else {
						explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
						shipDestroyed = true;
						soundManager.soundEffect(3);
						return false;
					}
				}
			}
		}
		return false;
	}

	int armadaVsShot(int nShot) {
		Shot shot = shots.get(nShot);
		for (int py = 0; py < players.length; py++) {
			for (int px = 0; px < players[0].length; px++) {
				boolean shotByEnemy = (shot.boundingCircle.offset.y == 0);
				if (shot.collides(players[py][px]) && players[py][px].alive && shotByEnemy) {
					players[py][px].alive = false;
					shots.remove(nShot);
					float explosionX = players[py][px].pos.x + players[py][px].boundingCircle.offset.x;						
					float explosionY = players[py][px].pos.y + players[py][px].boundingCircle.offset.y;
					if (players[py][px].isCurrent) {
						explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
						explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
						soundManager.soundEffect(4);
						return 2; 
					} else {
						explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);
						shipDestroyed = true;
						soundManager.soundEffect(3);
						return 1;
					}
				} 
			}
		}
		return 0;
	}
		
	boolean enemiesVsShot(int nShot) {
		Shot shot = shots.get(nShot);
		for (int ex = 0; ex < enemies.length; ex++) {
			boolean shotByPlayer = (shot.boundingCircle.offset.y == 10);
			if (shot.collides(enemies[ex]) && enemies[ex].lives > 0 && shotByPlayer && enemies[ex].deathRotation == 0) {
				float explosionX = enemies[ex].pos.x + enemies[ex].boundingCircle.offset.x;						
				float explosionY = enemies[ex].pos.y + enemies[ex].boundingCircle.offset.y;
				explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);					
				enemies[ex].lostLife = true;
				if (enemies[ex].lives == 1) {
					soundManager.soundEffect(1);
				} else {
					soundManager.soundEffect(0);
				}
				shots.remove(nShot);
				return true;
			}
		}
		return false;
	}

	boolean wallsVsShots(int nShot) {
		Shot shot = shots.get(nShot);
		for (int w = 0; w < walls.length; w++) {
			float x1 = walls[w].pos.x - walls[w].wallPieceDiameter / 2;
			float x2 = walls[w].pos.x + 5.5 * walls[w].wallPieceDiameter;
			float y = walls[w].pos.y - walls[w].wallPieceDiameter / 2; 
				
			if (!(shot.pos.x >= (x1 - 1) && shot.pos.x <= x2 && shot.pos.y + shot.boundingCircle.offset.y >= y))
				continue;
				
			for (int wp = 0; wp < walls[w].wall.length; wp++) {
				WallPiece wallPiece = walls[w].wall[wp];
				if (wallPiece.alive && shot.collides(wallPiece)) {
					explosionsManager.spawn(new PVector(shot.pos.x, shot.pos.y), color(0,80, 90), 6);
					explosionsManager.spawn(new PVector(shot.pos.x, shot.pos.y), color(0,160,180), 6);
					wallPiece.applyDamage();
					soundManager.soundEffect(6);
					shots.remove(nShot);
					return true;
				}
			}
		}
		return false;
	}

	boolean baselineVsShot(int nShot) {
		Shot shot = shots.get(nShot);
		if (shot.pos.y > height - 48) {
			soundManager.soundEffect(6);
			explosionsManager.spawn(new PVector(shot.pos.x, shot.pos.y), color(0,160,180), 8);
			shots.remove(nShot);
			return true;
		}
		return false;
	}
}