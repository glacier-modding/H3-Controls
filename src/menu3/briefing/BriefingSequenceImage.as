// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.briefing.BriefingSequenceImage

package menu3.briefing {
import common.BaseControl;

import flash.display.Sprite;

import menu3.MenuImageLoader;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.Animate;

public class BriefingSequenceImage extends BaseControl {

	private var m_animateStartRow:Number;
	private var m_animateEndRow:Number;
	private var m_animateStartCol:Number;
	private var m_animateEndCol:Number;
	private var m_animateStartScale:Number;
	private var m_animateEndScale:Number;
	private var m_animateEasingType:int;
	private var m_imageSequenceDuration:Number;
	private var m_imageContainer:Sprite;
	private var m_loader:MenuImageLoader;
	private var m_imagePath:String;
	private var m_unitWidth:Number = (MenuConstants.BaseWidth / 10);
	private var m_unitHeight:Number = (MenuConstants.BaseHeight / 6);

	public function BriefingSequenceImage() {
		trace("ETBriefing | BriefingSequenceImage CALLED!!!");
		this.m_imageContainer = new Sprite();
		this.m_imageContainer.name = "m_imageContainer";
		addChild(this.m_imageContainer);
	}

	public function onSetData(_arg_1:Object):void {
		this.m_imagePath = (_arg_1 as String);
	}

	public function start(_arg_1:Number, _arg_2:Number):void {
		this.loadImage(_arg_1, _arg_2);
	}

	private function loadImage(baseduration:Number, containeranimateinduration:Number):void {
		if (this.m_imageSequenceDuration) {
			baseduration = this.m_imageSequenceDuration;
		}

		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			this.m_imageContainer.removeChild(this.m_loader);
			this.m_loader = null;
		}

		this.m_loader = new MenuImageLoader();
		this.m_imageContainer.addChild(this.m_loader);
		this.m_loader.center = false;
		this.m_loader.loadImage(this.m_imagePath, function ():void {
			MenuUtils.trySetCacheAsBitmap(m_imageContainer, true);
			var _local_1:Number = ((m_imageContainer.width - (m_imageContainer.width * m_animateStartScale)) / 2);
			var _local_2:Number = ((m_imageContainer.width - (m_imageContainer.width * m_animateEndScale)) / 2);
			var _local_3:Number = ((m_imageContainer.height - (m_imageContainer.height * m_animateStartScale)) / 2);
			var _local_4:Number = ((m_imageContainer.height - (m_imageContainer.height * m_animateEndScale)) / 2);
			m_imageContainer.x = ((m_unitWidth * m_animateStartRow) + _local_1);
			m_imageContainer.y = ((m_unitHeight * m_animateStartCol) + _local_3);
			m_imageContainer.scaleX = (m_imageContainer.scaleY = m_animateStartScale);
			Animate.to(m_imageContainer, baseduration, containeranimateinduration, {
				"x": ((m_unitWidth * m_animateEndRow) + _local_2),
				"y": ((m_unitHeight * m_animateEndCol) + _local_4),
				"scaleX": m_animateEndScale,
				"scaleY": m_animateEndScale
			}, m_animateEasingType);
		});
	}

	override public function getContainer():Sprite {
		return (this.m_imageContainer);
	}

	public function set SequenceDurationOverride(_arg_1:Number):void {
		this.m_imageSequenceDuration = _arg_1;
	}

	public function set AnimateStartRow(_arg_1:Number):void {
		this.m_animateStartRow = _arg_1;
	}

	public function set AnimateEndRow(_arg_1:Number):void {
		this.m_animateEndRow = _arg_1;
	}

	public function set AnimateStartCol(_arg_1:Number):void {
		this.m_animateStartCol = _arg_1;
	}

	public function set AnimateEndCol(_arg_1:Number):void {
		this.m_animateEndCol = _arg_1;
	}

	public function set AnimateStartScale(_arg_1:Number):void {
		this.m_animateStartScale = _arg_1;
	}

	public function set AnimateEndScale(_arg_1:Number):void {
		this.m_animateEndScale = _arg_1;
	}

	public function set AnimateEasingType(_arg_1:String):void {
		this.m_animateEasingType = MenuUtils.getEaseType(_arg_1);
	}


}
}//package menu3.briefing

