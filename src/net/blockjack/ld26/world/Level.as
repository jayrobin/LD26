package net.blockjack.ld26.world 
{
	import net.blockjack.ld26.Main;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class Level 
	{
		private var width:Number;
		private var height:Number;
		
		private var tilemap:FlxTilemap;
		
		private const TILE_WIDTH:Number = 8;
		private const TILE_HEIGHT:Number = 8;
		
		[Embed(source="../../../../../assets/gfx/world/Level.png")]
		private const LevelPNG:Class;
		
		[Embed(source="../../../../../assets/gfx/world/Tiles.png")]
		private const TilesPNG:Class;
		
		[Embed(source="../../../../../assets/gfx/world/Background.png")]
		private const BackgroundPNG:Class;
		private var background:FlxSprite;
		
		public function Level() 
		{
			width = Math.floor(Main.SWF_WIDTH / TILE_WIDTH);
			height = Math.floor(Main.SWF_HEIGHT / TILE_HEIGHT);
		}
		
		public function load(levelNum:Number):FlxTilemap {
			var levelSprite:FlxSprite = new FlxSprite();
			levelSprite.loadGraphic(LevelPNG, true, false, width, height);
			
			if(levelNum < levelSprite.frames) {
				levelSprite.frame = levelNum;
				levelSprite.drawFrame(true);
				
				tilemap = new FlxTilemap();
				tilemap.loadMap(FlxTilemap.bitmapToCSV(levelSprite.framePixels, true), TilesPNG, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.AUTO, 0, 0);
				
				return tilemap;
			}
			else {
				return null;
			}
		}
		
		public function getBackground():FlxSprite {
			if (!background) {
				background = new FlxSprite(0, 0, BackgroundPNG);
			}
			
			return background;
		}
	}

}