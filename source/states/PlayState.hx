package states;

import entities.BaseEntity;
import entities.Goal;
import entities.Patroller;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import haxe.Json;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import Reg.WarpStatus;
import entities.Player;
import interfaces.IColorSwappable;
import managers.ColorPaletteManager;
import managers.LevelManager;
import utils.GeoOgmoLoader;
import utils.GeoTilemap;

class PlayState extends FlxUIState {
	
	private var player:Player;
	private var goal:Goal;
	private var tilemapBgWhite:GeoTilemap;
	private var tilemapBgRed:GeoTilemap;
	private var tilemapObjWhite:GeoTilemap;
	private var tilemapObjRed:GeoTilemap;
	private var colorSwappables:Array<IColorSwappable> = [];
	private var boundaries = new FlxTypedGroup<FlxSprite>();
	private var patrollerGroup = new FlxTypedGroup<Patroller>();

	override public function create():Void {
		super.create();
		
		Reg.initExternalData();
		player = new Player();
		setTilemaps();
		createBoundaries();
		setColorSwappableArray();
		addEverythingToState();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		collideThings();
		paletteSwapCheck();
	}
	
	private function collideThings() {
		collidePlayerWithGoal();
		collidePlayerWithTerrain();
		collidePatrollersWithTerrain();
		
		if (FlxG.overlap(patrollerGroup, player)) {
			FlxG.sound.play(AssetPaths.land__ogg);
			player.animation.play("hurt");
			FlxG.switchState(new PlayState());
		}
		
		FlxG.collide(patrollerGroup, null, collidedPatrollersEachOther);
		FlxG.collide(boundaries, player);
		FlxG.collide(boundaries, patrollerGroup, collidedSinglePatrollerWithBoundary);
	}
	
	private function addEverythingToState() {
		add(tilemapBgWhite);
		add(tilemapBgRed);
		add(tilemapObjWhite);
		add(tilemapObjRed);
		add(boundaries);
		if (goal != null) { add(goal); }
		add(patrollerGroup);
		add(player);
	}
	
	private function setColorSwappableArray() {
		colorSwappables.push(tilemapBgWhite);
		colorSwappables.push(tilemapBgRed);
		colorSwappables.push(tilemapObjWhite);
		colorSwappables.push(tilemapObjRed);
		colorSwappables.push(player);
		
		
		for (swappable in colorSwappables)
			swappable.setColors();
	}
	
	private function paletteSwapCheck() {
		if (FlxG.keys.justPressed.Q) {
			ColorPaletteManager.instance.addToIndex();
			for (swappable in colorSwappables)
				swappable.setColors();
		}
	}
	
	private function collidePlayerWithGoal() {
		if (goal != null &&
			goal.warped == player.warped &&
			!player.isWarping &&
			FlxG.overlap(goal, player)) {
			
			FlxG.sound.play(AssetPaths.warp2__ogg, 0.8);
			Reg.levelManager.progressOneLevel();
		}
	}
	
	// TODO: REFACTOR (SKIP FOR)
	private function collidePatrollersWithTerrain() {
		for (p in patrollerGroup) {
			collideSinglePatrollerWithTerrain(p);
			
			var shouldFlip = false;
			
			if (p.isTouching(FlxObject.LEFT | FlxObject.RIGHT)) {
				shouldFlip = true;
			} else {
				var feet = p.getFootingPos();
				var regularCol = p.warped ? tilemapBgWhite.isFeetPosCollidableByCoords(feet) : tilemapBgRed.isFeetPosCollidableByCoords(feet);
				var blockersCol = tilemapObjWhite.isFeetPosCollidableByCoords(feet) | tilemapObjRed.isFeetPosCollidableByCoords(feet);
				
				if ((regularCol | blockersCol) != 3)
					shouldFlip = true;
			}
			
			if (shouldFlip)
				p.handleCollisionWithMap();
		}
	}
	
	private function collidedPatrollersEachOther(p1:Patroller, p2:Patroller) {
		if (!p1.isFlipping) { p1.handleCollisionWithMap(); }
		if (!p2.isFlipping) { p2.handleCollisionWithMap(); }
	}
	
