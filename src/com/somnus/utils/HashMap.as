package com.somnus.utils
{
	import flash.utils.Dictionary;

	/**
	 *
	 * @author 谭跃文
	 * @date：2017-2-22 下午2:21:50
	 */
	public class HashMap
	{
		protected var _dict:Dictionary = null;
		/**可以控制字典类序列*/
		protected var _keyList:Array = null;

		public function HashMap(weakKeys:Boolean = false)
		{
			_dict = new Dictionary(weakKeys);
			_keyList = [];
		}

		public function put(key:Object , value:Object):void
		{
			if (key != null)
			{
				if(_keyList.indexOf(key)==-1)
				{
					_keyList.push(key);
				}
				_dict[key] = value;
			}
			else
			{
				throw new ArgumentError("cannot put a value with undefined or null key!");
			}
		}

		/**
		 * 移除键
		 * @param key
		 */
		public function remove(key:Object):void
		{
			var i:int = _keyList.indexOf(key);
			_keyList.splice(i , 1);
			if (_dict[key])
			{
				delete _dict[key];
			}
		}

		/**
		 * 清空HashMap
		 */
		public function clear():void
		{
			for (var i:int = 0 , j:int = _keyList.length ; i < j ; i++)
			{
				delete _dict[_keyList[i]];
			}
			_keyList.length = 0;
		}

		/**
		 * 获取对应的值
		 * @param key
		 * @return
		 */
		public function get(key:Object):Object
		{
			return _dict[key];
		}

		/**
		 * 查询对应值的索引
		 * @param value
		 * @return
		 */
		public function indexOf(value:Object):int
		{
			var i:int = 0;
			for (var key:Object in _dict)
			{
				if (_dict[key] == value)
				{
					return i;
				}
				i++;
			}
			return -1;
		}

		/**
		 * HashMap的长度
		 * @return
		 */
		public function length():int
		{
			return _keyList.length;
		}

		/**
		 * HashMap是否为空
		 * @return
		 */
		public function isEmpty():Boolean
		{
			return _keyList.length == 0;
		}

		/**
		 * 克隆一个HashMap
		 * @return
		 */
		public function clone():HashMap
		{
			var hashMap:HashMap = new HashMap();
			for each (var key:Object in _keyList)
			{
				hashMap.keyList.push(key);
				hashMap.put(key , _dict[key]);
			}
			return hashMap;
		}

		/**
		 * 判断HashMap中是否拥有键
		 * @param key
		 * @return
		 */
		public function containsKey(key:Object):Boolean
		{
			return _keyList.indexOf(key)!=-1;
		}

		/**
		 * 判断HashMap中是否拥有值
		 * @param value
		 * @return
		 */
		public function containsValue(value:Object):Boolean
		{
			for each (var v:Object in _dict)
			{
				if (v === value)
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * 字符串输出HashMap
		 * @return
		 */
		public function toString():String
		{
			var str:String = "HashMap Content:\n";
			for each (var key:Object in _keyList)
			{
				str += key + " -> " + _dict[key] + "\n";
			}
			return str;
		}
		
		public function dispose():void
		{
			_dict = null;
			_keyList = null;
		}

		public function get dict():Dictionary
		{
			return _dict;
		}

		public function get keyList():Array
		{
			return _keyList;
		}

		public function set keyList(value:Array):void
		{
			_keyList = value;
		}

	}
}
