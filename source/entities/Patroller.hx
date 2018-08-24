package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import interfaces.IColorSwappable;

/**
 * ...
 * @author A. Cid
 */
class Patroller extends FlxSprite implements IColorSwappable {

	private var warped:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, ?goingRight:Bool=true, ?isWarped:Bool=false) {
		super(X, Y);
		
		loadGraphic(AssetPaths.enemy__png, true, 16, 16);
		animation.add("walk", [0, 1, 2, 3, 4, 5], 6);
		animation.play("walk");
		
		velocity.x = Reg.patrollerVelX * (goingRight ? 1 : -1);
		warped = isWarped;
		setColors();
	}
	
	public function setColors() {
		color = warped ? Reg.colorPalette.colorFront : Reg.colorPalette.colorBack;
	}
	
	
	
}