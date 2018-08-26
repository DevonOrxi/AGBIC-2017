package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import interfaces.IColorSwappable;
import interfaces.IMapCollidable;

/**
 * ...
 * @author A. Cid
 */
class BaseEntity extends FlxSprite implements IColorSwappable implements IMapCollidable {	
	
	public var warped(get, null):Bool;
	
	public function handleCollisionWithMap() {}
	public function setColors() {}
	
	public function getFootingPos():Array<FlxPoint> {
		var footX = x;
		var footY = y + (warped ? -1 : height);
		
		return [
			FlxPoint.weak(footX, footY),
			FlxPoint.weak(footX + width - 1, footY)
		];
	}
	
	function get_warped():Bool {
		return warped;
	}
}