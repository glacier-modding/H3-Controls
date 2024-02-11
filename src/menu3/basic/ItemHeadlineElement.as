// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ItemHeadlineElement

package menu3.basic {
import menu3.MenuElementBase;

import common.menu.textTicker;

import flash.display.DisplayObject;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import hud.evergreen.EvergreenUtils;

import flash.display.MovieClip;

public dynamic class ItemHeadlineElement extends MenuElementBase {

	private static const PADDING:Number = 7;

	private var m_view:ItemHeadlineElementView;
	private var m_textObj:Object = new Object();
	private var m_textTicker:textTicker;
	private var m_perkElements:Array = [];
	private var m_evergreenRarityLabel:DisplayObject;

	public function ItemHeadlineElement(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ItemHeadlineElementView();
		MenuUtils.addDropShadowFilter(this.m_view.typeIcon);
		MenuUtils.addDropShadowFilter(this.m_view.header);
		MenuUtils.addDropShadowFilter(this.m_view.title);
		MenuUtils.addDropShadowFilter(this.m_view.rarityIcon);
		this.m_view.typeIcon.visible = false;
		var _local_2:String = _arg_1.typeicon;
		if (_local_2 == null) {
			_local_2 = _arg_1.icon;
		}
		;
		if (_local_2 != null) {
			this.m_view.typeIcon.visible = true;
			MenuUtils.setupIcon(this.m_view.typeIcon, _local_2, MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
		}
		;
		this.m_view.rarityIcon.visible = false;
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		if (((_arg_1.typeicon) || (_arg_1.icon))) {
			this.m_view.typeIcon.visible = true;
		}
		;
		var _local_2:Number = (this.m_view.rarityIcon.x - (this.m_view.rarityIcon.width / 2));
		var _local_3:Number = this.m_view.rarityIcon.y;
		var _local_4:Array = _arg_1.perks;
		if (((_local_4 == null) || (_local_4[0] == "NONE"))) {
			_local_4 = [];
		}
		;
		if (_arg_1.currentContractType == "evergreen") {
			if (_arg_1.evergreenCapacityCost > 0) {
				_local_4.unshift(("evergreen_gearcost_" + _arg_1.evergreenCapacityCost.toString()));
			}
			;
			if (((!(_arg_1.evergreenRarity == null)) && (EvergreenUtils.isValidRarityLabel(_arg_1.evergreenRarity)))) {
				this.m_evergreenRarityLabel = EvergreenUtils.createRarityLabel(_arg_1.evergreenRarity);
				this.m_evergreenRarityLabel.height = 30;
				this.m_evergreenRarityLabel.scaleX = this.m_evergreenRarityLabel.scaleY;
				this.m_evergreenRarityLabel.x = (_local_2 + (this.m_evergreenRarityLabel.width / 2));
				this.m_evergreenRarityLabel.y = _local_3;
				this.m_view.addChild(this.m_evergreenRarityLabel);
				_local_2 = (_local_2 + (this.m_evergreenRarityLabel.width + PADDING));
			}
			;
		}
		;
		_local_2 = this.setupPerks(_local_2, _local_3, _local_4);
		this.setupTextFields(_arg_1.header, _arg_1.title);
	}

	private function setupPerks(_arg_1:Number, _arg_2:Number, _arg_3:Array):Number {
		var _local_5:MovieClip;
		var _local_4:int = _arg_3.length;
		this.m_perkElements = [];
		var _local_6:int;
		while (_local_6 < _local_4) {
			_local_5 = new iconsAll76x76View();
			MenuUtils.setupIcon(_local_5, _arg_3[_local_6], MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE, 1);
			_local_5.width = (_local_5.height = 30);
			_local_5.x = (_arg_1 + (_local_5.width >> 1));
			_local_5.y = _arg_2;
			_arg_1 = (_arg_1 + (_local_5.width + PADDING));
			this.m_perkElements[_local_6] = _local_5;
			this.m_view.addChild(_local_5);
			_local_6++;
		}
		;
		return (_arg_1);
	}

	private function setupTextFields(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextUpper(this.m_view.header, _arg_1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupTextUpper(this.m_view.title, _arg_2, 54, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_textObj.header = this.m_view.header.htmlText;
		this.m_textObj.title = this.m_view.title.htmlText;
		MenuUtils.truncateTextfield(this.m_view.header, 1, null);
		MenuUtils.truncateTextfield(this.m_view.title, 1, null);
		this.callTextTicker(true);
	}

	private function callTextTicker(_arg_1:Boolean):void {
		if (!this.m_textTicker) {
			this.m_textTicker = new textTicker();
		}
		;
		if (_arg_1) {
			this.m_textTicker.startTextTickerHtml(this.m_view.title, this.m_textObj.title);
		} else {
			this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
			MenuUtils.truncateTextfield(this.m_view.title, 1, null);
		}
		;
	}

	override public function onUnregister():void {
		var _local_1:int;
		if (this.m_view) {
			if (this.m_textTicker) {
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				this.m_textTicker = null;
			}
			;
			if (this.m_evergreenRarityLabel != null) {
				this.m_view.removeChild(this.m_evergreenRarityLabel);
				this.m_evergreenRarityLabel = null;
			}
			;
			if (this.m_perkElements.length > 0) {
				_local_1 = 0;
				while (_local_1 < this.m_perkElements.length) {
					this.m_view.removeChild(this.m_perkElements[_local_1]);
					this.m_perkElements[_local_1] = null;
					_local_1++;
				}
				;
				this.m_perkElements = [];
			}
			;
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}


}
}//package menu3.basic

