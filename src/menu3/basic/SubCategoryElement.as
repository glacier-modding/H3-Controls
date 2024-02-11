// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.SubCategoryElement

package menu3.basic {
import common.MouseUtil;
import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.display.Sprite;
import flash.text.TextFieldAutoSize;
import flash.text.TextField;

public dynamic class SubCategoryElement extends CategoryElementBase {

	private const HORIZONTAL_PADDING:int = 20;

	private var m_view:SubCategoryElementView;

	public function SubCategoryElement(_arg_1:Object) {
		super(_arg_1);
		m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
		m_mouseModeCollapsed = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
		m_mouseModeUncollapsed = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
		this.m_view = new SubCategoryElementView();
		this.m_view.y = 14;
		this.m_view.tileBg.alpha = 0;
		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		this.setupTextFields(((_arg_1.title) || ("")));
		this.setSelectedAnimationState(STATE_DEFAULT);
		this.adjustSizeAndPosition();
		addChild(this.m_view);
	}

	override public function onUnregister():void {
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}

		super.onUnregister();
	}

	private function adjustSizeAndPosition():void {
		this.m_view.tileBg.width = Math.ceil((this.m_view.title.width + (this.HORIZONTAL_PADDING * 2)));
		this.m_view.tileSelect.width = (this.m_view.tileBg.width - 4);
		this.m_view.tileSelect.x = (this.m_view.tileBg.x + 2);
	}

	override public function getView():Sprite {
		return (this.m_view);
	}

	private function setupTextFields(_arg_1:String):void {
		MenuUtils.setupTextUpper(this.m_view.title, _arg_1, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.textfieldAutosize(this.m_view.title, TextFieldAutoSize.LEFT);
		MenuUtils.truncateTextfield(this.m_view.title, 1);
		this.m_view.title.width = Math.ceil(this.m_view.title.width);
		this.m_view.title.x = this.HORIZONTAL_PADDING;
	}

	override protected function setSelectedAnimationState(_arg_1:int):void {
		if (_arg_1 == STATE_SELECTED) {
			MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
		} else {
			if (_arg_1 == STATE_HOVER) {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
			} else {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			}

		}

	}

	private function textfieldAutosize(tf:TextField, direction:String = "left"):void {
		var tempHeight:Number;
		try {
			tf.autoSize = direction;
			tempHeight = tf.height;
			tf.autoSize = TextFieldAutoSize.NONE;
			tf.height = (tempHeight + 2);
		} catch (error:Error) {
			trace(this, "[TextFieldAutosize]", error);
		}

	}


}
}//package menu3.basic

