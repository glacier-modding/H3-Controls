// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.IItemTileState

package menu3.basic {
import flash.display.Sprite;
import flash.display.BitmapData;

public interface IItemTileState {

	function onSetData(_arg_1:Object):void;

	function destroy():void;

	function hideTitleAndHeader():void;

	function setTileSelect():void;

	function hideTileSelect():void;

	function getView():Sprite;

	function setImageFrom(_arg_1:BitmapData):void;

	function unloadImage():void;

}
}//package menu3.basic

