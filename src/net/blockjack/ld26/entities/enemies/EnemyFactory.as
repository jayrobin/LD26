package net.blockjack.ld26.entities.enemies 
{
	/**
	 * ...
	 * @author James Robinson
	 */
	public class EnemyFactory 
	{
		private static const TYPE_ENEMY:uint = 0xFFD800;
		
		public static function createEnemy(type:uint, x:Number, y:Number):Enemy {
			var enemy:Enemy;
			switch (type) {
				case TYPE_ENEMY:
					enemy = new Enemy();
					break;
			}
			
			if(enemy)
				enemy.reset(x, y);
			
			return enemy;
		}
		
	}

}