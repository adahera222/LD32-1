package com.ld48.screens
{
	import com.ld48.GameManager;
	import com.ld48.GameScreen;
	import com.ld48.Helper;
	import com.ld48.Present;
	import com.ld48.ScreenManager;
	
	import flash.display.MovieClip;
	
	public class GameplayScreen extends GameScreen
	{
		
		public var presentHolder1:MovieClip;
		public var presentHolder2:MovieClip;
		public var presentHolder3:MovieClip;
		public var presentHolder4:MovieClip;
		public var presentHolder5:MovieClip;
		public var presentHolder6:MovieClip;
		public var presentHolder7:MovieClip;
		public var presentHolder8:MovieClip;
		
		private var holders:Vector.<MovieClip>;
		
		public function GameplayScreen()
		{
			super();
			
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
				if(present==null)
				{
					present = new Present(GameManager.instance.getRandomPresentClass(),GameManager.instance.getRandomPresentColor(),"",i);
					GameManager.instance.addPresent(present);
				}
				var presentMC:MovieClip = Helper.getMovieClipFromLibrary(present.type);
				presentMC.gotoAndStop(present.color);
				presentMC.scaleX=presentMC.scaleY=0.75;
				holders[i].addChild(presentMC);
				addButton(holders[i]);
			}
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
		}
	}
}