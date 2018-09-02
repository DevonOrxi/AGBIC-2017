package managers;

/**
 * ...
 * @author Ariel Cid
 */
class LevelManager {
	
	static public var instance(default, null):LevelManager = new LevelManager();
	
	private var levelIndex:Int = 0;
	private var value:Array<String> = [];
	
	private function new() {}
	
	static public function boot() {
		if (LevelManager.instance.value.length == 0)
			LevelManager.instance.init();
		else
			trace("LevelManager already booted");
	}
	
	private function init() {
		var levels = Lambda.array(Reg.configData.levels);
		
		if (levels.length > 0)
			for (l in levels) 
				value.push(l);
		else
			value.push("famicase");
	}
	
	public function progressOneLevel() {
		levelIndex = (levelIndex + 1) % value.length;
	}
	
	public function getCurrentLevelID():String {
		return value[levelIndex];
	}
	
}