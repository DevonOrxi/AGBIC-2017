package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.addons.util.FlxFSM.FlxFSMState;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author A. Cid
 */
 
class PlayerBackup extends FlxSprite
{
	private var fsm:FlxFSM<Player>;
	public var isWarping(get, null):Bool = false;
	public var redPart(get, null):FlxSprite;
	public var whitePart(get, null):FlxSprite;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		acceleration.y = Reg.playerGravity;
		
		makeGraphic(16, 16, 0x00000000);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		facing = FlxObject.RIGHT;
		setSize(8, 13);
		
		redPart = new FlxSprite(x, y);
		redPart.loadGraphic(AssetPaths.charRedPart__png, true, 16, 16);
		redPart.animation.add("idle", [0, 1, 2, 3], 6, true);
		redPart.animation.add("hurt", [4], 12, false);
		redPart.animation.add("run", [5, 6, 7], 6, true);
		redPart.animation.add("jump", [8], 6, false);
		redPart.animation.add("fall", [9], 6, false);
		redPart.setFacingFlip(FlxObject.LEFT, true, false);
		redPart.setFacingFlip(FlxObject.RIGHT, false, false);
		redPart.setSize(8, 13);
		redPart.facing = FlxObject.RIGHT;
		redPart.color = 0xED1E24;

		whitePart = new FlxSprite(x, y);
		whitePart.loadGraphic(AssetPaths.charWhitePart__png, true, 16, 16);
		whitePart.animation.add("idle", [0, 1, 2, 3], 6, true);
		whitePart.animation.add("hurt", [4], 6, false);
		whitePart.animation.add("run", [5, 6, 7], 6, true);
		whitePart.animation.add("jump", [8], 6, false);
		whitePart.animation.add("fall", [9], 6, false);
		whitePart.setFacingFlip(FlxObject.LEFT, true, false);
		whitePart.setFacingFlip(FlxObject.RIGHT, false, false);
		whitePart.setSize(8, 13);
		whitePart.facing = FlxObject.RIGHT;
		whitePart.color = 0xFFFFFF;		
		
		adjustBox();
		
		fsm = new FlxFSM<Player>(this);
		fsm.transitions
			.add(Standing, Jumping, Conditions.airborne)
			.add(Jumping, Standing, Conditions.grounded)
			.add(Standing, Warping, Conditions.warping)
			.add(Warping, Standing, Conditions.warpFinished)
			.start(Standing);
	}
	
	override public function update(elapsed:Float):Void 
	{
		fsm.update(elapsed);
		
		adjustBox();
		redPart.x = x;
		whitePart.x = x;
		redPart.y = y;
		whitePart.y = y;
		
		super.update(elapsed);
	}
	
	public function switchWarp():Void
	{
		isWarping = !isWarping;
	}
	
	public function playAnim(name:String):Void
	{
		redPart.animation.play(name);
		whitePart.animation.play(name);
	}
	
	public function setFacing(direction:Int):Void
	{
		facing = direction;
		redPart.facing = facing;
		whitePart.facing = facing;
	}
	
	public function startWarpTweens():Void
	{
		FlxTween.tween(this, {y: y + 16 * scale.y}, Reg.warpTime);
		FlxTween.tween(scale, {y: 0}, Reg.warpTime / 2, {onComplete: halfTween});
		FlxTween.tween(whitePart.scale, {y: -whitePart.scale.y}, Reg.warpTime);
		FlxTween.tween(redPart.scale, {y: -redPart.scale.y}, Reg.warpTime);
	}
	
	private function adjustBox():Void
	{
		var hor:Float = (facing == FlxObject.RIGHT ? Reg.boxOffsetX : frameWidth - (Reg.boxOffsetX + width));
		var ver:Float = (!Reg.isWarped ? Reg.boxOffsetY : frameHeight - (Reg.boxOffsetY + height));
		
		offset.set(hor, ver);
		whitePart.offset.set(hor, ver);
		redPart.offset.set(hor, ver);
	}
	
	private function halfTween(tween:FlxTween):Void
	{
		var tempColor:FlxColor = redPart.color;
		redPart.color = whitePart.color;
		whitePart.color = tempColor;		
		FlxTween.tween(scale, {y: Reg.isWarped ? -1 : 1}, Reg.warpTime / 2, {onComplete: fullTween});
	}
	
	private function fullTween(tween:FlxTween):Void
	{
		switchWarp();
	}
	
	function get_isWarping():Bool 
	{
		return isWarping;
	}

	function get_redPart():FlxSprite
	{
		return redPart;
	}

	function get_whitePart():FlxSprite
	{
		return whitePart;
	}
}

