class CollisionManager {
	Player[][] players;
	Enemy[] enemies;
	ArrayList<Shot> shots;

	CollisionManager(Player[][] _players, Enemy[] _enemies, ArrayList<Shot> _shots) {
		players = _players;
		enemies = _enemies;
		shots = _shots;
	}

	void update(float delta_t) {
		// Check all shots against players, enemies and shields
		for (int n = 0; n < shots.size(); n++) {
			//if (shots.get(n).pos.y > 640)
			
		}
	}
}