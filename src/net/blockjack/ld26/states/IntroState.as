package net.blockjack.ld26.states 
{
	import net.blockjack.ld26.Main;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class IntroState extends FlxState
	{
		[Embed(source = "../../../../../assets/gfx/world/Background.png")]
		private const BackgroundPNG:Class;
				
		[Embed(source = "../../../../../assets/gfx/ui/introOutro.png")]
		private const introPNG:Class;
		
		private var intro:FlxSprite;
		
		private const NUM_FRAMES:Number = 2;
		private var frameFinished:Boolean;
		
		override public function create():void {
			super.create();
			
			var background:FlxSprite = new FlxSprite(0, 0, BackgroundPNG);
			add(background);
			
			intro = new FlxSprite();
			intro.loadGraphic(introPNG, true, false, Main.SWF_WIDTH, Main.SWF_HEIGHT);
			intro.alpha = 0.01;
			intro.frame = 0;
			add(intro);
			
			frameFinished = false;
		}
		
		override public function update():void {
			super.update();
			if (frameFinished) {
				intro.alpha -= 0.01;
			}
			else {
				intro.alpha += 0.005;
			}
			
			if (intro.alpha == 0) {
				nextFrame();
			}
			else if (intro.alpha == 1) {
				frameFinished = true;
			}
			
			if (FlxG.keys.justPressed("SPACE")) {
				frameFinished = true;
			}
		}
		
		private function nextFrame():void {
			intro.frame++;
			intro.drawFrame(true);
			intro.alpha = 0.01;
			frameFinished = false;
			
			if (intro.frame == NUM_FRAMES) {
				intro.visible = false;
				FlxG.fade(Main.BACKGROUND_COLOR, Main.TRANSITION_SPEED, function():void { FlxG.switchState(new MainMenuState()); } );
			}
		}
		
		
		
	}

}