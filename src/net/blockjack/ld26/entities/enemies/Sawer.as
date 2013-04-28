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
	public class Sawer extends Enemy
	{
		[Embed(source="../../../../../../assets/gfx/entities/enemies/Sawer.png")]
		private const EnemyPNG:Class;
		
		private static const ANIM_SAW_UP:String = "sawUp";
		private static const ANIM_SAW_DOWN:String = "sawDown";
		private static const ANIM_SAW_RIGHT:String = "sawRight";
		private static const ANIM_SAW_LEFT:String = "sawLeft";
		private static const ANIM_SAW_MIDDLE:String = "sawMiddle";
				
		public function Sawer() 
		{
			loadAnimations();
			
			//reset(0, 0);
		}
		
		private function loadAnimations():void {
			loadGraphic(EnemyPNG, true, false, WIDTH, HEIGHT);
			addAnimation(ANIM_SAW_UP, 		[0, 1], 20, true);
			addAnimation(ANIM_SAW_DOWN, 	[2, 3], 20, true);
			addAnimation(ANIM_SAW_RIGHT, 	[4, 5], 20, true);
			addAnimation(ANIM_SAW_LEFT, 	[6, 7], 20, true);
			addAnimation(ANIM_SAW_MIDDLE, 	[8, 9], 20, true);
		}
		
		override public function reset(x:Number, y:Number):void {
			super.reset(x, y);
			
			acceleration.y = 0;
			
			if (!Registry.engine.isTileEmptyAt(x, y - height)) {
				play(ANIM_SAW_DOWN);
			}
			else if(!Registry.engine.isTileEmptyAt(x, y + height)) {
				play(ANIM_SAW_UP);
			}
			else if(!Registry.engine.isTileEmptyAt(x - width, y)) {
				play(ANIM_SAW_RIGHT);
			}
			else if(!Registry.engine.isTileEmptyAt(x + width, y)) {
				play(ANIM_SAW_LEFT);
			}
			else {
				play(ANIM_SAW_MIDDLE);
			}
		}
		
	}

}