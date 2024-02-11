// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.InteractionIndicator

package hud {
import common.BaseControl;

import basic.ButtonPromptImage;

import common.menu.MenuConstants;
import common.CommonUtils;
import common.menu.MenuUtils;

import flash.text.TextFieldAutoSize;

import mx.utils.StringUtil;

public class InteractionIndicator extends BaseControl {

	public static const STATE_AVAILABLE:int = 0;
	public static const STATE_COLLAPSED:int = 1;
	public static const STATE_ACTIVATING:int = 2;
	public static const STATE_NOTAVAILABLE:int = 3;
	public static const TYPE_UNKNOWN:int = 0;
	public static const TYPE_PRESS:int = 1;
	public static const TYPE_HOLD:int = 2;
	public static const TYPE_HOLD_DOWN:int = 3;
	public static const TYPE_REPEAT:int = 4;
	public static const TYPE_GUIDE:int = 5;

	private var m_view:InteractionIndicatorView;
	private var m_promptImage:ButtonPromptImage;
	private var m_currentProgress:Number;
	private var m_nFontSizeCurrent:int;
	private var m_sLabelCurrent:String = "";
	private var m_sDescriptionCurrent:String = "";
	private var m_holdAnimFrameOffset:int;
	private var m_viewportScale:Number = 1;

	public function InteractionIndicator() {
		this.m_view = new InteractionIndicatorView();
		addChild(this.m_view);
		this.m_promptImage = new ButtonPromptImage();
		this.m_view.promptHolder_mc.addChild(this.m_promptImage);
		this.m_nFontSizeCurrent = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? MenuConstants.INTERACTIONPROMPTSIZE_FORCEDONSMALLDISPLAY : CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_INTERACTION_PROMPT"));
		this.setupTextFields();
	}

	private function setupTextFields():void {
		var _local_1:Object = MenuConstants.InteractionIndicatorFontSpecs[this.m_nFontSizeCurrent];
		MenuUtils.setupText(this.m_view.prompt_mc.label_txt, this.m_sLabelCurrent, _local_1.fontSizeLabel, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.prompt_mc.desc_txt, this.m_sDescriptionCurrent, _local_1.fontSizeDesc, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:int = ((_arg_1.m_nFontSize) ? _arg_1.m_nFontSize : 0);
		if (_local_2 != this.m_nFontSizeCurrent) {
			this.m_nFontSizeCurrent = _local_2;
			this.setupTextFields();
		}
		;
		this.updateScale();
		if (_arg_1.m_eState == STATE_AVAILABLE) {
			this.m_promptImage.alpha = ((_arg_1.m_bNoActionAvailable) ? 0.33 : 1);
			this.m_holdAnimFrameOffset = ((((_arg_1.m_bIllegal) || (_arg_1.m_bIllegalItem)) || (_arg_1.m_bSuspiciousItem)) ? 81 : 1);
			this.m_view.prompt_mc.x = ((_arg_1.m_bIsTxtDirReversed) ? -28 : 28);
			if (((_arg_1.m_eTypeId == TYPE_HOLD) || (_arg_1.m_eTypeId == TYPE_HOLD_DOWN))) {
				this.m_view.tap_mc.visible = false;
				this.m_view.hold_mc.visible = true;
				this.m_view.hold_mc.gotoAndStop(this.m_holdAnimFrameOffset);
			} else {
				if (_arg_1.m_eTypeId == TYPE_REPEAT) {
					this.m_view.hold_mc.visible = false;
					this.m_view.tap_mc.visible = true;
					this.m_view.tap_mc.play();
				} else {
					this.m_view.tap_mc.visible = false;
					this.m_view.hold_mc.visible = false;
				}
				;
			}
			;
			this.showActionButton(_arg_1.m_nIconId, _arg_1.m_sLabel, _arg_1.m_sDescription, _arg_1.m_sGlyph, _arg_1.m_bIllegalItem, _arg_1.m_bIllegal, _arg_1.m_bSuspiciousItem, _arg_1.m_bIsTxtDirReversed);
			this.m_view.collapsedEmpty_mc.alpha = 0;
			this.m_view.collapsedFull_mc.alpha = 0;
			this.m_promptImage.visible = true;
			this.m_view.prompt_mc.visible = true;
			if (ControlsMain.isVrModeActive()) {
				this.m_view.alpha = 0.6;
			}
			;
		} else {
			if (((_arg_1.m_eState == STATE_COLLAPSED) || (_arg_1.m_eState == STATE_NOTAVAILABLE))) {
				this.m_promptImage.visible = false;
				this.m_view.prompt_mc.visible = false;
				this.m_view.tap_mc.visible = false;
				this.m_view.hold_mc.visible = false;
				this.m_view.illegalIcon_mc.visible = false;
				if (_arg_1.m_bInRange) {
					this.m_view.collapsedFull_mc.alpha = 0.75;
					this.m_view.collapsedEmpty_mc.alpha = 0;
				} else {
					if (_arg_1.m_bContainsItem) {
						this.m_view.collapsedFull_mc.alpha = 0.4;
						this.m_view.collapsedEmpty_mc.alpha = 0;
					} else {
						this.m_view.collapsedFull_mc.alpha = 0;
						this.m_view.collapsedEmpty_mc.alpha = 0.4;
					}
					;
				}
				;
				if (ControlsMain.isVrModeActive()) {
					this.m_view.alpha = 1;
				}
				;
			} else {
				if (_arg_1.m_eState == STATE_ACTIVATING) {
					this.showActionButton(_arg_1.m_nIconId, _arg_1.m_sLabel, _arg_1.m_sDescription, _arg_1.m_sGlyph, _arg_1.m_bIllegalItem, _arg_1.m_bIllegal, _arg_1.m_bSuspiciousItem, _arg_1.m_bIsTxtDirReversed);
					this.m_view.collapsedEmpty_mc.alpha = 0;
					this.m_view.collapsedFull_mc.alpha = 0;
					this.m_view.tap_mc.visible = false;
					this.m_promptImage.visible = true;
					this.m_view.prompt_mc.visible = true;
					if (_arg_1.m_fProgress > 0) {
						this.m_view.hold_mc.visible = true;
						if (this.m_currentProgress != _arg_1.m_fProgress) {
							this.m_view.hold_mc.gotoAndStop((Math.ceil((_arg_1.m_fProgress * 60)) + this.m_holdAnimFrameOffset));
							this.m_currentProgress = _arg_1.m_fProgress;
						}
						;
					} else {
						this.m_view.hold_mc.visible = false;
					}
					;
					if (ControlsMain.isVrModeActive()) {
						this.m_view.alpha = 0.6;
					}
					;
				}
				;
			}
			;
		}
		;
	}

	public function setScaleFactor3D(_arg_1:Number):void {
		this.m_view.collapsedEmpty_mc.scaleX = (this.m_view.collapsedEmpty_mc.scaleY = _arg_1);
		this.m_view.collapsedFull_mc.scaleX = (this.m_view.collapsedFull_mc.scaleY = _arg_1);
	}

	private function showActionButton(_arg_1:int, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Boolean, _arg_8:Boolean):void {
		var _local_12:Number;
		var _local_13:int;
		var _local_14:int;
		var _local_15:String;
		if ((((_arg_7) || (_arg_6)) || (_arg_5))) {
			_local_12 = 0.46;
			_local_13 = 58;
			_local_14 = ((this.m_view.hold_mc.visible) ? 39 : 35);
			if (this.m_nFontSizeCurrent == MenuConstants.INTERACTIONPROMPTSIZE_MEDIUM) {
				_local_12 = 0.52;
				_local_13 = 60;
				_local_14 = ((this.m_view.hold_mc.visible) ? 40 : 36);
			} else {
				if (this.m_nFontSizeCurrent >= MenuConstants.INTERACTIONPROMPTSIZE_LARGE) {
					_local_12 = 0.65;
					_local_13 = 67;
					_local_14 = ((this.m_view.hold_mc.visible) ? 44 : 40);
				}
				;
			}
			;
			this.m_view.illegalIcon_mc.scaleX = (this.m_view.illegalIcon_mc.scaleY = _local_12);
			this.m_view.prompt_mc.x = ((_arg_8) ? -(_local_13) : _local_13);
			this.m_view.illegalIcon_mc.x = ((_arg_8) ? -(_local_14) : _local_14);
		}
		;
		this.m_view.prompt_mc.label_txt.autoSize = ((_arg_8) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.RIGHT);
		this.m_view.prompt_mc.desc_txt.autoSize = ((_arg_8) ? TextFieldAutoSize.LEFT : TextFieldAutoSize.RIGHT);
		this.m_promptImage.platform = ControlsMain.getControllerType();
		this.m_view.promptHolder_mc.scaleX = (this.m_view.promptHolder_mc.scaleY = ((this.m_promptImage.platform == "key") ? 0.8 : 1));
		if (_arg_1 != -1) {
			this.m_promptImage.button = _arg_1;
		} else {
			this.m_promptImage.customKey = _arg_4;
		}
		;
		var _local_9:String = _arg_2.toUpperCase();
		if (_local_9 != this.m_sLabelCurrent) {
			this.m_view.prompt_mc.label_txt.htmlText = _local_9;
			this.m_sLabelCurrent = _local_9;
		}
		;
		_arg_3 = StringUtil.trim(_arg_3);
		var _local_10:Object = MenuConstants.InteractionIndicatorFontSpecs[this.m_nFontSizeCurrent];
		if (((_arg_3) && (_arg_3.length > 0))) {
			this.m_view.prompt_mc.desc_txt.visible = true;
			_local_15 = _arg_3.toUpperCase();
			if (_local_15 != this.m_sDescriptionCurrent) {
				this.m_view.prompt_mc.desc_txt.htmlText = _local_15;
				this.m_sDescriptionCurrent = _local_15;
			}
			;
			this.m_view.prompt_mc.label_txt.y = _local_10.yOffsetLabel;
			this.m_view.prompt_mc.desc_txt.y = _local_10.yOffsetDesc;
		} else {
			this.m_view.prompt_mc.desc_txt.visible = false;
			this.m_view.prompt_mc.desc_txt.text = "";
			this.m_sDescriptionCurrent = "";
			this.m_view.prompt_mc.label_txt.y = _local_10.yOffsetLabelSolo;
		}
		;
		if (_arg_2 == "") {
			this.m_view.illegalIcon_mc.visible = false;
		} else {
			if (_arg_7) {
				this.m_view.illegalIcon_mc.visible = true;
				this.m_view.illegalIcon_mc.gotoAndStop("susarmed");
			} else {
				if (((_arg_6) || (_arg_5))) {
					this.m_view.illegalIcon_mc.visible = true;
					this.m_view.illegalIcon_mc.gotoAndStop("visarmed");
				} else {
					this.m_view.illegalIcon_mc.visible = false;
				}
				;
			}
			;
		}
		;
		var _local_11:int = ((this.m_view.hold_mc.visible) ? -3 : -7);
		if (_arg_8) {
			this.m_view.prompt_mc.label_txt.x = (-(_local_11) - this.m_view.prompt_mc.label_txt.width);
			this.m_view.prompt_mc.desc_txt.x = (-(_local_11) - this.m_view.prompt_mc.desc_txt.width);
		} else {
			this.m_view.prompt_mc.label_txt.x = _local_11;
			this.m_view.prompt_mc.desc_txt.x = _local_11;
		}
		;
	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		this.m_viewportScale = Math.min(_arg_1, _arg_2);
		this.updateScale();
	}

	private function updateScale():void {
		var _local_1:Boolean = ((!(ControlsMain.isVrModeActive())) && (ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL));
		var _local_2:Number = ((_local_1) ? 1.25 : 1);
		var _local_3:Object = MenuConstants.InteractionIndicatorFontSpecs[this.m_nFontSizeCurrent];
		this.m_view.scaleX = (((this.m_viewportScale * _local_2) * _local_3.fScaleGroup) * _local_3.fScaleIndividual);
		this.m_view.scaleY = (((this.m_viewportScale * _local_2) * _local_3.fScaleGroup) * _local_3.fScaleIndividual);
	}


}
}//package hud

