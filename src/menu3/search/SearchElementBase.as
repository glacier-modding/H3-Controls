// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.search.SearchElementBase

package menu3.search {
import menu3.MenuElementBase;

import common.Log;
import common.MouseUtil;
import common.Animate;

import flash.text.TextField;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.CommonUtils;
import common.menu.textTicker;

public dynamic class SearchElementBase extends MenuElementBase {

	protected const STATE_NONE:int = 0;
	protected const STATE_SELECT:int = 1;
	protected const STATE_ACTIVE:int = 2;
	protected const STATE_ACTIVE_SELECT:int = 3;
	protected const STATE_DISABLED:int = 4;

	protected var m_view:* = null;
	private var m_textTickerObjs:Array = new Array();
	protected var m_isSelected:Boolean = false;

	public function SearchElementBase(_arg_1:Object) {
		super(_arg_1);
		this.m_view = this.createPrivateView();
		if (this.m_view != null) {
			addChild(this.m_view);
		} else {
			Log.error(Log.ChannelDebug, this, "createPrivateView returned null!");
		}
		;
		m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.setupTitleTextField(((_arg_1.title) ? _arg_1.title : ""));
		this.setState(this.STATE_NONE);
	}

	public function setItemSelected(_arg_1:Boolean):void {
		if (this.m_isSelected == _arg_1) {
			return;
		}
		;
		this.m_isSelected = _arg_1;
		Animate.kill(this.m_view.tileHoverMc);
		if (this.m_isSelected) {
			this.callTextTicker(true);
		} else {
			this.callTextTicker(false);
		}
		;
		this.updateState();
	}

	protected function updateState():void {
		if (this.m_isSelected) {
			this.setState(this.STATE_SELECT);
		} else {
			this.setState(this.STATE_NONE);
		}
		;
	}

	protected function createPrivateView():* {
		return (null);
	}

	protected function getPrivateView():* {
		return (this.m_view);
	}

	protected function get TitleTextField():TextField {
		return (this.m_view.label_txt);
	}

	protected function setState(_arg_1:int):void {
		this.changeTextColor(MenuConstants.COLOR_WHITE);
		this.m_view.tileSelectPulsate.alpha = false;
		this.m_view.tileBgMc.visible = false;
		this.m_view.tileHoverMc.visible = false;
		m_mouseMode = MouseUtil.MODE_ONOVER_SELECT_ONUP_CLICK;
		this.changeTextColor(MenuConstants.COLOR_WHITE);
		if (_arg_1 == this.STATE_NONE) {
			this.m_view.tileSelectMc.visible = false;
		} else {
			if (((_arg_1 == this.STATE_SELECT) || (_arg_1 == this.STATE_ACTIVE_SELECT))) {
				this.m_view.tileSelectMc.alpha = 1;
				this.m_view.tileSelectMc.visible = true;
				MenuUtils.setColor(this.m_view.tileSelectMc, MenuConstants.COLOR_RED, false);
			} else {
				if (_arg_1 == this.STATE_ACTIVE) {
					this.m_view.tileSelectMc.alpha = 1;
					this.m_view.tileSelectMc.visible = true;
					this.changeTextColor(MenuConstants.COLOR_WHITE);
					MenuUtils.setColor(this.m_view.tileSelectMc, MenuConstants.COLOR_MENU_CONTRACT_SEARCH_GREY, false);
				} else {
					if (_arg_1 == this.STATE_DISABLED) {
						m_mouseMode = MouseUtil.MODE_ONOVER_HOVER_ONUP_SELECT;
						this.m_view.tileSelectMc.visible = false;
						this.changeTextColor(MenuConstants.COLOR_GREY_MEDIUM);
					}
					;
				}
				;
			}
			;
		}
		;
	}

	protected function setupTitleTextField(_arg_1:String):void {
		this.setupTextField(this.TitleTextField, _arg_1);
	}

	protected function setupTextField(_arg_1:TextField, _arg_2:String, _arg_3:String = "#464646"):void {
		MenuUtils.setupText(_arg_1, _arg_2, 18, MenuConstants.FONT_TYPE_MEDIUM, _arg_3);
		CommonUtils.changeFontToGlobalIfNeeded(_arg_1);
		var _local_4:Object = new Object();
		_local_4.title = _arg_1.htmlText;
		_local_4.textField = _arg_1;
		_local_4.ticker = new textTicker();
		MenuUtils.truncateTextfield(_arg_1, 1);
		this.m_textTickerObjs.push(_local_4);
	}

	protected function changeTextColor(_arg_1:int):void {
		var _local_2:int;
		while (_local_2 < this.m_textTickerObjs.length) {
			this.m_textTickerObjs[_local_2].textField.textColor = _arg_1;
			this.m_textTickerObjs[_local_2].ticker.setTextColor(_arg_1);
			_local_2++;
		}
		;
	}

	override public function onUnregister():void {
		var _local_2:Object;
		var _local_1:int;
		while (_local_1 < this.m_textTickerObjs.length) {
			_local_2 = this.m_textTickerObjs[_local_1];
			_local_2.ticker.stopTextTicker(_local_2.textField, _local_2.title);
			_local_2.ticker = null;
			_local_2.textField = null;
			_local_1++;
		}
		;
		this.m_textTickerObjs.length = 0;
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
		super.onUnregister();
	}

	private function callTextTicker(_arg_1:Boolean):void {
		var _local_3:Object;
		var _local_2:int;
		while (_local_2 < this.m_textTickerObjs.length) {
			_local_3 = this.m_textTickerObjs[_local_2];
			if (_arg_1) {
				_local_3.ticker.startTextTickerHtml(_local_3.textField, _local_3.title);
			} else {
				_local_3.ticker.stopTextTicker(_local_3.textField, _local_3.title);
				_local_3.textField.htmlText = _local_3.title;
				MenuUtils.truncateTextfield(_local_3.textField, 1);
			}
			;
			_local_2++;
		}
		;
	}


}
}//package menu3.search

