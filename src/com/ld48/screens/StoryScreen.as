package com.ld48.screens
{
	import com.ld48.GameScreen;
	import com.ld48.ScreenManager;
	import flash.display.MovieClip;
	
	public class StoryScreen extends GameScreen
	{
		public var nextButton:MovieClip;
		public var skipButton:MovieClip;
		
		public function StoryScreen()
		{
			super();
			addButton(nextButton);
			addButton(skipButton);
		}
		
		override public function update():void
		{
			super.update();
			if (this.currentFrameLabel == "stopFrame")
			{
				this.stop();
			}
		}
		
		override public function onButtonClicked(buttonName:String):void
		{
			super.onButtonClicked(buttonName);
			
			switch(buttonName)
			{
				case "nextButton":
				{
					if(this.currentFrame==this.totalFrames)
						ScreenManager.instance.gotoScreen(new GameplayScreen(), true);
					else
						play();
					
					break;
				}
				
				case "skipButton":
				{
					ScreenManager.instance.gotoScreen(new GameplayScreen(), true);
					break;
				}
			}
		}
	}
}