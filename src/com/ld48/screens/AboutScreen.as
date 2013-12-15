package com.ld48.screens 
{
	import com.ld48.GameScreen;
	import com.ld48.ScreenManager;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Matt
	 */
	public class AboutScreen extends GameScreen 
	{
		public var backButton:MovieClip;
		
		public function AboutScreen() 
		{
			super();
			addButton(backButton);
		}
		
		override public function initTextFields(_strings:XML):void
		{
			super.initTextFields(_strings);
			backButton.textField.htmlText = "Back";
		}
		
		override public function onButtonClicked(buttonName:String):void
		{
			super.onButtonClicked(buttonName);
			
			switch(buttonName)
			{
				case "backButton":
				{
					ScreenManager.instance.gotoScreen(new TitleScreen(),true);
					break;
				}
			}
		}
		
	}

}