// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.OutfitAndStatusMarkersVR

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

public class OutfitAndStatusMarkersVR extends BaseControl {

	public static const ICON_SEARCHING:int = 1;
	public static const ICON_COMPROMISED:int = 2;
	public static const ICON_HUNTED:int = 3;
	public static const ICON_COMBAT:int = 4;
	public static const ICON_SECURITYCAMERA:int = 5;
	public static const ICON_HIDDENINLVA:int = 6;
	public static const ICON_QUESTIONMARK:int = 7;
	public static const ICON_UNCONSCIOUSWITNESS:int = 8;
	private static const DX_GAP_TEXTTICKER:Number = 40;
	private static const DT_DELAY_TEXTTICKER:Number = 1;
	private static const DXPS_SPEED_TEXTTICKER:Number = 100;

	private var m_statusMarkerView:StatusMarkerViewLean = new StatusMarkerViewLean();
	private var m_Outfit_txtHeader:TextField = new TextField();
	private var m_Outfit_txtName:TextField = new TextField();
	private var m_Outfit_txtName2:TextField = new TextField();
	private var m_Outfit_offsetName:Sprite = new Sprite();
	private var m_Outfit_maskName:MaskView = new MaskView();
	private var m_Outfit_image:ImageLoader = new ImageLoader();
	private var m_Outfit_offsetImage:Sprite = new Sprite();
	private var m_Outfit_maskImage:MaskView = new MaskView();
	private var m_isHitmanSuit:Boolean = false;
	private var m_isPlayerLookingAtHand:Boolean = false;
	private var m_mask_pxWidth:Number;
	private var m_mask_pxHeight:Number;
	private var m_mask_pxPadding:Number;
	private var m_hitmanSuitCrop_fScale:Number;

