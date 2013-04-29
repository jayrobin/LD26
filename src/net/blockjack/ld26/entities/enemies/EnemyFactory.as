package net.blockjack.ld26.entities.enemies 
{
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class EnemyFactory 
	{
		private static const TYPE_WALKER:uint = 0xB6FF00;
		private static const TYPE_JUMPER:uint = 0xFFD800;
		private static const TYPE_BOUNCER:uint = 0x00FFFF;
		private static const TYPE_STICKER:uint = 0xFF00DC;
		private static const TYPE_RUNNER:uint = 0xB200FF;
		
		private static const TYPE_TURRET_LEFT:uint = 0x606060;
		private static const TYPE_TURRET_RIGHT:uint = 0x808080;
		private static const TYPE_TURRET_UP:uint = 0xA0A0A0;
		private static const TYPE_TURRET_DOWN:uint = 0xC0C0C0;
		
		private static const TYPE_SAWER:uint = 0x7FC9FF;
		
		public static function createEnemy(type:uint, x:Number, y:Number):Enemy {
			var enemy:Enemy;
			switch (type) {
				case TYPE_WALKER:
					enemy = new Walker();
					break;
				case TYPE_JUMPER:
					enemy = new Jumper();
					break;
				case TYPE_BOUNCER:
					enemy = new Bouncer();
					break;
				case TYPE_STICKER:
					enemy = new Sticker();
					break;
				case TYPE_RUNNER:
					enemy = new Runner();
					break;
				case TYPE_TURRET_LEFT:
					enemy = new Turret(FlxObject.LEFT);
					break;
				case TYPE_TURRET_RIGHT:
					enemy = new Turret(FlxObject.RIGHT);
					break;
				case TYPE_TURRET_UP:
					enemy = new Turret(FlxObject.UP);
					break;
				case TYPE_TURRET_DOWN:
					enemy = new Turret(FlxObject.DOWN);
					break;
				case TYPE_SAWER:
					enemy = new Sawer();
					break;
			}
			if(enemy)
				enemy.reset(x, y);
			
			return enemy;
		}
		
		public static function isEnemyPixel(pixel:uint):Boolean {
			return 	pixel == TYPE_WALKER ||
					pixel == TYPE_JUMPER ||
					pixel == TYPE_BOUNCER ||
					pixel == TYPE_STICKER ||
					pixel == TYPE_RUNNER ||
					pixel == TYPE_TURRET_LEFT ||
					pixel == TYPE_TURRET_RIGHT ||
					pixel == TYPE_TURRET_DOWN ||
					pixel == TYPE_SAWER;
		}
		
	}

}