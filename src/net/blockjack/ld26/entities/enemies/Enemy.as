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
		[Embed(source="../../../../../../assets/gfx/entities/enemies/Enemy.png")]
		private const EnemyPNG:Class;
		
		private static const WIDTH:Number = 8;
		private static const HEIGHT:Number = 8;
		
		private static const ANIM_WALK:String = "walk";
		
		private var speed:Number;
		private const BASE_SPEED:Number = -0.2;
		private const JUMP_SPEED:Number = 55;
		
		public function Enemy() 
		{
			loadAnimations();
			
			reset(0, 0);
		}
		
		private function loadAnimations():void {
			loadGraphic(EnemyPNG, true, true, WIDTH, HEIGHT);
			addAnimation(ANIM_WALK, [0, 1], 20, true);
		}
		
		override public function update():void {
			super.update();
			
			boundaryCheck();
			move();
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
			if (isTouching(RIGHT) || isTouching(LEFT)) {
				turnAround();
			}
			
			// nearing a platform edge
			if (facing == LEFT && !Registry.engine.levelOverlapsPoint(x, y + height)) {
				turnAround();
			}
			else if (facing == RIGHT && !Registry.engine.levelOverlapsPoint(x + width, y + height)) {
				turnAround();
			}
			
			// off bottom of screen
			if (y > Main.SWF_HEIGHT - height && alive) {
				y = Main.SWF_HEIGHT - height;
				velocity.y = 0;
			}
		}
		
		private function move():void {
			x += speed;
		}
		
		private function turnAround():void {
			speed = -speed;
			
			if (facing == RIGHT) {
				facing = LEFT;
			}
			else {
				facing = RIGHT;
			}
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			acceleration.y = Level.GRAVITY;
			maxVelocity.y = JUMP_SPEED;
			speed = BASE_SPEED;
			facing = LEFT;
			
			play(ANIM_WALK);
		}
		
	}

}