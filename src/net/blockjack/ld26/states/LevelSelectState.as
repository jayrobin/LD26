package net.blockjack.ld26.states 
{
	import flash.display.BitmapData;
	import net.blockjack.ld26.entities.enemies.EnemyFactory;
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import net.blockjack.ld26.world.Level;
	import net.blockjack.ld26.world.Tile;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class LevelSelectState extends FlxState
	{
		private var running:Boolean;
		
		private var levelSelector:FlxSprite;
		private var leftSelect:FlxSprite;
		private var rightSelect:FlxSprite;
		private var txtTitle:FlxText;
		private var index:Number;
		
		[Embed(source="../../../../../assets/gfx/ui/LeftSelector.png")]
		private const LeftSelectPNG:Class;
		[Embed(source="../../../../../assets/gfx/ui/RightSelector.png")]
		private const RightSelectPNG:Class;
		
		[Embed(source = "../../../../../assets/gfx/world/Level.png")]
		private const LevelsPNG:Class;
		
		[Embed(source = "../../../../../assets/gfx/world/LevelObjects.png")]
		private const LevelObjectsPNG:Class;
		
		[Embed(source = "../../../../../assets/gfx/world/LevelEnemies.png")]
		private const EnemiesPNG:Class;
		
		[Embed(source="../../../../../assets/gfx/ui/LevelSelectBackground.png")]
		private const BackgroundPNG:Class;
		
		override public function create():void {
			index = Registry.levelNum;
			
			setupUI();
			
			running = true;
			FlxG.flash(Main.BACKGROUND_COLOR, Main.TRANSITION_SPEED);
			changeLevel(0);
		}
		
		private function setupUI():void {
			var background:FlxSprite = new FlxSprite(0, 0, BackgroundPNG);
			add(background);
			
			levelSelector = new FlxSprite();
			var width:int = Math.floor(Main.SWF_WIDTH / Tile.WIDTH);
			var height:int = Math.floor(Main.SWF_HEIGHT / Tile.HEIGHT);
			levelSelector.loadGraphic(LevelsPNG, true, false, width, height);
			levelSelector.replaceColor(0xff000000, 0xff393829);
			levelSelector.replaceColor(0xffffffff, 0xffB4A56A);
			levelSelector.scale = new FlxPoint(4, 4);
			levelSelector.x = (Main.SWF_WIDTH / 2) - (levelSelector.width / 2);
			levelSelector.y = (Main.SWF_HEIGHT / 2) - (levelSelector.height / 2);
			
			
			var objectSprite:FlxSprite = new FlxSprite();
			objectSprite.loadGraphic(LevelObjectsPNG, true, false, width, height);
			
			var objectData:BitmapData = objectSprite.pixels;
			var pixel:int;
			var j:int;
			for (var i:int = 0; i < objectData.width; i++) {
				for (j = 0; j < objectData.height; j++) {
					pixel = objectData.getPixel(i, j);
					if(pixel == 0x4CFF00 || pixel == 0x0026FF || pixel == 0x9E753C || pixel == 0x004A7F) {
						levelSelector.pixels.setPixel(i, j, Main.BACKGROUND_COLOR);
					}
					//else if (pixel != 0) {
						//levelSelector.pixels.setPixel(i, j, 0x7B7162);
					//}
				}
			}
			
			objectSprite.loadGraphic(EnemiesPNG, true, false, width, height);
			
			objectData = objectSprite.pixels;
			for (i = 0; i < objectData.width; i++) {
				for (j = 0; j < objectData.height; j++) {
					pixel = objectData.getPixel(i, j);
					if(EnemyFactory.isEnemyPixel(pixel)) {
						levelSelector.pixels.setPixel(i, j, 0x7B7162);
					}
				}
			}
			
			
			leftSelect = new FlxSprite(8, (Main.SWF_HEIGHT / 2), LeftSelectPNG);
			rightSelect = new FlxSprite(Main.SWF_WIDTH - 16, (Main.SWF_HEIGHT / 2), RightSelectPNG);
			
			txtTitle = new FlxText(0, 20, Main.SWF_WIDTH, "");
			txtTitle.color = 0xFFB4A56A;
			txtTitle.size = 8;
			txtTitle.shadow = 0xFF7B7162;
			txtTitle.alignment = "center";
			
			add(levelSelector);
			add(leftSelect);
			add(rightSelect);
			add(txtTitle);
		}
		
		override public function update():void {
			super.update();
			
			if (running) {
				if (FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("A")) {
					FlxG.play(Registry.ClickSND);
					changeLevel(-1);
				}
				else if (FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("D")) {
					FlxG.play(Registry.ClickSND);
					changeLevel(1);
				}
				
				if (FlxG.keys.justPressed("SPACE")) {
					FlxG.play(Registry.ClickSND);
					transitionToPlay();
				}
				
				if (FlxG.keys.pressed("X") && FlxG.keys.pressed("C")) {
					Registry.unlockedToLevelNum = Registry.levelNum = 0;
					Registry.save.data.unlockedToLevelNum = Registry.unlockedToLevelNum;
					Registry.save.data.levelNum = Registry.save.data.levelNum;
					Registry.save.flush();
					changeLevel(0);
				}
			}
		}
		
		private function changeLevel(shift:Number):void {
			index += shift;
			index = Math.max(0, Math.min(Registry.unlockedToLevelNum, index));
			
			levelSelector.frame = index;
			levelSelector.drawFrame(true);
			
			leftSelect.visible = (index > 0);
			rightSelect.visible = (index < Registry.LEVEL_NAMES.length - 1);
			
			txtTitle.text = Registry.LEVEL_NAMES[index];
		}
		
		private function transitionToPlay():void {
			FlxG.fade(Main.BACKGROUND_COLOR, Main.TRANSITION_SPEED, play);
			running = false;
		}
		
		private function play():void {
			Registry.levelNum = index;
			FlxG.switchState(new PlayState());
		}
		
		private function prevLevel():void {
			changeLevel( -1);
		}
		
		private function nextLevel():void {
			changeLevel(1);
		}
		
	}

}