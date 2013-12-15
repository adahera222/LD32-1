package com.ld48 
{
	/**
	 * ...
	 * @author Matt
	 */
	public class Toy 
	{
		public var name:String;
		public var type:String;
		public var weighRotationAmount:Number;
		
		public function Toy(_name:String, _type:String, _weighRotationAmount:Number = 0 ) 
		{
			name = _name;
			type = _type;
			weighRotationAmount = _weighRotationAmount;
		}
		
		public static function getStringNameForToy(name:String):String
		{
			return Main.strings[name.toUpperCase() + "_NAME"];
		}
		public static function getShakeTextForToy(name:String):String
		{
			return Main.strings[name.toUpperCase() + "_SHAKE"];
		}
		public static function getWeighTextForToy(name:String):String
		{
			return Main.strings[name.toUpperCase() + "_WEIGH"];
		}
		public static function getHintTextForToy(name:String):String
		{
			return Main.strings[name.toUpperCase() + "_HINT"];
		}
		
	}

}