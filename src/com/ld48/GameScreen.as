package com.ld48
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Matt
	 */
	public class GameScreen extends MovieClip 
	{
		private var _initialized:Boolean = false;
		
		public var buttons:Vector.<MovieClip>;
		
		public function GameScreen() 
		{
			super();
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			initTextFields(Main.strings);
		}
		
		public function init():void
		{
			
		}
		
		public function initTextFields(_strings:XML):void
		{
			
		}
		
		public function addButton(button:MovieClip):void
		{
			if (buttons == null)
			{
				buttons = new Vector.<MovieClip>();
			}
			
			if (buttons.indexOf(button) != -1) return;
			
			buttons.push(button);
			
			initButton(button);
		}
		
		public function initButton(button:MovieClip):void
		{
			button.mouseChildren = false;
			button.gotoAndStop(1);
			
			button.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			button.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onKeyDown(e:KeyboardEvent):void	
		{
			//override m
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			if (e.currentTarget.totalFrames > 1)
			{
				e.currentTarget.gotoAndStop(2);
				if (e.currentTarget.rollover_mc)
				{
					e.currentTarget.rollover_mc.gotoAndPlay(1);
				}
			}
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			e.currentTarget.gotoAndStop(1);
			if (e.currentTarget.rollover_mc)
			{
				if (e.currentTarget.rollover_mc.currentFrame < 10)
				{
					e.currentTarget.rollover_mc.gotoAndPlay(e.currentTarget.rollover_mc.currentFrame + 10);
				}
				else
				{
					e.currentTarget.rollover_mc.gotoAndPlay(10);
				}
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			onButtonClicked(e.currentTarget.name);
		}
		
		public function onButtonClicked(buttonName:String):void
		{
			//override me
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (!_initialized)
			{
				init();
				_initialized = true;
			}
			if(this.currentFrame==this.totalFrames)
			{
				this.stop();
			}
			update();
		}
		
		public function onTransitionComplete():void
		{
			//override me
		}
		
		public function update():void
		{
			//override me
		}
		
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (buttons != null)
			{
				for (var i:int = 0; i < buttons.length; i++)
				{
					buttons[i].removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					buttons[i].removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
					buttons[i].removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				}
				
				buttons = null;
			}
			
			if (parent)
			{
				parent.removeChild(this);
			}
			trace("GameScreen::destroy");
		}
		
	}

}