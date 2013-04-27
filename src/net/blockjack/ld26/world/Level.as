package net.blockjack.ld26.world 
{
	import flash.display.BitmapData;
	import net.blockjack.ld26.entities.enemies.EnemyFactory;
	import net.blockjack.ld26.entities.Player;
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.plugin.axcho.FlxTilemapPlus;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class Level 
	{
		private var width:Number;
		private var height:Number;
		
		private var tilemap:FlxTilemap;
		private var tilemapObjects:FlxTilemapPlus;
		
		private const TILE_WIDTH:Number = 8;
		private const TILE_HEIGHT:Number = 8;
		
		[Embed(source="../../../../../assets/gfx/world/Level.png")]
		private const LevelPNG:Class;
		
		[Embed(source = "../../../../../assets/gfx/world/LevelObjects.png")]
		private const LevelObjectsPNG:Class;
		
		[Embed(source="../../../../../assets/gfx/world/Tiles.png")]
		private const TilesPNG:Class;
		
		[Embed(source="../../../../../assets/gfx/world/DynamicTiles.png")]
		private const DynamicTilesPNG:Class;
		
		[Embed(source="../../../../../assets/gfx/world/Legend.png")]
		private const ObjectLegendPNG:Class;
		
		[Embed(source = "../../../../../assets/gfx/world/LevelEnemies.png")]
		private const EnemiesPNG:Class;
		
		[Embed(source="../../../../../assets/gfx/world/Background.png")]
		private const BackgroundPNG:Class;
		private var background:FlxSprite;
		
		public static const GRAVITY:Number = 150;
		
		public function Level() 
		{
			width = Math.floor(Main.SWF_WIDTH / TILE_WIDTH);
			height = Math.floor(Main.SWF_HEIGHT / TILE_HEIGHT);
		}
		
		public function load(levelNum:Number):void {
			loadLevelTiles(levelNum);
			loadDynamicObjects(levelNum);
		}
		
		private function loadLevelTiles(levelNum:Number):void {
			var levelSprite:FlxSprite = new FlxSprite();
			levelSprite.loadGraphic(LevelPNG, true, false, width, height);
			levelSprite.frame = levelNum;
			levelSprite.drawFrame(true);
			
			tilemap = new FlxTilemap();
			tilemap.loadMap(FlxTilemap.bitmapToCSV(levelSprite.framePixels, true), TilesPNG, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO, 0, 0);
		}
		
		private function loadDynamicObjects(levelNum:Number):void {
			var levelSprite:FlxSprite = new FlxSprite();
			levelSprite.loadGraphic(LevelObjectsPNG, true, false, width, height);
			levelSprite.frame = levelNum;
			levelSprite.drawFrame(true);
			
			tilemapObjects = new FlxTilemapPlus();
			tilemapObjects.loadMap(FlxTilemapPlus.bitmapToCSV(levelSprite.framePixels, FlxTilemapPlus.imageToColors(ObjectLegendPNG)), DynamicTilesPNG, 8, 8);
			
			tilemapObjects.setTileProperties(Tile.TILE_START, FlxObject.NONE);
			tilemapObjects.setTileProperties(Tile.TILE_EXIT, FlxObject.ANY, Registry.engine.playerCollideWithExit, Player);
			tilemapObjects.setTileProperties(Tile.TILE_SPIKES, FlxObject.DOWN, Registry.engine.playerCollideWithSpikes, Player);
		}
		
		public function getTilemap():FlxTilemap {
			return tilemap;
		}
		
		public function getTilemapObjects():FlxTilemap {
			return tilemapObjects as FlxTilemap;
		}
		
		public function getEnemies(levelNum:Number):FlxGroup {
			var enemies:FlxGroup = new FlxGroup();
			
			var enemySprite:FlxSprite = new FlxSprite();
			enemySprite.loadGraphic(EnemiesPNG, true, false, width, height);
			
			enemySprite.frame = levelNum;
			enemySprite.drawFrame(true);
			
			var enemyData:BitmapData = enemySprite.framePixels;
			var pixel:int;
			var tileWidth:int = TILE_WIDTH;
			var tileHeight:int = TILE_HEIGHT;
			var j:int;
			for (var i:int = 0; i < width; i++) {
				for (j = 0; j < height; j++) {
					pixel = enemyData.getPixel(i, j);
					if(pixel != 0) {
						enemies.add(EnemyFactory.createEnemy(pixel, i * tileWidth, j * tileHeight));
					}
				}
			}
			
			return enemies;
		}
		
		public function getStartPoint():FlxPoint {
			var start:FlxPoint = new FlxPoint(0, 0);
			
			if (tilemapObjects) {
				var j:int;
				for (var i:int = 0; i < height; i++) {
					for (j = 0; j < width; j++) {
						if (tilemapObjects.getTile(j, i) == Tile.TILE_START) {
							start.x = j * TILE_WIDTH;
							start.y = i * TILE_HEIGHT;
						}
					}
				}
			}
			
			return start;
		}
		
		public function getBackground():FlxSprite {
			if (!background) {
				background = new FlxSprite(0, 0, BackgroundPNG);
			}
			
			return background;
		}
		
		public function overlapsPoint(x:uint, y:uint):Boolean {
			x = Math.floor(x / TILE_WIDTH);
			y = Math.floor(y / TILE_HEIGHT);
			return tilemap.getTile(x, y) != 0;
		}

	}

}