class Conditions {
	public static function airborne(owner:Player):Bool
	{
		return (!owner.isTouching(Reg.isWarped ? FlxObject.UP : FlxObject.DOWN));
	}
	
	public static function grounded(owner:Player):Bool
	{
		return (owner.isTouching(Reg.isWarped ? FlxObject.UP : FlxObject.DOWN));
	}
	
	public static function warping(owner:Player):Bool
	{
		return (grounded(owner) && (FlxG.keys.justPressed.UP && Reg.isWarped) || (FlxG.keys.justPressed.DOWN && !Reg.isWarped));
	}
	
	public static function warpFinished(owner:Player):Bool
	{
		return (!owner.isWarping);
	}
}
class Standing extends FlxFSMState<Player> {
	override public function enter(owner:Player, fsm:FlxFSM<Player>):Void 
	{
		checkRun(owner);
	}
	
	override public function update(elapsed:Float, owner:Player, fsm:FlxFSM<Player>):Void 
	{
		owner.velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT)
			owner.velocity.x += Reg.playerVelX;
		if (FlxG.keys.pressed.LEFT)
			owner.velocity.x -= Reg.playerVelX;
		
		checkRun(owner);
		
		if ((FlxG.keys.justPressed.UP && !Reg.isWarped) || (FlxG.keys.justPressed.DOWN && Reg.isWarped))
			owner.velocity.y = Reg.playerJumpForce;
	}
	
	private function checkRun(owner:Player):Void
	{
		owner.playAnim(owner.velocity.x != 0 ? "run" : "idle");
		owner.setFacing(owner.velocity.x > 0 ? FlxObject.RIGHT : (owner.velocity.x < 0 ? FlxObject.LEFT : owner.facing));
	}
}
class Jumping extends FlxFSMState<Player> {
	override public function enter(owner:Player, fsm:FlxFSM<Player>):Void 
	{
		owner.playAnim(owner.velocity.y > 0 ? "fall" : (owner.velocity.y < 0 ? "jump" : owner.redPart.animation.name));
	}
	
	override public function update(elapsed:Float, owner:Player, fsm:FlxFSM<Player>):Void 
	{
		owner.velocity.x = 0;
		
		if (FlxG.keys.pressed.RIGHT)
			owner.velocity.x += Reg.playerVelX;
		if (FlxG.keys.pressed.LEFT)
			owner.velocity.x -= Reg.playerVelX;
		
		var anim:String;
		if (owner.velocity.y > 0) 
		{
			if (!Reg.isWarped)
				anim = "fall";
			else
				anim = "jump";
		}
		else if (owner.velocity.y < 0)
		{
			if (Reg.isWarped)
				anim = "fall";
			else
				anim = "jump";
		}
		else
			anim = owner.redPart.animation.name;
		
		owner.playAnim(anim);
		owner.setFacing(owner.velocity.x > 0 ? FlxObject.RIGHT : (owner.velocity.x < 0 ? FlxObject.LEFT : owner.facing));
	}
}
class Warping extends FlxFSMState<Player> {
	private var localWarping:Bool;
	private var halfWarp:Bool;
	
	override public function enter(owner:Player, fsm:FlxFSM<Player>):Void 
	{
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
	
	override public function exit(owner:Player):Void 
	{
		owner.acceleration.y = Reg.playerGravity;
	}
}
