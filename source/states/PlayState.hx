package states;

import entities.Player;
import flixel.group.FlxGroup;
import haxe.Json;
import interfaces.IColorSwappable;
import managers.ColorPaletteManager;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import utils.GeoOgmoLoader;
import utils.GeoTilemap;

class PlayState extends FlxState {
	
	private var player:Player;
	private var tilemapBgWhite:GeoTilemap;
	private var tilemapBgRed:GeoTilemap;
	private var tilemapObjWhite:GeoTilemap;
	private var tilemapObjRed:GeoTilemap;
	private var tilemapGroup:FlxTypedGroup<GeoTilemap>;

	override public function create():Void {
		super.create();
		
		Reg.initExternalData();
		ColorPaletteManager.boot();
		tilemapGroup = new FlxTypedGroup<GeoTilemap>();
		player = new Player();
		FlxG.cameras.bgColor = 0xFFFF00FF;

		setTilemaps();

		add(tilemapBgWhite);
		add(tilemapBgRed);
		add(tilemapObjWhite);
		add(tilemapObjRed);
		add(player);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		collidePlayerWithTerrain();
		paletteSwapCheck();
	}
	
	private function paletteSwapCheck() {
		if (FlxG.keys.justPressed.Q) {
			ColorPaletteManager.instance.addToIndex();
			player.setColors();
			setLevelColors();
		}
	}
	
	private function collidePlayerWithTerrain() {
		if(!player.isWarping) {
			if (Reg.isWarped) {
				FlxG.collide(tilemapBgWhite, player);
				FlxG.collide(tilemapObjRed, player);
			} else {
				FlxG.collide(tilemapBgRed, player);
				FlxG.collide(tilemapObjWhite, player);
			}
		}
	}
	
	private function setTilemaps() {
		var isTestMode = Reg.configData.testMode == "true";
		var loader:GeoOgmoLoader = new GeoOgmoLoader(isTestMode ? AssetPaths.famicase__oel : AssetPaths.famicase__oel);
		
		tilemapBgWhite = loader.loadGeoTilemap(AssetPaths.tiles_bg_white__png, 16, 16, "bg_white");
		tilemapBgRed = loader.loadGeoTilemap(AssetPaths.tiles_bg_white__png, 16, 16, "bg_red");
		tilemapObjWhite = loader.loadGeoTilemap(AssetPaths.tiles_obj_red__png, 16, 16, "obj_over_white");
		tilemapObjRed = loader.loadGeoTilemap(AssetPaths.tiles_obj_red__png, 16, 16, "obj_over_red");
		
		tilemapBgWhite.init(true, true);
		tilemapBgRed.init(false, true);
		tilemapObjWhite.init(false, false);
		tilemapObjRed.init(true, false);
		
		loader.loadEntities(placeEntities, "entities");
	}
	
	private function setLevelColors() {
		for (map in tilemapGroup)
			map.setColors();
	}

	private function placeEntities(entityName:String, entityData:Xml):Void {
		var X:Int = Std.parseInt(entityData.get("x"));
		var Y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "player") {
			trace(X + " " + Y);
			player.x = X;
			player.y = Y;
		}
	}
}