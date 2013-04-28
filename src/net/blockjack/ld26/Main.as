package net.blockjack.ld26 
{
	
	import flash.events.Event;
	import net.blockjack.ld26.states.IntroState;
	import net.blockjack.ld26.states.MainMenuState;
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	[SWF(width="480", height="432", backgroundColor="#E6D69C", align="center")]
	[Frame(factoryClass = "net.blockjack.ld26.Preloader")]
	
	public class Main extends FlxGame
	{
		public static const SWF_WIDTH:int = 160;
		public static const SWF_HEIGHT:int = 144;
		
		public static const BACKGROUND_COLOR:uint = 0xE6D69C;
		public static const TRANSITION_SPEED:Number = 0.5;
		
		public static const VERSION:String = "0.1";
		
		public function Main()
		{
			super(SWF_WIDTH, SWF_HEIGHT, IntroState, 3, 60, 60);
			
			setupGame();
			
			if (Registry.unlockedToLevelNum > 0) {
				_iState = MainMenuState;
			}
		}
		
		private function setupGame():void {
			var save:FlxSave = new FlxSave();
			save.bind("net.blockjack.ld26");
			Registry.save = save;
			Registry.levelNum = 0;
			Registry.unlockedToLevelNum = 0;
			Registry.replays = new Array();
			
			loadData();
			Registry.levelNum = Registry.LEVEL_NAMES.length - 1;
			Registry.unlockedToLevelNum = Registry.LEVEL_NAMES.length - 1;
			
			useSoundHotKeys = false;
		}
		
        override protected function create(FlashEvent:Event):void { 
			super.create(FlashEvent);
			stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
			stage.removeEventListener(Event.ACTIVATE, onFocus);
        }
	
		private function loadData():void {
			var save:FlxSave = Registry.save;
			if (save.data.version && save.data.version == VERSION) {
				if(save.data.levelNum)
					Registry.levelNum = save.data.levelNum;
				
				if(save.data.unlockedToLevelNum) {
					Registry.levelNum = save.data.unlockedToLevelNum;
					Registry.unlockedToLevelNum = save.data.unlockedToLevelNum;
				}
			}
		}
	}

}