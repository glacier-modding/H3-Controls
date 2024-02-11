// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.MasteryElement

package menu3.basic {
import menu3.MenuElementBase;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Localization;
import common.Animate;

public dynamic class MasteryElement extends MenuElementBase {

	private var m_view:MasteryElementView;
	private var m_masteryXpTitleText:String;
	private var m_unit:String;

	public function MasteryElement(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new MasteryElementView();
		this.m_view.masteryxp.indicator.scaleX = 0;
		this.m_view.masteryxp.visible = false;
		MenuUtils.setupTextUpper(this.m_view.masterytitle, "", 12, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.masteryxptitle, "", 12, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.refreshLoca();
		addChild(this.m_view);
	}

	protected function getRootView():MasteryElementView {
		return (this.m_view);
	}

	public function refreshLoca():void {
		this.m_unit = Localization.get("UI_PERFORMANCE_MASTERY_XP");
	}

	public function getVisiblityFromData(_arg_1:Object):Boolean {
		if (((_arg_1.masterycompletion == undefined) || (_arg_1.masteryxpleft == undefined))) {
			return (false);
		}

		if (((_arg_1.masterycompletion >= 0) && (!(_arg_1.masteryxpleft == "")))) {
			return (true);
		}

		return (false);
	}

	override public function onSetData(_arg_1:Object):void {
		if ((((((getData().masteryheader == _arg_1.masteryheader) && (getData().masterytitle == _arg_1.masterytitle)) && (getData().masterycompletion == _arg_1.masterycompletion)) && (getData().masteryxpleft == _arg_1.masteryxpleft)) && (getData().showUnit == _arg_1.showUnit))) {
			return;
		}

		super.onSetData(_arg_1);
		if (((_arg_1.masterycompletion == undefined) || (_arg_1.masteryxpleft == undefined))) {
			this.m_view.visible = false;
			return;
		}

		var _local_2:Boolean = true;
		if (_arg_1.showUnit != null) {
			_local_2 = _arg_1.showUnit;
		}

		this.showMastery(_arg_1.masteryheader, _arg_1.masterytitle, _arg_1.masterycompletion, _arg_1.masteryxpleft, _local_2);
	}

	private function showMastery(_arg_1:String, _arg_2:String, _arg_3:Number, _arg_4:String, _arg_5:Boolean):void {
		var _local_6:Number;
		var _local_7:String;
		var _local_8:Boolean;
		var _local_9:String;
		if (((_arg_3 >= 0) && (!(_arg_4 == "")))) {
			_local_6 = Number(_arg_4);
			if (((!(isNaN(_local_6))) && (!(_local_6 == 0)))) {
				_arg_4 = MenuUtils.formatNumber(_local_6);
			}

			this.m_view.visible = true;
			_local_7 = (((_arg_1 != null) ? _arg_1 : "") + ((_arg_2 != null) ? (" " + _arg_2) : ""));
			this.m_view.masterytitle.htmlText = _local_7.toUpperCase();
			this.m_view.masteryxp.visible = true;
			_arg_3 = Math.min(Math.max(_arg_3, 0), 1);
			Animate.to(this.m_view.masteryxp.indicator, 0.2, 0, {"scaleX": _arg_3}, Animate.ExpoOut);
			_local_8 = (!(_arg_4 == "0"));
			this.m_view.masteryxptitle.visible = _local_8;
			this.m_view.arrow.visible = _local_8;
			_local_9 = _arg_4;
			if (_arg_5) {
				_local_9 = ((_local_9 + " ") + this.m_unit);
			}

			this.m_masteryXpTitleText = _local_9.toUpperCase();
			this.m_view.masteryxptitle.htmlText = this.m_masteryXpTitleText;
		} else {
			this.m_view.visible = false;
		}

	}

	public function setupDifficulty(_arg_1:Boolean):void {
	}

	private function completeAnimations():void {
		Animate.complete(this.m_view.masteryxp.indicator);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			this.completeAnimations();
			removeChild(this.m_view);
			this.m_view = null;
		}

		super.onUnregister();
	}


}
}//package menu3.basic

