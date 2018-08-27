package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import interfaces.IColorSwappable;

/**
 * ...
 * @author A. Cid
 */
class Goal extends FlxSprite implements IColorSwappable
{
	private var warped:Bool = false;

	public function new(?X:Float=0, ?Y:Float=0, ?isWarped:Bool=false) 
	{
		super(X, Y);
		
		warped = isWarped;
		loadGraphic(AssetPaths.goal__png, true, Reg.tileWidth, Reg.tileHeight);
		animation.add("whoa", [0, 1, 2, 3], 4, true);
		animation.play("whoa");
		
		setColors();
	}
	
	public function setColors() {
		color = warped ? Reg.colorPalette.colorFront : Reg.colorPalette.colorBack;
	}
	
}