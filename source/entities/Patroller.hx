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

	private var warped:Bool = false;
	private var isWarping:Bool = false;
	private var goingRight:Bool = false;
	private var goingRightMultiplier(get, null):Int;
	
	public function new(?X:Float=0, ?Y:Float=0, ?isGoingRight:Bool=false, ?isWarped:Bool=false) {
		super(X, Y);
		
		loadGraphic(AssetPaths.enemy__png, true, 16, 16);
		animation.add("walk", [0, 1, 2, 3, 4, 5], 6);
		animation.play("walk");
		
		goingRight = isGoingRight;
		setProperHorizontalVelocity();
		scale.x = -goingRightMultiplier;
		warped = isWarped;
		setColors();
	}
	
	override public function setColors() {
		color = warped ? Reg.colorPalette.colorFront : Reg.colorPalette.colorBack;
	}
	
	override public function collisionHandlerWithMap() {
		if (!isWarping) {
			isWarping = true;
			goingRight = !goingRight;
			FlxTween.tween(scale, {x: -goingRightMultiplier}, 0.2, {onComplete: collideFlipFinished});
			velocity.x = 0;
		}
	}
	
	private function collideFlipFinished(tween:FlxTween) {
		isWarping = false;
		setProperHorizontalVelocity();
	}
	
	private function setProperHorizontalVelocity() {
		velocity.x = Reg.patrollerVelX * goingRightMultiplier;
	}
	
	function get_goingRightMultiplier():Int {
		return (goingRight ? 1 : -1);
	}
	
}