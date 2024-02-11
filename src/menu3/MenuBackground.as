// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.MenuBackground

package menu3 {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.MenuConstants;

import flash.geom.Rectangle;
import flash.geom.Point;

public class MenuBackground extends BaseControl {

	private var m_ingameBackgroundContainer:Sprite;


	public function drawIngameBackground():void {
		this.m_ingameBackgroundContainer = new Sprite();
		addChild(this.m_ingameBackgroundContainer);
		var _local_1:Sprite = new Sprite();
		_local_1.graphics.clear();
		_local_1.graphics.beginFill(MenuConstants.COLOR_END_SCREEN_BACKGROUND, MenuConstants.MenuFrameEndScreenBackgroundAlpha);
		_local_1.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		_local_1.graphics.endFill();
		this.m_ingameBackgroundContainer.addChild(_local_1);
	}

	public function showBokeh(_arg_1:Rectangle, _arg_2:int, _arg_3:int, _arg_4:Number, _arg_5:Number):void {
	}

	public function showLensFlare(_arg_1:Point, _arg_2:Number, _arg_3:Number, _arg_4:Number):void {
	}


}
}//package menu3

