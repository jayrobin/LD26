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
	public class Jumper extends Enemy
	{
		[Embed(source="../../../../../../assets/gfx/entities/enemies/Jumper.png")]
		private const EnemyPNG:Class;
		
		[Embed(source = "../../../../../../assets/snd/enemyJump.mp3")]
		private const enemyJumpSND:Class;
		
		private static const ANIM_IDLE:String = "idle";
		private static const ANIM_JUMPING:String = "jumping";
		
		private var jumpDelay:Number;
		private const MAX_JUMP_DELAY:Number = 2;
		
		public function Jumper() 
		{
			loadAnimations();
			
			reset(0, 0);
		}
		
		private function loadAnimations():void {
			loadGraphic(EnemyPNG, true, true, WIDTH, HEIGHT);
			addAnimation(ANIM_IDLE, [0], 20, true);
			addAnimation(ANIM_JUMPING, [0, 1, 2], 10, false);
		}
		
		override public function update():void {
			super.update();
			move();
		}
		
		private function move():void {
			if(jumpDelay > MAX_JUMP_DELAY) {
				velocity.y = -maxVelocity.y;
				play(ANIM_JUMPING);
				jumpDelay = 0;
				FlxG.play(enemyJumpSND);
			}
			else if (isTouching(DOWN)) {
				jumpDelay += FlxG.elapsed;
				play(ANIM_IDLE);
			}
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			jumpDelay = 0;
			play(ANIM_IDLE);
		}
		
	}

}