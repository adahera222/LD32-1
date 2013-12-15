package com.ld48.screens
{
	import com.ld48.GameManager;
	import com.ld48.GameScreen;
	import com.ld48.Helper;
	import com.ld48.Present;
	import com.ld48.ScreenManager;
	import com.ld48.Toy;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.None;
	import flash.events.MouseEvent;
	
	import flash.display.MovieClip;
	
	public class GameplayScreen extends GameScreen
	{
		public var hud:MovieClip;
		public var dialogueBox:MovieClip;
		
		public var presentHolder1:MovieClip;
		public var presentHolder2:MovieClip;
		public var presentHolder3:MovieClip;
		public var presentHolder4:MovieClip;
		public var presentHolder5:MovieClip;
		public var presentHolder6:MovieClip;
		public var presentHolder7:MovieClip;
		public var presentHolder8:MovieClip;
		
		public var homeButton:MovieClip;
		
		private var holders:Vector.<MovieClip>;
		
		public function GameplayScreen()
		{
			super();
			
			homeButton.visible = false;
			
			holders = new Vector.<MovieClip>();
			holders.push(presentHolder1);
			holders.push(presentHolder2);
			holders.push(presentHolder3);
			holders.push(presentHolder4);
			holders.push(presentHolder5);
			holders.push(presentHolder6);
			holders.push(presentHolder7);
			holders.push(presentHolder8);
			
			for(var i:int=0; i<holders.length; i++)
			{
				var present:Present = GameManager.instance.getAvailablePresentAtIndex(i);
				if (present == null)
				{
					present = GameManager.instance.getOpenedPresentAtIndex(i);
					var toy:MovieClip = Helper.getMovieClipFromLibrary(present.toy);
					holders[i].addChild(toy);
					toy.scaleX = toy.scaleY = 0.5;
					toy.y = -toy.height / 2;
				
				}
				if (!present.isOpened)
				{
					var presentMC:MovieClip = Helper.getMovieClipFromLibrary(present.type);
					presentMC.gotoAndStop(present.color);
					presentMC.scaleX=presentMC.scaleY=0.5;
					holders[i].addChild(presentMC);
					addButton(holders[i]);
					holders[i].addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHolder);
					holders[i].addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHolder);
				}
			}
			
			updateHud();
		}
		
		private function updateHud():void
		{
			if (GameManager.instance.gameWon())
			{
				homeButton.visible = true;
				homeButton.textField.htmlText = "To Title";
				addButton(homeButton);
				dialogueBox.textField.htmlText = "<font color='#FF3668'>Christmas is saved!</font> You opened all your presents!";
			}
			else
			{
				hud.rotatingBurst.visible = false;
				dialogueBox.textField.htmlText = "Why don't you pick out the <font color='#FF3668'>" + Toy.getStringNameForToy(GameManager.instance.currentDesiredToy) + "</font> this time!";
			}
			hud.presentCount.htmlText = GameManager.instance.numPresentsOpened + "/" + GameManager.TOTAL_NUM_PRESENTS;
		}
		
		private function onMouseOverHolder(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var tweenX:Tween = new Tween(mc, "scaleX", None.easeNone, mc.scaleX, 1.05, 0.15, true);
			var tweenY:Tween = new Tween(mc, "scaleY", None.easeNone, mc.scaleY, 1.05, 0.15, true);
		}
		
		private function onMouseOutHolder(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			var tweenX:Tween = new Tween(mc, "scaleX", None.easeNone, mc.scaleX, 1.0, 0.15, true);
			var tweenY:Tween = new Tween(mc, "scaleY", None.easeNone, mc.scaleY, 1.0, 0.15, true);
		}
		
		override public function onButtonClicked(buttonName:String):void
		{
			super.onButtonClicked(buttonName);
			
			if(buttonName.indexOf("Holder")!=-1)
			{
				var buttonNum:int = int(buttonName.charAt(buttonName.length-1));
				
				var present:Present = GameManager.instance.getAvailablePresentAtIndex(buttonNum-1);
				ScreenManager.instance.gotoScreen(new PresentInspectionScreen(present),true);
			}
			
			if (buttonName == "homeButton")
			{
				GameManager.instance.resetGameplay();
				ScreenManager.instance.gotoScreen(new TitleScreen(), true);
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			for (var i:int = 0; i < holders.length; i++)
			{
				if (holders[i].hasEventListener(MouseEvent.MOUSE_OVER))
				{
					holders[i].removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHolder);
				}
				if (holders[i].hasEventListener(MouseEvent.MOUSE_OUT))
				{
					holders[i].removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHolder);
				}
			}
		}
	}
}