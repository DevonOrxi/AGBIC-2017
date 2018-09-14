package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import managers.ColorPaletteManager;

/**
 * ...
 * @author Ariel Cid
 */
class StartState extends FlxUIState 
{
	private var music = new FlxSound();

	override public function create():Void {
		super.create();
		
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		
		Reg.initExternalData();
		
		var back = new FlxSprite();
		var text = new FlxText(0, 0, 0, "G E O", 64);
		back.makeGraphic(FlxG.width, FlxG.height);
		back.color = Reg.colorPalette.colorBack;
		text.font = AssetPaths.m6x11__ttf;
		text.color = Reg.colorPalette.colorFront;
		text.setPosition((FlxG.width - text.width) / 2, (FlxG.height - text.height) / 2);
		
		add(back);
		add(text);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		var next = FlxG.keys.anyJustPressed(["UP", "DOWN", "LEFT", "RIGHT"]);
		
		if (next)
			FlxG.switchState(new PlayState());
	}
	
}