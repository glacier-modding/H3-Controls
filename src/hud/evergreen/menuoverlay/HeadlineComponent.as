// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.menuoverlay.HeadlineComponent

package hud.evergreen.menuoverlay {
import flash.display.Sprite;

import hud.evergreen.IMenuOverlayComponent;

import flash.display.Shape;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.Animate;

public class HeadlineComponent extends Sprite implements IMenuOverlayComponent {

	public static const PXPADDING:Number = 25;
	public static const DYMARGINBOTTOM:Number = 90;

	private var m_background:Shape = new Shape();
	private var m_content:Sprite = new Sprite();
	private var m_titleRow:TitleRow = new TitleRow();
	private var m_microRow:MicroRow = new MicroRow();
	private var m_yBottom:Number = 0;
	private var m_isTitleRowVisible:Boolean = false;
	private var m_isMicroRowVisible:Boolean = false;
	private var m_isEmpty:Boolean = true;

	public function HeadlineComponent() {
		this.m_background.name = "m_background";
		this.m_background.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, 0.85);
		this.m_background.graphics.drawRect(0, 0, 25, 25);
		this.m_background.graphics.endFill();
		addChild(this.m_background);
		this.m_content.name = "m_content";
		MenuUtils.addDropShadowFilter(this.m_content);
		addChild(this.m_content);
		this.m_titleRow.name = "m_titleRow";
		this.m_microRow.name = "m_microRow";
		this.m_content.addChild(this.m_titleRow);
		this.m_content.addChild(this.m_microRow);
		this.m_content.x = PXPADDING;
	}

	public function isLeftAligned():Boolean {
		return (true);
	}

	public function onControlLayoutChanged():void {
	}

	public function onUsableSizeChanged(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		this.m_yBottom = _arg_3;
		this.m_content.y = ((_arg_3 - DYMARGINBOTTOM) - PXPADDING);
		this.updateLayout();
	}

	public function onSetData(_arg_1:Object):void {
		this.m_titleRow.onSetData(_arg_1);
		this.m_microRow.onSetData(_arg_1);
		this.updateLayout();
	}

	private function updateLayout():void {
		var y:Number;
		var dyGapLastUsed:Number;
		var dyBackgroundHeight:Number;
		var wasTitleRowVisible:Boolean = this.m_isTitleRowVisible;
		var wasMicroRowVisible:Boolean = this.m_isMicroRowVisible;
		var wasEmpty:Boolean = this.m_isEmpty;
		this.m_isTitleRowVisible = this.m_titleRow.visible;
		this.m_isMicroRowVisible = this.m_microRow.visible;
		this.m_isEmpty = ((!(this.m_isTitleRowVisible)) && (!(this.m_isMicroRowVisible)));
		if (this.m_isEmpty) {
			if (!wasEmpty) {
				Animate.to(this.m_background, 0.1, 0, {"width": 1}, Animate.SineOut, function ():void {
					m_background.visible = false;
				});
			}

		} else {
			y = 0;
			dyGapLastUsed = 0;
			if (this.m_isMicroRowVisible) {
				y = (y - MicroRow.PXMICROICONSIZE);
				this.m_microRow.y = y;
				this.m_microRow.x = 0;
				dyGapLastUsed = (PXPADDING * MicroRow.MICROICONSCALE);
				y = (y - dyGapLastUsed);
			}

			if (this.m_isTitleRowVisible) {
				this.m_microRow.x = (this.m_titleRow.dxIconOffset + 4);
				y = (y - TitleRow.PXICONSIZE);
				if (!wasTitleRowVisible) {
					this.m_titleRow.y = y;
				} else {
					Animate.to(this.m_titleRow, 0.1, 0, {"y": y}, Animate.SineOut);
				}

				dyGapLastUsed = PXPADDING;
				y = (y - dyGapLastUsed);
			}

			y = (y + dyGapLastUsed);
			this.m_background.visible = true;
			Animate.to(this.m_background, 0.1, 0, {"width": (Math.max(this.m_titleRow.dxTotalWidth, (this.m_microRow.x + this.m_microRow.dxTotalWidth)) + (2 * PXPADDING))}, Animate.SineOut);
			dyBackgroundHeight = (Math.abs(y) + (2 * PXPADDING));
			if (wasEmpty) {
				this.m_background.y = ((this.m_yBottom - DYMARGINBOTTOM) - dyBackgroundHeight);
				this.m_background.height = dyBackgroundHeight;
			} else {
				Animate.addTo(this.m_background, 0.1, 0, {
					"y": ((this.m_yBottom - DYMARGINBOTTOM) - dyBackgroundHeight),
					"height": dyBackgroundHeight
				}, Animate.SineOut);
			}

		}

	}


}
}//package hud.evergreen.menuoverlay

import flash.display.Sprite;
import flash.text.TextField;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.text.TextFieldAutoSize;
import flash.display.Shape;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.geom.ColorTransform;

