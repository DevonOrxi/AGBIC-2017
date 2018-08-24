package;
import managers.ColorPaletteManager;
import flixel.util.FlxColor;
import managers.LevelManager;
import openfl.Assets;
import haxe.Json;

/*
 * 1. Check A and B points for collision
 * 2. If both A and B collide and is grounded, make warpable
 * 2a. If A collides and (A.x + width / 2) % Reg.tileWidth > Reg.tileWidth / 2, make warpable with left auto alignment
 * 2b. If B collides and (B.x - width / 2) % Reg.tileWidth < Reg.tileWidth / 2, make warpable with right auto alignment
 * 2c. If not A nor B collide, make not warpable
 */

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
	inline static public var patrollerVelX:Float = 80;
	inline static public var warpTime:Float = 0.25;
	inline static public var boxOffsetX:Float = 3;
	inline static public var boxOffsetY:Float = 3;
	inline static public var tileWidth:Int = 16;
	inline static public var tileHeight:Int = 16;
	
	static public var playerGravity:Float = 512;
	static public var playerJumpForce:Float = -128;
	static public var isWarped:Bool = false;
	static public var warpStatus:WarpStatus = NO_WARP;
	static public var colorPalette:ColorPaletteManager = ColorPaletteManager.instance;
	static public var levelManager:LevelManager = LevelManager.instance;	
	static public var configData(get, null):Dynamic;	
	static public var warpMultiplier(get, null):Int;
	
	static public function initExternalData() {
		var jsonString:String = Assets.getText(AssetPaths.config__json);
		Reg.configData = Json.parse(jsonString);
	}
	
	static function get_warpMultiplier():Int {
		return Reg.isWarped ? -1 : 1;
	}
	
	static function get_configData():Dynamic {
		return configData;
	}
}