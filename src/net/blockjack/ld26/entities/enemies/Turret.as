package net.blockjack.ld26.entities.enemies 
{
	import net.blockjack.ld26.Registry;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class Turret extends Enemy
	{
		[Embed(source="../../../../../../assets/gfx/entities/enemies/Turret.png")]
		private const EnemyPNG:Class;
		
		private static const ANIM_IDLE_LEFT:String = "idleLeft";
		private static const ANIM_SHOOT_LEFT:String = "shootLeft";
		private static const ANIM_IDLE_RIGHT:String = "idleRight";
		private static const ANIM_SHOOT_RIGHT:String = "shootRight";
		private static const ANIM_IDLE_UP:String = "idleUp";
		private static const ANIM_SHOOT_UP:String = "shootUp";
		private static const ANIM_IDLE_DOWN:String = "idleDown";
		private static const ANIM_SHOOT_DOWN:String = "shootDown";
		
		private var weaponPos:FlxPoint;
		private var fireDelay:Number;
		private var weaponDirection:uint;
		private const MAX_FIRE_DELAY:Number = 2;
		
		public function Turret(weaponDirection:uint) 
		{
			this.weaponDirection = weaponDirection;
			loadAnimations();
			
			reset(0, 0);
		}
		
		private function loadAnimations():void {
			loadGraphic(EnemyPNG, true, false, WIDTH, HEIGHT);
			addAnimation(ANIM_IDLE_LEFT, 	[0], 20, true);
			addAnimation(ANIM_SHOOT_LEFT, 	[1, 2, 1, 0], 10, false);
			addAnimation(ANIM_IDLE_RIGHT, 	[3], 20, true);
			addAnimation(ANIM_SHOOT_RIGHT, 	[4, 5, 4, 3], 10, false);
			addAnimation(ANIM_IDLE_UP, 		[6], 20, true);
			addAnimation(ANIM_SHOOT_UP, 	[7, 8, 7, 6], 10, false);
			addAnimation(ANIM_IDLE_DOWN, 	[9], 20, true);
			addAnimation(ANIM_SHOOT_DOWN, 	[10,11,10,9], 10, false);
		}
		
		override public function update():void {
			super.update();
			checkFire();
		}
		
		private function checkFire():void {
			if (fireDelay > MAX_FIRE_DELAY) {
				fire();
			}
			fireDelay += FlxG.elapsed;
		}
		
		private function fire():void {
			fireDelay = 0;
			
			switch(facing) {
				case LEFT:
					play(ANIM_SHOOT_LEFT);
					break;
				case RIGHT:
					play(ANIM_SHOOT_RIGHT);
					break;
				case UP:
					play(ANIM_SHOOT_UP);
					break;
				case DOWN:
					play(ANIM_SHOOT_DOWN);
					break;
			}
			
			Registry.engine.createProjectile(weaponPos, facing);
		}
		
		public function setDirection(facing:uint):void {
			this.facing = facing;
			
			switch(facing) {
				case LEFT:
					play(ANIM_IDLE_LEFT);
					weaponPos = new FlxPoint(x, y + 3);
					break;
				case RIGHT:
					play(ANIM_IDLE_RIGHT);
					weaponPos = new FlxPoint(x + width, y + 3);
					break;
				case UP:
					play(ANIM_IDLE_UP);
					weaponPos = new FlxPoint(x + width / 2 - 1, y);
					break;
				case DOWN:
					play(ANIM_IDLE_DOWN);
					weaponPos = new FlxPoint(x + width / 2 - 1, y + height);
					break;
			}
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			setDirection(weaponDirection);
			fireDelay = 0;
			acceleration.y = 0;
		}
		
	}

}