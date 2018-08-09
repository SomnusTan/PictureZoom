package com.somnus.utils
{
	import com.bit101.components.Text;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author tyw
	 */
	public class Log
	{
		static private var _txt:Text;
		static private var _container:DisplayObjectContainer;
		
		public function Log()
		{
		
		}
		
		public static function initTxt(container:DisplayObjectContainer):void
		{
			_container = container;
			_txt = new Text();
			_txt.setSize(360, 65);
			_txt.editable = false;
			_txt.y = 10;
		}
		
		/**
		 * 显示
		 * @param	container
		 */
		public static function show(container:DisplayObjectContainer = null):void
		{
			if (container)
				_container = container;
			if (_txt && _txt.parent == null && _container)
				_container.addChild(_txt);
			onResize();
		}
		
		public static function hide():void
		{
			if (_txt && _txt.parent)
				_txt.parent.removeChild(_txt);
		}
		
		public static function onResize():void
		{
			if (_txt && _txt.stage)
			{
				_txt.x = _txt.stage.stageWidth - 410;
			}
		}
		
		public static function log(... args):void
		{
			_txt.text += "\n" + args;
			_txt.textField.scrollV = _txt.textField.maxScrollV + 10;
		}
		
		public static function clear():void
		{
			if (_txt)
				_txt.text = "";
		}
	
	}

}