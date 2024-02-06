package menu3.basic
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public interface IItemTileState
	{
		
		function onSetData(param1:Object):void;
		
		function destroy():void;
		
		function hideTitleAndHeader():void;
		
		function setTileSelect():void;
		
		function hideTileSelect():void;
		
		function getView():Sprite;
		
		function setImageFrom(param1:BitmapData):void;
		
		function unloadImage():void;
	}
}
