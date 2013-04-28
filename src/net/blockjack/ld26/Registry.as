package net.blockjack.ld26 
{
	import net.blockjack.ld26.states.PlayState;
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
		public static const LEVEL_NAMES:Array =[	"Level 1",
													"Level 2",
													"Level 3",
													"Level 4"];
		
	}

}