	private function collideSinglePatrollerWithTerrain(p:Patroller):Bool {
		if (p.isFlipping)
			return false;
		
		if (p.warped)
			return (FlxG.collide(tilemapBgWhite, p) || FlxG.collide(tilemapObjRed, p)) ? true : false;
		else
			return (FlxG.collide(tilemapBgRed, p) || FlxG.collide(tilemapObjWhite, p)) ? true : false;
		
		return false;
	}
	
	private function collidePlayerWithTerrain() {
		if (!player.isWarping) {
			if (player.warped) {
				FlxG.collide(tilemapBgWhite, player);
				FlxG.collide(tilemapObjRed, player);
			} else {
				FlxG.collide(tilemapBgRed, player);
				FlxG.collide(tilemapObjWhite, player);
			}
			
			if (PlayerConditions.grounded(player)) {
				var result = canPlayerWarp();
				
				Reg.warpStatus = switch (result) {
					case 0: WarpStatus.NO_WARP;
					case 1: WarpStatus.WARP_LEFT;
					case 2: WarpStatus.WARP_RIGHT;
					default: WarpStatus.WARP_STATIC;
				};
			}
		}
	}
	
	private function canPlayerWarp():Int {
		var feet = player.getFootingPos();
		var regularCol = player.warped ? tilemapBgWhite.isFeetPosCollidableByCoords(feet) : tilemapBgRed.isFeetPosCollidableByCoords(feet);
		var blockersCol = tilemapObjWhite.isFeetPosCollidableByCoords(feet) | tilemapObjRed.isFeetPosCollidableByCoords(feet);
		
		return (regularCol & ~blockersCol);
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
		var loader:GeoOgmoLoader = new GeoOgmoLoader(
			Reg.configData.testMode == "true" ?
			AssetPaths.famicase__oel :
			"assets/data/level/progression/" + Reg.levelManager.currentLevel + ".oel");
		
		tilemapBgWhite = loader.loadGeoTilemap(AssetPaths.tiles_bg_white__png, Reg.tileWidth, Reg.tileHeight, "bg_white");
		tilemapBgRed = loader.loadGeoTilemap(AssetPaths.tiles_bg_white__png, Reg.tileWidth, Reg.tileHeight, "bg_red");
		tilemapObjWhite = loader.loadGeoTilemap(AssetPaths.tiles_obj_red__png, Reg.tileWidth, Reg.tileHeight, "obj_over_white");
		tilemapObjRed = loader.loadGeoTilemap(AssetPaths.tiles_obj_red__png, Reg.tileWidth, Reg.tileHeight, "obj_over_red");
		
		tilemapBgWhite.init(true, true);
		tilemapBgRed.init(false, true);
		tilemapObjWhite.init(false, false);
		tilemapObjRed.init(true, false);
		
		FlxG.camera.setScrollBounds(0, tilemapBgWhite.width, 0, tilemapBgWhite.height);
		FlxG.worldBounds.set(-Reg.tileWidth, -Reg.tileHeight, tilemapBgWhite.width + Reg.tileWidth, tilemapBgWhite.height + Reg.tileHeight);
		
		loader.loadEntities(placeEntities, "entities");
	}

	private function placeEntities(entityName:String, entityData:Xml):Void {
		var X = Std.parseInt(entityData.get("x"));
		var Y = Std.parseInt(entityData.get("y"));
		var isWarped = Std.string(entityData.get("warped")) == "True" ? true : false ;
		var goingRight = Std.string(entityData.get("goingRight")) == "True" ? true : false ;
		
		switch (entityName) {
			case "player":
				player = new Player(X, Y, isWarped, goingRight);
				player.x += player.offset.x;
				player.y += player.offset.y;
			case "patroller":
				var patroller = new Patroller(X, Y, goingRight, isWarped);
				patroller.x += patroller.offset.x;
				patroller.y += patroller.offset.y;
				
				patrollerGroup.add(patroller);
				colorSwappables.push(patroller);
			case "goal":
				goal = new Goal(X, Y, isWarped);
				colorSwappables.push(goal);
		}
	}
	
	private function collidedSinglePatrollerWithBoundary(boundary:FlxSprite, patroller:Patroller) {
		patroller.handleCollisionWithMap();
	}
}