package net.blockjack.ld26.states 
{
	import net.blockjack.ld26.entities.Player;
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.world.Level;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class PlayState extends FlxState
	{
		private var player:Player;
		
		private var level:Level;
		private var tilemapLevel:FlxTilemap;
		
		override public function create():void {
			super.create();
			
			createLevel();
			createPlayer();
			
			setupLevel();
			
			FlxG.flash(Main.BACKGROUND_COLOR, 0.5);
		}
		
		private function createPlayer():void {
			player = new Player();
			player.x = 8;
			player.y = Main.SWF_HEIGHT - 16;
		}
		
		private function createLevel():void {
			level = new Level();
			tilemapLevel = level.load(0);
		}
		
		private function setupLevel():void {
			add(level.getBackground());
			add(tilemapLevel);
			add(player);
		}
		
		override public function update():void {
			super.update();
			
			checkCollisions();
			
			checkReset();
		}
		
		private function checkCollisions():void {
			FlxG.collide(player, tilemapLevel);
		}
		
		private function checkReset():void {
			if (FlxG.keys.justPressed("R")) {
				FlxG.switchState(new PlayState());
			}
		}
	}

}