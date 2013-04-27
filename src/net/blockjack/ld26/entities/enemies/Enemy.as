package net.blockjack.ld26.entities.enemies 
{
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import net.blockjack.ld26.world.Level;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class Enemy extends FlxSprite
	{
		protected var speed:Number;
		protected const JUMP_SPEED:Number = 55;
		
		protected static const WIDTH:Number = 8;
		protected static const HEIGHT:Number = 8;
		
		override public function update():void {
			super.update();
			
			boundaryCheck();
		}
		
		protected function boundaryCheck():void {
			// collide with walls
			if (isTouching(RIGHT) || isTouching(LEFT)) {
				turnAround();
			}
		}
		
		protected function turnAround():void {
			speed = -speed;
			
			if (facing == RIGHT) {
				facing = LEFT;
			}
			else {
				facing = RIGHT;
			}
			
			velocity.x = -velocity.x;
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			acceleration.y = Level.GRAVITY;
			maxVelocity.y = JUMP_SPEED;
			facing = LEFT;
		}
		
	}

}