// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.CategoryElement

package menu3.basic {
import common.MouseUtil;
import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

import flash.display.Sprite;

public dynamic class CategoryElement extends CategoryElementBase {

	private var m_view:CategoryElementView;
	private var m_icon:String;

	public function CategoryElement(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
		m_mouseModeCollapsed = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
		m_mouseModeUncollapsed = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
		this.m_view = new CategoryElementView();
		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileSelect.alpha = 0;
		this.m_icon = _arg_1.icon;
		this.setupTextFields(((_arg_1.title) || ("")));
		this.setSelectedAnimationState(STATE_DEFAULT);
		addChild(this.m_view);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			Animate.kill(this.m_view.tileSelect);
			removeChild(this.m_view);
			this.m_view = null;
		}

		super.onUnregister();
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	private function setupTextFields(_arg_1:String):void {
		MenuUtils.setupTextAndShrinkToFitUpper(this.m_view.title, _arg_1, 20, MenuConstants.FONT_TYPE_MEDIUM, this.m_view.title.width, -1, 15, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite);
	}

	private function changeTextColor(_arg_1:uint):void {
		this.m_view.title.textColor = _arg_1;
	}

	override protected function setSelectedAnimationState(_arg_1:int):void {
		Animate.complete(this.m_view.tileSelect);
		if (_arg_1 == STATE_SELECTED) {
			MenuUtils.removeDropShadowFilter(this.m_view.title);
			MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
			MenuUtils.setupIcon(this.m_view.tileIcon, this.m_icon, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
			Animate.to(this.m_view.tileSelect, MenuConstants.HiliteTime, 0, {"alpha": MenuConstants.MenuElementSelectedAlpha}, Animate.Linear);
			this.changeTextColor(MenuConstants.COLOR_WHITE);
		} else {
			if (_arg_1 == STATE_HOVER) {
				MenuUtils.removeDropShadowFilter(this.m_view.title);
				MenuUtils.removeDropShadowFilter(this.m_view.tileIcon);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_icon, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
				Animate.to(this.m_view.tileSelect, MenuConstants.HiliteTime, 0, {"alpha": MenuConstants.MenuElementSelectedAlpha}, Animate.Linear);
				this.changeTextColor(MenuConstants.COLOR_WHITE);
			} else {
				MenuUtils.addDropShadowFilter(this.m_view.title);
				MenuUtils.addDropShadowFilter(this.m_view.tileIcon);
				this.m_view.tileSelect.alpha = 0;
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_icon, MenuConstants.COLOR_WHITE, true, false);
				this.changeTextColor(MenuConstants.COLOR_WHITE);
			}

		}

	}


}
}//package menu3.basic

