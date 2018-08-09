package com.somnus.utils
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author 谭跃文
	 */
	public class LoaderUtil
	{
		
		private static var CACHE:HashMap = new HashMap();;
		
		public function LoaderUtil()
		{
		
		}
		
		public static function load(url:String, callBack:Function):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load(new URLRequest(url));
			CACHE.put(loader, callBack);
		}
		
		public static function loadBytes(byte:ByteArray, callBack:Function):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.loadBytes(byte);
			CACHE.put(loader, callBack);
		}
		
		static private function onLoadComplete(e:Event):void
		{
			var callBack:Function = CACHE.get((e.currentTarget as LoaderInfo).loader) as Function
			if (callBack is Function)
			{
				callBack((e.currentTarget as LoaderInfo).content);
			}
		}
		
		static public function dispose():void
		{
			var loader:Loader;
			for (var i:int = 0, j:int = CACHE.keyList.length; i < j; i++)
			{
				loader = CACHE.keyList[i] as Loader;
				if (loader)
				{
					loader.unloadAndStop();
				}
			}
			CACHE.clear();
		}
	}

}