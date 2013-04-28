package net.blockjack.ld26.ui 
{
	import net.blockjack.ld26.Main;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author James Robinson
	 */
	public class InfoPopup extends FlxSprite
	{
		
		[Embed(source="../../../../../assets/gfx/ui/RestartMessage.png")]
		private const InfoPopupsPNG:Class;
		
		private const ANIM_RESTART:String = "restart";
		private const ANIM_REPLAY_COMPLETE:String = "replayComplete";
		
		public function InfoPopup() 
		{
			loadAnimations();
		}
		
		private function loadAnimations():void {
			loadGraphic(InfoPopupsPNG, true, false, Main.SWF_WIDTH, Main.SWF_HEIGHT);
			addAnimation(ANIM_RESTART, [0]);
			addAnimation(ANIM_REPLAY_COMPLETE, [1]);
			alpha = 0;
		}
		
		public function showRestart():void {
			play(ANIM_RESTART);
			alpha = 0.01;
		}
		
		public function showReplayComplete():void {
			play(ANIM_REPLAY_COMPLETE);
			alpha = 0.01;
		}
		
		override public function update():void {
			super.update();
			
			if (alpha > 0) {
				alpha += 0.005;
			}
		}
		
		public function isShowing():Boolean {
			return alpha > 0;
		}
		
	}

}