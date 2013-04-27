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
	public class Bullet extends Enemy
	{
		[Embed(source="../../../../../../assets/gfx/entities/enemies/Bullet.png")]
		private const EnemyPNG:Class;
		
		private static const ANIM_FIRE_LEFT:String = "fireLeft";
		private static const ANIM_FIRE_RIGHT:String = "fireRight";
		private static const ANIM_FIRE_UP:String = "fireUp";
		private static const ANIM_FIRE_DOWN:String = "fireDown";
		private static const ANIM_HIT:String = "hit";
		
		private const BASE_SPEED:Number = 50;
		
		protected const WIDTH:Number = 3;
		protected const HEIGHT:Number = 3;
		
		public function Bullet() 
		{
			loadAnimations();
			
			reset(0, 0);
		}
		
		private function loadAnimations():void {
			loadGraphic(EnemyPNG, true, false, WIDTH, HEIGHT);
			addAnimation(ANIM_FIRE_LEFT, [0, 1], 20, true);
			addAnimation(ANIM_FIRE_RIGHT, [2, 3], 20, true);
			addAnimation(ANIM_FIRE_UP, [4, 5], 20, true);
			addAnimation(ANIM_FIRE_DOWN, [6, 7], 20, true);
			addAnimation(ANIM_HIT, [8, 9], 20, false);
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			acceleration.y = 0;
		}
		
		public function setDirection(facing:uint):void {
			this.facing = facing;
			
			switch(facing) {
				case LEFT:
					velocity.x = -BASE_SPEED;
					play(ANIM_FIRE_LEFT);
					break;
				case RIGHT:
					velocity.x = BASE_SPEED;
					play(ANIM_FIRE_RIGHT);
					break;
				case UP:
					velocity.y = -BASE_SPEED;
					play(ANIM_FIRE_UP);
					break;
				case DOWN:
					velocity.y = BASE_SPEED;
					play(ANIM_FIRE_DOWN);
					break;
			}
		}
		
		override public function update():void {
			super.update();
			if (finished && !alive) {
				super.kill();
			}
		}
		
		override public function kill():void {
			play(ANIM_HIT);
			alive = false;
			velocity.x = 0;
		}
		
	}

}