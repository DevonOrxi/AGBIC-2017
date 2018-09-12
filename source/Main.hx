package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.EndState;
import states.PlayState;
import states.StartState;

class Main extends Sprite {
	
	public function new() {
		super();
		
		addChild(new FlxGame(256, 240, StartState));
	}
	
}