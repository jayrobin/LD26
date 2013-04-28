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
	}

}