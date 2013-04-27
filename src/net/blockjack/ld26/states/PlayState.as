package net.blockjack.ld26.states 
{
	import net.blockjack.ld26.entities.enemies.Enemy;
	import net.blockjack.ld26.entities.Player;
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import net.blockjack.ld26.world.Level;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.system.FlxTile;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class PlayState extends FlxState
	{
		private var player:Player;
		private var gibs:FlxEmitter
		
		private var enemies:FlxGroup;
		
		private var level:Level;
		private var tilemapLevel:FlxTilemap;
		private var tilemapObjects:FlxTilemap;
		
		[Embed(source = "../../../../../assets/gfx/effects/Gibs.png")]
		private const GibsPNG:Class;
		
		[Embed(source="../../../../../assets/gfx/ui/RestartMessage.png")]
		private const RestartPNG:Class;
		private var restartText:FlxSprite;
		
		private var ui:FlxGroup;
		
		override public function create():void {
			Registry.engine = this;
			
			super.create();
			
			createLevel();
			var startPos:FlxPoint = level.getStartPoint();
			createGibs();
			createEnemies();
			createPlayer(startPos);
			createUI();
			
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
		
		private function createEnemies():void {
			enemies = level.getEnemies(Registry.levelNum);
		}
		
		private function createUI():void {
			ui = new FlxGroup();
			
			restartText = new FlxSprite(0, 0, RestartPNG);
			restartText.x = Main.SWF_WIDTH / 2 - restartText.width / 2;
			restartText.y = Main.SWF_HEIGHT / 2 - restartText.height / 2;
			restartText.visible = false;
			
			ui.add(restartText);
		}
		
		private function setupLevel():void {
			add(level.getBackground());
			add(tilemapLevel);
			add(tilemapObjects);
			add(player);
			add(gibs);
			add(enemies);
			add(ui);
		}
		
		override public function update():void {
			super.update();
			
			checkCollisions();
			
			checkReset();
		}
		
		private function checkCollisions():void {
			FlxG.collide(enemies, tilemapLevel);
			FlxG.collide(player, tilemapLevel);
			FlxG.overlap(player, enemies, playerCollideWithEnemy);
			FlxG.collide(player, tilemapObjects);
			FlxG.collide(gibs, tilemapLevel);
		}
		
		private function checkReset():void {
			if (!player.alive && FlxG.keys.justPressed("SPACE")) {
				FlxG.switchState(new PlayState());
			}
		}
		
		public function playerCollideWithSpikes(tile:FlxTile, player:Player):void {
			killPlayer();
		}
		
		public function playerCollideWithEnemy(player:Player, enemy:Enemy):void {
			if(FlxCollision.pixelPerfectCheck(player, enemy)) {
				killPlayer();
			}
		}
		
		public function playerCollideWithExit(tile:FlxTile, player:Player):void {
			nextLevel();
		}
		
		public function levelOverlapsPoint(x:Number, y:Number):Boolean {
			return level.overlapsPoint(x, y);
		}
		
		private function nextLevel():void {
			player.alive = false;
			Registry.levelNum++;
			FlxG.fade(Main.BACKGROUND_COLOR, 0.5, function():void { FlxG.switchState(new PlayState()); } );
		}
		
		public function killPlayer():void {
			restartText.visible = true;
			player.kill();
		}
		
		override public function destroy():void {
			Registry.engine = null;
			
			super.destroy();
		}
	}

}