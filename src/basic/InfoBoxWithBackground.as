// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.InfoBoxWithBackground

package basic {
import flash.display.Sprite;
import flash.text.TextField;

import common.menu.MenuConstants;
import common.menu.MenuUtils;

public class InfoBoxWithBackground extends Sprite {

	private const HEIGHT:int = 94;
	private const POS_X:int = 85;
	private const POS_TITLE_Y:int = 10;
	private const POS_DESCRIPTION_Y:int = 51;

	private var m_title:TextField;
	private var m_description:TextField;
	private var m_background:Sprite;

	public function InfoBoxWithBackground() {
		this.m_background = new Sprite();
		addChild(this.m_background);
		this.m_background.graphics.clear();
		this.m_background.graphics.beginFill(0xFFFFFF, 1);
		this.m_background.graphics.drawRect(0, 0, MenuConstants.BaseWidth, this.HEIGHT);
		this.m_background.graphics.endFill();
		this.m_background.visible = false;
		this.m_title = new TextField();
		this.m_title.x = this.POS_X;
		this.m_title.y = this.POS_TITLE_Y;
		this.m_title.width = (MenuConstants.BaseWidth - (2 * this.POS_X));
		this.m_title.height = (this.POS_DESCRIPTION_Y - this.POS_TITLE_Y);
		addChild(this.m_title);
		this.m_description = new TextField();
		this.m_description.x = this.POS_X;
		this.m_description.y = this.POS_DESCRIPTION_Y;
		this.m_description.width = (MenuConstants.BaseWidth - (2 * this.POS_X));
		this.m_description.height = (this.HEIGHT - this.POS_DESCRIPTION_Y);
		addChild(this.m_description);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String = ((_arg_1.title != undefined) ? _arg_1.title : "");
		var _local_3:String = ((_arg_1.description != undefined) ? _arg_1.description : "");
		var _local_4:* = (_arg_1.isWarning === true);
		this.m_background.visible = ((!(_local_2.length == 0)) || (!(_local_3.length == 0)));
		var _local_5:String = ((_local_4) ? MenuConstants.FontColorGreyUltraLight : MenuConstants.FontColorBlack);
		var _local_6:int = ((_local_4) ? MenuUtils.TINT_COLOR_LIGHT_RED : MenuUtils.TINT_COLOR_WHITE);
		MenuUtils.setupText(this.m_title, _local_2, 36, MenuConstants.FONT_TYPE_MEDIUM, _local_5);
		MenuUtils.setupText(this.m_description, _local_3, 24, MenuConstants.FONT_TYPE_MEDIUM, _local_5);
		MenuUtils.shrinkTextToFit(this.m_description, this.m_description.width, this.m_description.height);
		MenuUtils.setTintColor(this.m_background, _local_6);
	}


}
}//package basic

