package net.blockjack.ld26 
{
	import net.blockjack.ld26.states.PlayState;
	import org.flixel.FlxObject;
	import org.flixel.FlxSave;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class Registry 
	{
		public static var engine:PlayState;
		public static var replays:Array;
		public static var save:FlxSave;
		public static var levelNum:Number;
		public static var unlockedToLevelNum:Number;
		public static const LEVEL_NAMES:Array =[	"The End",
													"See Saws",
													"R.O.U.S",
													"A Hole",
													"Ratatwo-ee",
													"Stairway to Hell",
													"Mind the Gap",
													"Jacob's Ladder",
													"Underachiever",
													"Top Gun",
													"The Great Escape",
													"Courage Under Fire",
													"Springtime",
													"Entirely Unnecessary",
													"Tap-a Tap-a Tap-a",
													"Get Sprung",
													"The Sting",
													"Rat Race",
													"Swingline",
													"Workplace Hazard",
													"Springfield",
													"Ladder 49",
													"Monty Hall",
													"The Beginning"];
		
		public static const REPLAY_POS:Array = [	FlxObject.UP,
													FlxObject.UP,
													FlxObject.DOWN,
													FlxObject.DOWN,
													FlxObject.NONE,
													FlxObject.UP,
													FlxObject.UP,
													FlxObject.UP,
													FlxObject.UP,
													FlxObject.UP,
													FlxObject.NONE,
													FlxObject.NONE,
													FlxObject.NONE,
													FlxObject.NONE,
													FlxObject.NONE,
													FlxObject.NONE,
													FlxObject.UP,
													FlxObject.DOWN,
													FlxObject.NONE,
													FlxObject.NONE,
													FlxObject.NONE,
													FlxObject.NONE,
													FlxObject.NONE,
													FlxObject.NONE];
		
		[Embed(source="../../../../assets/snd/click.mp3")]
		public static const ClickSND:Class;
		
	}

}