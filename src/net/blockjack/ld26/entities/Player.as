package net.blockjack.ld26.entities 
{
	import net.blockjack.ld26.Main;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class Player extends FlxSprite
	{
		[Embed(source = "../../../../../assets/gfx/entities/Player.png")]
		private const playerPNG:Class;
		
		private static const WIDTH:Number = 8;
		private static const HEIGHT:Number = 8;
		
		private static const ANIM_IDLE:String = "idle";
		
		private var speed:Number;
		private static const BASE_SPEED:Number = 0.5;
		private var canJump:Boolean;
		private var jump:Number;
		
		public function Player() 
		{
			loadAnimations();
			
			reset(0, 0);
		}
		
		private function loadAnimations():void {
			loadGraphic(playerPNG, true, true, WIDTH, HEIGHT);
			addAnimation(ANIM_IDLE, [0], 0, true);
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			jump = 0;
			velocity.y = 0;
			acceleration.y = 150;
			maxVelocity.y = 55;
			speed = BASE_SPEED;
			
			play(ANIM_IDLE);
		}
		
		override public function update():void {
			boundaryCheck();
			jumpCheck();
			
			x += speed;
			
			super.update();
		}
		
		private function boundaryCheck():void {
			// collide with left/right play area
			if (x > Main.SWF_WIDTH - width) {
				speed = -speed;
				x = Main.SWF_WIDTH - width;
			}
			else if (x < 0) {
				speed = -speed;
				x = 0;
			}
			
			// collide with walls
			if (isTouching(FlxObject.RIGHT) || isTouching(FlxObject.LEFT)) {
				speed = -speed;
			}
			
			// collide with floor
			if (isTouching(FlxObject.DOWN)) {
				canJump = true;
				jump = 0;
			}
			
			// off bottom of screen = kill
			if (y > Main.SWF_HEIGHT - height && alive) {
				y = Main.SWF_HEIGHT - height;
				velocity.y = 0;
				
				//kill();
			}
		}
		
		private function jumpCheck():void {
			//if (FlxG.keys.justPressed("SPACE") && canJump) {
				//velocity.y = -60;
				//canJump = false;
			//}
			if (jump >= 0 && FlxG.keys.SPACE) {
				jump += FlxG.elapsed;
				if (jump > 0.25) {
					jump = -1;
				}
			}
			else {
				jump = -1;
			}
			
			if (jump > 0) {
				if (jump < 0.2) {
					velocity.y = -0.6 * maxVelocity.y;
				}
				else {
					velocity.y = -1 * maxVelocity.y;
				}
			}
		}
		
	}

}