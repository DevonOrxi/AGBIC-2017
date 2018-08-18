package states.substates;

import haxe.Json;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;

import Reg.WarpStatus;
import entities.Player;
import interfaces.IColorSwappable;
import managers.ColorPaletteManager;
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
	private var boundaries = new FlxTypedGroup<FlxSprite>();

	override public function create():Void {
		super.create();
		
		Reg.initExternalData();
		ColorPaletteManager.boot();
		LevelManager.boot();
		player = new Player();
		FlxG.cameras.bgColor = 0xFFFF00FF;

		setTilemaps();
		createBoundaries();
		setColorSwappableArray();
		addToState();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		collidePlayerWithTerrain();
		collidePlayerWithBoundaries();
		paletteSwapCheck();
	}
	
	private function collidePlayerWithBoundaries() {
		FlxG.collide(boundaries, player);
	}
	
	private function addToState() {
		add(tilemapBgWhite);
		add(tilemapBgRed);
		add(tilemapObjWhite);
		add(tilemapObjRed);
		add(boundaries);
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
		if (!player.isWarping) {
			if (Reg.isWarped) {
				FlxG.collide(tilemapBgWhite, player);
				FlxG.collide(tilemapObjRed, player);
			} else {
				FlxG.collide(tilemapBgRed, player);
				FlxG.collide(tilemapObjWhite, player);
			}
			
			//	I THINK THIS IS THE POOPIEST CODE I'VE EVER POOPED
			if (Conditions.grounded(player)) {
				var feet = player.getFootingPos();
				var result:Int = 0;
				
				result = Reg.isWarped ?
					tilemapBgWhite.isFeetPosCollidableByCoords(feet) | tilemapObjRed.isFeetPosCollidableByCoords(feet) :
					tilemapBgRed.isFeetPosCollidableByCoords(feet) | tilemapObjWhite.isFeetPosCollidableByCoords(feet);
				
				Reg.warpStatus = switch (result) {
					case 0: WarpStatus.NO_WARP;
					case 1: WarpStatus.WARP_LEFT;
					case 2: WarpStatus.WARP_RIGHT;
					default: WarpStatus.WARP_STATIC;
				};
			}
		}
	}
	
	private function createBoundaries() {
		var width = Std.int(tilemapBgRed.width);
		var height = Std.int(tilemapBgRed.height);
		var sprite:FlxSprite = new FlxSprite();		
		
		for (i in 0...4) {
			switch (i) {
				case 0:
					//	LEFT
					sprite = new FlxSprite(-Reg.tileWidth, -Reg.tileHeight);
					sprite.makeGraphic(Reg.tileWidth, height + 2 * Reg.tileHeight);
				case 1:
					//	TOP
					sprite = new FlxSprite(-Reg.tileWidth, -Reg.tileHeight);
					sprite.makeGraphic(width + 2 * Reg.tileHeight, Reg.tileHeight);
				case 2:
					//	RIGHT
					sprite = new FlxSprite(width, -Reg.tileHeight);
					sprite.makeGraphic(Reg.tileWidth, height + 2 * Reg.tileHeight);
				case 3:
					//	BOTTOM
					sprite = new FlxSprite(-Reg.tileWidth, height);
					sprite.makeGraphic(width + 2 * Reg.tileHeight, Reg.tileHeight);
			}
			sprite.immovable = true;
			boundaries.add(sprite);
		}
	}
	
	private function setTilemaps() {
		var isTestMode = Reg.configData.testMode == "true";
		
		var loader:GeoOgmoLoader = new GeoOgmoLoader(
			isTestMode ?
			AssetPaths.famicase__oel :
			"assets/data/level/progression/" + Reg.levelManager.getCurrentLevelID() + ".oel");
		
		tilemapBgWhite = loader.loadGeoTilemap(AssetPaths.tiles_bg_white__png, Reg.tileWidth, Reg.tileHeight, "bg_white");
		tilemapBgRed = loader.loadGeoTilemap(AssetPaths.tiles_bg_white__png, Reg.tileWidth, Reg.tileHeight, "bg_red");
		tilemapObjWhite = loader.loadGeoTilemap(AssetPaths.tiles_obj_red__png, Reg.tileWidth, Reg.tileHeight, "obj_over_white");
		tilemapObjRed = loader.loadGeoTilemap(AssetPaths.tiles_obj_red__png, Reg.tileWidth, Reg.tileHeight, "obj_over_red");
		
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