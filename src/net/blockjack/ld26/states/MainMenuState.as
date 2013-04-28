package net.blockjack.ld26.states 
{
	import net.blockjack.ld26.entities.enemies.Bouncer;
	import net.blockjack.ld26.entities.enemies.Walker;
	import net.blockjack.ld26.entities.Player;
	import net.blockjack.ld26.Main;
	import org.flixel.FlxButton;
	import org.flixel.FlxEmitter;
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
		[Embed(source = "../../../../../assets/gfx/ui/menuBackground.png")]
		private const backgroundPNG:Class;
		
		private var transitioning:Boolean;
		
		override public function create():void {
			super.create();
			
			var background:FlxSprite = new FlxSprite(0, 0, backgroundPNG);
			add(background);
			
			FlxG.flash(Main.BACKGROUND_COLOR, Main.TRANSITION_SPEED);
			
			transitioning = false;
		}
		
		override public function update():void {
			super.update();
			
			if (!transitioning && FlxG.keys.justPressed("SPACE")) {
				transitioning = true;
				FlxG.fade(0xE6D69C, Main.TRANSITION_SPEED, function():void { play(); } );
			}
		}
		
		private function play():void {
			FlxG.switchState(new LevelSelectState());
		}
	}
}