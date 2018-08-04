package;
import flixel.util.FlxColor;

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
	private var value(get, null):Array<Array<Int>> = [
		[0xED1E24, 0xFFFFFF]
	];

	private function new() 
	{
		
	}
	
	function get_value():Array<Array<Int>> 
	{
		return value;
	}
	
	function get_colorBack():Int 
	{
		return value[paletteIndex][0];
	}
	
	function get_colorFront():Int 
	{
		return value[paletteIndex][1];
	}
	
}