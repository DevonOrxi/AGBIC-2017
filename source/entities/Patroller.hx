package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import interfaces.IColorSwappable;

/**
 * ...
 * @author A. Cid
 */
class Patroller extends BaseEntity {
	
	public var isFlipping(get, null):Bool = false;
	private var goingRight:Bool = false;
	
	
	public function new(?X:Float=0, ?Y:Float=0, ?isGoingRight:Bool=false, ?isWarped:Bool=false) {
		super(X, Y);
		
		loadGraphic(AssetPaths.enemy__png, true, 16, 16);
		animation.add("walk", [0, 1, 2, 3, 4, 5], 6);
		animation.play("walk");
		
		goingRight = isGoingRight;
		setProperHorizontalVelocity();
		scale.x = -goingRightMultiplier();
		
		
		warped = isWarped;
		setSize(12, 13);
		offset.set(2, warped ? 0 : 3);
		scale.y = warpMultiplier;
		
		setColors();
	}
	
	override public function setColors() {
		color = warped ? Reg.colorPalette.colorFront : Reg.colorPalette.colorBack;
	}
	
	override public function handleCollisionWithMap() {
		if (!isFlipping) {
			isFlipping = true;
			goingRight = !goingRight;
			FlxTween.tween(scale, {x: -goingRightMultiplier()}, 0.2, {onComplete: collideFlipFinished});
			velocity.x = 0;
		}
	}
	
	private function collideFlipFinished(tween:FlxTween) {
		isFlipping = false;
		setProperHorizontalVelocity();
	}
	
	private function setProperHorizontalVelocity() {
		velocity.x = Reg.patrollerVelX * goingRightMultiplier();
	}
	
	private function goingRightMultiplier():Int {
		return (goingRight ? 1 : -1);
	}
	
	function get_isFlipping():Bool 
	{
		return isFlipping;
	}
	
}