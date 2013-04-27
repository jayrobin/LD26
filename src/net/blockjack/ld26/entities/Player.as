package net.blockjack.ld26.entities 
{
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import net.blockjack.ld26.world.Level;
	import org.flixel.FlxEmitter;
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
		
		private var gibs:FlxEmitter;
		
		private static const WIDTH:Number = 8;
		private static const HEIGHT:Number = 8;
		
		private static const ANIM_IDLE:String = "idle";
		private static const ANIM_RUN:String = "run";
		private static const ANIM_JUMPING:String = "jump";
		
		private var speed:Number;
		private const BASE_SPEED:Number = 0.5;
		
		private var jump:Number;
		private const JUMP_SPEED:Number = 55;
		
		private var fallTime:Number;
		private const MAX_FALL_TIME:Number = 1;
		
		public function Player(gibs:FlxEmitter) 
		{
			this.gibs = gibs;
			
			loadAnimations();
			
			reset(0, 0);
		}
		
		private function loadAnimations():void {
			loadGraphic(playerPNG, true, true, WIDTH, HEIGHT);
			addAnimation(ANIM_IDLE, [0], 0, true);
			addAnimation(ANIM_RUN, [0, 1, 2, 1, 0, 3, 4, 3], 60, true);
			addAnimation(ANIM_JUMPING, [5], 0, true);
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			jump = 0;
			velocity.y = 0;
			acceleration.y = Level.GRAVITY;
			maxVelocity.y = JUMP_SPEED;
			speed = BASE_SPEED;
			fallTime = 0;
			
			play(ANIM_RUN);
		}
		
		override public function update():void {
			boundaryCheck();
			jumpCheck();
			move();
			
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
			if (isTouching(RIGHT) || isTouching(LEFT)) {
				speed = -speed;
				
				if (facing == RIGHT) {
					facing = LEFT;
				}
				else {
					facing = RIGHT;
				}
			}
			
			// collide with floor
			if (isTouching(FlxObject.DOWN)) {
				if (fallTime > MAX_FALL_TIME) {
					Registry.engine.killPlayer();
				}
				jump = 0;
				fallTime = 0;
				play(ANIM_RUN);
			}
			else if (velocity.y > 0) {
				fallTime += FlxG.elapsed;
			}
			else {
				fallTime = 0;
			}
			
			// off bottom of screen
			if (y > Main.SWF_HEIGHT - height && alive) {
				y = Main.SWF_HEIGHT - height;
				velocity.y = 0;
			}
		}
		
		private function jumpCheck():void {
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
				play(ANIM_JUMPING);
			}
		}
		
		private function move():void {
			x += speed;
		}
		
		override public function kill():void {
			if (!alive)
				return;
				
			super.kill();
			FlxG.shake(0.002, 0.2);
			//FlxG.flash(0xffdb3624, 0.35);
			if (gibs) {
				gibs.at(this);
				gibs.start(true);
			}
		}
	}

}