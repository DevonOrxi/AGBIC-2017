package utils;

import flixel.FlxObject;
import flixel.math.FlxPoint;
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
	
	public function isTileCollisionAnyByCoords(Coord:FlxPoint):Bool
	{
		var localX = Coord.x - x;
		var localY = Coord.y - y;
		Coord.putWeak();
		
		if ((localX < 0) || (localY < 0) || (localX >= width) || (localY >= height))
			return false;
		
		var index = Std.int(localY / _scaledTileHeight) * widthInTiles + Std.int(localX / _scaledTileWidth);
		var type = _data[index];
		var collision = _tileObjects[type].allowCollisions;
		return collision == FlxObject.ANY;
	}
	
	public function isFeetPosCollidableByCoords(feet:Array<FlxPoint>):Int
	{
		var result:Int = 0;
		
		for (i in 0...feet.length) {
			var foot = feet[i];
			var localX = foot.x - x;
			var localY = foot.y - y;
			foot.putWeak();
			
			if ((localX < 0) || (localY < 0) || (localX >= width) || (localY >= height))
				return -1;
			
			var index = Std.int(localY / _scaledTileHeight) * widthInTiles + Std.int(localX / _scaledTileWidth);
			var type = _data[index];
			if (_tileObjects[type].allowCollisions == FlxObject.ANY) {
				result = result | (1 << i);
			}
		}
		return result;
	}
	
	function get_isTopColored():Bool 
	{
		return isTopColored;
	}
}