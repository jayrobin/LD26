package net.blockjack.ld26.states 
{
	import net.blockjack.ld26.Main;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author James Robinson
	 */
	public class MainMenuState extends FlxState
	{
		[Embed(source = "../../../../../assets/gfx/states/menuBackground.png")]
		private const backgroundPNG:Class;
		
		private var transitioning:Boolean;
		
		override public function create():void {
			super.create();
			
			var background:FlxSprite = new FlxSprite(0, 0, backgroundPNG);
			add(background);
			
			FlxG.flash(Main.BACKGROUND_COLOR, 0.5);
			
			transitioning = false;
		}
		
		override public function update():void {
			super.update();
			
			if (!transitioning && FlxG.keys.justPressed("SPACE")) {
				transitioning = true;
				FlxG.fade(0xE6D69C, 0.5, function():void { play(); } );
			}
		}
		
		private function play():void {
			FlxG.switchState(new PlayState());
		}
	}
}