package;
import flixel.util.FlxColor;

/**
 * ...
 * @author A. Cid
 */
class Reg 
{
	inline static public var playerVelX:Float = 96;
	inline static public var warpTime:Float = 0.25;
	inline static public var boxOffsetX:Float = 3;
	inline static public var boxOffsetY:Float = 3;
	
	static public var playerGravity:Float = 512;
	static public var playerJumpForce:Float = -128;
	static public var isWarped:Bool = false;
	static public var paletteIndex:Int = 0;
	static public var colorPalette:ColorPaletteManager = ColorPaletteManager.instance;
}