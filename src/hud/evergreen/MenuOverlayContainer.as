// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.MenuOverlayContainer

package hud.evergreen {
import common.BaseControl;

import flash.display.Sprite;
import flash.utils.Dictionary;

import common.Animate;

import flash.utils.getDefinitionByName;

public class MenuOverlayContainer extends BaseControl {

	private var m_slideContainerL:Sprite = new Sprite();
	private var m_slideContainerR:Sprite = new Sprite();
	private var m_componentByName:Dictionary = new Dictionary();
	private var m_isMenuOpen:Boolean = false;
	private var m_dxWidthLayout:Number = 0;
	private var m_dyHeightLayout:Number = 0;
	private var m_xLeft:Number = 0;
	private var m_xRight:Number = 0;
	private var m_yTop:Number = 0;
	private var m_yBottom:Number = 0;
	private var m_pxGutter:Number = 0;
	private var m_dtSlideAnimDuration:Number = 0;
	private var m_dxSlideAnimOffset:Number = 0;
	private var m_drawDebug:Boolean = false;

	public function MenuOverlayContainer() {
		this.m_slideContainerL.name = "m_slideContainerL";
		this.m_slideContainerR.name = "m_slideContainerR";
		addChild(this.m_slideContainerL);
		addChild(this.m_slideContainerR);
	}

	[PROPERTY(CATEGORY="Evergreen Menu Overlay Container", CONSTRAINT="Step(1) MinValue(0)")]
	public function set pxGutter(_arg_1:Number):void {
		this.m_pxGutter = _arg_1;
		this.updateLayout();
	}

	[PROPERTY(CATEGORY="Evergreen Menu Overlay Container", CONSTRAINT="MinValue(0)")]
	public function set dtSlideAnimDuration(_arg_1:Number):void {
		this.m_dtSlideAnimDuration = _arg_1;
	}

	[PROPERTY(CATEGORY="Evergreen Menu Overlay Container", CONSTRAINT="Step(1)")]
	public function set dxSlideAnimOffset(_arg_1:Number):void {
		this.m_dxSlideAnimOffset = _arg_1;
	}

	[PROPERTY(CATEGORY="Evergreen Menu Overlay Container")]
	public function set DrawDebug(_arg_1:Boolean):void {
		this.m_drawDebug = _arg_1;
		this.updateLayout();
	}

	public function onControlLayoutChanged():void {
		var _local_1:IMenuOverlayComponent;
		for each (_local_1 in this.m_componentByName) {
			_local_1.onControlLayoutChanged();
		}

	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_dxWidthLayout = _arg_1;
		this.m_dyHeightLayout = _arg_2;
		this.updateLayout();
	}

	public function onMenuOpening(_arg_1:Number):void {
		this.m_isMenuOpen = true;
		var _local_2:Number = Math.min(_arg_1, this.m_dtSlideAnimDuration);
		Animate.to(this.m_slideContainerL, _local_2, (_arg_1 - _local_2), {
			"alpha": 1,
			"x": this.m_xLeft
		}, Animate.ExpoOut);
		Animate.to(this.m_slideContainerR, _local_2, (_arg_1 - _local_2), {
			"alpha": 1,
			"x": this.m_xRight
		}, Animate.ExpoOut);
	}

	public function onMenuClosing(_arg_1:Number):void {
		this.m_isMenuOpen = false;
		var _local_2:Number = Math.min(_arg_1, this.m_dtSlideAnimDuration);
		Animate.to(this.m_slideContainerL, _local_2, 0, {
			"alpha": 0,
			"x": (this.m_xLeft - this.m_dxSlideAnimOffset)
		}, Animate.ExpoIn);
		Animate.to(this.m_slideContainerR, _local_2, 0, {
			"alpha": 0,
			"x": (this.m_xRight + this.m_dxSlideAnimOffset)
		}, Animate.ExpoIn);
	}

	public function routeDataToComponent(_arg_1:String, _arg_2:Object):void {
		var _local_4:Class;
		var _local_3:IMenuOverlayComponent = this.m_componentByName[_arg_1];
		if (_local_3 == null) {
			_local_4 = Class(getDefinitionByName((("hud.evergreen.menuoverlay." + _arg_1) + "Component")));
			_local_3 = new (_local_4)();
			this.m_componentByName[_arg_1] = _local_3;
			((_local_3.isLeftAligned()) ? this.m_slideContainerL : this.m_slideContainerR).addChild(_local_3);
			_local_3.onUsableSizeChanged((this.m_xRight - this.m_xLeft), this.m_yTop, this.m_yBottom);
		}

		_local_3.onSetData(_arg_2);
	}

	private function updateLayout():void {
		var _local_1:Number;
		var _local_4:IMenuOverlayComponent;
		_local_1 = Math.min((this.m_dxWidthLayout / 1920), (this.m_dyHeightLayout / 1080));
		var _local_2:Number = (1920 * _local_1);
		var _local_3:Number = this.m_dyHeightLayout;
		this.m_xLeft = (((this.m_dxWidthLayout / 2) - (_local_2 / 2)) + this.m_pxGutter);
		this.m_yTop = (((this.m_dyHeightLayout / 2) - (_local_3 / 2)) + this.m_pxGutter);
		this.m_xRight = ((this.m_xLeft + _local_2) - (2 * this.m_pxGutter));
		this.m_yBottom = ((this.m_yTop + _local_3) - (2 * this.m_pxGutter));
		Animate.kill(this.m_slideContainerL);
		Animate.kill(this.m_slideContainerR);
		this.m_slideContainerL.alpha = ((this.m_isMenuOpen) ? 1 : 0);
		this.m_slideContainerR.alpha = ((this.m_isMenuOpen) ? 1 : 0);
		this.m_slideContainerL.x = (this.m_xLeft - ((this.m_isMenuOpen) ? 0 : this.m_dxSlideAnimOffset));
		this.m_slideContainerR.x = (this.m_xRight + ((this.m_isMenuOpen) ? 0 : this.m_dxSlideAnimOffset));
		graphics.clear();
		this.m_slideContainerL.graphics.clear();
		this.m_slideContainerR.graphics.clear();
		if (this.m_drawDebug) {
			graphics.lineStyle(3, 0xFFFF00, 1);
			graphics.drawRect(4, 4, (this.m_dxWidthLayout - (2 * 4)), (this.m_dyHeightLayout - (2 * 4)));
			graphics.lineStyle();
			graphics.beginFill(0xFF0000, 0.25);
			graphics.drawRect(this.m_xLeft, this.m_yTop, (this.m_xRight - this.m_xLeft), (this.m_yBottom - this.m_yTop));
			this.m_slideContainerL.graphics.lineStyle(3, 0xFF00, 1);
			this.m_slideContainerL.graphics.moveTo(0, -9999);
			this.m_slideContainerL.graphics.lineTo(0, 9999);
			this.m_slideContainerR.graphics.lineStyle(3, 0xFF00, 1);
			this.m_slideContainerR.graphics.moveTo(0, -9999);
			this.m_slideContainerR.graphics.lineTo(0, 9999);
		}

		for each (_local_4 in this.m_componentByName) {
			_local_4.onUsableSizeChanged((this.m_xRight - this.m_xLeft), this.m_yTop, this.m_yBottom);
		}

	}


}
}//package hud.evergreen

