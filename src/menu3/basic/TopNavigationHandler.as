// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.TopNavigationHandler

package menu3.basic {
import flash.display.Sprite;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class TopNavigationHandler extends Sprite implements IConfigurableMenuResource {

	private const OVERLAP_HEIGHT:Number = 1;
	private const ADDITIONAL_BACKGROUND_HEIGHT:Number = 40;

	private var m_parent:Sprite = null;
	private var m_view:TopNavigationView = null;
	private var m_endPosition:Number = 0;
	private var m_textTickerUtil:TextTickerUtil = new TextTickerUtil();
	public var m_promptsContainer:Sprite;

	public function TopNavigationHandler() {
		this.m_view = new TopNavigationView();
		this.m_endPosition = ((this.m_view.y - this.m_view.height) + this.OVERLAP_HEIGHT);
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileSelect.height = (this.m_view.tileSelect.height + this.ADDITIONAL_BACKGROUND_HEIGHT);
		this.m_view.tileSelect.y = (this.m_view.tileSelect.y - (this.ADDITIONAL_BACKGROUND_HEIGHT / 2));
		this.m_view.tileSelect.visible = false;
		this.m_view.tileIcon.visible = false;
		this.m_view.visible = false;
		MenuUtils.addDropShadowFilter(this.m_view.header);
		MenuUtils.addDropShadowFilter(this.m_view.title);
		MenuUtils.addDropShadowFilter(this.m_view.tileIcon);
		this.m_promptsContainer = new Sprite();
		this.m_promptsContainer.y = MenuConstants.TabsPromptsYOffset;
		addChild(this.m_promptsContainer);
		addChild(this.m_view);
	}

	public function onSetData(_arg_1:Object):void {
		if (_arg_1 != null) {
			this.setText(_arg_1.header, _arg_1.title);
			this.m_view.tileIcon.visible = true;
			this.setIcon(_arg_1.icon);
		}
		;
	}

	public function onUnregister():void {
		if (this.m_view == null) {
			return;
		}
		;
		this.m_textTickerUtil.onUnregister();
		if (this.m_parent != null) {
			this.m_parent.removeChild(this);
			this.m_parent = null;
		}
		;
		removeChild(this.m_promptsContainer);
		this.m_promptsContainer = null;
		removeChild(this.m_view);
		this.m_view = null;
	}

	public function updateFrom(_arg_1:Sprite):void {
		this.m_parent = _arg_1;
		this.m_parent.addChild(this);
		this.m_view.x = 0;
		this.m_view.y = this.m_endPosition;
		this.m_view.visible = true;
		this.m_textTickerUtil.stopTextTickers();
		this.m_textTickerUtil.callTextTicker(true);
	}

	private function setText(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextUpper(this.m_view.header, _arg_1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.m_textTickerUtil.addTextTickerHtml(this.m_view.header, 2000);
		MenuUtils.truncateTextfield(this.m_view.header, 1, MenuConstants.FontColorWhite);
		MenuUtils.setupTextUpper(this.m_view.title, _arg_2, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_textTickerUtil.addTextTickerHtml(this.m_view.title, 2000);
		MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite);
	}

	private function setIcon(_arg_1:String):void {
		MenuUtils.setupIcon(this.m_view.tileIcon, _arg_1, MenuConstants.COLOR_WHITE, true, false);
	}


}
}//package menu3.basic