import hud.evergreen.EvergreenUtils;

import common.Animate;

class TitleRow extends Sprite {

	public static const PXICONSIZE:Number = 50;
	public static const PXGAPBETWEENICONANDTITLE:Number = 12;

	/*private*/
	var m_title_txt:TextField = new TextField();
	/*private*/
	var m_header_txt:TextField = new TextField();
	/*private*/
	var m_icon:iconsAll76x76View = new iconsAll76x76View();
	/*private*/
	var m_dxIconOffset:Number = 0;

	public function TitleRow() {
		this.m_title_txt.name = "m_title_txt";
		this.m_header_txt.name = "m_header_txt";
		this.m_icon.name = "m_icon";
		MenuUtils.setupText(this.m_title_txt, "", 30, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_header_txt, "", 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_title_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_header_txt.autoSize = TextFieldAutoSize.LEFT;
		addChild(this.m_title_txt);
		addChild(this.m_header_txt);
		addChild(this.m_icon);
		this.m_icon.scaleX = (PXICONSIZE / 76);
		this.m_icon.scaleY = (PXICONSIZE / 76);
		this.m_icon.x = (PXICONSIZE / 2);
		this.m_icon.y = (PXICONSIZE / 2);
	}

	public function get dxIconOffset():Number {
		return (this.m_dxIconOffset);
	}

	public function get dxTotalWidth():Number {
		return (Math.max((this.m_dxIconOffset + Math.max(this.m_title_txt.textWidth, this.m_header_txt.textWidth))));
	}

	public function onSetData(_arg_1:Object):void {
		if ((((_arg_1 == null) || (_arg_1.lstrTitle == null)) || (_arg_1.lstrTitle == ""))) {
			this.m_title_txt.visible = false;
			this.m_title_txt.text = "";
		} else {
			this.m_title_txt.visible = true;
			this.m_title_txt.text = _arg_1.lstrTitle.toUpperCase();
		}

		if ((((_arg_1 == null) || (_arg_1.lstrHeader == null)) || (_arg_1.lstrHeader == ""))) {
			this.m_header_txt.visible = false;
			this.m_header_txt.text = "";
		} else {
			this.m_header_txt.visible = true;
			this.m_header_txt.text = _arg_1.lstrHeader.toUpperCase();
		}

		if ((((_arg_1 == null) || (_arg_1.icon == null)) || (_arg_1.icon == ""))) {
			this.m_icon.visible = false;
		} else {
			this.m_icon.visible = true;
			MenuUtils.setupIcon(this.m_icon, _arg_1.icon, MenuConstants.COLOR_WHITE, false, false, 0xFFFFFF, 0, 0, true);
		}

		if ((((!(this.m_title_txt.visible)) && (!(this.m_header_txt.visible))) && (!(this.m_icon.visible)))) {
			this.visible = false;
		} else {
			this.visible = true;
			this.m_dxIconOffset = ((this.m_icon.visible) ? (PXICONSIZE + PXGAPBETWEENICONANDTITLE) : 0);
			this.m_title_txt.x = this.m_dxIconOffset;
			this.m_header_txt.x = this.m_dxIconOffset;
			if (this.m_header_txt.visible) {
				this.m_header_txt.y = -2;
				this.m_title_txt.y = ((PXICONSIZE - this.m_title_txt.textHeight) + 2);
			} else {
				this.m_title_txt.y = ((PXICONSIZE / 2) - (this.m_title_txt.textHeight / 2));
			}

		}

	}


}

class MicroLabel extends Sprite {

	/*private*/
	var m_txt:TextField = new TextField();
	/*private*/
	var m_background:Shape = new Shape();

	public function MicroLabel() {
		this.m_txt.name = "m_txt";
		this.m_background.name = "m_background";
		addChild(this.m_background);
		addChild(this.m_txt);
		MenuUtils.setupText(this.m_txt, "", 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_txt.x = 5;
		this.m_txt.y = 2;
		this.m_background.graphics.lineStyle(6, 0x7F7F7F, 1, false, LineScaleMode.VERTICAL, CapsStyle.NONE, JointStyle.ROUND);
		this.m_background.graphics.beginFill(0x7F7F7F);
		this.m_background.graphics.drawRect(3, 3, 100, (25 - 6));
		this.m_background.graphics.endFill();
	}

	public function onSetData(_arg_1:int, _arg_2:String):void {
		this.m_txt.text = _arg_2.toUpperCase();
		this.m_background.width = ((5 + this.m_txt.textWidth) + 9);
		var _local_3:ColorTransform = this.m_background.transform.colorTransform;
		_local_3.color = EvergreenUtils.LABELBGCOLOR[_arg_1];
		this.m_background.transform.colorTransform = _local_3;
	}


}

class MicroRow extends Sprite {

