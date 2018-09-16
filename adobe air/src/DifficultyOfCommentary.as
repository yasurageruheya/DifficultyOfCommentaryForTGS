package
{
	import flash.display.MovieClip;
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
		
		public function DifficultyOfCommentary() 
		{
			buttonHard.addEventListener(MouseEvent.CLICK, onButtonClickHandler);
			buttonNormal.addEventListener(MouseEvent.CLICK, onButtonClickHandler);
			buttonEasy.addEventListener(MouseEvent.CLICK, onButtonClickHandler);
		}
		
		[Inline]
		final private function onButtonClickHandler(e:MouseEvent):void 
		{
			buttonHard.mouseEnabled = buttonNormal.mouseEnabled = buttonEasy.mouseEnabled = false;
			buttonHard.alpha = buttonNormal.alpha = buttonEasy.alpha = 0.5;
			
			var name:String = (e.currentTarget as MovieClip).name;
			var request:URLRequest = new URLRequest("http://192.168.43.1:3000/sendLog");
			request.useCache = false;
			request.cacheResponse = false;
			request.method = URLRequestMethod.POST;
			var now:Date = new Date();
			var time:String = now.getFullYear() + "/" + (now.getMonth() + 1) + "/" + now.getDate();
			time += " " + now.getHours() + ":" + now.getMinutes() + ":" + now.getSeconds() + "." + now.getMilliseconds();
			request.data = JSON.stringify( { "message" : time + " clicked : " + name } );
			request.requestHeaders = [new URLRequestHeader("Content-Type", "application/json")];
			trace( "request.data : " + request.data );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onRequestComplete);
			urlLoader.load(request);
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