// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.splashhints.SplashHintBackground

package menu3.splashhints {
import common.BaseControl;

import flash.display.Sprite;
import flash.geom.Point;

import common.menu.MenuConstants;
import common.Animate;

public class SplashHintBackground extends BaseControl implements ISplashHint {

	private var m_animationDelayIn:Number;
	private var m_animationDelayOut:Number;
	private var m_container:Sprite;
	private var m_view:Sprite;
	private var bgInitialPosition:Point;
	private var m_sizeX:Number = MenuConstants.BaseWidth;
	private var m_sizeY:Number = MenuConstants.BaseHeight;
	private var m_safeAreaRatio:Number = 1;

	public function SplashHintBackground() {
		this.m_container = new Sprite();
		addChild(this.m_container);
		this.m_view = new Sprite();
		this.m_view.graphics.clear();
		this.m_view.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
		this.m_view.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		this.m_view.graphics.endFill();
		this.m_view.alpha = 0;
		this.m_view.y = (MenuConstants.UserLineUpperYPos - 242);
		this.m_container.addChild(this.m_view);
		this.bgInitialPosition = new Point(this.m_view.x, this.m_view.y);
	}

	public function set AnimationDelayIn(_arg_1:Number):void {
		this.m_animationDelayIn = _arg_1;
	}

	public function set AnimationDelayOut(_arg_1:Number):void {
		this.m_animationDelayOut = _arg_1;
	}

	public function onSetData(_arg_1:Object):void {
		if (this.m_view != null) {
			this.m_view.visible = (!(_arg_1.hinttype == MenuConstants.SPLASH_HINT_TYPE_CONTROLLER));
		}
		;
	}

	public function show():void {
		Animate.fromTo(this.m_view, 0.2, this.m_animationDelayIn, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.addFromTo(this.m_view, 0.4, this.m_animationDelayIn, {"y": (this.bgInitialPosition.y + 400)}, {"y": this.bgInitialPosition.y}, Animate.ExpoInOut);
	}

	public function hide():void {
		Animate.fromTo(this.m_view, 0.2, this.m_animationDelayOut, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
	}

	override public function getContainer():Sprite {
		return (this.m_container);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		super.onSetSize(_arg_1, _arg_2);
		this.m_sizeX = _arg_1;
		this.m_sizeY = _arg_2;
		this.scaleBackground(this.m_sizeX, this.m_sizeY, this.m_safeAreaRatio);
	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		super.onSetViewport(_arg_1, _arg_2, _arg_3);
		this.m_safeAreaRatio = _arg_3;
		this.scaleBackground(this.m_sizeX, this.m_sizeY, this.m_safeAreaRatio);
	}

	private function scaleBackground(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		var _local_4:Number = (_arg_1 / MenuConstants.BaseWidth);
		var _local_5:Number = Math.min(_local_4, (_arg_2 / MenuConstants.BaseHeight));
		var _local_6:Number = (_local_5 * _arg_3);
		var _local_7:Number = (_arg_2 - (_local_6 * MenuConstants.BaseHeight));
		var _local_8:Number = ((MenuConstants.BaseHeight * (1 - _arg_3)) / 2);
		this.m_container.scaleX = _local_4;
		this.m_container.x = 0;
		this.m_container.scaleY = _local_6;
		this.m_container.y = (_local_7 - _local_8);
	}


}
}//package menu3.splashhints

