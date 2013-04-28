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
	public class Sticker extends Enemy
	{
		[Embed(source="../../../../../../assets/gfx/entities/enemies/Sticker.png")]
		private const EnemyPNG:Class;
		
		[Embed(source = "../../../../../../assets/snd/enemyJump.mp3")]
		private const enemyJumpSND:Class;
		
		private static const ANIM_IDLE_UP:String = "idleUp";
		private static const ANIM_IDLE_DOWN:String = "idleDown";
		private static const ANIM_JUMPING:String = "jumping";
		
		private var jumpDelay:Number;
		private const MAX_JUMP_DELAY:Number = 2;
		
		public function Sticker() 
		{
			loadAnimations();
			
			reset(0, 0);
		}
		
		private function loadAnimations():void {
			loadGraphic(EnemyPNG, true, true, WIDTH, HEIGHT);
			addAnimation(ANIM_IDLE_DOWN, [2, 0], 20, false);
			addAnimation(ANIM_IDLE_UP, [2, 3], 20, false);
			addAnimation(ANIM_JUMPING, [1, 2], 20, false);
		}
		
		override public function update():void {
			super.update();
			move();
		}
		
		private function move():void {
			jumpDelay += FlxG.elapsed;
			
			if (jumpDelay > MAX_JUMP_DELAY) {
				if(facing == UP) {
					velocity.y = -maxVelocity.y;
					facing = DOWN;
				}
				else {
					velocity.y = maxVelocity.y;
					facing = UP;
				}
				
				play(ANIM_JUMPING);
				jumpDelay = 0;
				FlxG.play(enemyJumpSND);
			}
			else if (justTouched(DOWN)) {
				acceleration.y = 0;
				play(ANIM_IDLE_DOWN);
			}
			else if (justTouched(UP)) {
				acceleration.y = 0;
				play(ANIM_IDLE_UP);
			}
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			facing = UP;
			jumpDelay = 0;
			play(ANIM_IDLE_UP);
		}
		
	}

}