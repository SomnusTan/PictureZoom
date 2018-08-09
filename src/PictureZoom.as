package
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Style;
	import com.somnus.alert.Alert;
	import com.somnus.utils.FileUtil;
	import com.somnus.utils.LoaderUtil;
	import com.somnus.utils.TimerManager;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	public class PictureZoom extends Sprite
	{
		private var _dragSp:Sprite;
		
		private var _txtInputSrc:InputText;
		private var _txtInputTar:InputText;
		
		private var _txtError:Label;
		
		private var _scale:Number=1;
		
		private var _list:Vector.<File>;
		private var _matrix:Matrix;

		private var _file:File;
		private var _len:int;
		
		public function PictureZoom()
		{
			this.init();
		}
		
		private function init():void
		{
			this.initUI();
			
			TimerManager.init(stage);
			
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			
			stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragEnterHandler);
			stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDropHandler);
			stage.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, onDragExitHandler);
			stage.addEventListener(Event.RESIZE, onResize);
			
			this.onResize();
			
		}
		
		private function initUI():void
		{
			this._dragSp = new Sprite();
			this.addChild(this._dragSp);
			
			Style.fontSize=12;
			new Label(this,140,30,"图片原始尺寸：");
			this._txtInputSrc=new InputText(this,230,30,"1000");
			this._txtInputSrc.restrict="0-9";
			
			new Label(this,140,80,"图片目标尺寸：");
			this._txtInputTar=new InputText(this,230,80,"500");
			this._txtInputTar.restrict="0-9";
			
			this._txtError=new Label(this,200,120,"");
			this._txtError.textField.textColor=0xff0000;
			
			Alert.init(this);
		}
		
		private function onDragEnterHandler(e:NativeDragEvent):void
		{
			var clipBoard:Clipboard = e.clipboard;
			if (clipBoard.hasFormat(ClipboardFormats.BITMAP_FORMAT) || clipBoard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				NativeDragManager.acceptDragDrop(stage);
			}
		}
		
		private function onDragDropHandler(e:NativeDragEvent):void
		{
			if (e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				var list:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				var file:File;
				var extension:String;
				var tempList:Vector.<File>=Vector.<File>([]);
				for (var i:int = 0; i < list.length; i++) 
				{
					file = list[i];
					if (file.isDirectory == false)
					{
						extension = file.extension.toLowerCase();
						if (extension == "jpg" || extension == "png")
						{
							tempList.push(file);
						}
					}
					else
					{
						tempList = tempList.concat(FileUtil.getFileList(file,"jpg;png"));
					}
				}
				if(tempList.length>0)
				{
					this.startZoom(tempList);
				}
				else
				{
					this.showError("没有可缩放的图片文件");
				}
			}
		}
		
		private function startZoom(list:Vector.<File>):void
		{
			if(this.mouseEnabled==false)
				return;
			var srcSize:int = int(this._txtInputSrc.text);
			var tarSize:int = int(this._txtInputTar.text);
			if(srcSize==0||tarSize==0)
			{
				this.showError("尺寸不能为0");
				return;
			}
			this._scale = tarSize/srcSize;
			if(this._scale==1)
			{
				this.showError("尺寸不能相同");
				return;
			}
			this.showError("");
			this.mouseEnabled=false;
			this._list=list;
			this._len = this._list.length;
			if(this._matrix==null)
			{
				this._matrix = new Matrix(1,0,0,1);
			}
			this._matrix.a=this._scale;
			this._matrix.d=this._scale;
			this.loadPicture();
		}
		
		private function loadPicture():void
		{
			if(this._list.length>0)
			{
				this._file = this._list.shift();
				LoaderUtil.loadBytes(FileUtil.getBytes(this._file),this.onLoadComplete);
				Alert.showWaiting("正在缩放:"+this._file.nativePath+"("+(this._len-this._list.length)+"/"+this._len+")")
			}
			else
			{
				this.mouseEnabled=true;
				Alert.hideWaiting();
				this.showError("全部缩放完成")
			}
		}
		
		private function onLoadComplete(bmp:Bitmap):void
		{
			var bmd:BitmapData=new BitmapData(bmp.bitmapData.width*this._scale,bmp.bitmapData.height*this._scale,bmp.bitmapData.transparent,bmp.bitmapData.transparent?0:0xffffff);
			bmd.draw(bmp.bitmapData,this._matrix);
			var byte:ByteArray;
			if(this._file.extension.toLowerCase()=="jpg")
				byte = new JPGEncoder(80).encode(bmd);
			else
				byte = PNGEncoder.encode(bmd);
			FileUtil.saveBytes(this._file,byte);
			bmd.dispose();
			bmp.bitmapData.dispose();
			LoaderUtil.dispose();
			this.loadPicture();
		}
		
		private function onDragExitHandler(e:NativeDragEvent):void
		{
			
		}
		
		private function showError(error:String):void
		{
			this._txtError.text = error;
		}
		
		private function onResize(e:Event = null):void
		{
			if(_dragSp)
			{
				_dragSp.graphics.clear();
				_dragSp.graphics.beginFill(0, 0);
				_dragSp.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				_dragSp.graphics.endFill();
			}
		}
		
	}
}