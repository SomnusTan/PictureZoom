package com.somnus.utils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Somnus
	 */
	public class TimerManager
	{
		static private var _stage:Stage;
		
		static private var _dataList:Object;
		
		public function TimerManager()
		{
		
		}
		
		public static function init(stage:Stage):void
		{
			_stage = stage;
			_dataList = new Object();
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		static private function onEnterFrame(e:Event):void
		{
			for each (var frameMethod:FrameMethod in _dataList)
			{
				if (frameMethod.addFrame() == false)
				{
					delete _dataList[frameMethod.method];
					frameMethod.exec();
					frameMethod.dispose();
				}
			}
		}
		
		/**
		 * 间隔帧执行一次
		 * @param	delay 间隔的帧数
		 * @param	method 方法
		 * @param	arg 参数
		 */
		public static function doOnceByFrame(delay:int, method:Function, arg:Array):void
		{
			if (method is Function)
			{
				var frameMethod:FrameMethod = _dataList[method];
				if (frameMethod)
				{
					frameMethod.args = arg;
					frameMethod.isLoop = false;
				}
				else
					_dataList[method] = new FrameMethod(delay, false, method, arg);
			}
		}
	
	}

}

class FrameMethod
{
	public var isLoop:Boolean;
	
	public var method:Function;
	
	public var args:Array;
	
	public var frame:int;
	
	public var delay:int;
	
	public function FrameMethod(delay:int, isLoop:Boolean, method:Function, args:Array = null)
	{
		if (delay < 1)
			delay = 1;
		this.delay = delay;
		this.isLoop = isLoop;
		this.method = method;
		this.args = args;
	}
	
	public function addFrame():Boolean
	{
		frame++;
		if (frame >= delay)
		{
			return isLoop;
		}
		return true;
	}
	
	public function exec():void
	{
		if (method is Function)
		{
			method.apply(this, args);
		}
	}
	
	public function dispose():void
	{
		if (args)
			args.length = 0;
		args = null;
		method = null;
	}
}