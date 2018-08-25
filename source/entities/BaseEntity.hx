package entities;

import flixel.FlxSprite;
import interfaces.IColorSwappable;
import interfaces.IMapCollidable;

/**
 * ...
 * @author A. Cid
 */
class BaseEntity extends FlxSprite implements IColorSwappable implements IMapCollidable {	
	public function collisionHandlerWithMap() {}
	public function setColors() {}	
}