package net.blockjack.ld26.states 
{
	import net.blockjack.ld26.entities.Player;
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import net.blockjack.ld26.world.Level;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class PlayState extends FlxState
	{
		private var player:Player;
		
		private var gibs:FlxEmitter
		
		private var level:Level;
		private var tilemapLevel:FlxTilemap;
		private var tilemapObjects:FlxTilemap;
		
		[Embed(source = "../../../../../assets/gfx/effects/Gibs.png")]
		private const GibsPNG:Class;
		
		override public function create():void {
			Registry.engine = this;
			
			super.create();
			
			createLevel();
			var startPos:FlxPoint = level.getStartPoint();
			createGibs();
			createPlayer(startPos);
			
			setupLevel();
			
			FlxG.flash(Main.BACKGROUND_COLOR, 0.5);
		}
		
		private function createPlayer(startPos:FlxPoint):void {
			player = new Player(gibs);
			player.x = startPos.x;
			player.y = startPos.y;
		}
		
		private function createLevel():void {
			level = new Level();
			level.load(Registry.levelNum);
			tilemapLevel = level.getTilemap();
			tilemapObjects = level.getTilemapObjects();
		}
		
		private function createGibs():void {
			gibs = new FlxEmitter();
			gibs.setXSpeed( -50, 50);
			gibs.setYSpeed( -100, 0);
			gibs.gravity = 420;
			gibs.particleDrag = new FlxPoint(100, 100);
			gibs.setRotation( 0, 0);
			gibs.makeParticles(GibsPNG, 20, 0, true, 0.5);
		}
		
		private function setupLevel():void {
			add(level.getBackground());
			add(tilemapLevel);
			add(tilemapObjects);
			add(player);
			add(gibs);
		}
		
		override public function update():void {
			super.update();
			
			checkCollisions();
			
			checkReset();
		}
		
		private function checkCollisions():void {
			FlxG.collide(player, tilemapLevel);
			FlxG.collide(player, tilemapObjects);
			FlxG.collide(gibs, tilemapLevel);
		}
		
		private function checkReset():void {
			if (FlxG.keys.justPressed("R")) {
				FlxG.switchState(new PlayState());
			}
		}
		
		public function playerCollideWithSpikes(tile:FlxTile, player:Player):void {
			player.kill();
		}
		
		public function playerCollideWithExit(tile:FlxTile, player:Player):void {
			nextLevel();
		}
		
		private function nextLevel():void {
			player.alive = false;
			Registry.levelNum++;
			FlxG.fade(Main.BACKGROUND_COLOR, 0.5, function():void { FlxG.switchState(new PlayState()); } );
		}
		
		override public function destroy():void {
			Registry.engine = null;
			
			super.destroy();
		}
	}

}