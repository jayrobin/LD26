package net.blockjack.ld26.states 
{
	import net.blockjack.ld26.entities.enemies.Bullet;
	import net.blockjack.ld26.entities.enemies.Enemy;
	import net.blockjack.ld26.entities.Player;
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import net.blockjack.ld26.ui.InfoPopup;
	import net.blockjack.ld26.world.Level;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSave;
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
		private var gibs:FlxEmitter;
		
		private var replay:Boolean;
		private var replays:FlxGroup;
		
		private var enemies:FlxGroup;
		private var projectiles:FlxGroup;
		
		private var level:Level;
		private var tilemapLevel:FlxTilemap;
		private var tilemapObjects:FlxTilemap;
		
		[Embed(source = "../../../../../assets/gfx/effects/Gibs.png")]
		private const GibsPNG:Class;
		
		private var infoPopup:InfoPopup;
		
		[Embed(source="../../../../../assets/gfx/ui/ReplayBackground.png")]
		private const ReplayPNG:Class;
		private var replayPopup:FlxSprite;
		
		[Embed(source="../../../../../assets/gfx/ui/InfoPopups.png")]
		private const TutorialsPNG:Class;
		
		private var ui:FlxGroup;
		
		public function PlayState(replay:Boolean = false):void {
			this.replay = replay;
		}
		
		override public function create():void {
			Registry.engine = this;
			
			super.create();
			
			createLevel();
			var startPos:FlxPoint = level.getStartPoint();
			createGibs();
			createEnemies();
			createPlayer(startPos);
			createReplays(startPos);
			createUI();
			
			setupLevel();
			
			FlxG.flash(Main.BACKGROUND_COLOR, Main.TRANSITION_SPEED);
		}
		
		private function createPlayer(startPos:FlxPoint):void {
			if(!replay) {
				player = new Player(gibs);
				player.x = startPos.x;
				player.y = startPos.y;
			}
		}
		
		private function createReplays(startPos:FlxPoint):void {
			if (replay) {
				replays = new FlxGroup();
				var numReplays:Number = Registry.replays.length;
				
				for (var i:int = 0; i < numReplays; i++) {
					var player:Player = new Player(gibs, Registry.replays[i]);
					player.x = startPos.x;
					player.y = startPos.y;
					
					replays.add(player);
				}
			}
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
			gibs.makeParticles(GibsPNG, 500, 0, true, 0.5);
		}
		
		private function createEnemies():void {
			enemies = level.getEnemies(Registry.levelNum);
			projectiles = new FlxGroup();
		}
		
		private function createUI():void {
			ui = new FlxGroup();
			
			if(!replay) {
				var tutorial:FlxSprite = new FlxSprite(0, 0);
				tutorial.loadGraphic(TutorialsPNG, true, false, Main.SWF_WIDTH, Main.SWF_HEIGHT);
				tutorial.frame = Registry.levelNum;
				tutorial.drawFrame(true);
				ui.add(tutorial);
			}
			else {
				replayPopup = new FlxSprite(0, 0);
				replayPopup.loadGraphic(ReplayPNG, true, false, Main.SWF_WIDTH, Main.SWF_HEIGHT);
				replayPopup.addAnimation("playTop", [0, 1], 10);
				replayPopup.addAnimation("playBottom", [2, 3], 10);
				replayPopup.play("playTop");
				ui.add(replayPopup);
			}
			
			infoPopup = new InfoPopup();
			ui.add(infoPopup);
		}
		
		private function setupLevel():void {
			add(level.getBackground());
			add(tilemapLevel);
			add(tilemapObjects);
			
			if (replay) {
				add(replays);
			}
			else {
				add(player);
			}
			
			add(gibs);
			add(enemies);
			add(projectiles);
			add(ui);
		}
		
		override public function update():void {
			super.update();
			
			checkCollisions();
			
			checkReset();
		}
		
		private function checkCollisions():void {
			FlxG.collide(enemies, tilemapLevel);
			FlxG.collide(projectiles, tilemapLevel, projectileCollideWithLevel);
			FlxG.collide(gibs, tilemapLevel);
			
			if(replay) {
				FlxG.collide(replays, tilemapLevel);
				FlxG.overlap(replays, enemies, playerCollideWithEnemy);
				FlxG.overlap(replays, projectiles, playerCollideWithProjectile);
				FlxG.collide(replays, tilemapObjects);
			}
			else {
				FlxG.collide(player, tilemapLevel);
				FlxG.overlap(player, enemies, playerCollideWithEnemy);
				FlxG.overlap(player, projectiles, playerCollideWithProjectile);
				FlxG.collide(player, tilemapObjects);
			}
		}
		
		private function checkReset():void {
			if (FlxG.keys.justPressed("SPACE")) {
				if (replay) {
					nextLevel();
				}
				else if(!replay && !player.alive) {
					FlxG.switchState(new PlayState());
				}
			}
			
			if (FlxG.keys.justPressed("ESCAPE")) {
				Registry.replays = new Array();
				FlxG.switchState(new MainMenuState());
			}
			
			if (FlxG.keys.justPressed("R") && replay && infoPopup.isShowing()) {
				FlxG.switchState(new PlayState(true));
			}
		}
		
		public function playerCollideWithSpikes(tile:FlxTile, player:Player):void {
			killPlayer(player);
		}
		
		public function projectileCollideWithLevel(projectile:Bullet, tiles:FlxTilemap):void {
			projectile.kill();
		}
		
		public function playerCollideWithEnemy(player:Player, enemy:Enemy):void {
			if(FlxCollision.pixelPerfectCheck(player, enemy)) {
				killPlayer(player);
			}
		}
		
		public function playerCollideWithProjectile(player:Player, projectile:Bullet):void {
			if(projectile.alive && FlxCollision.pixelPerfectCheck(player, projectile)) {
				killPlayer(player);
				projectile.kill();
			}
		}
		
		public function playerCollideWithExit(tile:FlxTile, player:Player):void {
			player.exit();
			
			if (replay) {
				infoPopup.showReplayComplete();
				replayPopup.visible = false;
			}
			else {
				Registry.replays.push(player.getReplay());
				showReplay();
			}
		}
		
		public function playerCollideWithSpring(tile:FlxTile, player:Player):void {
			player.bounce();
		}
		
		public function levelOverlapsPoint(x:Number, y:Number):Boolean {
			return level.overlapsPoint(x, y);
		}
		
		public function isTileLadderAt(x:Number, y:Number):Boolean {
			return level.isTileLadderAt(x, y);
		}
		
		public function isTileEmptyAt(x:Number, y:Number):Boolean {
			return level.isTileEmptyAt(x, y);
		}
		
		private function nextLevel():void {
			Registry.replays = new Array();
			
			Registry.levelNum++;
			saveData();
			
			FlxG.fade(Main.BACKGROUND_COLOR, 0.5, function():void { FlxG.switchState(new PlayState()); } );
		}
		
		private function showReplay():void {
			Registry.unlockedToLevelNum = Math.max(Registry.levelNum + 1, Registry.unlockedToLevelNum);
			saveData();
			
			FlxG.fade(Main.BACKGROUND_COLOR, 0.5, function():void { FlxG.switchState(new PlayState(true)); } );
		}
		
		public function killPlayer(player:Player = null):void {
			if (!player) {
				player = this.player;
			}
			
			player.kill();
			
			if(!replay) {
				Registry.replays.push(player.getReplay());
				infoPopup.showRestart();
			}
		}
		
		public function createProjectile(position:FlxPoint, direction:uint):void {
			var projectile:Bullet = projectiles.recycle(Bullet) as Bullet
			projectile.reset(position.x, position.y);
			projectile.setDirection(direction);
		}
		
		private function saveData():void {
			var save:FlxSave = Registry.save;
			
			save.data.version = Main.VERSION;
			save.data.levelNum = Registry.levelNum;
			save.data.unlockedToLevelNum = Registry.unlockedToLevelNum;
			
			save.flush();
		}
		
		override public function destroy():void {
			Registry.engine = null;
			
			super.destroy();
		}
	}

}