package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import interfaces.IColorSwappable;

/**
 * ...
 * @author A. Cid
 */
class Goal extends BaseEntity
{

	public function new(?X:Float=0, ?Y:Float=0, ?isWarped:Bool=false) 
	{
		super(X, Y);
		
		warped = isWarped;
		loadGraphic(AssetPaths.goal__png, true, Reg.tileWidth, Reg.tileHeight);
		animation.add("whoa", [0, 1, 2, 3], 4, true);
		animation.play("whoa");
		
		width = 12;
		height = 12;
		offset.set(2, 2);
		x += 2;
		y += 2;
		
		setColors();
	}
	
	override public function setColors() {
		color = warped ? Reg.colorPalette.colorFront : Reg.colorPalette.colorBack;
	}
	
	override public function handleCollisionWithMap() {}
	
}