	public static const PXMICROICONSIZE:Number = 25;
	public static const MICROICONSCALE:Number = (25 / 76);//0.328947368421053
	public static const PXPADDING:Number = (25 * MICROICONSCALE);//8.22368421052632

	/*private*/
	var m_labels:Sprite = new Sprite();
	/*private*/
	var m_microicons:Sprite = new Sprite();
	/*private*/
	var m_micromessage_txt:TextField = new TextField();
	/*private*/
	var m_dxTotalWidth:Number = 0;

	public function MicroRow() {
		this.m_labels.name = "m_labels";
		this.m_microicons.name = "m_microicons";
		this.m_micromessage_txt.name = "m_micromessage_txt";
		addChild(this.m_labels);
		addChild(this.m_microicons);
		addChild(this.m_micromessage_txt);
		this.m_microicons.scaleX = MICROICONSCALE;
		this.m_microicons.scaleY = MICROICONSCALE;
		MenuUtils.setupText(this.m_micromessage_txt, "", 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.m_micromessage_txt.autoSize = TextFieldAutoSize.LEFT;
		this.m_micromessage_txt.y = 2;
	}

	public function get dxTotalWidth():Number {
		return (this.m_dxTotalWidth);
	}

	public function onSetData(_arg_1:Object):void {
		var _local_8:MicroLabel;
		var _local_9:iconsAll76x76View;
		this.m_dxTotalWidth = 0;
		var _local_2:Number = 0;
		this.m_labels.x = this.m_dxTotalWidth;
		var _local_3:int = this.m_labels.numChildren;
		var _local_4:int = (((_arg_1 == null) || (_arg_1.labels == null)) ? 0 : _arg_1.labels.length);
		while (this.m_labels.numChildren > _local_4) {
			this.m_labels.removeChildAt((this.m_labels.numChildren - 1));
		}

		while (this.m_labels.numChildren < _local_4) {
			this.m_labels.addChild(new MicroLabel());
		}

		var _local_5:int;
		while (_local_5 < _local_4) {
			_local_8 = MicroLabel(this.m_labels.getChildAt(_local_5));
			_local_8.onSetData(_arg_1.labels[_local_5].purpose, _arg_1.labels[_local_5].lstrTitle);
			_local_2 = PXPADDING;
			this.m_dxTotalWidth = ((this.m_labels.x + (_local_8.x + _local_8.width)) + _local_2);
			_local_5++;
		}

		this.m_microicons.x = this.m_dxTotalWidth;
		var _local_6:int = this.m_microicons.numChildren;
		var _local_7:int = (((_arg_1 == null) || (_arg_1.microicons == null)) ? 0 : _arg_1.microicons.length);
		while (this.m_microicons.numChildren > _local_7) {
			this.m_microicons.removeChildAt((this.m_microicons.numChildren - 1));
		}

		while (this.m_microicons.numChildren < _local_7) {
			this.m_microicons.addChild(new iconsAll76x76View());
		}

		_local_5 = 0;
		while (_local_5 < _local_7) {
			_local_9 = iconsAll76x76View(this.m_microicons.getChildAt(_local_5));
			MenuUtils.setupIcon(_local_9, _arg_1.microicons[_local_5], MenuConstants.COLOR_WHITE, false, false, 0xFFFFFF, 0, 0, true);
			_local_9.x = ((76 / 2) + (_local_5 * (76 + (PXPADDING / MICROICONSCALE))));
			_local_9.y = (76 / 2);
			this.m_dxTotalWidth = (this.m_microicons.x + ((_local_9.x + (76 / 2)) * MICROICONSCALE));
			if (_local_6 == 0) {
				_local_9.scaleX = 0;
				_local_9.scaleY = 0;
				Animate.to(_local_9, 0.1, 0, {
					"scaleX": 1,
					"scaleY": 1
				}, Animate.SineOut);
			}

			_local_5++;
		}

		if (_local_7 > 0) {
			_local_2 = PXPADDING;
			this.m_dxTotalWidth = (this.m_dxTotalWidth + _local_2);
		}

		if ((((_arg_1 == null) || (_arg_1.lstrMicroMessage == null)) || (_arg_1.lstrMicroMessage == ""))) {
			this.m_micromessage_txt.visible = false;
			this.m_micromessage_txt.htmlText = "";
		} else {
			this.m_micromessage_txt.visible = true;
			this.m_micromessage_txt.htmlText = _arg_1.lstrMicroMessage.toUpperCase();
			this.m_micromessage_txt.x = this.m_dxTotalWidth;
			_local_2 = PXPADDING;
			this.m_dxTotalWidth = (this.m_dxTotalWidth + (this.m_micromessage_txt.textWidth + _local_2));
		}

		this.m_dxTotalWidth = (this.m_dxTotalWidth - _local_2);
		this.visible = ((_local_7 > 0) || (this.m_micromessage_txt.visible));
	}


}


