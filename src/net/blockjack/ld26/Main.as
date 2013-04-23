package net.blockjack.ld26 
{
	
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	[SWF(width="480", height="432", backgroundColor="#E6D69C", align="center")]
	[Frame(factoryClass = "net.blockjack.ld26.Preloader")]
	
	public class Main extends FlxGame
	{
		public static const SWF_WIDTH:int = 160;
		public static const SWF_HEIGHT:int = 144;
		
		public function Main()
		{
			super(SWF_WIDTH, SWF_HEIGHT, MenuState, 3, 60, 60);
		}
	}

}