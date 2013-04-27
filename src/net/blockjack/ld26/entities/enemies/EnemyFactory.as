package net.blockjack.ld26.entities.enemies 
{
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
			}
			if(enemy)
				enemy.reset(x, y);
			
			return enemy;
		}
		
	}

}