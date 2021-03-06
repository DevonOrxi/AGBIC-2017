package;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.system.FlxSoundGroup;
import managers.ColorPaletteManager;
import flixel.util.FlxColor;
import managers.LevelManager;
import managers.TransitionManager;
import openfl.Assets;
import haxe.Json;

/**
 * ...
 * @author A. Cid
 */

enum WarpStatus {
	WARP_STATIC;
	WARP_RIGHT;
	WARP_LEFT;
	NO_WARP;
}

class Reg {
	inline static public var playerVelX:Float = 80;
	inline static public var patrollerVelX:Float = 40;
	inline static public var warpTime:Float = 0.25;
	inline static public var boxOffsetX:Float = 3;
	inline static public var boxOffsetY:Float = 3;
	inline static public var tileWidth:Int = 16;
	inline static public var tileHeight:Int = 16;
	inline static public var playerGravity:Float = 512;
	inline static public var playerJumpForce:Float = -128;
	
	static public var warpStatus:WarpStatus = NO_WARP;
	static public var colorPalette:ColorPaletteManager = ColorPaletteManager.instance;
	static public var levelManager:LevelManager = LevelManager.instance;
	static public var transitionManager:TransitionManager = TransitionManager.instance;
	static public var configData(get, null):Dynamic;
	
	static private var initialized:Bool = false;
	
	static public function initExternalData() {
		if (!initialized) {
			var jsonString:String = Assets.getText(AssetPaths.config__json);
			configData = Json.parse(jsonString);
			
			ColorPaletteManager.boot();
			LevelManager.boot();
			FlxG.sound.load("assets/sounds/music.ogg", 1, true, null, false, true);
			
			initialized = true;
		}
	}
	
	static private function playSomeFuckingMusicAlready() {
	}
	
	static function get_configData():Dynamic {
		return configData;
	}
}