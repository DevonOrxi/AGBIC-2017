package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	private var player:Player;
	private var redMap:FlxTilemap;
	private var whiteMap:FlxTilemap;

	override public function create():Void
	{
		super.create();

		var loader:FlxOgmoLoader = new FlxOgmoLoader(AssetPaths.sandbox__oel);
		redMap = loader.loadTilemap(AssetPaths.tiles__png);
		whiteMap = loader.loadTilemap(AssetPaths.tiles__png);

		redMap.setTileProperties(0, FlxObject.NONE);
		redMap.setTileProperties(1, FlxObject.NONE);
		redMap.setTileProperties(2, FlxObject.ANY);
		redMap.setTileProperties(3, FlxObject.ANY);
		redMap.setTileProperties(4, FlxObject.ANY);

		whiteMap.setTileProperties(0, FlxObject.NONE);
		whiteMap.setTileProperties(1, FlxObject.ANY);
		whiteMap.setTileProperties(2, FlxObject.NONE);
		whiteMap.setTileProperties(3, FlxObject.ANY);
		whiteMap.setTileProperties(4, FlxObject.ANY);

		FlxG.cameras.bgColor = 0xFFFF00FF;

		player = new Player();
		loader.loadEntities(placeEntities, "entities");

		add(redMap);
		add(whiteMap);
		add(player);
		add(player.whitePart);
		add(player.redPart);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if(!player.isWarping)
		{
			if (Reg.isWarped)
				FlxG.collide(whiteMap, player);
			else
				FlxG.collide(redMap, player);
		}
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