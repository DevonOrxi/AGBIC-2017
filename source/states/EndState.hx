package states;

import flixel.FlxG;
import flixel.FlxSprite;
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
		
		Reg.initExternalData();
		
		var back = new FlxSprite();
		var text = new FlxText(0, 0, 0, "THANKS FOR PLAYING!", 32);
		back.makeGraphic(FlxG.width, FlxG.height);
		back.color = Reg.colorPalette.colorBack;
		text.font = AssetPaths.m6x11__ttf;
		text.color = Reg.colorPalette.colorFront;
		text.setPosition((FlxG.width - text.width) / 2, (FlxG.height - text.height) / 2);
		
		add(back);
		add(text);
	}
	
}