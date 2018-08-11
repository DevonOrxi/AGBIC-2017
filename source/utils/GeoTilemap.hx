package utils;

import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import interfaces.IColorSwappable;
import managers.ColorPaletteManager;

/**
 * ...
 * @author A. Cid
 */
class GeoTilemap extends FlxTilemap implements IColorSwappable
{
	public var isTopColored(get, null):Bool = true;
	
	public function setColors()
	{
		color = isTopColored ? ColorPaletteManager.instance.colorFront : ColorPaletteManager.instance.colorBack;
	}
	
	public function init(topColored:Bool, isBackgroundTilemap: Bool)
	{
		isTopColored = topColored;
		
		if (isBackgroundTilemap)
		{
			setTileProperties(0, FlxObject.NONE);
			setTileProperties(1, FlxObject.ANY);
		}
		else
		{
			setTileProperties(0, FlxObject.NONE);
			setTileProperties(1, FlxObject.ANY);
		}
		
		setColors();
	}
	
	function get_isTopColored():Bool 
	{
		return isTopColored;
	}
}