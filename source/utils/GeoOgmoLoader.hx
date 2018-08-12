package utils;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author A. Cid
 */
class GeoOgmoLoader extends FlxOgmoLoader {

	public function loadGeoTilemap(TileGraphic:Dynamic, TileWidth:Int = Reg.tileWidth, TileHeight:Int = Reg.tileHeight, TileLayer:String = "tiles"):GeoTilemap {
		var geoTilemap:GeoTilemap = new GeoTilemap();
		geoTilemap.loadMapFromCSV(_fastXml.node.resolve(TileLayer).innerData, TileGraphic, TileWidth, TileHeight);
		return geoTilemap;
	}
	
}