class CollisionManager {
	Player[][] players;
	Enemy[] enemies;
	ArrayList<Shot> shots;

	CollisionManager(Player[][] _players, Enemy[] _enemies, ArrayList<Shot> _shots) {
		players = _players;
		enemies = _enemies;
		shots = _shots;
	}

	boolean update(float delta_t) {
		// Check all shots against players, enemies and shields
		for (int n = 0; n < shots.size(); n++) {
			Shot s = shots.get(n);
		
			// players:
			for (int py = 0; py < players.length; py++) {
				for (int px = 0; px < players[0].length; px++) {
					if (s.collides(players[py][px]) && players[py][px].alive) {
						players[py][px].alive = false;
						shots.remove(n);
						if (players[py][px].isCurrent)
							return true; // Game Over!
					}
				}
			}
		
			// enemies:
			for (int ex = 0; ex < enemies.length; ex++) {
				if (s.collides(enemies[ex])) {
					//exit();
				}
			}
		}
		return false; // No game over!
	}
}