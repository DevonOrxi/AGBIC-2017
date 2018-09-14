package entities;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.addons.util.FlxFSM.FlxFSMState;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import interfaces.IColorSwappable;
import Reg.WarpStatus;

/**
 * ...
 * @author A. Cid
 */
 
class Player extends BaseEntity {
	
	private var fsm:FlxFSM<Player>;
	public var isWarping(get, null):Bool = false;
	
	public var leftFoot:FlxSprite;
	public var rightFoot:FlxSprite;

	public function new(?X:Float=0, ?Y:Float=0, ?startWarped:Bool=false, ?goingRight:Bool=true)  {
		super(X, Y);
		
		loadGraphic(AssetPaths.charRedPart__png, true, Reg.tileWidth, Reg.tileHeight);
		animation.add("idle", [0, 1, 2, 3], 6, true);
		animation.add("hurt", [4], 6, false);
		animation.add("run", [5, 6, 7], 6, true);
		animation.add("jump", [8], 6, false);
		animation.add("fall", [9], 6, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setSize(8, 13);
		facing = FlxObject.RIGHT;
		warped = startWarped;
		acceleration.y = Reg.playerGravity * warpMultiplier;
		
		setColors();
		adjustBox();
		
		fsm = new FlxFSM<Player>(this);
		fsm.transitions
			.add(Standing, Jumping, PlayerConditions.airborne)
			.add(Jumping, Standing, PlayerConditions.grounded)
			.add(Standing, Warping, PlayerConditions.warping)
			.add(Warping, Standing, PlayerConditions.warpFinished)
			.start(Standing);
	}
	
	override public function update(elapsed:Float):Void {
		fsm.update(elapsed);
		adjustBox();
		
		super.update(elapsed);
	}
	
	public function switchWarping():Void {
		isWarping = !isWarping;
	}
	
	public function switchWarped():Void {
		warped = !warped;
	}
	
	public function playAnim(name:String):Void {
		animation.play(name);
	}
	
	public function setFacing(direction:Int):Void {
		facing = direction;
	}
	
	public function startWarpTweens():Void {
		FlxTween.tween(this, {y: y + height * scale.y}, Reg.warpTime);
		FlxTween.tween(scale, {y: 0}, Reg.warpTime / 2, {onComplete: halfTween});
	}
	
	private function adjustBox():Void {
		var hor:Float = facing == FlxObject.RIGHT ? Reg.boxOffsetX : frameWidth - (Reg.boxOffsetX + width);
		var ver:Float = !warped ? Reg.boxOffsetY : frameHeight - (Reg.boxOffsetY + height);
		
		offset.set(hor, ver);
	}
	
	private function halfTween(tween:FlxTween):Void {
		setColors();
		FlxTween.tween(scale, {y: warpMultiplier}, Reg.warpTime / 2, {onComplete: fullTween});
	}
	
	private function fullTween(tween:FlxTween):Void {
		switchWarping();
	}
	
	override public function setColors() {
		color = warped ? Reg.colorPalette.colorFront : Reg.colorPalette.colorBack;
	}
	
	function get_isWarping():Bool {
		return isWarping;
	}
}

class PlayerConditions {
	
	public static function airborne(owner:Player):Bool {
		return (!grounded(owner));
	}
	
	public static function grounded(owner:Player):Bool {
		return (owner.isTouching(owner.warped ? FlxObject.UP : FlxObject.DOWN));
	}
	
	public static function warping(owner:Player):Bool {
		return (
			grounded(owner) &&
			Reg.warpStatus == WarpStatus.WARP_STATIC &&	(
				(FlxG.keys.justPressed.UP && owner.warped) ||
				(FlxG.keys.justPressed.DOWN && !owner.warped)
			)
		);
	}
	
	public static function warpFinished(owner:Player):Bool {
		return (!owner.isWarping);
	}
}
class Standing extends FlxFSMState<Player> {
	
	override public function enter(owner:Player, fsm:FlxFSM<Player>):Void {
		checkRun(owner);
	}
	
	override public function update(elapsed:Float, owner:Player, fsm:FlxFSM<Player>):Void {
		owner.velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT)
			owner.velocity.x += Reg.playerVelX;
		if (FlxG.keys.pressed.LEFT)
			owner.velocity.x -= Reg.playerVelX;
		
		checkRun(owner);
		
		if ((FlxG.keys.justPressed.UP && !owner.warped) || (FlxG.keys.justPressed.DOWN && owner.warped)) {
			owner.velocity.y = Reg.playerJumpForce * owner.warpMultiplier;
			FlxG.sound.play(AssetPaths.jump__ogg, 0.6);
		}
	}
	
	private function checkRun(owner:Player):Void {
		owner.playAnim(owner.velocity.x != 0 ? "run" : "idle");
		owner.setFacing(owner.velocity.x > 0 ? FlxObject.RIGHT : (owner.velocity.x < 0 ? FlxObject.LEFT : owner.facing));
	}
}
class Jumping extends FlxFSMState<Player> {
	
	override public function enter(owner:Player, fsm:FlxFSM<Player>):Void {
		owner.playAnim(owner.velocity.y > 0 ? "fall" : (owner.velocity.y < 0 ? "jump" : owner.animation.name));
	}
	
	override public function update(elapsed:Float, owner:Player, fsm:FlxFSM<Player>):Void {
		owner.velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT)
			owner.velocity.x += Reg.playerVelX;
		if (FlxG.keys.pressed.LEFT)
			owner.velocity.x -= Reg.playerVelX;
		
		var anim:String = owner.animation.name;
		
		if (owner.velocity.y != 0) {
			if (!owner.warped)
				anim = owner.velocity.y < 0 ? "jump" : "fall";
			else
				anim = owner.velocity.y < 0 ? "fall" : "jump";
		}
		
		owner.playAnim(anim);
		owner.setFacing(owner.velocity.x > 0 ? FlxObject.RIGHT : (owner.velocity.x < 0 ? FlxObject.LEFT : owner.facing));
	}
}
class Warping extends FlxFSMState<Player> {
	
	private var localWarping:Bool;
	private var halfWarp:Bool;
	
	override public function enter(owner:Player, fsm:FlxFSM<Player>):Void {
		localWarping = true;
		halfWarp = false;
		owner.switchWarped();
		owner.switchWarping();
		owner.animation.pause();
		owner.velocity.set(0, 0);
		owner.acceleration.y = 0;
		owner.startWarpTweens();
	}
	
	override public function exit(owner:Player):Void {
		owner.acceleration.y = Reg.playerGravity * owner.warpMultiplier;
	}
}
