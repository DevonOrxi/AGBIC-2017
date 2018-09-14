package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import managers.ColorPaletteManager;

/**
 * ...
 * @author Ariel Cid
 */
class EndState extends FlxUIState 
{

	override public function create():Void {
		super.create();
		
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		
		Reg.initExternalData();
		
		var back = new FlxSprite();
		var text = new FlxText(0, 0, 0, "THANKS FOR PLAYING", 32);
		var text2 = new FlxText(0, 0, 0, "(MORE LEVELS COMING SOON)", 16);
		back.makeGraphic(FlxG.width, FlxG.height);
		back.color = Reg.colorPalette.colorBack;
		text.font = AssetPaths.m6x11__ttf;
		text.color = Reg.colorPalette.colorFront;
		text.setPosition((FlxG.width - text.width) / 2, (FlxG.height - text.height) / 2 - 16);
		text2.font = AssetPaths.m6x11__ttf;
		text2.color = Reg.colorPalette.colorFront;
		text2.setPosition((FlxG.width - text2.width) / 2, (FlxG.height - text2.height) / 2 + 16);
		
		add(back);
		add(text);
		add(text2);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
	
}