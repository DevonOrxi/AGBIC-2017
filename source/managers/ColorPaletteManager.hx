package managers;
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
		var colors = Lambda.array(Reg.configData.colors);
		
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