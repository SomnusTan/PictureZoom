package com.somnus.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Somnus
	 */
	public class FileUtil
	{
		
		public function FileUtil()
		{
		
		}
		
		/**
		 * 读取文本
		 * @param	file
		 * @param	charset
		 * @return
		 */
		public static function readText(file:File, charset:String = "gb2312"):String
		{
			if (file && file.exists)
			{
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.READ);
				var str:String = fs.readMultiByte(fs.bytesAvailable, charset);
				fs.close();
				return str;
			}
			return null;
		}
		
		/**
		 * 保存文本
		 * @param	file
		 * @param	data
		 * @param	charset
		 * @param	isCover
		 */
		public static function saveText(file:File, data:String, charset:String = "gb2312", isCover:Boolean = true):void
		{
			if (file && !file.isDirectory)
			{
				if (!isCover && file.exists)
				{
					file = file.parent.resolvePath(StringUtil.getNextFileName(file.name.split(".")[0]) + "." + file.extension);
				}
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.WRITE);
				fs.writeMultiByte(data, charset);
				fs.close();
			}
		}
		
		/**
		 * 加载二进制
		 * @param	file
		 * @return
		 */
		public static function getBytes(file:File):ByteArray
		{
			if (file && file.exists)
			{
				var byte:ByteArray = new ByteArray();
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.READ);
				fs.readBytes(byte);
				fs.close();
				byte.position = 0;
				return byte;
			}
			else
				return null;
		}
		
		/**
		 * 保存二进制
		 * @param	file
		 * @param	byte
		 * @param	isCover
		 */
		static public function saveBytes(file:File, byte:ByteArray, isCover:Boolean = true):void
		{
			if (file&&!file.isDirectory)
			{
				if (!isCover && file.exists)
				{
					file = file.parent.resolvePath(StringUtil.getNextFileName(file.name.split(".")[0]) + "." + file.extension);
				}
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.WRITE);
				fs.writeBytes(byte);
				fs.close();
			}
		}
		
		/**
		 * 同步获取对应扩展名的文件列表
		 * @param file
		 * @param filterExt 扩展名 (png;mp),如果为""，则是所有文件
		 * @return
		 */
		public static function getFileList(file:File, filterExt:String = ""):Vector.<File>
		{
			var fileList:Vector.<File> = new Vector.<File>();
			if (file && file.isDirectory)
			{
				filterExt = filterExt.toLocaleLowerCase();
				var filterExtArr:Array = filterExt.split(";");
				getDirectorys(file);
				function getDirectorys(tempFile:File):void
				{
					var list:Array = tempFile.getDirectoryListing();
					for (var i:int = 0, len:int = list.length; i < len; i++)
					{
						file = list[i];
						if (file.isDirectory)
						{
							getDirectorys(file);
						}
						else
						{
							if (filterExt == "" || filterExtArr.indexOf(file.extension.toLocaleLowerCase()) != -1)
							{
								fileList.push(file);
							}
						}
					}
				}
			}
			return fileList;
		}
		
		/**
		 * 获取不重名的文件
		 * @param	baseFile
		 * @param	name
		 * @param	extension
		 * @param	index
		 * @return
		 */
		public static function getNoExistFile(baseFile:File,name:String,extension:String,index:int):File
		{
			var file:File = baseFile.resolvePath(name+"_" + index + "." + extension);
			if (file.exists)
				return getNoExistFile(baseFile, name, extension, index + 1);
			return file;
		}
		
		/**
		 * 获取路径对应的File
		 * @param	url
		 * @param	isRelativePath 是否相对路径
		 * @return
		 */
		public static function getFile(url:String, isRelativePath:Boolean = false):File
		{
			return isRelativePath ? File.applicationDirectory.resolvePath(url) : new File(url);
		}
		
		/**
		 * 包含应用程序已安装文件的文件夹。
		 * @param	path
		 * @return
		 */
		public static function getApplicationDirectory(path:String):File
		{
			return new File(File.applicationDirectory.resolvePath(path).nativePath);
		}
		
		/**
		 * 应用程序的专用存储目录。
		 * @param	path
		 * @return
		 */
		public static function getApplicationStorageDirectory(path:String):File
		{
			return new File(File.applicationStorageDirectory.resolvePath(path).nativePath);
		}
		
		/**
		 * 用户桌面目录。
		 * @param	path
		 * @return
		 */
		public static function getDesktopDirectory(path:String):File
		{
			return new File(File.desktopDirectory.resolvePath(path).nativePath);
		}
		
		/**
		 * 用户文档目录。
		 * @param	path
		 * @return
		 */
		public static function getDocumentsDirectory(path:String):File
		{
			return new File(File.documentsDirectory.resolvePath(path).nativePath);
		}
	
	}

}