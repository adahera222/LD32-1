package com.ld48.screens
{
	import com.ld48.GameEvent;
	import com.ld48.GameEventDispatcher;
	import com.ld48.GameManager;
	import com.ld48.GameScreen;
	import com.ld48.Helper;
	import com.ld48.Present;
	import com.ld48.ScreenManager;
	
	import flash.display.MovieClip;
	
	public class PresentInspectionScreen extends GameScreen
	{
		private var _present:Present;
		
		public var xRayButton:MovieClip;
		public var shakeButton:MovieClip;
		public var weighButton:MovieClip;
		public var hintButton:MovieClip;
		
		public var backButton:MovieClip;
		public var selectButton:MovieClip;
		
		public var presentLayer:MovieClip;
		private var _presentMC:MovieClip;
		
		public function PresentInspectionScreen(present:Present)
		{
			super();
			_present = present;
			_presentMC = Helper.getMovieClipFromLibrary(_present.type) as MovieClip;
			_presentMC.gotoAndStop(_present.color);
			_presentMC.scaleX=_presentMC.scaleY=0.75;
			_presentMC.y = _presentMC.height/2;
			
			//TODO: add toy to toy layer
			
			presentLayer.addChild(_presentMC);
			
			addButton(xRayButton);
			addButton(shakeButton);
			addButton(weighButton);
			addButton(hintButton);
			addButton(backButton);
			addButton(selectButton);
			
			updateCounters();
			
		}
		
		private function updateCounters():void
		{
			xRayButton.counter.textField.text = GameManager.instance.numXRaysLeft.toString();
			shakeButton.counter.textField.text = GameManager.instance.numShakesLeft.toString();
			weighButton.counter.textField.text = GameManager.instance.numWeighsLeft.toString();
			hintButton.counter.textField.text = GameManager.instance.numHintsLeft.toString();
		}
		
		public function useXRay():void
		{
			if(GameManager.instance.numXRaysLeft<=0) return;
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_XRAY));
			
			updateCounters();
		}
		
		public function useShake():void
		{
			if(GameManager.instance.numShakesLeft<=0) return;
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_SHAKE));
			
			updateCounters();
		}
		
		public function useWeigh():void
		{
			if(GameManager.instance.numWeighsLeft<=0) return;
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_WEIGH));
			
			updateCounters();	
		}
		
		public function useHint():void
		{
			if(GameManager.instance.numHintsLeft<=0) return;
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_HINT));
			
			updateCounters();
		}
		
		override public function initTextFields(_strings:XML):void
		{
			super.initTextFields(_strings);
			xRayButton.textField.htmlText = "X-Ray";
			shakeButton.textField.htmlText = "Shake";
			weighButton.textField.htmlText = "Weigh";
			hintButton.textField.htmlText = "Hint";
			backButton.textField.htmlText = "Back";
			selectButton.textField.htmlText = "Choose!";
		}
		
		override public function onButtonClicked(buttonName:String):void
		{
			super.onButtonClicked(buttonName);
			
			switch(buttonName)
			{
				case "backButton":
				{
					ScreenManager.instance.gotoScreen(new GameplayScreen(),true);
					break;
				}
					
				case "selectButton":
				{
					break;
				}
					
				case "xRayButton":
				{
					useXRay();
					break;
				}
					
				case "shakeButton":
				{
					useShake();
					break;
				}
					
				case "weighButton":
				{
					useWeigh();
					break;
				}
					
				case "hintButton":
				{
					useHint();
					break;
				}
				
			}
		}
	}
}