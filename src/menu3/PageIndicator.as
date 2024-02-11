// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.PageIndicator

package menu3 {
import flash.geom.Rectangle;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;

public class PageIndicator extends PageIndicatorView {

	private var m_pageSize:int;
	private var m_stepSize:Number;

	public function PageIndicator(_arg_1:int) {
		this.m_pageSize = _arg_1;
		var _local_2:Rectangle = new Rectangle(3, 1, 94, 754);
		indicator.scale9Grid = _local_2;
		indicatorbg.scale9Grid = _local_2;
		indicatorbg.width = this.m_pageSize;
		arrowL.alpha = 0.3;
		arrowR.alpha = 0.3;
		scrollnumL01.autoSize = "left";
		scrollnumL02.autoSize = "left";
		scrollnumR01.autoSize = "right";
		scrollnumR02.autoSize = "right";
	}

	public function setPageIndicator(_arg_1:int):void {
		this.m_stepSize = (this.m_pageSize / _arg_1);
		indicator.width = this.m_stepSize;
	}

	public function updatePageIndicator(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:String):void {
		MenuUtils.setupText(scrollnumL01, (_arg_3 + " +"), 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
		MenuUtils.setupText(scrollnumL02, (_arg_3 + " +"), 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
		MenuUtils.setupText(scrollnumR01, ("+ " + _arg_4), 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
		MenuUtils.setupText(scrollnumR02, ("+ " + _arg_4), 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyDark);
		Animate.legacyTo(indicator, 0.3, {"x": (this.m_stepSize * _arg_1)}, Animate.ExpoOut);
	}


}
}//package menu3

