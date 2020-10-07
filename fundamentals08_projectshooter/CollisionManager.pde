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
				if (playerVsWalls(players[py][px]))
					return true;
				if (playerVsEnemies(players[py][px]))
					return true;
				if (playerVsBaseline(players[py][px]))
					return true;
			}
		}	

		for (int nShot = 0; nShot < shots.size(); nShot++) {
			if (enemiesVsShot(nShot))
				continue;
			
			if (wallsVsShot(nShot))
				continue;
		
			if (baselineVsShot(nShot))
				continue;

			if (armadaVsShot(nShot))
				return true;
		}
		return false; 
	}

	boolean playerVsEnemies(Player player) {
		for (int ex = 0; ex < enemies.length; ex++) {
			if (player.collides(enemies[ex])) {
				shipDestroyed = true;
				if (player.explode(explosionsManager, soundManager))
					return true;		
			}
		}
		return false;
	}

	boolean playerVsBaseline(Player player) {
		if (player.pos.y > height - 48) {
			shipDestroyed = true;
			if (player.explode(explosionsManager, soundManager))
				return true;		
		}
		return false;
	}

	boolean playerVsWalls(Player player) {
		for (int w = 0; w < walls.length; w++) {					
			for (int wp = 0; wp < walls[w].wall.length; wp++) {
				WallPiece wallPiece = walls[w].wall[wp];
				if (player.collides(wallPiece)) {
					shipDestroyed = true;
					if (player.explode(explosionsManager, soundManager))
						return true;
				}
			}
		}
		return false;
	}
	int x = 0;
	boolean armadaVsShot(int nShot) {
		Shot shot = shots.get(nShot);
		for (int py = 0; py < players.length; py++) {
			for (int px = 0; px < players[0].length; px++) {
				boolean shotByEnemy = (shot.boundingCircle.offset.y == 0);
				if (shot.collides(players[py][px]) && shotByEnemy) {
					shots.remove(nShot);
					shipDestroyed = true;
					if (players[py][px].explode(explosionsManager, soundManager))
						return true;		
					else 
						return false;
				} 
			}
		}
		return false;
	}
		
	boolean enemiesVsShot(int nShot) {
		Shot shot = shots.get(nShot);
		for (int ex = 0; ex < enemies.length; ex++) {
			boolean shotByPlayer = (shot.boundingCircle.offset.y == 10);
			if (shot.collides(enemies[ex]) && shotByPlayer && enemies[ex].deathRotation == 0) {
				float explosionX = enemies[ex].pos.x + enemies[ex].boundingCircle.offset.x;						
				float explosionY = enemies[ex].pos.y + enemies[ex].boundingCircle.offset.y;
				explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 0, 0), 12);					
				enemies[ex].lostLife = true;
				if (enemies[ex].lives == 1) {
					soundManager.soundEffect(1);
					enemies[ex].alive = false;
				} else {
					soundManager.soundEffect(0);
				}
				shots.remove(nShot);
				return true;
			}
		}
		return false;
	}

	boolean wallsVsShot(int nShot) {
		Shot shot = shots.get(nShot);
		for (int w = 0; w < walls.length; w++) {
			float x1 = walls[w].pos.x - walls[w].wallPieceDiameter / 2;
			float x2 = walls[w].pos.x + 5.5 * walls[w].wallPieceDiameter;
			float y = walls[w].pos.y - walls[w].wallPieceDiameter / 2; 
				
			if (!(shot.pos.x >= (x1 - 1) && shot.pos.x <= x2 && shot.pos.y + shot.boundingCircle.offset.y >= y))
				continue;
				
			for (int wp = 0; wp < walls[w].wall.length; wp++) {
				WallPiece wallPiece = walls[w].wall[wp];
				if (shot.collides(wallPiece)) {
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