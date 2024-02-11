// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.LocationIntelWidget

package hud.evergreen {
import common.BaseControl;

import hud.evergreen.misc.LocationIntelBlock;

public class LocationIntelWidget extends BaseControl {

	private var m_view:LocationIntelBlock = null;
	private var m_sizeX:Number;
	private var m_sizeY:Number;
	private var m_padding:Number;
	private var m_data:Object;


	public function set Padding(_arg_1:Number):void {
		if (this.m_padding == _arg_1) {
			return;
		}

		this.m_padding = _arg_1;
		this.destroyView();
		this.onSetData(this.m_data);
	}

	public function onSetData(_arg_1:Object):void {
		if (this.m_view == null) {
			this.m_view = new LocationIntelBlock(this.m_sizeX, this.m_padding);
			this.m_view.visible = false;
			addChild(this.m_view);
		}

		this.m_data = _arg_1;
		if (this.m_data != null) {
			this.m_view.onSetData(this.m_data);
		}

	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		if (this.m_sizeX != _arg_1) {
			this.destroyView();
		}

		this.m_sizeX = _arg_1;
		this.m_sizeY = _arg_2;
		this.onSetData(this.m_data);
	}

	private function destroyView():void {
		if (this.m_view == null) {
			return;
		}

		removeChild(this.m_view);
		this.m_view = null;
	}


}
}//package hud.evergreen

