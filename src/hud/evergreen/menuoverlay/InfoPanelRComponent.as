// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.menuoverlay.InfoPanelRComponent

package hud.evergreen.menuoverlay {
import flash.display.Sprite;

import hud.evergreen.IMenuOverlayComponent;

import flash.display.Shape;
import flash.text.TextField;

import basic.DottedLine;

import common.menu.MenuConstants;
import common.menu.MenuUtils;

import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import common.CommonUtils;

import hud.evergreen.EvergreenUtils;

import common.Animate;

public class InfoPanelRComponent extends Sprite implements IMenuOverlayComponent {

	public static const PXMARGINBOTTOM:Number = 0;
	public static const PXPADDING:Number = 25;
	public static const PXGAPBETWEENICONANDTITLE:Number = 12;
	public static const PXICONSIZE:Number = 50;
	public static const PXCONTENTWIDTH:Number = 598;
	public static const PXGAPBETWEENLABELS:Number = 8;

	private var m_background:Shape = new Shape();
	private var m_contentMask:Shape = new Shape();
	private var m_content:Sprite = new Sprite();
	private var m_icon:iconsAll76x76View = new iconsAll76x76View();
	private var m_title_txt:TextField = new TextField();
	private var m_header_txt:TextField = new TextField();
	private var m_descr_txt:TextField = new TextField();
	private var m_perksHolder:Sprite = new Sprite();
	private var m_labelsHolder:Sprite = new Sprite();
	private var m_headlineSeparator:DottedLine = new DottedLine(PXCONTENTWIDTH, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
	private var m_perkSeparator:DottedLine = new DottedLine(PXCONTENTWIDTH, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
	private var m_labelSeparator:DottedLine = new DottedLine(PXCONTENTWIDTH, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
	private var m_yTop:Number = 0;
	private var m_yBottom:Number = 0;
	private var m_isEmpty:Boolean = true;

	public function InfoPanelRComponent() {
		this.m_background.name = "m_background";
		this.m_background.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, 0.85);
		this.m_background.graphics.drawRect(0, 0, (PXCONTENTWIDTH + (2 * PXPADDING)), 25);
		this.m_background.graphics.endFill();
		addChild(this.m_background);
		this.m_contentMask.name = "m_contentMask";
		this.m_contentMask.graphics.beginFill(0xFF);
		this.m_contentMask.graphics.drawRect(0, 0, (PXCONTENTWIDTH + (2 * PXPADDING)), 25);
		this.m_contentMask.graphics.endFill();
		addChild(this.m_contentMask);
		this.m_content.name = "m_content";
		addChild(this.m_content);
		this.m_content.x = -(PXCONTENTWIDTH + PXPADDING);
		this.m_contentMask.x = -(PXCONTENTWIDTH + (PXPADDING * 2));
		this.m_background.x = -(PXCONTENTWIDTH + (PXPADDING * 2));
		this.m_content.mask = this.m_contentMask;
		this.m_content.alpha = 0;
		this.m_contentMask.height = 1;
		this.m_background.height = 1;
		this.m_icon.name = "m_icon";
		this.m_title_txt.name = "m_title_txt";
		this.m_header_txt.name = "m_header_txt";
		this.m_headlineSeparator.name = "m_headlineSeparator";
		this.m_descr_txt.name = "m_descr_txt";
		this.m_perkSeparator.name = "m_perkSeparator";
		this.m_perksHolder.name = "m_perksHolder";
		this.m_labelSeparator.name = "m_labelSeparator";
		this.m_labelsHolder.name = "m_labelsHolder";
		this.m_content.addChild(this.m_icon);
		this.m_content.addChild(this.m_title_txt);
		this.m_content.addChild(this.m_header_txt);
		this.m_content.addChild(this.m_headlineSeparator);
		this.m_content.addChild(this.m_descr_txt);
		this.m_content.addChild(this.m_perkSeparator);
		this.m_content.addChild(this.m_perksHolder);
		this.m_content.addChild(this.m_labelSeparator);
		this.m_content.addChild(this.m_labelsHolder);
		this.m_icon.scaleX = (PXICONSIZE / 76);
		this.m_icon.scaleY = (PXICONSIZE / 76);
		this.m_icon.x = (PXICONSIZE / 2);
		this.m_icon.y = (PXICONSIZE / 2);
		MenuUtils.setupText(this.m_title_txt, "", 30, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_header_txt, "", 16, MenuConstants.FONT_TYPE_LIGHT, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_descr_txt, "", 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.m_title_txt.width = ((PXCONTENTWIDTH - PXICONSIZE) - PXGAPBETWEENICONANDTITLE);
		this.m_header_txt.width = ((PXCONTENTWIDTH - PXICONSIZE) - PXGAPBETWEENICONANDTITLE);
		this.m_descr_txt.width = PXCONTENTWIDTH;
		this.m_descr_txt.multiline = true;
		this.m_descr_txt.wordWrap = true;
		this.m_descr_txt.autoSize = TextFieldAutoSize.LEFT;
		var _local_1:TextFormat = this.m_descr_txt.defaultTextFormat;
		_local_1.align = TextFormatAlign.JUSTIFY;
		this.m_descr_txt.defaultTextFormat = _local_1;
	}

	public function isLeftAligned():Boolean {
		return (false);
	}

	public function onControlLayoutChanged():void {
	}

	public function onUsableSizeChanged(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		this.m_yTop = _arg_2;
		this.m_yBottom = _arg_3;
		this.updateLayout();
	}

	public function onSetData(_arg_1:Object):void {
		var _local_9:ModalItemPerkView;
		var _local_10:ModalDialogItemDetailsKilltypeView;
		var _local_11:ModalDialogItemDetailsPoisonTypeView;
		if ((((_arg_1 == null) || (_arg_1.icon == null)) || (_arg_1.icon == ""))) {
			this.m_icon.visible = false;
		} else {
			this.m_icon.visible = true;
			MenuUtils.setupIcon(this.m_icon, _arg_1.icon, MenuConstants.COLOR_WHITE, true, false, 0xFFFFFF, 0, 0, false);
		}

		if ((((_arg_1 == null) || (_arg_1.lstrTitle == null)) || (_arg_1.lstrTitle == ""))) {
			this.m_title_txt.visible = false;
			this.m_title_txt.text = "";
		} else {
			this.m_title_txt.visible = true;
			this.m_title_txt.text = _arg_1.lstrTitle.toUpperCase();
			MenuUtils.truncateTextfield(this.m_title_txt, 1, MenuConstants.FontColorWhite);
		}

		if ((((_arg_1 == null) || (_arg_1.lstrHeader == null)) || (_arg_1.lstrHeader == ""))) {
			this.m_header_txt.visible = false;
			this.m_header_txt.text = "";
		} else {
			this.m_header_txt.visible = true;
			this.m_header_txt.text = _arg_1.lstrHeader.toUpperCase();
		}

		if ((((_arg_1 == null) || (_arg_1.lstrDescription == null)) || (_arg_1.lstrDescription == ""))) {
			this.m_descr_txt.visible = false;
			this.m_descr_txt.text = "";
		} else {
			this.m_descr_txt.visible = true;
			this.m_descr_txt.text = _arg_1.lstrDescription;
			CommonUtils.changeFontToGlobalIfNeeded(this.m_descr_txt);
		}

		var _local_2:int = (((_arg_1 == null) || (_arg_1.perks == null)) ? 0 : _arg_1.perks.length);
		while (this.m_perksHolder.numChildren > _local_2) {
			this.m_perksHolder.removeChildAt((this.m_perksHolder.numChildren - 1));
		}

		while (this.m_perksHolder.numChildren < _local_2) {
			this.m_perksHolder.addChild(new ModalItemPerkView());
		}

		var _local_3:Number = 0;
		var _local_4:Number = 0;
		var _local_5:Boolean = true;
		var _local_6:int;
		while (_local_6 < _local_2) {
			_local_9 = ModalItemPerkView(this.m_perksHolder.getChildAt(_local_6));
			_local_9.scaleX = 0.9;
			_local_9.scaleY = 0.9;
			MenuUtils.setupIcon(_local_9.icon, _arg_1.perks[_local_6].icon, MenuConstants.COLOR_WHITE, true, (!(_arg_1.perks[_local_6].purposeColorTint == EvergreenUtils.LABELPURPOSE_NONE)), EvergreenUtils.LABELBGCOLOR[_arg_1.perks[_local_6].purposeColorTint], 1, 0, false);
			MenuUtils.setupText(_local_9.header, _arg_1.perks[_local_6].lstrTitle, 21, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			MenuUtils.setupText(_local_9.description, _arg_1.perks[_local_6].lstrDescription, 17, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			_local_9.description.autoSize = TextFieldAutoSize.LEFT;
			_local_9.description.width = ((((PXCONTENTWIDTH / 2) - (PXPADDING / 2)) / _local_9.scaleX) - _local_9.description.x);
			_local_9.y = _local_3;
			_local_4 = Math.max(_local_4, _local_9.height);
			if (_local_5) {
				_local_9.x = 0;
			} else {
				_local_9.x = ((PXCONTENTWIDTH / 2) + (PXPADDING / 2));
				_local_3 = (_local_3 + (_local_4 + PXPADDING));
				_local_4 = 0;
			}

			_local_5 = (!(_local_5));
			_local_6++;
		}

		var _local_7:int = (((_arg_1 == null) || (_arg_1.labels == null)) ? 0 : _arg_1.labels.length);
		while (this.m_labelsHolder.numChildren > 0) {
			this.m_labelsHolder.removeChildAt((this.m_labelsHolder.numChildren - 1));
		}

		var _local_8:Number = 0;
		_local_6 = 0;
		while (_local_6 < _local_7) {
			switch (_arg_1.labels[_local_6].purpose) {
				case EvergreenUtils.LABELPURPOSE_ACTION_KILL_TYPE:
				case EvergreenUtils.LABELPURPOSE_LOSE_ON_WOUNDED:
					_local_10 = new ModalDialogItemDetailsKilltypeView();
					_local_10.label_txt.text = _arg_1.labels[_local_6].lstrTitle;
					_local_10.label_txt.autoSize = TextFieldAutoSize.LEFT;
					_local_10.back_mc.width = (Math.ceil(_local_10.label_txt.textWidth) + 18);
					_local_10.x = _local_8;
					_local_8 = (_local_8 + (_local_10.back_mc.width + PXGAPBETWEENLABELS));
					this.m_labelsHolder.addChild(_local_10);
					break;
				case EvergreenUtils.LABELPURPOSE_POISON_LETHAL:
				case EvergreenUtils.LABELPURPOSE_POISON_EMETIC:
				case EvergreenUtils.LABELPURPOSE_POISON_SEDATIVE:
					_local_11 = new ModalDialogItemDetailsPoisonTypeView();
					MenuUtils.setupText(_local_11.label_txt, _arg_1.labels[_local_6].lstrTitle, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					_local_11.label_txt.autoSize = TextFieldAutoSize.LEFT;
					_local_11.back_mc.gotoAndStop(((_arg_1.labels[_local_6].purpose == EvergreenUtils.LABELPURPOSE_POISON_LETHAL) ? 1 : ((_arg_1.labels[_local_6].purpose == EvergreenUtils.LABELPURPOSE_POISON_SEDATIVE) ? 2 : 3)));
					_local_11.back_mc.width = (Math.ceil(_local_11.label_txt.textWidth) + 18);
					_local_11.x = _local_8;
					_local_8 = (_local_8 + (_local_11.back_mc.width + PXGAPBETWEENLABELS));
					this.m_labelsHolder.addChild(_local_11);
					break;
			}

			_local_6++;
		}

		this.updateLayout();
	}

	private function updateLayout():void {
		var yContent:Number;
		var yBackground:Number;
		var yContentMask:Number;
		Animate.kill(this.m_content);
		Animate.kill(this.m_background);
		Animate.kill(this.m_contentMask);
		var dxIconOffset:Number = ((this.m_icon.visible) ? (PXICONSIZE + PXGAPBETWEENICONANDTITLE) : 0);
		this.m_title_txt.x = dxIconOffset;
		this.m_header_txt.x = dxIconOffset;
		var yLayout:Number = 0;
		if (this.m_header_txt.visible) {
			this.m_header_txt.y = (yLayout - 2);
			this.m_title_txt.y = (((this.m_icon.y + (PXICONSIZE / 2)) - this.m_title_txt.textHeight) + 2);
		} else {
			this.m_title_txt.y = ((yLayout + (PXICONSIZE / 2)) - (this.m_title_txt.textHeight / 2));
		}

		yLayout = (yLayout + PXICONSIZE);
		if (!this.m_descr_txt.visible) {
			this.m_headlineSeparator.visible = false;
		} else {
			yLayout = (yLayout + PXPADDING);
			this.m_headlineSeparator.visible = true;
			this.m_headlineSeparator.y = yLayout;
			yLayout = (yLayout + PXPADDING);
			this.m_descr_txt.y = yLayout;
			yLayout = (yLayout + this.m_descr_txt.textHeight);
		}

		if (this.m_perksHolder.numChildren == 0) {
			this.m_perkSeparator.visible = false;
		} else {
			yLayout = (yLayout + PXPADDING);
			this.m_perkSeparator.visible = true;
			this.m_perkSeparator.y = yLayout;
			yLayout = (yLayout + PXPADDING);
			this.m_perksHolder.y = yLayout;
			yLayout = (yLayout + this.m_perksHolder.height);
		}

		if (this.m_labelsHolder.numChildren == 0) {
			this.m_labelSeparator.visible = false;
		} else {
			yLayout = (yLayout + PXPADDING);
			this.m_labelSeparator.visible = true;
			this.m_labelSeparator.y = yLayout;
			yLayout = (yLayout + PXPADDING);
			this.m_labelsHolder.y = yLayout;
			yLayout = (yLayout + this.m_labelsHolder.height);
		}

		var wasEmpty:Boolean = this.m_isEmpty;
		this.m_isEmpty = (((((!(this.m_icon.visible)) && (!(this.m_title_txt.visible))) && (!(this.m_header_txt.visible))) && (!(this.m_descr_txt.visible))) && (this.m_perksHolder.numChildren == 0));
		if (this.m_isEmpty) {
			Animate.to(this.m_content, 0.1, 0, {"alpha": 0}, Animate.SineOut);
			Animate.to(this.m_background, 0.1, 0, {"height": 1}, Animate.SineOut, function ():void {
				m_background.visible = false;
			});
			Animate.to(this.m_contentMask, 0.1, 0, {"height": 1}, Animate.SineOut);
		} else {
			this.m_background.visible = true;
			Animate.to(this.m_content, 0.1, 0.1, {"alpha": 1}, Animate.SineOut);
			Animate.to(this.m_background, 0.1, 0, {"height": (yLayout + (2 * PXPADDING))}, Animate.SineOut);
			Animate.to(this.m_contentMask, 0.1, 0, {"height": (yLayout + (1.5 * PXPADDING))}, Animate.SineOut);
		}

		if (!this.m_isEmpty) {
			yContent = (((this.m_yBottom - PXMARGINBOTTOM) - yLayout) - PXPADDING);
			yBackground = (((this.m_yBottom - PXMARGINBOTTOM) - yLayout) - (2 * PXPADDING));
			yContentMask = (((this.m_yBottom - PXMARGINBOTTOM) - yLayout) - (1.75 * PXPADDING));
			if (wasEmpty) {
				this.m_content.y = yContent;
				this.m_background.y = yBackground;
				this.m_contentMask.y = yContentMask;
			} else {
				Animate.addTo(this.m_content, 0.1, 0, {"y": yContent}, Animate.SineOut);
				Animate.addTo(this.m_background, 0.1, 0, {"y": yBackground}, Animate.SineOut);
				Animate.addTo(this.m_contentMask, 0.1, 0, {"y": yContentMask}, Animate.SineOut);
			}

		}

	}


}
}//package hud.evergreen.menuoverlay

