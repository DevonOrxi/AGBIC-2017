package managers;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;

/**
 * ...
 * @author A. Cid
 */
class TransitionManager 
{
	static public var instance(default, null):TransitionManager = new TransitionManager();
	
	private function new() {
		FlxTransitionableState.defaultTransIn = new TransitionData();
		FlxTransitionableState.defaultTransOut = new TransitionData();
		
		/*
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
			
		FlxTransitionableState.defaultTransIn.tileData = { asset: diamond, width: 16, height: 16 };
		FlxTransitionableState.defaultTransOut.tileData = { asset: diamond, width: 16, height: 16 };
		
		FlxTransitionableState.defaultTransOut.duration = 1;
		FlxTransitionableState.defaultTransOut.direction.set( -1, -1);
		FlxTransitionableState.defaultTransOut.color = 0x00FFFF;
		FlxTransitionableState.defaultTransOut.type = TransitionType.TILES;
		
		FlxTransitionableState.defaultTransIn.duration = 1;
		FlxTransitionableState.defaultTransIn.direction.set( -1, -1);
		FlxTransitionableState.defaultTransIn.color = 0x00FFFF;
		FlxTransitionableState.defaultTransIn.type = TransitionType.TILES;*/
	}
}