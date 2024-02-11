// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.SafeAreaScaleContainer

package basic {
import common.BaseControl;

import flash.display.Sprite;

import common.Log;

public class SafeAreaScaleContainer extends BaseControl {

	private var m_container:Sprite;
	private var m_safeAreaRatio:Number = 1;
	private var m_baseSizeX:Number = 1920;
	private var m_baseSizeY:Number = 1080;
	private var m_SizeX:Number = m_baseSizeX;
	private var m_SizeY:Number = m_baseSizeY;

	public function SafeAreaScaleContainer() {
		this.m_container = new Sprite();
		this.addChild(this.m_container);
		this.update();
	}

	override public function getContainer():Sprite {
		return (this.m_container);
	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		this.m_SizeX = (this.m_baseSizeX * _arg_1);
		this.m_SizeY = (this.m_baseSizeY * _arg_2);
		this.m_safeAreaRatio = _arg_3;
		this.update();
	}

	private function update():void {
		this.getContainer().scaleX = this.m_safeAreaRatio;
		this.getContainer().scaleY = this.m_safeAreaRatio;
		this.getContainer().x = ((this.m_SizeX * (1 - this.getContainer().scaleX)) / 2);
		this.getContainer().y = ((this.m_SizeY * (1 - this.getContainer().scaleY)) / 2);
		Log.xinfo(Log.ChannelContainer, ((((((((" ScaleContainer " + "getContainer().scaleX ") + this.getContainer().scaleX) + " getContainer().scaleY ") + this.getContainer().scaleY) + " getContainer().x ") + this.getContainer().x) + " getContainer().y ") + this.getContainer().y));
	}


}
}//package basic

