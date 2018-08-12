package states.substates;

import entities.Player;
import flixel.group.FlxGroup;
import haxe.Json;
import interfaces.IColorSwappable;
import managers.ColorPaletteManager;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import managers.LevelManager;
import utils.GeoOgmoLoader;
import utils.GeoTilemap;

class PlayState extends FlxSubState {
	
	private var player:Player;
	private var tilemapBgWhite:GeoTilemap;
	private var tilemapBgRed:GeoTilemap;
	private var tilemapObjWhite:GeoTilemap;
	private var tilemapObjRed:GeoTilemap;
	private var colorSwappables:Array<IColorSwappable> = [];

	override public function create():Void {
		super.create();
		
		Reg.initExternalData();
		ColorPaletteManager.boot();
		LevelManager.boot();
		player = new Player();
		FlxG.cameras.bgColor = 0xFFFF00FF;

		setTilemaps();
		setColorSwappableArray();
		addToState();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		collidePlayerWithTerrain();
		paletteSwapCheck();
	}
	
	private function addToState() {
		add(tilemapBgWhite);
		add(tilemapBgRed);
		add(tilemapObjWhite);
		add(tilemapObjRed);
		add(player);
	}
	
	private function setColorSwappableArray() {
		colorSwappables.push(tilemapBgWhite);
		colorSwappables.push(tilemapBgRed);
		colorSwappables.push(tilemapObjWhite);
		colorSwappables.push(tilemapObjRed);
		colorSwappables.push(player);
	}
	
	private function paletteSwapCheck() {
		if (FlxG.keys.justPressed.Q) {
			ColorPaletteManager.instance.addToIndex();
			for (swappable in colorSwappables)
				swappable.setColors();
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
		
		var loader:GeoOgmoLoader = new GeoOgmoLoader(
			isTestMode ?
			AssetPaths.famicase__oel :
			"assets/data/level/progression/" + Reg.levelManager.getCurrentLevelID() + ".oel");
		
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

	private function placeEntities(entityName:String, entityData:Xml):Void {
		var X:Int = Std.parseInt(entityData.get("x"));
		var Y:Int = Std.parseInt(entityData.get("y"));
		
		if (entityName == "player") {
			player.x = X;
			player.y = Y;
		}
	}
}