package com.somnus.alert
{
	import com.somnus.utils.TextFieldUtil;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Somnus
	 */
	public class Alert
	{
		static private var _container:DisplayObjectContainer;
		
		static private var _view:Sprite;
		
		static private var _waitingAlert:Sprite;
		
		public function Alert()
		{
			super();
		
		}
		
		public static function init(container:DisplayObjectContainer):void
		{
			_container = container;
		}
		
		public static function dispose():void
		{
			_container = null;
			if (_view)
			{
				_view.removeChildren();
				_view.graphics.clear();
				_view = null;
			}
			if (_waitingAlert)
			{
				if (_waitingAlert.parent)
					_waitingAlert.parent.removeChild(_waitingAlert);
				_waitingAlert.graphics.clear();
				_waitingAlert.removeChildren();
				_waitingAlert = null;
			}
		}
		
		static public function onResize():void
		{
			updateMask();
			if (_waitingAlert && _waitingAlert.stage)
			{
				_waitingAlert.x = (_container.stage.stageWidth - _waitingAlert.width) >> 1;
				_waitingAlert.y = (_container.stage.stageHeight - _waitingAlert.height) >> 1;
			}
		}
		
		/**
		 * 显示等待提示
		 * @param	msg
		 */
		public static function showWaiting(msg:String):void
		{
			view.removeChildren();
			var label:TextField;
			if (_waitingAlert == null)
			{
				_waitingAlert = new Sprite();
				_waitingAlert.graphics.lineStyle(0, 0x999999);
				_waitingAlert.graphics.beginFill(0xdddddd, 0.8);
				_waitingAlert.graphics.drawRect(0, 0, 360, 80);
				_waitingAlert.graphics.endFill();
				
				label = TextFieldUtil.getMultiLineTextField("center");
				label.width = _waitingAlert.width>>1;
				_waitingAlert.addChild(label);
			}
			if (label == null)
				label = _waitingAlert.getChildAt(0) as TextField;
			label.htmlText = msg;
			label.x = (_waitingAlert.width - label.textWidth) >> 1;
			label.y = (_waitingAlert.height - label.textHeight) >> 1;
			view.addChild(_waitingAlert);
			_waitingAlert.x = (_container.stage.stageWidth - _waitingAlert.width) >> 1;
			_waitingAlert.y = (_container.stage.stageHeight - _waitingAlert.height) >> 1;
			_container.addChild(view);
		}
		
		/**
		 * 隐藏等待提示
		 */
		public static function hideWaiting():void
		{
			if (view && view.parent)
				view.parent.removeChild(view);
			view.removeChildren();
		}
		
		private static function updateMask():void
		{
			if (_view)
			{
				_view.graphics.beginFill(0xffffff, 0.3);
				_view.graphics.drawRect(0, 0, _container.stage.stageWidth, _container.stage.stageHeight);
				_view.graphics.endFill();
			}
		}
		
		private static function get view():Sprite
		{
			if (_view == null)
			{
				_view = new Sprite();
				updateMask();
			}
			return _view;
		}
		
		public static function clear():void
		{
		
		}
	
	}

}