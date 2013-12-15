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
	import com.ld48.Toy;
	import com.ld48.SoundManager;
	
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
			
			presentLayer.addChild(_presentMC);
			
			addButton(xRayButton);
			addButton(shakeButton);
			addButton(weighButton);
			addButton(hintButton);
			addButton(backButton);
			addButton(selectButton);
			addButton(inspectDialogue.dismissDialogueButton);
			
			xRayButton.icon.gotoAndStop(1);
			shakeButton.icon.gotoAndStop(2);
			weighButton.icon.gotoAndStop(3);
			hintButton.icon.gotoAndStop(4);
			
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
		
		private var xRayTweenOn:Tween;
		public function useXRay():void
		{
			if(GameManager.instance.numXRaysLeft<=0 || !_canClickButtons) return;
			
			hideClueButtons();
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_XRAY));
			
			_xRayMC = Helper.getMovieClipFromLibrary("XRayMachine") as MovieClip;
			
			effectLayer.addChild(_xRayMC);
			
			xRayTweenOn = new Tween(_xRayMC, "y", Elastic.easeOut, Main.HEIGHT, 0, 1.5, true);
			xRayTweenOn.addEventListener(TweenEvent.MOTION_FINISH, onXRayTweenComplete);
			var presentAlphaTween:Tween = new Tween(_presentMC.box, "alpha", Strong.easeOut, 1.0, 0.5, 1.5, true);
			
			updateCounters();
		}
		
		private function onXRayTweenComplete(e:TweenEvent):void
		{
			xRayTweenOn.removeEventListener(TweenEvent.MOTION_FINISH, onXRayTweenComplete);
			xRayTweenOn = null;
			showDialogue(Main.strings["XRAY_"+MathHelper.RandomInt(1,6).toString()]);
		}
		
		public function useShake():void
		{
			if(GameManager.instance.numShakesLeft<=0 || !_canClickButtons) return;
			
			hideClueButtons();
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_SHAKE));
			
			for (var i:int = 0; i < NUM_SHAKES_PER_USE; i++)
			{
				var shakeAway:uint = setTimeout(shakeAwayFromCenter, 1000 * SHAKE_TIME * (i));
				var shakeTowards:uint = setTimeout(shakeTowardsCenter, 1000 * SHAKE_TIME * (i+1));
			}
			var shakeComplete:uint = setTimeout(onShakeComplete, 1000 * SHAKE_TIME * NUM_SHAKES_PER_USE);
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
			SoundManager.instance.playSFX("ShakeSFX");
		}
		
		private function onShakeComplete():void
		{
			showDialogue(Toy.getShakeTextForToy(_present.toy));
			//showClueButtons();
		}
		
		private var presentFallTween:Tween;
		public function useWeigh():void
		{
			if(GameManager.instance.numWeighsLeft<=0 || !_canClickButtons) return;
			
			hideClueButtons();
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_WEIGH));
			
			_scaleMC = Helper.getMovieClipFromLibrary("ScaleMachine");
			effectLayer.addChild(_scaleMC);
			
			var scaleTween:Tween = new Tween(_scaleMC, "y", None.easeNone, Main.HEIGHT, 0, 0.15, true);
			
			var presentTween:Tween = new Tween(_presentMC, "y", None.easeNone, _presentMC.y, -_presentMC.height, 0.25, true);
			
			var weighPresentTimeout:uint = setTimeout(function():void
			{
				presentFallTween = null;
				presentFallTween = new Tween(_presentMC, "y", None.easeNone, -_presentMC.height, 0, 0.25, true);
				presentFallTween.addEventListener(TweenEvent.MOTION_FINISH, onPresentFallTweenComplete);
				SoundManager.instance.playSFX("OnScaleSFX");
			}, 500);
			updateCounters();	
		}
		
		private var needleTween:Tween;
		private function onPresentFallTweenComplete(e:TweenEvent):void
		{
			presentFallTween.removeEventListener(TweenEvent.MOTION_FINISH, onPresentFallTweenComplete);
			var downAmount:Number = 15;
			var scaleTween:Tween = new Tween(_scaleMC.top, "y", Strong.easeOut, _scaleMC.top.y, _scaleMC.top.y + downAmount, 0.15, true);
			
			var presentTween:Tween = new Tween(_presentMC, "y", Strong.easeOut, _presentMC.y, _presentMC.y + downAmount, 0.15, true);
			
			needleTween = null;
			needleTween = new Tween(_scaleMC.needle, "rotation", Strong.easeOut, 0, _present.weighRotation, 1.5, true);
			needleTween.addEventListener(TweenEvent.MOTION_FINISH, onNeedleFinished);
		}
		
		private function onNeedleFinished(e:TweenEvent):void
		{
			needleTween.removeEventListener(TweenEvent.MOTION_FINISH, onNeedleFinished);
			showDialogue(Toy.getWeighTextForToy(_present.toy));
		}
		
		public function useHint():void
		{
			if(GameManager.instance.numHintsLeft<=0 || !_canClickButtons) return;
			
			hideClueButtons();
			
			GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.USED_HINT));
			
			var showDialogueFromHintTimeout:uint = setTimeout(function():void { showDialogue(Toy.getHintTextForToy(_present.toy)); }, 500 );
			
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
		
		private var hideXRayButtonTween:Tween;
		private var hideShakeButtonTween:Tween;
		private var hideWeighButtonTween:Tween;
		private var hideHintButtonTween:Tween;
		private var hideBackButtonTween:Tween;
		private var hideSelectButtonTween:Tween;
		
		private var hideXRayTimeout:uint;
		private var hideShakeTimeout:uint;
		private var hideWeighTimeout:uint;
		private var hideHintTimeout:uint;
		private var hideBackTimeout:uint;
		private var hideSelectTimeout:uint;
		
		public function hideClueButtons():void
		{
			SoundManager.instance.playSFX("XRaySFX");
			_canClickButtons = false;
			
			hideXRayTimeout = setTimeout(function():void 
			{ 
				hideXRayButtonTween = new Tween(xRayButton, "y", Strong.easeIn, xRayButton.y, Main.HEIGHT+xRayButton.height, 0.35, true);
			}, 1000 * 0.0);
			
			hideShakeTimeout = setTimeout(function():void 
			{ 
				hideShakeButtonTween = new Tween(shakeButton, "y", Strong.easeIn, shakeButton.y, Main.HEIGHT+shakeButton.height, 0.35, true);
			}, 1000 * 0.05);
			
			hideWeighTimeout = setTimeout(function():void 
			{ 
				hideWeighButtonTween = new Tween(weighButton, "y", Strong.easeIn, weighButton.y, Main.HEIGHT+weighButton.height, 0.35, true);
			}, 1000 * 0.10);
			
			hideHintTimeout = setTimeout(function():void 
			{ 
				hideHintButtonTween = new Tween(hintButton, "y", Strong.easeIn, hintButton.y, Main.HEIGHT+hintButton.height, 0.35, true);
			}, 1000 * 0.15);
			
			hideBackTimeout = setTimeout(function():void 
			{ 
				hideBackButtonTween = new Tween(backButton, "y", Strong.easeIn, backButton.y, -100, 0.35, true);
			}, 1000 * 0.015);
			
			hideSelectTimeout = setTimeout(function():void 
			{ 
				hideSelectButtonTween = new Tween(selectButton, "y", Strong.easeIn, selectButton.y, -100, 0.35, true);
			}, 1000 * 0.035);
		}
		
		private var showXRayButtonTween:Tween;
		private var showShakeButtonTween:Tween;
		private var showWeighButtonTween:Tween;
		private var showHintButtonTween:Tween;
		private var showBackButtonTween:Tween;
		private var showSelectButtonTween:Tween;
		
		private var showXRayTimeout:uint;
		private var showShakeTimeout:uint;
		private var showWeighTimeout:uint;
		private var showHintTimeout:uint;
		private var showBackTimeout:uint;
		private var showSelectTimeout:uint;
		
		public function showClueButtons():void
		{
			SoundManager.instance.playSFX("XRaySFX");
			_canClickButtons = true;
			showXRayTimeout = setTimeout(function():void 
			{ 
				showXRayButtonTween = new Tween(xRayButton, "y", Strong.easeOut, xRayButton.y, 456, 0.35, true);
			}, 1000 * 0.0);
			
			showShakeTimeout = setTimeout(function():void 
			{ 
				showShakeButtonTween = new Tween(shakeButton, "y", Strong.easeOut, shakeButton.y, 456, 0.35, true);
			}, 1000 * 0.05);
			
			showWeighTimeout = setTimeout(function():void 
			{ 
				showWeighButtonTween = new Tween(weighButton, "y", Strong.easeOut, weighButton.y, 456, 0.35, true);
			}, 1000 * 0.10);
			showHintTimeout = setTimeout(function():void 
			{ 
				showHintButtonTween = new Tween(hintButton, "y", Strong.easeOut, hintButton.y, 456, 0.35, true);
			}, 1000 * 0.15);
			
			showBackTimeout = setTimeout(function():void 
			{ 
				showBackButtonTween = new Tween(backButton, "y", Strong.easeOut, backButton.y, 11.95, 0.35, true);
			}, 1000 * 0.015);
			
			showSelectTimeout = setTimeout(function():void 
			{ 
				showSelectButtonTween = new Tween(selectButton, "y", Strong.easeOut, selectButton.y, 11.95, 0.35, true);
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
		private var openPresentBoxTween:Tween;
		public function openPresent():void
		{
			openPresentBoxTween = new Tween(_presentMC.box, "y", Strong.easeIn, _presentMC.box.y, -Main.HEIGHT * 2, 0.35, true);
			
			if (_present.toy == GameManager.instance.currentDesiredToy)
			{
				//CORRECT!!!
				GameEventDispatcher.dispatchEvent(new GameEvent(GameEvent.PRESENT_OPENED, _present));
				
				openedCorrectPresent = true;
				
				var rotatingBurst:MovieClip = Helper.getMovieClipFromLibrary("RotatingBurst");
				var burstTweenX:Tween = new Tween(rotatingBurst, "scaleX", None.easeNone, 0, 1, 0.25, true);
				var burstTweenY:Tween = new Tween(rotatingBurst, "scaleY", None.easeNone, 0, 1, 0.25, true);
				presentLayer.addChildAt(rotatingBurst, 0);
				
				showDialogue(Main.strings["CORRECT_PRESENT_" + MathHelper.RandomInt(1, 9)]);
				
				SoundManager.instance.playSFX("CorrectPresent");
				//ScreenManager.instance.gotoScreen(new GameplayScreen(), true);
			}
			else
			{
				openedIncorrectPresent = true;
				//INCORRECT
				showDialogue(Main.strings["INCORRECT_PRESENT_"+MathHelper.RandomInt(1,4)]);
				tryAgainButton.visible = true;
				mainMenuButton.visible = true;
				inspectDialogue.dismissDialogueButton.visible = false;
				addButton(tryAgainButton);
				addButton(mainMenuButton);
				
				trace("fail");
			}
		}
		
		private var xRayTweenOff:Tween;
		private var scaleTweenOff:Tween;
		private var openPresentTimeout:uint;
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
					openPresentTimeout = setTimeout(openPresent,500);
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
							ScreenManager.instance.gotoScreen(new GameplayScreen(), true);
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
						xRayTweenOff = new Tween(_xRayMC, "y", None.easeNone, _xRayMC.y, Main.HEIGHT, 0.25, true);
						xRayTweenOff.addEventListener(TweenEvent.MOTION_FINISH, onXRayMovedOffscreen);
						var alphaTween:Tween = new Tween(_presentMC.box, "alpha", Strong.easeOut, 0.5, 1.0, 0.15, true);
					}
					else if (_scaleMC != null)
					{
						scaleTweenOff = new Tween(_scaleMC, "y", None.easeNone, _scaleMC.y, Main.HEIGHT, 0.25, true);
						scaleTweenOff.addEventListener(TweenEvent.MOTION_FINISH, onScaleMovedOffscreen);
						
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
			xRayTweenOff.removeEventListener(TweenEvent.MOTION_FINISH, onXRayMovedOffscreen);
			xRayTweenOff = null;
			
			_xRayMC.parent.removeChild(_xRayMC);
			_xRayMC = null;
			hideDialogue();
			showClueButtons();
		}
		
		private function onScaleMovedOffscreen(e:TweenEvent):void
		{
			scaleTweenOff.removeEventListener(TweenEvent.MOTION_FINISH, onScaleMovedOffscreen);
			scaleTweenOff = null;
			_scaleMC.parent.removeChild(_scaleMC);
			_scaleMC = null;
			hideDialogue();
			showClueButtons();
		}
	}
}