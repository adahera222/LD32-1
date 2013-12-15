package com.ld48
{
	public class Present
	{
		public var color:String;
		public var type:String;
		public var toy:String;
		
		public var holderIndex:int;
		
		public var isOpened:Boolean = false;
		
		public static const COLOR_RED:String = "red";
		public static const COLOR_BLUE:String = "blue";
		public static const COLOR_GREEN:String = "green";
		public static const COLOR_YELLOW:String = "yellow";
		
		public static const TYPE_SMALL:String = "SmallPresent";
		public static const TYPE_LONG:String = "LongPresent";
		public static const TYPE_TALL:String = "TallPresent";
		
		public static const TOY_BASEBALL_BAT:String = "baseballBat";
		public static const TOY_ACTION_FIGURE:String = "actionFigure";
		public static const TOY_STUFFED_ANIMAL:String = "stuffedAnimal";
		
		public function Present(_type:String,_color:String,_toy:String,_holderIndex:int)
		{
			type=_type;
			color=_color;
			toy=_toy;
			holderIndex=_holderIndex;
		}
		
		public static function getWeightStringForToy(_toy:String):String
		{
			return "";
		}
		
		public static function getShakeStringForToy(_toy:String):String
		{
			return "";
		}
		
		public static function getHintStringForToy(_toy:String):String
		{
			return "";
		}
		
		public static function getRandomToyForType(_type:String):String
		{
			switch(_type)
			{
				case TYPE_SMALL:
					break;
				case TYPE_LONG:
					break;
				case TYPE_TALL:
					break;
			}
			
			return "";
		}
	}
}