	public function OutfitAndStatusMarkersVR() {
		this.m_Outfit_txtHeader.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupTextUpper(this.m_Outfit_txtHeader, Localization.get("UI_VR_HUD_OUTFITWIDGET_HEADER"), 12, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.addDropShadowFilter(this.m_Outfit_txtHeader);
		this.m_Outfit_txtName.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupText(this.m_Outfit_txtName, "...", 18, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.addDropShadowFilter(this.m_Outfit_txtName);
		this.m_Outfit_txtName2.autoSize = TextFieldAutoSize.LEFT;
		MenuUtils.setupText(this.m_Outfit_txtName2, "...", 18, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.addDropShadowFilter(this.m_Outfit_txtName2);
		this.m_Outfit_offsetName.name = "offsetName";
		this.m_Outfit_offsetName.addChild(this.m_Outfit_txtName);
		this.m_Outfit_offsetName.addChild(this.m_Outfit_txtName2);
		this.m_Outfit_offsetImage.mask = this.m_Outfit_maskImage;
		this.m_Outfit_offsetName.mask = this.m_Outfit_maskName;
		this.m_Outfit_offsetImage.addChild(this.m_Outfit_image);
		var _local_1:Sprite = new Sprite();
		_local_1.name = "containerImg";
		_local_1.addChild(this.m_Outfit_offsetImage);
		_local_1.addChild(this.m_Outfit_maskImage);
		addChild(_local_1);
		this.m_statusMarkerView.x = 105;
		this.m_statusMarkerView.y = 105;
		addChild(this.m_statusMarkerView);
		var _local_2:Sprite = new Sprite();
		_local_2.name = "containerTxt";
		_local_2.addChild(this.m_Outfit_txtHeader);
		_local_2.addChild(this.m_Outfit_offsetName);
		_local_2.addChild(this.m_Outfit_maskName);
		addChild(_local_2);
	}

	public function set mask_pxWidth(_arg_1:Number):void {
		this.m_mask_pxWidth = _arg_1;
		this.onOutfitPropertiesChanged();
	}

	public function set mask_pxHeight(_arg_1:Number):void {
		this.m_mask_pxHeight = _arg_1;
		this.onOutfitPropertiesChanged();
	}

	public function set mask_pxPadding(_arg_1:Number):void {
		this.m_mask_pxPadding = _arg_1;
		this.onOutfitPropertiesChanged();
	}

	public function set hitmanSuitCrop_fScale(_arg_1:Number):void {
		this.m_hitmanSuitCrop_fScale = _arg_1;
		this.onOutfitPropertiesChanged();
	}

	public function set outfit_zOffset(_arg_1:Number):void {
		this.m_Outfit_offsetImage.z = _arg_1;
	}

	public function set outfit_fScale(_arg_1:Number):void {
		this.m_Outfit_offsetImage.scaleX = (this.m_Outfit_offsetImage.scaleY = _arg_1);
	}

	public function updateOutfit(lstrName:String, ridImage:String, isHitmanSuit:Boolean, isOutfitChange:Boolean):void {
		this.m_isHitmanSuit = isHitmanSuit;
		this.m_Outfit_image.loadImage(ridImage, function ():void {
			applyOutfitName(lstrName);
			applyOutfitImageSize();
		}, function ():void {
			applyOutfitName(lstrName);
		});
	}

	public function onSetData(_arg_1:Object):void {
		this.m_statusMarkerView.setTrespassing(_arg_1.bTrespassing, _arg_1.bDeepTrespassing);
	}

	public function hiddenInCrowd(_arg_1:Boolean):void {
		this.m_statusMarkerView.hiddenInCrowd(_arg_1);
	}

	public function hiddenInVegetation(_arg_1:Boolean):void {
		this.m_statusMarkerView.hiddenInVegetation(_arg_1);
	}

	public function setTensionMessage(_arg_1:String, _arg_2:int, _arg_3:int):void {
		this.m_statusMarkerView.setTensionMessage(_arg_1, _arg_2, _arg_3);
	}

	public function setPlayerLookingAtHand(_arg_1:Boolean):void {
		this.m_isPlayerLookingAtHand = _arg_1;
		if (_arg_1) {
			this.resetAndStartTextTicker();
		} else {
			Animate.kill(this.m_Outfit_txtName);
			Animate.kill(this.m_Outfit_txtName2);
		}
		;
	}

	private function applyOutfitName(_arg_1:String):void {
		_arg_1 = _arg_1.toUpperCase();
		this.m_Outfit_txtName.text = _arg_1;
		if (this.m_Outfit_txtName.width <= (this.m_mask_pxWidth - (2 * this.m_mask_pxPadding))) {
			this.m_Outfit_txtName.x = 0;
			if (this.m_Outfit_txtName2.visible) {
				this.m_Outfit_txtName2.visible = false;
				Animate.kill(this.m_Outfit_txtName);
				Animate.kill(this.m_Outfit_txtName2);
			}
			;
		} else {
			this.m_Outfit_txtName2.visible = true;
			this.m_Outfit_txtName2.text = _arg_1;
			if (this.m_isPlayerLookingAtHand) {
				this.resetAndStartTextTicker();
			}
			;
		}
		;
	}

	private function resetTextTicker():void {
		this.m_Outfit_txtName.x = 0;
		this.m_Outfit_txtName2.x = (this.m_Outfit_txtName.width + DX_GAP_TEXTTICKER);
	}

	private function resetAndStartTextTicker():void {
		var _local_1:Number;
		var _local_2:Number;
		var _local_3:Number;
		this.resetTextTicker();
		if (!this.m_Outfit_txtName2.visible) {
			return;
		}
		;
		if (this.m_isPlayerLookingAtHand) {
			_local_1 = this.m_Outfit_txtName.width;
			_local_2 = (DX_GAP_TEXTTICKER + _local_1);
			Animate.fromTo(this.m_Outfit_txtName, (_local_2 / DXPS_SPEED_TEXTTICKER), DT_DELAY_TEXTTICKER, {
				"alpha": 1,
				"x": this.m_Outfit_txtName.x
			}, {
				"alpha": 1,
				"x": -(_local_1 + DX_GAP_TEXTTICKER)
			}, Animate.Linear, this.loopTextTicker, this.m_Outfit_txtName);
			_local_3 = ((2 * DX_GAP_TEXTTICKER) + (2 * _local_1));
			Animate.fromTo(this.m_Outfit_txtName2, (_local_3 / DXPS_SPEED_TEXTTICKER), DT_DELAY_TEXTTICKER, {
				"alpha": 1,
				"x": this.m_Outfit_txtName2.x
			}, {
				"alpha": 1,
				"x": -(_local_1 + DX_GAP_TEXTTICKER)
			}, Animate.Linear, this.loopTextTicker, this.m_Outfit_txtName2);
		}
		;
	}

	private function loopTextTicker(_arg_1:TextField):void {
		var _local_2:Number;
		_local_2 = _arg_1.width;
		var _local_3:Number = ((2 * DX_GAP_TEXTTICKER) + (2 * _local_2));
		Animate.fromTo(_arg_1, (_local_3 / DXPS_SPEED_TEXTTICKER), 0, {
			"alpha": 1,
			"x": (_local_2 + DX_GAP_TEXTTICKER)
		}, {
			"alpha": 1,
			"x": -(_local_2 + DX_GAP_TEXTTICKER)
		}, Animate.Linear, this.loopTextTicker, _arg_1);
	}

	private function applyOutfitImageSize():void {
		if (!this.m_isHitmanSuit) {
			this.m_Outfit_image.height = this.m_mask_pxHeight;
		} else {
			this.m_Outfit_image.height = (this.m_mask_pxHeight * this.m_hitmanSuitCrop_fScale);
		}
		;
		this.m_Outfit_image.scaleX = this.m_Outfit_image.scaleY;
		this.m_Outfit_image.x = (-(this.m_Outfit_image.width) / 2);
		this.m_Outfit_image.y = (-(this.m_mask_pxHeight) / 2);
	}

	private function onOutfitPropertiesChanged():void {
		this.m_Outfit_maskImage.width = this.m_mask_pxWidth;
		this.m_Outfit_maskImage.height = this.m_mask_pxHeight;
		this.m_Outfit_maskName.x = this.m_mask_pxPadding;
		this.m_Outfit_maskName.width = (this.m_mask_pxWidth - (2 * this.m_mask_pxPadding));
		this.m_Outfit_maskName.height = this.m_mask_pxHeight;
		this.m_Outfit_txtHeader.x = this.m_mask_pxPadding;
		this.m_Outfit_offsetName.x = this.m_mask_pxPadding;
		this.m_Outfit_txtHeader.y = (((this.m_mask_pxHeight - this.m_mask_pxPadding) - this.m_Outfit_txtName.height) - this.m_Outfit_txtHeader.height);
		this.m_Outfit_offsetName.y = ((this.m_mask_pxHeight - this.m_mask_pxPadding) - this.m_Outfit_txtName.height);
		this.m_Outfit_offsetImage.x = (this.m_mask_pxWidth / 2);
		this.m_Outfit_offsetImage.y = (this.m_mask_pxHeight / 2);
		this.applyOutfitImageSize();
	}


}
}//package hud

import flash.display.Sprite;

import common.Localization;

import flash.display.MovieClip;
import flash.text.TextFormat;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import hud.OutfitAndStatusMarkersVR;

class StatusMarkerViewLean extends Sprite {

	/*private*/
	const m_lstrHiddenInCrowd:String = Localization.get("UI_MENU_LVA_BLENDING_IN_CROWD").toUpperCase();
	/*private*/
	const m_lstrHiddenInVegetation:String = Localization.get("UI_MENU_LVA_HIDDEN").toUpperCase();
	/*private*/
	const m_lstrDeepTrespassing:String = Localization.get("EGAME_TEXT_SL_HOSTILEAREA").toUpperCase();
	/*private*/
	const m_lstrTrespassing:String = Localization.get("EGAME_TEXT_SL_TRESPASSING_ON").toUpperCase();

	/*private*/
	var m_gradientOverlay:MovieClip;
	/*private*/
	var m_borderMc:MovieClip;
	/*private*/
	var m_gradientOverlayLVA:MovieClip;
	/*private*/
	var m_trespassingIndicatorMc:MovieClip;
	/*private*/
	var m_tensionIndicatorMc:MovieClip;
	/*private*/
	var m_informationBarLVA:MovieClip;
	/*private*/
	var m_isHiddenInCrowd:Boolean = false;
	/*private*/
	var m_isHiddenInVegetation:Boolean = false;

	public function StatusMarkerViewLean() {
		var _local_1:StatusMarkerView = new StatusMarkerView();
		this.m_gradientOverlay = _local_1.gradientOverlay;
		addChild(this.m_gradientOverlay);
		this.m_borderMc = _local_1.borderMc;
		addChild(this.m_borderMc);
		this.m_gradientOverlayLVA = _local_1.gradientOverlayLVA;
		addChild(this.m_gradientOverlayLVA);
		this.m_trespassingIndicatorMc = _local_1.trespassingIndicatorMc;
		addChild(this.m_trespassingIndicatorMc);
		this.m_tensionIndicatorMc = _local_1.tensionIndicatorMc;
		addChild(this.m_tensionIndicatorMc);
		this.m_informationBarLVA = _local_1.informationBarLVA;
		addChild(this.m_informationBarLVA);
		this.m_gradientOverlay.alpha = 0.3;
		this.m_gradientOverlayLVA.alpha = 0.6;
		this.m_gradientOverlayLVA.visible = false;
		this.m_trespassingIndicatorMc.visible = false;
		this.m_tensionIndicatorMc.visible = false;
		this.m_informationBarLVA.visible = false;
		var _local_2:TextFormat = new TextFormat();
		_local_2.leading = -3.5;
		this.m_trespassingIndicatorMc.bgGradient.alpha = 0.5;
		this.m_trespassingIndicatorMc.y = 105;
		this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.overlayMc);
		this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.pulseMc);
		this.m_tensionIndicatorMc.labelTxt.autoSize = "left";
		this.m_tensionIndicatorMc.labelTxt.multiline = true;
		this.m_tensionIndicatorMc.labelTxt.wordWrap = true;
		this.m_tensionIndicatorMc.labelTxt.width = 186;
		this.m_tensionIndicatorMc.labelTxt.text = "...";
		this.m_tensionIndicatorMc.labelTxt.setTextFormat(_local_2);
		MenuUtils.setupText(this.m_tensionIndicatorMc.unconMc.labelTxt, "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		this.m_tensionIndicatorMc.bgMc.height = 23;
		this.m_tensionIndicatorMc.bgGradient.alpha = 0.5;
		this.m_tensionIndicatorMc.y = -129;
		this.m_informationBarLVA.iconMc.gotoAndStop(OutfitAndStatusMarkersVR.ICON_HIDDENINLVA);
		this.m_informationBarLVA.labelTxt.autoSize = "left";
		this.m_informationBarLVA.labelTxt.multiline = true;
		this.m_informationBarLVA.labelTxt.wordWrap = true;
		this.m_informationBarLVA.labelTxt.width = 186;
		this.m_informationBarLVA.labelTxt.text = "";
		this.m_informationBarLVA.labelTxt.setTextFormat(_local_2);
		MenuUtils.setupText(this.m_informationBarLVA.labelTxt, "...", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		this.m_informationBarLVA.y = -105;
	}

	public function setTrespassing(_arg_1:Boolean, _arg_2:Boolean):void {
		var _local_3:String;
		var _local_4:Number;
		var _local_5:Number;
		if (((_arg_1) || (_arg_2))) {
			_local_3 = ((_arg_2) ? this.m_lstrDeepTrespassing : this.m_lstrTrespassing);
			_local_4 = -1;
			_local_5 = 9;
			MenuUtils.setupTextAndShrinkToFitUpper(this.m_trespassingIndicatorMc.labelTxt, _local_3, 18, MenuConstants.FONT_TYPE_MEDIUM, 184, _local_4, _local_5, MenuConstants.FontColorGreyUltraDark);
			this.m_trespassingIndicatorMc.visible = true;
		} else {
			this.m_trespassingIndicatorMc.visible = false;
		}
		;
	}

	public function hiddenInCrowd(_arg_1:Boolean):void {
		this.m_isHiddenInCrowd = _arg_1;
		this.applyLVA();
	}

	public function hiddenInVegetation(_arg_1:Boolean):void {
		this.m_isHiddenInVegetation = _arg_1;
		this.applyLVA();
	}

	/*private*/
	function applyLVA():void {
		if (this.m_isHiddenInCrowd) {
			this.m_informationBarLVA.labelTxt.text = this.m_lstrHiddenInCrowd;
			this.m_informationBarLVA.visible = true;
			this.m_gradientOverlayLVA.visible = true;
		} else {
			if (this.m_isHiddenInVegetation) {
				this.m_informationBarLVA.labelTxt.text = this.m_lstrHiddenInVegetation;
				this.m_informationBarLVA.visible = true;
				this.m_gradientOverlayLVA.visible = true;
			} else {
				this.m_informationBarLVA.visible = false;
				this.m_gradientOverlayLVA.visible = false;
			}
			;
		}
		;
	}

	public function setTensionMessage(_arg_1:String, _arg_2:int, _arg_3:int):void {
		var _local_4:String;
		if (_arg_1 == "") {
			this.m_tensionIndicatorMc.visible = false;
		} else {
			this.m_tensionIndicatorMc.iconMc.gotoAndStop(((_arg_2 > 0) ? _arg_2 : 1));
			this.m_tensionIndicatorMc.labelTxt.text = _arg_1.toUpperCase();
			this.m_tensionIndicatorMc.bgMc.height = (23 + ((this.m_tensionIndicatorMc.labelTxt.numLines - 1) * 19));
			this.m_tensionIndicatorMc.y = (-129 - ((this.m_tensionIndicatorMc.labelTxt.numLines - 1) * 19));
			if (_arg_3 >= 1) {
				this.m_tensionIndicatorMc.iconMc.gotoAndStop(OutfitAndStatusMarkersVR.ICON_UNCONSCIOUSWITNESS);
				if (_arg_3 >= 2) {
					_local_4 = String(_arg_3);
					this.m_tensionIndicatorMc.unconMc.labelTxt.text = _local_4;
					this.m_tensionIndicatorMc.unconMc.bgMc.width = (29 + (_local_4.length * 12));
					this.m_tensionIndicatorMc.unconMc.bgMc.height = this.m_tensionIndicatorMc.bgMc.height;
				}
				;
			}
			;
			this.m_tensionIndicatorMc.visible = true;
			this.m_tensionIndicatorMc.unconMc.visible = (_arg_3 >= 2);
		}
		;
	}


}


