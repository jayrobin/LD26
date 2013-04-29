package net.blockjack.ld26.states 
{
	import net.blockjack.ld26.Main;
	import net.blockjack.ld26.Registry;
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class OutroState extends FlxState
	{
		[Embed(source = "../../../../../assets/gfx/world/Background.png")]
		private const BackgroundPNG:Class;
				
		[Embed(source = "../../../../../assets/gfx/ui/introOutro.png")]
		private const OutroPNG:Class;
		
		private var outro:FlxSprite;
		private var background:FlxSprite
		
		private var frameFinished:Boolean;
		
		override public function create():void {
			super.create();
			
			Registry.levelNum = 0;
			Registry.unlockedToLevelNum = Registry.LEVEL_NAMES.length - 1;
			saveData();
			
			background = new FlxSprite(0, 0, BackgroundPNG);
			add(background);
			
			outro = new FlxSprite();
			outro.loadGraphic(OutroPNG, true, false, Main.SWF_WIDTH, Main.SWF_HEIGHT);
			outro.alpha = 0.01;
			outro.frame = 2;
			add(outro);
			
			frameFinished = false;
		}
		
		override public function update():void {
			super.update();
			if (frameFinished) {
				outro.alpha -= 0.003;
				if (FlxG.keys.justPressed("SPACE")) {
					frameFinished = true;
				}
			}
			else {
				outro.alpha += 0.005;
			}
			
			if (outro.alpha == 0) {
				FlxG.fade(Main.BACKGROUND_COLOR, Main.TRANSITION_SPEED, function():void { FlxG.switchState(new MainMenuState()); } );
			}
			else if (outro.alpha == 1) {
				remove(background);
				frameFinished = true;
			}
		}
		
		private function saveData():void {
			var save:FlxSave = Registry.save;
			
			save.data.version = Main.VERSION;
			save.data.levelNum = Registry.levelNum;
			save.data.unlockedToLevelNum = Registry.unlockedToLevelNum;
			
			save.flush();
		}
	}

}