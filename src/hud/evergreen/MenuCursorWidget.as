// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.MenuCursorWidget

package hud.evergreen {
import common.BaseControl;

import flash.display.Sprite;
import flash.display.Shape;
import flash.filters.DropShadowFilter;
import flash.filters.BitmapFilterQuality;

import common.Animate;

import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.Graphics;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

public class MenuCursorWidget extends BaseControl {

	private var m_pxMargin:Number;
	private var m_pxThickness:Number;
	private var m_pxSerif:Number;
	private var m_pxAnimOffset:Number;
	private var m_fScaleIcon:Number;
	private var m_sprSizeTL:Sprite = new Sprite();
	private var m_sprSizeTR:Sprite = new Sprite();
	private var m_sprSizeBL:Sprite = new Sprite();
	private var m_sprSizeBR:Sprite = new Sprite();
	private var m_sprAnimTL:Sprite = new Sprite();
	private var m_sprAnimTR:Sprite = new Sprite();
	private var m_sprAnimBL:Sprite = new Sprite();
	private var m_sprAnimBR:Sprite = new Sprite();
	private var m_shpShadowTL:Shape = new Shape();
	private var m_shpShadowTR:Shape = new Shape();
	private var m_shpShadowBL:Shape = new Shape();
	private var m_shpShadowBR:Shape = new Shape();
	private var m_shpWhiteTL:Shape = new Shape();
	private var m_shpWhiteTR:Shape = new Shape();
	private var m_shpWhiteBL:Shape = new Shape();
	private var m_shpWhiteBR:Shape = new Shape();
	private var m_icon:iconsAll76x76View = new iconsAll76x76View();

	public function MenuCursorWidget() {
		this.m_sprSizeTL.name = "m_sprSizeTL";
		this.m_sprAnimTL.name = "m_sprAnimTL";
		this.m_shpShadowTL.name = "m_shpShadowTL";
		this.m_shpWhiteTL.name = "m_shpWhiteTL";
		addChild(this.m_sprSizeTL);
		this.m_sprSizeTL.addChild(this.m_sprAnimTL);
		this.m_sprAnimTL.addChild(this.m_shpShadowTL);
		this.m_sprAnimTL.addChild(this.m_shpWhiteTL);
		this.m_sprSizeTR.name = "m_sprSizeTR";
		this.m_sprAnimTR.name = "m_sprAnimTR";
		this.m_shpShadowTR.name = "m_shpShadowTR";
		this.m_shpWhiteTR.name = "m_shpWhiteTR";
		addChild(this.m_sprSizeTR);
		this.m_sprSizeTR.addChild(this.m_sprAnimTR);
		this.m_sprAnimTR.addChild(this.m_shpShadowTR);
		this.m_sprAnimTR.addChild(this.m_shpWhiteTR);
		this.m_sprSizeBL.name = "m_sprSizeBL";
		this.m_sprAnimBL.name = "m_sprAnimBL";
		this.m_shpShadowBL.name = "m_shpShadowBL";
		this.m_shpWhiteBL.name = "m_shpWhiteBL";
		addChild(this.m_sprSizeBL);
		this.m_sprSizeBL.addChild(this.m_sprAnimBL);
		this.m_sprAnimBL.addChild(this.m_shpShadowBL);
		this.m_sprAnimBL.addChild(this.m_shpWhiteBL);
		this.m_sprSizeBR.name = "m_sprSizeBR";
		this.m_sprAnimBR.name = "m_sprAnimBR";
		this.m_shpShadowBR.name = "m_shpShadowBR";
		this.m_shpWhiteBR.name = "m_shpWhiteBR";
		addChild(this.m_sprSizeBR);
		this.m_sprSizeBR.addChild(this.m_sprAnimBR);
		this.m_sprAnimBR.addChild(this.m_shpShadowBR);
		this.m_sprAnimBR.addChild(this.m_shpWhiteBR);
		this.m_icon.name = "m_icon";
		addChild(this.m_icon);
		this.m_icon.filters = [new DropShadowFilter(4, 90, 0, 1, 16, 16, 1, BitmapFilterQuality.MEDIUM, false, false, false)];
	}

	[PROPERTY(CONSTRAINT="MinValue(0) Step(1)")]
	public function set pxMargin(_arg_1:Number):void {
		this.m_pxMargin = _arg_1;
		this.redrawAllCorners();
	}

	[PROPERTY(CONSTRAINT="MinValue(0) Step(1)")]
	public function set pxThickness(_arg_1:Number):void {
		this.m_pxThickness = _arg_1;
		this.redrawAllCorners();
	}

	[PROPERTY(CONSTRAINT="MinValue(0) Step(1)")]
	public function set pxSerif(_arg_1:Number):void {
		this.m_pxSerif = _arg_1;
		this.redrawAllCorners();
	}

	[PROPERTY(CONSTRAINT="MinValue(0) Step(1)")]
	public function set xShadowOffset(_arg_1:Number):void {
		this.m_shpWhiteTL.x = (this.m_shpWhiteTR.x = (this.m_shpWhiteBL.x = (this.m_shpWhiteBR.x = (this.m_icon.x = -(_arg_1)))));
	}

	[PROPERTY(CONSTRAINT="MinValue(0) Step(1)")]
	public function set yShadowOffset(_arg_1:Number):void {
		this.m_shpWhiteTL.y = (this.m_shpWhiteTR.y = (this.m_shpWhiteBL.y = (this.m_shpWhiteBR.y = (this.m_icon.y = -(_arg_1)))));
	}

	[PROPERTY(CONSTRAINT="MinValue(0) Step(1)")]
	public function set zShadowOffset(_arg_1:Number):void {
		this.m_shpWhiteTL.z = (this.m_shpWhiteTR.z = (this.m_shpWhiteBL.z = (this.m_shpWhiteBR.z = (this.m_icon.z = -(_arg_1)))));
	}

	[PROPERTY(CONSTRAINT="MinValue(0) Step(1)")]
	public function set pxAnimOffset(_arg_1:Number):void {
		this.m_pxAnimOffset = _arg_1;
	}

	[PROPERTY(CONSTRAINT="MinValue(0)")]
	public function set fScaleIcon(_arg_1:Number):void {
		this.m_fScaleIcon = _arg_1;
		Animate.complete(this.m_icon);
		this.m_icon.scaleX = _arg_1;
		this.m_icon.scaleY = _arg_1;
	}

	private function redrawAllCorners():void {
		this.redrawCorner(this.m_shpShadowTL.graphics, this.m_shpWhiteTL.graphics, -(this.m_pxMargin), (-(this.m_pxMargin) + this.m_pxSerif), -(this.m_pxMargin), -(this.m_pxMargin), (-(this.m_pxMargin) + this.m_pxSerif), -(this.m_pxMargin));
		this.redrawCorner(this.m_shpShadowTR.graphics, this.m_shpWhiteTR.graphics, this.m_pxMargin, (-(this.m_pxMargin) + this.m_pxSerif), this.m_pxMargin, -(this.m_pxMargin), (this.m_pxMargin - this.m_pxSerif), -(this.m_pxMargin));
		this.redrawCorner(this.m_shpShadowBL.graphics, this.m_shpWhiteBL.graphics, -(this.m_pxMargin), (this.m_pxMargin - this.m_pxSerif), -(this.m_pxMargin), this.m_pxMargin, (-(this.m_pxMargin) + this.m_pxSerif), this.m_pxMargin);
		this.redrawCorner(this.m_shpShadowBR.graphics, this.m_shpWhiteBR.graphics, this.m_pxMargin, (this.m_pxMargin - this.m_pxSerif), this.m_pxMargin, this.m_pxMargin, (this.m_pxMargin - this.m_pxSerif), this.m_pxMargin);
	}

	private function redrawCorner(_arg_1:Graphics, _arg_2:Graphics, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number):void {
		_arg_1.clear();
		_arg_1.lineStyle(this.m_pxThickness, 0, 0.5, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
		_arg_1.moveTo(_arg_3, _arg_4);
		_arg_1.lineTo(_arg_5, _arg_6);
		_arg_1.lineTo(_arg_7, _arg_8);
		_arg_2.clear();
		_arg_2.lineStyle(this.m_pxThickness, 0xFFFFFF, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
		_arg_2.moveTo(_arg_3, _arg_4);
		_arg_2.lineTo(_arg_5, _arg_6);
		_arg_2.lineTo(_arg_7, _arg_8);
	}

	public function updateSizeAndDecoration(_arg_1:Number, _arg_2:Number, _arg_3:Object):void {
		if ((((_arg_3 == null) || (_arg_3.icon == null)) || (_arg_3.icon == ""))) {
			this.m_icon.visible = false;
		} else {
			this.m_icon.visible = true;
			MenuUtils.setupIcon(this.m_icon, _arg_3.icon, MenuConstants.COLOR_WHITE, _arg_3.isIconFramed, false, 0xFFFFFF, 0, 0, _arg_3.isIconCutOut);
			_arg_1 = Math.max(_arg_1, (76 * this.m_fScaleIcon));
			_arg_2 = Math.max(_arg_2, (76 * this.m_fScaleIcon));
		}

		this.m_sprSizeTL.x = (-(_arg_1) / 2);
		this.m_sprSizeTL.y = (-(_arg_2) / 2);
		this.m_sprSizeTR.x = (_arg_1 / 2);
		this.m_sprSizeTR.y = (-(_arg_2) / 2);
		this.m_sprSizeBL.x = (-(_arg_1) / 2);
		this.m_sprSizeBL.y = (_arg_2 / 2);
		this.m_sprSizeBR.x = (_arg_1 / 2);
		this.m_sprSizeBR.y = (_arg_2 / 2);
	}

	public function animateCursorCorners():void {
		this.m_sprAnimTL.alpha = 0;
		this.m_sprAnimTR.alpha = 0;
		this.m_sprAnimBL.alpha = 0;
		this.m_sprAnimBR.alpha = 0;
		this.m_icon.alpha = 0;
		Animate.kill(this);
		this.animatePulse(0, false);
	}

	private function animatePulse(_arg_1:Number, _arg_2:Boolean):void {
		var _local_5:Number;
		var _local_3:Object = {
			"x": 0,
			"y": 0
		};
		var _local_4:Object = {
			"scaleX": this.m_fScaleIcon,
			"scaleY": this.m_fScaleIcon,
			"alpha": 1
		};
		_local_5 = this.m_pxAnimOffset;
		var _local_6:Object = {
			"x": -(_local_5),
			"y": -(_local_5)
		};
		var _local_7:Object = {
			"x": _local_5,
			"y": -(_local_5)
		};
		var _local_8:Object = {
			"x": -(_local_5),
			"y": _local_5
		};
		var _local_9:Object = {
			"x": _local_5,
			"y": _local_5
		};
		var _local_10:Object = {
			"scaleX": (this.m_fScaleIcon * 1.25),
			"scaleY": (this.m_fScaleIcon * 1.25),
			"alpha": 0
		};
		if (_arg_1 != 1) {
			_local_3.alpha = 1;
			_local_4.alpha = 1;
			_local_6.alpha = _arg_1;
			_local_7.alpha = _arg_1;
			_local_8.alpha = _arg_1;
			_local_9.alpha = _arg_1;
		}

		Animate.fromTo(this.m_sprAnimTL, 0.2, (1 / 30), ((_arg_2) ? _local_3 : _local_6), ((_arg_2) ? _local_6 : _local_3), ((_arg_2) ? Animate.SineIn : Animate.SineOut));
		Animate.fromTo(this.m_sprAnimTR, 0.2, (1 / 30), ((_arg_2) ? _local_3 : _local_7), ((_arg_2) ? _local_7 : _local_3), ((_arg_2) ? Animate.SineIn : Animate.SineOut));
		Animate.fromTo(this.m_sprAnimBL, 0.2, (1 / 30), ((_arg_2) ? _local_3 : _local_8), ((_arg_2) ? _local_8 : _local_3), ((_arg_2) ? Animate.SineIn : Animate.SineOut));
		Animate.fromTo(this.m_sprAnimBR, 0.2, (1 / 30), ((_arg_2) ? _local_3 : _local_9), ((_arg_2) ? _local_9 : _local_3), ((_arg_2) ? Animate.SineIn : Animate.SineOut));
		Animate.fromTo(this.m_icon, 0.2, (1 / 30), ((_arg_2) ? _local_4 : _local_10), ((_arg_2) ? _local_10 : _local_4), ((_arg_2) ? Animate.SineIn : Animate.SineOut));
		Animate.delay(this, ((_arg_2) ? (0.2 + (1 / 60)) : (1.5 - (2 * 0.2))), this.animatePulse, 1, (!(_arg_2)));
	}


}
}//package hud.evergreen

