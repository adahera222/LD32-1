package com.ld48
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const DEFAULT_GAME_EVENT:String = "DefaultGameEvent";
		public static const USED_XRAY:String = "OnXRayUsed";
		public static const USED_SHAKE:String = "OnShakeUsed";
		public static const USED_WEIGH:String = "OnWeightUsed";
		public static const USED_HINT:String = "OnHintUsed";
		
		public static const PRESENT_OPENED:String = "OnPresentOpened";
		
		public var data:*;
		
		public function GameEvent(type:String=GameEvent.DEFAULT_GAME_EVENT, eventData:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			super(type, bubbles, cancelable);
			data = eventData;
		}
		
		override public function clone():Event {
			// Return a new instance of this event with the same parameters.
			return new GameEvent(type, data, bubbles, cancelable);
		}
	}
}