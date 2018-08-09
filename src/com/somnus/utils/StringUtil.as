package com.somnus.utils
{
	
	/**
	 * ...
	 * @author Somnus
	 */
	public class StringUtil
	{
		
		public function StringUtil()
		{
		
		}
		
		public static function getNextFileName(str:String):String
		{
			var reg:RegExp = /\(([0-9]*)\)/g;
			var result:Object;
			var canDo:Boolean = true;
			var id:int = 1;
			var index:int;
			while (canDo)
			{
				canDo = false;
				result = reg.exec(str);
				if (result is Array)
				{
					index = reg.lastIndex - result[0].length;
					canDo = true;
					id = result[1];
				}
			}
			if (index != 0)
			{
				if (index + 2 + id.toString().length == str.length)
				{
					return str.substr(0, index) + "(" + (id + 1) + ")";
				}
			}
			return str + "(1)";
		}
	
	}

}