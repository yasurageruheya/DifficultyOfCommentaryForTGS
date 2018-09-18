package
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	
	/**
	 * ...
	 * @author 毛
	 */
	public class DifficultyOfCommentary extends Sprite 
	{
		public var buttonHard:Sprite;
		public var buttonNormal:Sprite;
		public var buttonEasy:Sprite;
		
		public const blackCover:Shape = new Shape();
		
		public const COMMAND_HIDE:String = "NHEEENNNN";
		public const COMMAND_SHOW:String = "HEHENNNNN";
		
		
		public var commandHistory:String = "";
		public var formatCommandTime:int = 600;
		public var formatCommandLeft:int = 0;
		
		public function DifficultyOfCommentary() 
		{
			buttonHard.buttonMode = buttonNormal.buttonMode = buttonEasy.buttonMode = true;
			
			const graphics:Graphics = blackCover.graphics;
			graphics.beginFill(0x0);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			addChild(blackCover);
			blackCover.visible = false;
			
			buttonHard.addEventListener(MouseEvent.CLICK, onButtonClickHandler);
			buttonNormal.addEventListener(MouseEvent.CLICK, onButtonClickHandler);
			buttonEasy.addEventListener(MouseEvent.CLICK, onButtonClickHandler);
			
			formatCommandTime = (formatCommandTime * stage.frameRate) >> 0;
			formatCommandLeft = formatCommandTime;
			
			addEventListener(Event.ENTER_FRAME, formatCommandWait);
		}
		
		[Inline]
		final private function formatCommandWait(e:Event):void 
		{
			if (!formatCommandLeft--)
			{
				formatCommandLeft = formatCommandTime;
				commandHistory = "";
			}
		}
		
		[Inline]
		final private function onButtonClickHandler(e:MouseEvent):void 
		{
			buttonHard.mouseEnabled = buttonNormal.mouseEnabled = buttonEasy.mouseEnabled = false;
			buttonHard.alpha = buttonNormal.alpha = buttonEasy.alpha = 0.5;
			
			var name:String;
			var command:String;
			switch((e.currentTarget as MovieClip).name)
			{
				case buttonHard.name:
					name = "HIGH";
					command = "H";
					break;
				case buttonNormal.name:
					name = "NORMAL";
					command = "N";
					break;
				case buttonEasy.name:
					name = "EASY";
					command = "E";
					break;
			}
			
			var request:URLRequest = new URLRequest("http://192.168.43.1:3000/sendLog");
			request.useCache = false;
			request.cacheResponse = false;
			request.method = URLRequestMethod.POST;
			var now:Date = new Date();
			var time:String = now.getFullYear() + "/" + (now.getMonth() + 1) + "/" + now.getDate();
			time += " " + now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds() + "." + now.getMilliseconds();
			request.data = JSON.stringify( { "message" : time + " : " + name } );
			request.requestHeaders = [new URLRequestHeader("Content-Type", "application/json")];
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onRequestComplete);
			urlLoader.load(request);
			
			commandHistory += command;
			trace( "commandHistory : " + commandHistory );
			if (commandHistory.indexOf(COMMAND_HIDE) >= 0)
			{
				blackCover.visible = true;
				trace( "blackCover.visible : " + blackCover.visible );
				commandHistory = "";
			}
			else if (commandHistory.indexOf(COMMAND_SHOW) >= 0)
			{
				blackCover.visible = false;
				commandHistory = "";
			}
		}
		
		[Inline]
		final private function onRequestComplete(e:Event):void 
		{
			const urlLoader:URLLoader = e.currentTarget as URLLoader;
			if (urlLoader.data === "request received")
			{
				buttonHard.mouseEnabled = buttonNormal.mouseEnabled = buttonEasy.mouseEnabled = true;
				buttonHard.alpha = buttonNormal.alpha = buttonEasy.alpha = 1;
			}
		}
	}
}