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
	public class Runner extends Enemy
	{
		[Embed(source="../../../../../../assets/gfx/entities/enemies/Walker.png")]
		private const EnemyPNG:Class;
		
		private static const ANIM_WALK:String = "walk";
		
		private const BASE_SPEED:Number = -0.6;
		
		public function Runner() 
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
			move();
		}
		
		private function move():void {
			x += speed;
		}
		
		override protected function boundaryCheck():void {
			super.boundaryCheck();
			
			// nearing a platform edge
			if (facing == LEFT && !Registry.engine.levelOverlapsPoint(x, y + height)) {
				turnAround();
			}
			else if (facing == RIGHT && !Registry.engine.levelOverlapsPoint(x + width, y + height)) {
				turnAround();
			}
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			speed = BASE_SPEED;
			play(ANIM_WALK);
		}
		
	}

}