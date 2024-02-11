// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.Credits

package menu3 {
import common.ImageLoader;
import common.menu.MenuConstants;

import flash.text.TextField;

import common.menu.MenuUtils;

import flash.text.TextFieldAutoSize;
import flash.text.AntiAliasType;

public dynamic class Credits extends MenuElementBase {

	private var m_view:CreditsSectionView;
	private var m_loader:ImageLoader;
	private var COLOR_RED:String;
	private var COLOR_GREY_DARK:String;
	private var COLOR_WHITE:String;
	private var m_height:Number = 0;

	public function Credits(_arg_1:Object):void {
		super(_arg_1);
		this.COLOR_RED = MenuConstants.ColorString(MenuConstants.COLOR_RED);
		this.COLOR_GREY_DARK = MenuConstants.ColorString(MenuConstants.COLOR_GREY);
		this.COLOR_WHITE = MenuConstants.ColorString(MenuConstants.COLOR_GREY_ULTRA_LIGHT);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_2:TextField;
		var _local_3:int;
		var _local_4:int;
		var _local_5:int;
		var _local_6:int;
		var _local_7:int;
		super.onSetData(_arg_1);
		this.m_height = 100;
		if (_arg_1.subline != null) {
			_local_2 = new TextField();
			_local_2.width = 1065;
			_local_2.height = 20;
			MenuUtils.setupText(_local_2, _arg_1.subline, ((_arg_1.breadtext == true) ? 18 : 22), MenuConstants.FONT_TYPE_GLOBAL, this.COLOR_GREY_DARK);
			_local_2.multiline = true;
			_local_2.wordWrap = true;
			_local_2.autoSize = TextFieldAutoSize.LEFT;
			this.m_height = (this.m_height + _local_2.textHeight);
		}
		;
		if (_arg_1.images) {
			_local_3 = 100;
			if (_arg_1.subline) {
				_local_3 = (_local_3 + this.m_height);
			}
			;
			_local_4 = 0;
			while (_local_4 < _arg_1.images.length) {
				if (_arg_1.images[_local_4].paddingTop) {
					_local_3 = (_local_3 + _arg_1.images[_local_4].paddingTop);
				}
				;
				_local_3 = (_local_3 + (_arg_1.images[_local_4].height + 100));
				_local_4++;
			}
			;
			this.m_height = Math.max(this.m_height, _local_3);
		}
		;
		if (_arg_1.credits) {
			_local_5 = this.m_height;
			_local_6 = 0;
			while (_local_6 < _arg_1.credits.length) {
				_local_7 = 0;
				while (_local_7 < _arg_1.credits[_local_6].names.length) {
					_local_5 = (_local_5 + 25);
					_local_7++;
				}
				;
				_local_5 = (_local_5 + 30);
				_local_6++;
			}
			;
			this.m_height = Math.max(this.m_height, _local_5);
		}
		;
	}

	public function setCreditsVisible(_arg_1:Boolean):void {
		if (this.visible == _arg_1) {
			return;
		}
		;
		this.visible = _arg_1;
		if (!_arg_1) {
			removeChild(this.m_view);
			this.m_view = null;
		} else {
			this.createView();
		}
		;
	}

	private function createView():void {
		var _local_2:int;
		var _local_3:int;
		var _local_4:int;
		var _local_5:int;
		var _local_6:TextField;
		var _local_7:int;
		var _local_8:TextField;
		this.m_view = new CreditsSectionView();
		addChild(this.m_view);
		var _local_1:Object = getData();
		if (_local_1.redcategoryheadline == true) {
			MenuUtils.setupText(this.m_view.headline_txt, _local_1.headline, 36, MenuConstants.FONT_TYPE_GLOBAL, this.COLOR_RED);
			this.m_view.removeChild(this.m_view.titlesAndNames_mc);
		} else {
			MenuUtils.setupText(this.m_view.headline_txt, _local_1.headline, ((_local_1.smallerHeadline == true) ? 40 : 50), MenuConstants.FONT_TYPE_GLOBAL, this.COLOR_WHITE);
		}
		;
		if (_local_1.subline) {
			MenuUtils.setupText(this.m_view.subline_txt, _local_1.subline, ((_local_1.breadtext == true) ? 18 : 22), MenuConstants.FONT_TYPE_GLOBAL, this.COLOR_GREY_DARK);
			this.m_view.subline_txt.multiline = true;
			this.m_view.subline_txt.wordWrap = true;
			this.m_view.subline_txt.autoSize = TextFieldAutoSize.LEFT;
		} else {
			this.m_view.subline_txt.visible = false;
		}
		;
		this.m_view.separator_mc.visible = _local_1.separator;
		if (_local_1.images) {
			_local_2 = 100;
			if (_local_1.subline) {
				_local_2 = (_local_2 + this.m_view.subline_txt.height);
			}
			;
			_local_3 = 0;
			while (_local_3 < _local_1.images.length) {
				this.m_loader = new ImageLoader();
				this.m_loader.loadImage(_local_1.images[_local_3].img);
				this.m_loader.x = 0;
				if (_local_1.images[_local_3].paddingTop) {
					_local_2 = (_local_2 + _local_1.images[_local_3].paddingTop);
				}
				;
				this.m_loader.y = _local_2;
				_local_2 = (_local_2 + (_local_1.images[_local_3].height + 100));
				this.m_view.addChild(this.m_loader);
				_local_3++;
			}
			;
		}
		;
		if (_local_1.credits) {
			_local_4 = 0;
			_local_5 = 0;
			while (_local_5 < _local_1.credits.length) {
				_local_6 = new TextField();
				_local_6.multiline = false;
				_local_6.autoSize = TextFieldAutoSize.RIGHT;
				_local_6.x = 0;
				_local_6.y = _local_4;
				MenuUtils.setupText(_local_6, _local_1.credits[_local_5].title, 18, MenuConstants.FONT_TYPE_GLOBAL, this.COLOR_RED);
				_local_7 = 0;
				while (_local_7 < _local_1.credits[_local_5].names.length) {
					_local_8 = new TextField();
					_local_8.multiline = false;
					_local_8.autoSize = TextFieldAutoSize.LEFT;
					_local_8.antiAliasType = AntiAliasType.ADVANCED;
					_local_8.x = 10;
					_local_8.y = _local_4;
					MenuUtils.setupText(_local_8, _local_1.credits[_local_5].names[_local_7], 18, MenuConstants.FONT_TYPE_GLOBAL, this.COLOR_GREY_DARK);
					this.m_view.titlesAndNames_mc.addChild(_local_8);
					_local_4 = (_local_4 + 25);
					if (_local_1.credits[_local_5].checkifonline) {
						if ((((_local_1.credits[_local_5].names[_local_7] == undefined) || (_local_1.credits[_local_5].names[_local_7] == "")) || (_local_1.credits[_local_5].names[_local_7] == "Anonymous"))) {
							this.m_view.titlesAndNames_mc.visible = false;
						}
						;
					}
					;
					_local_7++;
				}
				;
				this.m_view.titlesAndNames_mc.addChild(_local_6);
				_local_4 = (_local_4 + 30);
				_local_5++;
			}
			;
		}
		;
	}

	override public function onUnregister():void {
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}

	public function getCreditsHeight():Number {
		return (this.m_height);
	}


}
}//package menu3

