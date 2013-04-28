package net.blockjack.ld26.entities 
{
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import net.blockjack.ld26.world.Level;
	import net.blockjack.ld26.world.Tile;
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
		
		[Embed(source="../../../../../assets/snd/jump.mp3")]
		private const jumpSND:Class;
		
		[Embed(source="../../../../../assets/snd/die.mp3")]
		private const dieSND:Class;
		
		[Embed(source="../../../../../assets/snd/win.mp3")]
		private const winSND:Class;
		
		private var inControl:Boolean;
		private var replay:Array;
		private var replayIndex:Number;
		private var age:Number;
		
		private var numGibs:Number;
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
		private const MAX_FALL_TIME:Number = 0.8;
		
		private var isClimbing:Boolean;
		
		public function Player(gibs:FlxEmitter, replay:Array = null) 
		{
			this.gibs = gibs;
			if (replay) {
				this.replay = replay;
				inControl = false;
			}
			else {
				this.replay = new Array();
				inControl = true;
			}
			
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
			
			age = 0;
			replayIndex = 0;
			jump = 0;
			velocity.y = 0;
			acceleration.y = Level.GRAVITY;
			maxVelocity.y = 1.7 * JUMP_SPEED;
			speed = BASE_SPEED;
			fallTime = 0;
			
			if (inControl) {
				numGibs = 25;
			}
			else {
				numGibs = 5;
			}
			
			play(ANIM_RUN);
		}
		
		override public function update():void {
			age++;
			
			boundaryCheck();
			jumpCheck();
			ladderCheck();
			move();
			
			super.update();
		}
		
		private function isJumpPressed():Boolean {
			if (inControl) {
				if (FlxG.keys.SPACE) {
					replay[replayIndex] = age;
					replayIndex++;
				}
				
				if (FlxG.keys.justPressed("SPACE") && velocity.y == 0) {
					FlxG.play(jumpSND);
				}
				
				return FlxG.keys.SPACE;
			}
			else {
				if (replay[replayIndex] == age) {
					replayIndex++;
					
					if (velocity.y == 0) {
						FlxG.play(jumpSND);
					}
					
					return true;
				}
				else {
					return false;
				}
			}
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
			if (isTouching(FlxObject.DOWN) && velocity.y == 0) {
				if (fallTime > MAX_FALL_TIME) {
					Registry.engine.killPlayer(this);
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
			if (jump >= 0 && isJumpPressed()) {
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
					velocity.y = -0.6 * JUMP_SPEED;
				}
				else {
					velocity.y = -JUMP_SPEED;
				}
				play(ANIM_JUMPING);
			}
		}
		
		public function bounce():void {
			velocity.y = -maxVelocity.y;
			play(ANIM_JUMPING);
			FlxG.play(jumpSND);
		}
		
		public function exit():void {
			speed = 0;
			play(ANIM_IDLE);
			FlxG.play(winSND);
		}
		
		private function ladderCheck():void {
			var xCheck:Number = x;
			if (facing == LEFT) {
				xCheck += width - 1;
			}
			
			if (Registry.engine.isTileLadderAt(xCheck, y + height - 1)) {
				
				setClimbing(true);
			}
			else {
				setClimbing(false);
			}
		}
		
		private function setClimbing(isClimbing:Boolean):void {
			if (isClimbing && !this.isClimbing) {
				jump = -1;
				velocity.y = 0;
				speed = BASE_SPEED;
				acceleration.y = 0;
				x = Math.floor(x / Tile.WIDTH) * Tile.WIDTH;
				play(ANIM_JUMPING);
			}
			else if(this.isClimbing && !isClimbing) {
				acceleration.y = Level.GRAVITY;
				y -= 0.5;	// jump 0.5 pixel up so as not to collide with adjacent platform
				play(ANIM_RUN);
				
				if (facing == LEFT) {
					speed = -BASE_SPEED;
				}
				else {
					speed = BASE_SPEED;
				}
			}
			this.isClimbing = isClimbing;
		}
		
		private function move():void {
			if (isClimbing) {
				y -= speed;
			}
			else {
				x += speed;
			}
		}
		
		public function getReplay():Array {
			return replay;
		}
		
		override public function kill():void {
			if (!alive)
				return;
				
			super.kill();
			FlxG.shake(0.002, 0.2);
			FlxG.play(dieSND);
			if (gibs) {
				gibs.at(this);
				gibs.start(true, 0, 0, numGibs);
			}
		}
	}

}