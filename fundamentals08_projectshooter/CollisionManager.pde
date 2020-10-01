class CollisionManager {
	Player[][] players;
	Enemy[] enemies;
	ArrayList<Shot> shots;
	Wall[] walls;
	ExplosionsManager explosionsManager;

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
		// Check all shots against players, enemies and walls
		for (int n = 0; n < shots.size(); n++) {
			Shot s = shots.get(n);

			// players:
			for (int py = 0; py < players.length; py++) {
				for (int px = 0; px < players[0].length; px++) {
					if (s.collides(players[py][px]) && players[py][px].alive) {
						players[py][px].alive = false;
						shots.remove(n);
						float explosionX = players[py][px].pos.x + players[py][px].boundingCircle.offset.x;						
						float explosionY = players[py][px].pos.y + players[py][px].boundingCircle.offset.y;
						if (players[py][px].isCurrent) {
							explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 128, 255), 30);
							explosionsManager.spawn(new PVector(explosionX, explosionY), color(0, 64, 128), 30);
							return true; // Game Over!
						} else {
							explosionsManager.spawn(new PVector(explosionX, explosionY), color(255, 255, 255), 30);
							return false;
						}
					} 
				}
			}
		
			// enemies:
			for (int ex = 0; ex < enemies.length; ex++) {
				if (s.collides(enemies[ex])) {
					float explosionX = enemies[ex].pos.x + enemies[ex].boundingCircle.offset.x;						
					float explosionY = enemies[ex].pos.y + enemies[ex].boundingCircle.offset.y;
					explosionsManager.spawn(new PVector(explosionX, explosionY), color(255, 255, 255), 30);					
					shots.remove(n);					
					return false;
				}
			}

			// walls:
			for (int w = 0; w < walls.length; w++) {
				for (int wp = 0; wp < walls[w].wall.length; wp++) {
					WallPiece wallPiece = walls[w].wall[wp];
					if (wallPiece.alive && s.collides(wallPiece)) {
						//wallPiece.alive = false;
						wallPiece.applyDamage();
						shots.remove(n);						
						return false;
					}
				}
			}
		}
		return false; // No game over!
	}
}