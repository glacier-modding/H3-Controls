// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.EmptySpace

package hud {
import menu3.MenuElementBase;

public dynamic class EmptySpace extends MenuElementBase {

	public function EmptySpace(_arg_1:Object) {
		var _local_2:Object = new Object();
		super(_local_2);
		var _local_3:InventorySlotSpace = new InventorySlotSpace();
		_local_3.width = _arg_1.width;
		_local_3.height = _arg_1.height;
		_local_3.y = (_arg_1.height * 0.5);
		addChild(_local_3);
	}

}
}//package hud

