package com.ld48.screens
{
	import com.ld48.GameEvent;
	import com.ld48.GameEventDispatcher;
	import com.ld48.GameManager;
	import com.ld48.GameScreen;
	import com.ld48.Helper;
	import com.ld48.Present;
	import com.ld48.ScreenManager;
	import com.ld48.MathHelper;
	import fl.motion.Tweenables;
	
	import flash.display.MovieClip;
	
	import flash.utils.setTimeout;
	import flash.utils.setInterval;
	
	import flash.filters.BlurFilter;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	public class PresentInspectionScreen extends GameScreen
	{
		private static var NUM_SHAKES_PER_USE:int = 20;
		private static var SHAKE_TIME:Number = 0.05;
		private static var MAX_SHAKE_VARIANCE:Number = 50;
		private static var MAX_SHAKE_ROT:Number = 10;
		
		private var _present:Present;
		
		public var xRayButton:MovieClip;
		public var shakeButton:MovieClip;
		public var weighButton:MovieClip;
		public var hintButton:MovieClip;
		
		public var tryAgainButton:MovieClip;
		public var mainMenuButton:MovieClip;
		
		public var backButton:MovieClip;
		public var selectButton:MovieClip;
		
		public var inspectDialogue:MovieClip;
		
		public var effectLayer:MovieClip;
		public var presentLayer:MovieClip;
		private var _presentMC:MovieClip;
		
		private var _canClickButtons:Boolean = true;
		
		private var _xRayMC:MovieClip = null;
		
		private var _scaleMC:MovieClip = null;
		
		public function PresentInspectionScreen(present:Present)
		{
			super();
			_present = present;
			_presentMC = Helper.getMovieClipFromLibrary(_present.type) as MovieClip;
			_presentMC.gotoAndStop(_present.color);
			_presentMC.scaleX=_presentMC.scaleY=0.75;
			_presentMC.y = _presentMC.height / 2;
			
			_presentMC.toyLayer.addChild(Helper.getMovieClipFromLibrary(_present.toy));
			
			//TODO: add toy to toy layer
			
			presentLayer.addChild(_presentMC);
			
			addButton(xRayButton);
			addButton(shakeButton);
			addButton(weighButton);
			addButton(hintButton);
			addButton(backButton);
			addButton(selectButton);
			addButton(inspectDialogue.dismissDialogueButton);
			
			updateCounters();
			
			hideDialogue();
			
			tryAgainButton.visible = false;
			mainMenuButton.visible = false;
			
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
			if(GameManager.instance.numXRaysLeft<=0 || !_canClickButtons) return;
			
			hideClueButtons();
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_XRAY));
			
			_xRayMC = Helper.getMovieClipFromLibrary("XRayMachine") as MovieClip;
			
			effectLayer.addChild(_xRayMC);
			
			var tween:Tween = new Tween(_xRayMC, "y", Elastic.easeOut, Main.HEIGHT, 0, 1.5, true);
			tween.addEventListener(TweenEvent.MOTION_FINISH, onXRayTweenComplete);
			var presentAlphaTween:Tween = new Tween(_presentMC.box, "alpha", Strong.easeOut, 1.0, 0.5, 1.5, true);
			
			//TODO:: SILHOEUTTE TOY BEHIND PRESENT
			
			updateCounters();
		}
		
		private function onXRayTweenComplete(e:TweenEvent):void
		{
			showDialogue("Used an xray!");
		}
		
		public function useShake():void
		{
			if(GameManager.instance.numShakesLeft<=0 || !_canClickButtons) return;
			
			hideClueButtons();
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_SHAKE));
			
			for (var i:int = 0; i < NUM_SHAKES_PER_USE; i++)
			{
				setTimeout(shakeAwayFromCenter, 1000 * SHAKE_TIME * (i));
				setTimeout(shakeTowardsCenter, 1000 * SHAKE_TIME * (i+1));
			}
			setTimeout(onShakeComplete, 1000 * SHAKE_TIME * NUM_SHAKES_PER_USE);
			updateCounters();
		}

		private function shakeAwayFromCenter():void
		{
			var tweenX:Tween = new Tween(_presentMC, "x", None.easeNone, _presentMC.x, MathHelper.RandomInt(-MAX_SHAKE_VARIANCE, MAX_SHAKE_VARIANCE), SHAKE_TIME, true);
			var tweenY:Tween = new Tween(_presentMC, "y", None.easeNone, _presentMC.y, _presentMC.y+MathHelper.RandomInt( -MAX_SHAKE_VARIANCE, MAX_SHAKE_VARIANCE), SHAKE_TIME, true);
			
			var tweenRot:Tween = new Tween(_presentMC, "rotation", None.easeNone, _presentMC.rotation, MathHelper.RandomInt( -MAX_SHAKE_ROT, MAX_SHAKE_ROT), SHAKE_TIME, true);
		}
		
		private function shakeTowardsCenter():void
		{
			var tweenX:Tween = new Tween(_presentMC, "x", None.easeNone, _presentMC.x, 0, SHAKE_TIME, true);
			var tweenY:Tween = new Tween(_presentMC, "y", None.easeNone, _presentMC.y, _presentMC.height / 2, SHAKE_TIME, true);
			var tweenRot:Tween = new Tween(_presentMC, "rotation", None.easeNone, _presentMC.rotation, 0, SHAKE_TIME, true);
		}
		
		private function onShakeComplete():void
		{
			showDialogue("We just shook the box!!!!!");
			//showClueButtons();
		}
		
		public function useWeigh():void
		{
			if(GameManager.instance.numWeighsLeft<=0 || !_canClickButtons) return;
			
			hideClueButtons();
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_WEIGH));
			
			_scaleMC = Helper.getMovieClipFromLibrary("ScaleMachine");
			effectLayer.addChild(_scaleMC);
			
			var scaleTween:Tween = new Tween(_scaleMC, "y", None.easeNone, Main.HEIGHT, 0, 0.15, true);
			
			var presentTween:Tween = new Tween(_presentMC, "y", None.easeNone, _presentMC.y, -_presentMC.height, 0.25, true);
			
			setTimeout(function():void
			{
				var presentTween:Tween = new Tween(_presentMC, "y", None.easeNone, -_presentMC.height, 0, 0.25, true);
				presentTween.addEventListener(TweenEvent.MOTION_FINISH, onPresentFallTweenComplete);
			}, 500);
			updateCounters();	
		}
		
		private function onPresentFallTweenComplete(e:TweenEvent):void
		{
			var downAmount:Number = 15;
			var scaleTween:Tween = new Tween(_scaleMC.top, "y", Strong.easeOut, _scaleMC.top.y, _scaleMC.top.y + downAmount, 0.15, true);
			
			var presentTween:Tween = new Tween(_presentMC, "y", Strong.easeOut, _presentMC.y, _presentMC.y + downAmount, 0.15, true);
			
			var needleTween:Tween = new Tween(_scaleMC.needle, "rotation", Strong.easeOut, 0, 180, 1.5, true);
			needleTween.addEventListener(TweenEvent.MOTION_FINISH, onNeedleFinished);
		}
		
		private function onNeedleFinished(e:TweenEvent):void
		{
			showDialogue("We just weighed something!!!");
		}
		
		public function useHint():void
		{
			if(GameManager.instance.numHintsLeft<=0 || !_canClickButtons) return;
			
			hideClueButtons();
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_HINT));
			
			setTimeout(function():void { showDialogue("This is a hint about what's in the box :D"); }, 500 );
			
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
			tryAgainButton.textField.htmlText = "Try Again";
			mainMenuButton.textField.htmlText = "To Title";
		}
		
		public function showDialogue(dialogueString:String):void
		{
			inspectDialogue.y = 448;
			inspectDialogue.textField.htmlText = dialogueString;
		}
		
		public function hideDialogue():void
		{
			inspectDialogue.y = Main.HEIGHT + inspectDialogue.height;
		}
		
		public function showDialogueConfirmButton():void
		{

		}
		
		public function hideDialogueConfirmButton():void
		{
			
		}
		
		public function hideClueButtons():void
		{
			_canClickButtons = false;
			
			setTimeout(function():void { hideClueButton(xRayButton); }, 1000 * 0.0);
			setTimeout(function():void { hideClueButton(shakeButton); }, 1000 * 0.05);
			setTimeout(function():void { hideClueButton(weighButton); }, 1000 * 0.10);
			setTimeout(function():void { hideClueButton(hintButton); }, 1000 * 0.15);
			
			setTimeout(function():void 
			{ 
				var bTween:Tween = new Tween(backButton, "y", Strong.easeIn, backButton.y, -100, 0.35, true);
			}, 1000 * 0.015);
			
			setTimeout(function():void 
			{ 
				var sTween:Tween = new Tween(selectButton, "y", Strong.easeIn, selectButton.y, -100, 0.35, true);
			}, 1000 * 0.035);
		}
		
		public function showClueButtons():void
		{
			_canClickButtons = true;
			setTimeout(function():void { showClueButton(xRayButton); }, 1000 * 0.0);
			setTimeout(function():void { showClueButton(shakeButton); }, 1000 * 0.05);
			setTimeout(function():void { showClueButton(weighButton); }, 1000 * 0.10);
			setTimeout(function():void { showClueButton(hintButton); }, 1000 * 0.15);
			
			setTimeout(function():void 
			{ 
				var bTween:Tween = new Tween(backButton, "y", Strong.easeOut, backButton.y, 11.95, 0.35, true);
			}, 1000 * 0.015);
			
			setTimeout(function():void 
			{ 
				var sTween:Tween = new Tween(selectButton, "y", Strong.easeOut, selectButton.y, 11.95, 0.35, true);
			}, 1000 * 0.035);
		}
		
		private function hideClueButton(btn:MovieClip):void
		{
			var tween:Tween = new Tween(btn, "y", Strong.easeIn, btn.y, Main.HEIGHT+btn.height, 0.35, true);
		}
		
		private function showClueButton(btn:MovieClip):void
		{
			var tween:Tween = new Tween(btn, "y", Strong.easeOut, btn.y, 456, 0.35, true);
		}
		private var openedCorrectPresent:Boolean = false;
		private var openedIncorrectPresent:Boolean = false;
		public function openPresent():void
		{
			var boxTween:Tween = new Tween(_presentMC.box, "y", Strong.easeIn, _presentMC.box.y, -Main.HEIGHT * 2, 0.35, true);
			
			if (_present.toy == GameManager.instance.currentDesiredToy)
			{
				//CORRECT!!!
				GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.PRESENT_OPENED, _present));
				
				openedCorrectPresent = true;
				
				var rotatingBurst:MovieClip = Helper.getMovieClipFromLibrary("RotatingBurst");
				var burstTweenX:Tween = new Tween(rotatingBurst, "scaleX", None.easeNone, 0, 1, 0.25, true);
				var burstTweenY:Tween = new Tween(rotatingBurst, "scaleY", None.easeNone, 0, 1, 0.25, true);
				presentLayer.addChildAt(rotatingBurst, 0);
				
				showDialogue("Congrats!");
				//ScreenManager.instance.gotoScreen(new GameplayScreen(), true);
			}
			else
			{
				openedIncorrectPresent = true;
				//INCORRECT
				showDialogue("Bwahahaha. Not even close kid. Better luck next year!");
				tryAgainButton.visible = true;
				mainMenuButton.visible = true;
				inspectDialogue.dismissDialogueButton.visible = false;
				addButton(tryAgainButton);
				addButton(mainMenuButton);
				
				trace("fail");
			}
		}
		
		override public function onButtonClicked(buttonName:String):void
		{
			super.onButtonClicked(buttonName);
			
			switch(buttonName)
			{
				case "backButton":
				{
					if (!_canClickButtons) return;
					ScreenManager.instance.gotoScreen(new GameplayScreen(),true);
					break;
				}
					
				case "selectButton":
				{
					if (!_canClickButtons) return;
					hideClueButtons();
					setTimeout(openPresent,500);
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
				
				case "tryAgainButton":
				{
					trace("TRY AGAIN CLICKED");
					GameManager.instance.resetGameplay();
					ScreenManager.instance.gotoScreen(new GameplayScreen(), true);
					break;
				}
				
				case "mainMenuButton":
				{
					trace("MAIN MENU CLICKED");
					GameManager.instance.resetGameplay();
					ScreenManager.instance.gotoScreen(new TitleScreen(), true);
					break;
				}
				
				case "dismissDialogueButton":
				{
					if (openedCorrectPresent)
					{
						if (GameManager.instance.numPresentsOpened == GameManager.TOTAL_NUM_PRESENTS)
						{
							//game win!!
						}
						else
						{
							ScreenManager.instance.gotoScreen(new GameplayScreen(), true);
						}
					}
					else if (openedIncorrectPresent)
					{
						GameManager.instance.resetGameplay();
						ScreenManager.instance.gotoScreen(new TitleScreen(), true);
					}
					else if (_xRayMC != null)
					{
						var tween:Tween = new Tween(_xRayMC, "y", None.easeNone, _xRayMC.y, Main.HEIGHT, 0.25, true);
						tween.addEventListener(TweenEvent.MOTION_FINISH, onXRayMovedOffscreen);
						var alphaTween:Tween = new Tween(_presentMC.box, "alpha", Strong.easeOut, 0.5, 1.0, 0.15, true);
					}
					else if (_scaleMC != null)
					{
						var sTween:Tween = new Tween(_scaleMC, "y", None.easeNone, _scaleMC.y, Main.HEIGHT, 0.25, true);
						sTween.addEventListener(TweenEvent.MOTION_FINISH, onScaleMovedOffscreen);
						
						var presentTween:Tween = new Tween(_presentMC, "y", None.easeNone, _presentMC.y, _presentMC.height / 2, 0.15, true);
					}
					else
					{
						hideDialogue();
						showClueButtons();
					}
					break;
				}
				
			}
		}
		
		private function onXRayMovedOffscreen(e:TweenEvent):void
		{
			_xRayMC.parent.removeChild(_xRayMC);
			_xRayMC = null;
			hideDialogue();
			showClueButtons();
		}
		
		private function onScaleMovedOffscreen(e:TweenEvent):void
		{
			_scaleMC.parent.removeChild(_scaleMC);
			_scaleMC = null;
			hideDialogue();
			showClueButtons();
		}
	}
}