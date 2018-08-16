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
 
class Player extends FlxSprite implements IColorSwappable {
	
	private var fsm:FlxFSM<Player>;
	public var isWarping(get, null):Bool = false;
	
	public var leftFoot:FlxSprite;
	public var rightFoot:FlxSprite;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)  {
		super(X, Y, SimpleGraphic);
		
		acceleration.y = Reg.playerGravity;
		
		leftFoot = new FlxSprite();
		rightFoot = new FlxSprite();
		leftFoot.makeGraphic(1, 1, 0xFF0000FF);
		rightFoot.makeGraphic(1, 1, 0xFF0000FF);
		
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
		
		setColors();		
		adjustBox();
		
		fsm = new FlxFSM<Player>(this);
		fsm.transitions
			.add(Standing, Jumping, Conditions.airborne)
			.add(Jumping, Standing, Conditions.grounded)
			.add(Standing, Warping, Conditions.warping)
			.add(Warping, Standing, Conditions.warpFinished)
			.start(Standing);
	}
	
	override public function update(elapsed:Float):Void {
		fsm.update(elapsed);
		adjustBox();
		
		super.update(elapsed);
		
		var feet = getFootingPos();
		leftFoot.setPosition(feet[0].x, feet[0].y);
		rightFoot.setPosition(feet[1].x, feet[1].y);
	}
	
	public function switchWarp():Void {
		isWarping = !isWarping;
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
		var ver:Float = !Reg.isWarped ? Reg.boxOffsetY : frameHeight - (Reg.boxOffsetY + height);
		
		offset.set(hor, ver);
	}
	
	private function halfTween(tween:FlxTween):Void {
		setColors();
		FlxTween.tween(scale, {y: Reg.warpMultiplier}, Reg.warpTime / 2, {onComplete: fullTween});
	}
	
	private function fullTween(tween:FlxTween):Void {
		switchWarp();
	}
	
	public function setColors() {
		color = Reg.isWarped ? Reg.colorPalette.colorFront : Reg.colorPalette.colorBack;
	}
	
	public function getFootingPos():Array<FlxPoint> {
		var footX = x;
		var footY = y + (Reg.isWarped ? -1 : height);
		
		return [
			FlxPoint.weak(footX, footY),
			FlxPoint.weak(footX + width - 1, footY)
		];
	}
	
	function get_isWarping():Bool {
		return isWarping;
	}
}

class Conditions {
	
	public static function airborne(owner:Player):Bool {
		return (!grounded(owner));
	}
	
	public static function grounded(owner:Player):Bool {
		return (owner.isTouching(Reg.isWarped ? FlxObject.UP : FlxObject.DOWN));
	}
	
	public static function warping(owner:Player):Bool {
		return (grounded(owner) /*&& Reg.warpStatus == WarpStatus.WARP_STATIC*/ && (FlxG.keys.justPressed.UP && Reg.isWarped) || (FlxG.keys.justPressed.DOWN && !Reg.isWarped));
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
		
		if ((FlxG.keys.justPressed.UP && !Reg.isWarped) || (FlxG.keys.justPressed.DOWN && Reg.isWarped))
			owner.velocity.y = Reg.playerJumpForce;
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
			if (!Reg.isWarped)
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
		Reg.isWarped = !Reg.isWarped;
		owner.switchWarp();
		owner.animation.pause();
		owner.velocity.set(0, 0);
		owner.acceleration.y = 0;
		
		Reg.playerGravity *= -1;
		Reg.playerJumpForce *= -1;
		owner.startWarpTweens();
	}
	
	override public function exit(owner:Player):Void {
		owner.acceleration.y = Reg.playerGravity;
	}
}
