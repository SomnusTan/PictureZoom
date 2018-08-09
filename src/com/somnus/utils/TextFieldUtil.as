package com.somnus.utils
{
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Somnus
	 */
	public class TextFieldUtil
	{
		static private var xmlTxt:TextField;
		
		public function TextFieldUtil()
		{
		
		}
		
		/**
		 * 获取文本
		 * @param	autoSize
		 * @param	selectable
		 * @param	multiline
		 * @param	wordWrap
		 * @return
		 */
		public static function getTextField(autoSize:String = "left", selectable:Boolean = false, multiline:Boolean = true, wordWrap:Boolean = true):TextField
		{
			var txt:TextField = new TextField();
			txt.selectable = selectable;
			txt.autoSize = autoSize;
			txt.wordWrap = wordWrap;
			txt.multiline = multiline;
			return txt;
		}
		
		/**
		 * 获取单行文本
		 * @param	autoSize
		 * @return
		 */
		public static function getSingleLineTextField(autoSize:String = "left"):TextField
		{
			return getTextField(autoSize, false, false, false);
		}
		
		/**
		 * 获取多行文本
		 * @param	autoSize
		 * @return
		 */
		public static function getMultiLineTextField(autoSize:String = "left"):TextField
		{
			return getTextField(autoSize, false, true, true);
		}
		
		public static function xmlStrToStr(xmlStr:String):String
		{
			if (xmlTxt == null)
			{
				xmlTxt = new TextField();
			}
			xmlTxt.htmlText = xmlStr;
			return xmlTxt.text;
		}
	
	}

}