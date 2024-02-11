// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.Checkbox

package basic {
import common.BaseControl;
import common.CommonUtils;

public class Checkbox extends BaseControl {

	private var m_view:CheckboxView;

	public function Checkbox() {
		this.m_view = new CheckboxView();
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Boolean):void {
		this.SetValue(_arg_1);
	}

	public function SetValue(_arg_1:Boolean):void {
		CommonUtils.gotoFrameLabelAndStop(this.m_view, ((_arg_1) ? "checked" : "unchecked"));
	}

	public function SetTrue():void {
		this.SetValue(true);
	}

	public function SetFalse():void {
		this.SetValue(false);
	}


}
}//package basic

