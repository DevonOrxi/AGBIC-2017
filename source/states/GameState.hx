package states;

import flixel.FlxState;
import states.substates.PlayState;

/**
 * ...
 * @author Ariel Cid
 */
class GameState extends FlxState 
{

	override public function create():Void 
	{
		super.create();
		
		openSubState(new PlayState());
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}