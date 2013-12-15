package com.ld48.screens 
{
	import com.ld48.GameScreen;
	import com.ld48.ScreenManager;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Matt
	 */
	public class TitleScreen extends GameScreen
	{
		public var playButton:MovieClip;
		public var aboutButton:MovieClip;
		
		public function TitleScreen() 
		{
			super();
			addButton(playButton);
			addButton(aboutButton);
		}
		
		override public function init():void
		{
			super.init();
			if(ScreenManager.instance.busy)
				gotoAndStop(1);
		}
		
		override public function onTransitionComplete():void
		{
			play();
		}
		
		override public function initTextFields(_strings:XML):void
		{
			super.initTextFields(_strings);
			playButton.textField.htmlText = "Play";
			aboutButton.textField.htmlText = "About";
		}
		
		override public function onButtonClicked(buttonName:String):void
		{
			super.onButtonClicked(buttonName);
			
			switch(buttonName)
			{
				case "playButton":
				{
					//ScreenManager.instance.gotoScreen(new GameplayScreen(),true);
					ScreenManager.instance.gotoScreen(new StoryScreen(),true);
					break;
				}
				case "aboutButton":
				{
					ScreenManager.instance.gotoScreen(new AboutScreen(), true);
					break;
				}
			}
		}
		
		
	}

}