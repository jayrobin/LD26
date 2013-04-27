package net.blockjack.ld26.entities.enemies 
{
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import net.blockjack.ld26.world.Level;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class Bouncer extends Enemy
	{
		[Embed(source="../../../../../../assets/gfx/entities/enemies/Bouncer.png")]
		private const EnemyPNG:Class;
		
		private static const ANIM_IDLE:String = "idle";
		private static const ANIM_JUMPING:String = "jumping";
		
		private var jumpDelay:Number;
		private const MAX_JUMP_DELAY:Number = 2;
		
		public function Bouncer() 
		{
			loadAnimations();
			
			reset(0, 0);
		}
		
		private function loadAnimations():void {
			loadGraphic(EnemyPNG, true, true, WIDTH, HEIGHT);
			addAnimation(ANIM_IDLE, [0], 20, true);
			addAnimation(ANIM_JUMPING, [0, 1], 20, false);
		}
		
		override public function update():void {
			super.update();
			move();
		}
		
		private function move():void {
			if (jumpDelay > MAX_JUMP_DELAY) {
				if (facing == LEFT) {
					velocity.x = -50;
					facing = RIGHT;
				}
				else {
					velocity.x = 50;
					facing = LEFT;
				}
				velocity.y = -1 * maxVelocity.y;
				play(ANIM_JUMPING);
				jumpDelay = 0;
			}
			else if (isTouching(DOWN)) {
				jumpDelay += FlxG.elapsed;
				play(ANIM_IDLE);
				velocity.x = 0;
			}
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			jumpDelay = 0;
			maxVelocity.x = maxVelocity.y;
			play(ANIM_IDLE);
		}
		
	}

}