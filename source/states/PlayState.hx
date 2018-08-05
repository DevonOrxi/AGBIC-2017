package states;

import entities.Player;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	private var player:Player;
	private var tilemapBgWhite:FlxTilemap;
	private var tilemapBgRed:FlxTilemap;
	private var tilemapObjWhite:FlxTilemap;
	private var tilemapObjRed:FlxTilemap;
	
	private var redMap:FlxTilemap;
	private var whiteMap:FlxTilemap;

	override public function create():Void
	{
		super.create();

		player = new Player();
		FlxG.cameras.bgColor = 0xFFFF00FF;

		setTilemaps();

		add(tilemapBgWhite);
		add(tilemapBgRed);
		add(tilemapObjWhite);
		add(tilemapObjRed);
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if(!player.isWarping)
		{
			if (Reg.isWarped)
			{
				FlxG.collide(tilemapBgWhite, player);
				FlxG.collide(tilemapObjRed, player);
			}
			else
			{
				FlxG.collide(tilemapBgRed, player);
				FlxG.collide(tilemapObjWhite, player);
			}
		}
	}
	
	private function setTilemaps()
	{
		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.famicase__oel);
		tilemapBgWhite = loader.loadTilemap(AssetPaths.tiles_bg_white__png, 16, 16, "bg_white");
		tilemapBgRed = loader.loadTilemap(AssetPaths.tiles_bg_red__png, 16, 16, "bg_red");
		tilemapObjWhite = loader.loadTilemap(AssetPaths.tiles_obj_white__png, 16, 16, "obj_over_white");
		tilemapObjRed = loader.loadTilemap(AssetPaths.tiles_obj_red__png, 16, 16, "obj_over_red");

		tilemapBgWhite.setTileProperties(0, FlxObject.NONE);
		tilemapBgWhite.setTileProperties(1, FlxObject.ANY);
		tilemapBgRed.setTileProperties(0, FlxObject.NONE);
		tilemapBgRed.setTileProperties(1, FlxObject.ANY);
		tilemapObjWhite.setTileProperties(0, FlxObject.NONE);
		tilemapObjWhite.setTileProperties(1, FlxObject.ANY);
		tilemapObjRed.setTileProperties(0, FlxObject.NONE);
		tilemapObjRed.setTileProperties(1, FlxObject.ANY);
		
		loader.loadEntities(placeEntities, "entities");
	}

	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var X:Int = Std.parseInt(entityData.get("x"));
		var Y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			trace(X + " " + Y);
			player.x = X;
			player.y = Y;
		}
	}
}