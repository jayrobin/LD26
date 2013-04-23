package net.blockjack.ld26 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author James Robinson
	 */
	public class MenuState extends FlxState
	{
		
		public function MenuState() 
		{
			FlxG.mouse.show();
			
			var title:FlxText = new FlxText(0, 0, FlxG.width, "LD26");
			title.size = 16;
			title.alignment = "center";
			add(title);
			
			
			var play:FlxButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height * 2 / 3, "Play", play);
			add(play);
		}
		
		private function play():void {
			
		}
	}
}