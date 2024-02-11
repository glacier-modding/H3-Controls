// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.misc.IconStack

package hud.evergreen.misc {
import flash.display.Sprite;

import common.menu.MenuUtils;

import hud.evergreen.worldmap.IconStackThinSlice;

public class IconStack extends Sprite {

	private var m_icon:iconsAll76x76View = new iconsAll76x76View();

	public function IconStack(_arg_1:String) {
		this.m_icon.name = "m_icon";
		MenuUtils.setupIcon(this.m_icon, _arg_1, 0xFFFFFF, false, false, 0xFFFFFF, 0, 0, true);
		this.m_icon.x = (this.m_icon.width / 2);
		this.m_icon.y = (this.m_icon.height / 2);
		addChild(this.m_icon);
	}

	public function set numItemsInStack(_arg_1:int):void {
		var _local_2:IconStackThinSlice;
		while (numChildren > (_arg_1 + 1)) {
			removeChild(getChildAt((numChildren - 1)));
		}

		while (numChildren < _arg_1) {
			if (numChildren != 0) {
				_local_2 = new IconStackThinSlice();
				_local_2.x = ((this.m_icon.x + (this.m_icon.width / 2)) + ((_local_2.width * 2) * (numChildren - 0.5)));
				_local_2.y = this.m_icon.y;
				addChild(_local_2);
			}

		}

	}

	public function get numItemsInStack():int {
		return (numChildren);
	}


}
}//package hud.evergreen.misc

