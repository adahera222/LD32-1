package com.ld48 
{
	/**
	 * ...
	 * @author Matt
	 */
	public class GameManager 
	{
		private static var _instance:GameManager;
		public static function get instance():GameManager { return _instance; }
		
		private static var NUM_STARTING_XRAYS:int = 2;
		private static var NUM_STARTING_SHAKES:int = 2;
		private static var NUM_STARTING_WEIGHS:int = 2;
		private static var NUM_STARTING_HINTS:int = 2;
		
		private var _numXRaysLeft:int;
		public function get numXRaysLeft():int { return _numXRaysLeft; }
		private var _numShakesLeft:int;
		public function get numShakesLeft():int { return _numShakesLeft; }
		private var _numWeighsLeft:int;
		public function get numWeighsLeft():int { return _numWeighsLeft; }
		private var _numHintsLeft:int;
		public function get numHintsLeft():int { return _numHintsLeft; }
		
		private var _presents:Vector.<Present>;
		
		public function GameManager() 
		{
			if (_instance != null)
			{
				trace("WARNING! An instance of Game Manager already exists");
			}
			else
			{
				_instance = this;
			}
			
			init();
		}
		
		private function init():void
		{
			GameEventDispatcher.addEventListener(GameEvent.USED_XRAY,onXRayUsed);
			GameEventDispatcher.addEventListener(GameEvent.USED_SHAKE, onShakeUsed);
			GameEventDispatcher.addEventListener(GameEvent.USED_WEIGH, onWeighUsed);
			GameEventDispatcher.addEventListener(GameEvent.USED_HINT, onHintUsed);
			
			resetGameplay();
		}
		
		private function resetGameplay():void
		{
			_presents = null;
			_presents = new Vector.<Present>();
			
			_numXRaysLeft=NUM_STARTING_XRAYS;
			_numShakesLeft=NUM_STARTING_SHAKES;
			_numWeighsLeft=NUM_STARTING_WEIGHS;
			_numHintsLeft=NUM_STARTING_HINTS;
		}
		
		private function onXRayUsed(e:GameEvent):void
		{
			_numXRaysLeft--;
		}
		
		private function onShakeUsed(e:GameEvent):void
		{
			_numShakesLeft--;
		}
		
		private function onWeighUsed(e:GameEvent):void
		{
			_numWeighsLeft--;
		}
		
		private function onHintUsed(e:GameEvent):void
		{
			_numHintsLeft--;
		}
		
		public function getRandomPresentClass():String
		{
			var rand:Number = Math.random()*100;
			if(rand<33)
				return "SmallPresent";
			if(rand<66)
				return "LongPresent";
			return "TallPresent";
		}
		
		public function getRandomPresentColor():String
		{
			var rand:Number = Math.random()*100;
			if(rand<25)
				return "red";
			if(rand<50)
				return "green";
			if(rand<75)
				return "blue";
			return "yellow";
		}
		
		public function addPresent(present:Present):void
		{
			_presents.push(present);
		}
		
		public function getAvailablePresentAtIndex(index:int):Present
		{
			for(var i:int=0; i<_presents.length; i++)
			{
				if(_presents[i].holderIndex==index)
				{
					return _presents[i];
				}
			}
			
			return null;
		}
		
	}

}