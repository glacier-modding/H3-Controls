// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.OutfitWidgetVR

package hud {
import common.BaseControl;

import flash.text.TextField;
import flash.display.Sprite;

import common.ImageLoader;

import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.Localization;
import common.menu.MenuConstants;
import common.Animate;

public class OutfitWidgetVR extends BaseControl {

	private static const DT_ANIMDURATION:Number = 0.5;
	private static const DT_ANIMDELAY:Number = 0.1;

	private var m_txtHeader:TextField = new TextField();
	private var m_txtOutfitName:TextField = new TextField();
	private var m_container:Sprite = new Sprite();
	private var m_imgOutfit:ImageLoader = new ImageLoader();
	private var m_mask:MaskView = new MaskView();
	private var m_isHitmanSuit:Boolean = false;
	private var m_mask_pxWidth:Number;
	private var m_mask_pxHeight:Number;
	private var m_hitmanSuitCrop_fScale:Number;

	public function OutfitWidgetVR() {
		this.m_container.alpha = 0;
		this.m_txtHeader.alpha = 0;
		this.m_txtOutfitName.alpha = 0;
		this.m_txtHeader.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupTextUpper(this.m_txtHeader, Localization.get("UI_VR_HUD_OUTFITWIDGET_HEADER"), 20, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.addDropShadowFilter(this.m_txtHeader);
		this.m_txtOutfitName.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupText(this.m_txtOutfitName, "", 34, MenuConstants.FONT_TYPE_BOLD);
		MenuUtils.addDropShadowFilter(this.m_txtOutfitName);
		this.m_txtOutfitName.y = this.m_txtHeader.height;
		this.m_imgOutfit.mask = this.m_mask;
		this.m_container.addChild(this.m_imgOutfit);
		this.m_container.addChild(this.m_mask);
		addChild(this.m_container);
		addChild(this.m_txtHeader);
		addChild(this.m_txtOutfitName);
	}

	public function set mask_pxWidth(_arg_1:Number):void {
		this.m_mask_pxWidth = _arg_1;
		this.onPropertiesChanged();
	}

	public function set mask_pxHeight(_arg_1:Number):void {
		this.m_mask_pxHeight = _arg_1;
		this.onPropertiesChanged();
	}

	public function set hitmanSuitCrop_fScale(_arg_1:Number):void {
		this.m_hitmanSuitCrop_fScale = _arg_1;
		this.onPropertiesChanged();
	}

	public function onTCMovementBegun():void {
		Animate.kill(this.m_container);
		Animate.kill(this.m_txtHeader);
		Animate.kill(this.m_txtOutfitName);
		this.m_container.alpha = 0;
		this.m_txtHeader.alpha = 0;
		this.m_txtOutfitName.alpha = 0;
	}

	public function updateOutfit(lstrName:String, ridImage:String, isHitmanSuit:Boolean, isOutfitChange:Boolean):void {
		this.m_isHitmanSuit = isHitmanSuit;
		this.m_imgOutfit.loadImage(ridImage, function ():void {
			m_txtOutfitName.text = lstrName.toUpperCase();
			applyImageSize();
			repositionImage(isOutfitChange);
			repositionTextFields(isOutfitChange);
		}, function ():void {
			m_txtOutfitName.text = lstrName.toUpperCase();
			repositionTextFields(isOutfitChange);
		});
	}

	private function applyImageSize():void {
		if (!this.m_isHitmanSuit) {
			this.m_imgOutfit.height = this.m_mask_pxHeight;
		} else {
			this.m_imgOutfit.height = (this.m_mask_pxHeight * this.m_hitmanSuitCrop_fScale);
		}

		this.m_imgOutfit.scaleX = this.m_imgOutfit.scaleY;
		this.m_imgOutfit.x = (-(this.m_imgOutfit.width) + ((this.m_imgOutfit.width - this.m_mask_pxWidth) / 2));
	}

	private function repositionImage(_arg_1:Boolean):void {
		if (_arg_1) {
			Animate.fromTo(this.m_container, DT_ANIMDURATION, (DT_ANIMDELAY + 0.5), {
				"x": -50,
				"alpha": 0
			}, {
				"x": 0,
				"alpha": 1
			}, Animate.ExpoOut);
		} else {
			this.m_container.x = 0;
			this.m_container.alpha = 1;
		}

	}

	private function repositionTextFields(_arg_1:Boolean):void {
		if (_arg_1) {
			Animate.fromTo(this.m_txtHeader, DT_ANIMDURATION, (DT_ANIMDELAY + 0.8), {
				"x": 50,
				"alpha": 0
			}, {
				"x": 8,
				"alpha": 1
			}, Animate.ExpoOut);
			Animate.fromTo(this.m_txtOutfitName, DT_ANIMDURATION, (DT_ANIMDELAY + 1), {
				"x": 50,
				"alpha": 0
			}, {
				"x": 8,
				"alpha": 1
			}, Animate.ExpoOut);
		} else {
			this.m_txtHeader.x = 8;
			this.m_txtOutfitName.x = 8;
			this.m_txtHeader.alpha = 1;
			this.m_txtOutfitName.alpha = 1;
		}

	}

	private function onPropertiesChanged():void {
		this.m_mask.width = this.m_mask_pxWidth;
		this.m_mask.height = this.m_mask_pxHeight;
		this.m_mask.x = -(this.m_mask_pxWidth);
		this.applyImageSize();
	}


}
}//package hud

