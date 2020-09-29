GameObjectsManager gameObjects = new GameObjectsManager();

class GameObjectsManager {
	ArrayList<GameObject> gameObjects; // players, enemy, bullets, etc.

	GameObjectsManager() {
		gameObjects = new ArrayList<GameObject>(200);
	}

	void add(GameObject go) {
		gameObjects.add(go);
	}
}