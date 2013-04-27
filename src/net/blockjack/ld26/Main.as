package net.blockjack.ld26 
{
	
	import net.blockjack.ld26.states.MainMenuState;
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	[SWF(width="480", height="432", backgroundColor="#E6D69C", align="center")]
	[Frame(factoryClass = "net.blockjack.ld26.Preloader")]
	
	public class Main extends FlxGame
	{
		public static const SWF_WIDTH:int = 160;
		public static const SWF_HEIGHT:int = 144;
		
		public static const BACKGROUND_COLOR:uint = 0xE6D69C;
		
		public function Main()
		{
			super(SWF_WIDTH, SWF_HEIGHT, MainMenuState, 3, 60, 60);
		}
	}

}