package managers;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;

/**
 * Singleton for the array of color palettes
 * @author A. Cid
 */
class ColorPaletteManager
{
	static public var instance(default, null):ColorPaletteManager = new ColorPaletteManager();
	public var colorBack(get, null):Int;
	public var colorFront(get, null):Int;
	
	private var paletteIndex:Int = 0;
	private var value(get, null):Array<Array<Int>> = [];

	private function new() 
	{
		
	}
	
	static public function boot() {
		if (ColorPaletteManager.instance.value.length == 0)
			ColorPaletteManager.instance.init();
		else
			trace("Failed to re-boot ColorPaletteManager");
	}
	
	private function init() {
		var jsonString:String = Assets.getText(AssetPaths.config__json); trace("stringed");
		var data:Dynamic = Json.parse(jsonString); trace("parsed");
		var colors = Lambda.array(data.colors);  trace("array...ed?");
		
		if (colors.length > 0)
			for (c in colors) 
				value.push([Std.parseInt(c.top), Std.parseInt(c.bottom)]);
		else
			value.push([0xED1E24, 0xFFFFFF]);
	}
	
	public function addToIndex(?val:Int = 1)
	{
		paletteIndex = (paletteIndex + val) % value.length;
	}
	
	function get_value():Array<Array<Int>> 
	{
		return value;
	}
	
	function get_colorBack():Int 
	{
		return value[paletteIndex][1];
	}
	
	function get_colorFront():Int 
	{
		return value[paletteIndex][0];
	}
	
}