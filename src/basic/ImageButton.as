// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.ImageButton

package basic {
import common.BaseControl;
import common.ImageLoader;

import flash.display.Sprite;
import flash.display.Graphics;

import common.Animate;

public class ImageButton extends BaseControl {

	private var m_loader:ImageLoader = new ImageLoader();
	private var m_outline:Sprite = new Sprite();
	private var m_sizeX:Number;
	private var m_sizeY:Number;


	override public function onAttached():void {
		addChild(this.m_loader);
		addChild(this.m_outline);
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_loader.width = _arg_1;
		this.m_loader.height = _arg_2;
		this.m_sizeX = _arg_1;
		this.m_sizeY = _arg_2;
	}

	public function loadImage(rid:String):void {
		this.m_loader.loadImage(rid, function ():void {
			m_loader.width = m_sizeX;
			m_loader.height = m_sizeY;
		});
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:String = (_arg_1 as String);
		if (_local_2) {
			this.loadImage(_local_2);
		}
		;
	}

	public function onSetFocused(_arg_1:Boolean):void {
		var _local_2:Graphics;
		if (_arg_1) {
			_local_2 = this.m_outline.graphics;
			_local_2.moveTo(0, 0);
			_local_2.clear();
			_local_2.lineStyle(2, 0xFF, 1);
			_local_2.drawRect(0, 0, this.m_sizeX, this.m_sizeY);
			this.m_outline.visible = true;
		} else {
			this.m_outline.visible = false;
		}
		;
	}

	public function onButtonPressed():void {
		this.m_loader.alpha = 0;
		Animate.legacyTo(this.m_loader, 0.4, {"alpha": 1}, Animate.ExpoOut);
	}


}
}//package basic

