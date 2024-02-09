package menu3.basic
{
	import basic.DottedLine;
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import menu3.MenuElementBase;
	import mx.utils.StringUtil;
	
	public dynamic class HeadlineElement extends MenuElementBase
	{
		
		private var m_view:HeadlineElementView;
		
		private var m_isPopupModeActive:Boolean = false;
		
		private var m_fontColor:String;
		
		private var m_dottedLineContainer:Sprite;
		
		private var m_textTickerUtil:TextTickerUtil;
		
		public function HeadlineElement(param1:Object)
		{
			this.m_textTickerUtil = new TextTickerUtil();
			super(param1);
			this.m_view = new HeadlineElementView();
			MenuUtils.addDropShadowFilter(this.m_view.typeIcon);
			MenuUtils.addDropShadowFilter(this.m_view.headerlarge);
			MenuUtils.addDropShadowFilter(this.m_view.titlelarge);
			MenuUtils.addDropShadowFilter(this.m_view.creatorname);
			MenuUtils.addDropShadowFilter(this.m_view.header);
			MenuUtils.addDropShadowFilter(this.m_view.title);
			MenuUtils.addDropShadowFilter(this.m_view.titlemultiline);
			this.m_view.typeIcon.visible = false;
			addChild(this.m_view);
		}
		
		protected function getRootView():HeadlineElementView
		{
			return this.m_view;
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc5_:DottedLine = null;
			var _loc6_:String = null;
			this.m_isPopupModeActive = param1.popupMode !== false;
			this.m_fontColor = this.m_isPopupModeActive ? MenuConstants.FontColorWhite : MenuConstants.FontColorGreyDark;
			if (param1.useDottedLine === true)
			{
				this.m_dottedLineContainer = new Sprite();
				this.m_dottedLineContainer.x = 0;
				this.m_dottedLineContainer.y = -15;
				_loc5_ = new DottedLine(MenuConstants.GridUnitWidth * 10, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
				this.m_dottedLineContainer.addChild(_loc5_);
				this.m_view.addChild(this.m_dottedLineContainer);
			}
			var _loc2_:String = this.getHeaderString(param1);
			var _loc3_:String = this.getTitleString(param1);
			if (param1.largetitle)
			{
				this.setupLargeTextField(_loc2_, _loc3_);
			}
			else
			{
				if ((_loc6_ = String(param1.typeicon)) == null)
				{
					_loc6_ = String(param1.icon);
				}
				if (_loc6_ != null)
				{
					this.m_view.typeIcon.visible = true;
					MenuUtils.setupIcon(this.m_view.typeIcon, _loc6_, MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
				}
				this.setupTextFields(_loc2_, _loc3_, param1.multilinetitle);
			}
			var _loc4_:String = "";
			if (param1.creatorname)
			{
				_loc4_ = String(param1.creatorname);
			}
			if (param1.publicid)
			{
				_loc4_ += " " + Localization.get("UI_DIALOG_SLASH") + " " + param1.publicid;
			}
			if (_loc4_ != "")
			{
				MenuUtils.setupText(this.m_view.creatorname, Localization.get("UI_AUTHOR_BY") + " " + _loc4_, 24, MenuConstants.FONT_TYPE_MEDIUM, this.m_fontColor);
				MenuUtils.truncateTextfield(this.m_view.creatorname, 1, MenuConstants.FontColorGreyDark);
				CommonUtils.changeFontToGlobalIfNeeded(this.m_view.creatorname);
			}
		}
		
		private function getHeaderString(param1:Object):String
		{
			var _loc4_:String = null;
			var _loc5_:int = 0;
			var _loc6_:int = 0;
			var _loc7_:String = null;
			var _loc2_:* = "";
			var _loc3_:Array = param1.header as Array;
			if (_loc3_ != null && _loc3_.length > 0)
			{
				_loc4_ = Localization.get("UI_TEXT_PERIOD");
				_loc5_ = int(_loc3_.length);
				_loc6_ = 0;
				while (_loc6_ < _loc5_)
				{
					if ((_loc7_ = _loc3_[_loc6_] as String) != null)
					{
						if ((_loc7_ = StringUtil.trim(_loc7_)).length != 0)
						{
							if (_loc4_.length > 0)
							{
								if (_loc7_.charAt(_loc7_.length - 1) != _loc4_.charAt(0))
								{
									_loc7_ += _loc4_;
								}
							}
							if (_loc2_.length > 0)
							{
								_loc2_ += " ";
							}
							_loc2_ += _loc7_;
						}
					}
					_loc6_++;
				}
			}
			if (_loc2_.length == 0)
			{
				_loc2_ = String(param1.header);
			}
			return _loc2_;
		}
		
		private function getTitleString(param1:Object):String
		{
			if (param1.title != undefined)
			{
				return param1.title;
			}
			if (param1.player != undefined)
			{
				if (param1.player2 != undefined)
				{
					return param1.player + MenuConstants.PLAYER_MULTIPLAYER_DELIMITER + param1.player2;
				}
				return param1.player;
			}
			return "";
		}
		
		private function setupLargeTextField(param1:String = "", param2:String = ""):void
		{
			this.m_view.creatorname.x = -2;
			this.m_view.headerlarge.visible = true;
			this.m_view.titlelarge.visible = true;
			MenuUtils.setupTextUpper(this.m_view.headerlarge, param1, 24, MenuConstants.FONT_TYPE_MEDIUM, this.m_fontColor);
			MenuUtils.setupTextUpper(this.m_view.titlelarge, param2, 54, MenuConstants.FONT_TYPE_BOLD, this.m_fontColor);
			this.m_textTickerUtil.addTextTickerHtml(this.m_view.headerlarge);
			this.m_textTickerUtil.addTextTickerHtml(this.m_view.titlelarge);
			MenuUtils.truncateTextfield(this.m_view.headerlarge, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.headerlarge));
			MenuUtils.truncateTextfield(this.m_view.titlelarge, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.titlelarge));
			this.m_textTickerUtil.callTextTicker(true);
		}
		
		private function setupTextFields(param1:String, param2:String, param3:Boolean):void
		{
			this.m_view.creatorname.x = 92;
			if (param1 == null)
			{
				param1 = "";
			}
			if (param2 == null)
			{
				param2 = "";
			}
			if (param3)
			{
				this.m_view.titlemultiline.visible = true;
				this.m_view.header.visible = false;
				this.m_view.title.visible = false;
				MenuUtils.setupTextUpper(this.m_view.titlemultiline, param2, 36, MenuConstants.FONT_TYPE_MEDIUM, this.m_fontColor);
				CommonUtils.changeFontToGlobalIfNeeded(this.m_view.titlemultiline);
				this.m_view.header.visible = this.m_view.titlemultiline.numLines == 1;
				MenuUtils.truncateHTMLField(this.m_view.titlemultiline, this.m_view.titlemultiline.htmlText);
			}
			else
			{
				this.m_view.titlemultiline.visible = false;
				this.m_view.header.visible = true;
				this.m_view.title.visible = true;
				MenuUtils.setupTextUpper(this.m_view.header, param1, 24, MenuConstants.FONT_TYPE_MEDIUM, this.m_fontColor);
				MenuUtils.setupTextUpper(this.m_view.title, param2, 54, MenuConstants.FONT_TYPE_BOLD, this.m_fontColor);
				CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header);
				CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title);
				this.m_textTickerUtil.addTextTickerHtml(this.m_view.header);
				this.m_textTickerUtil.addTextTickerHtml(this.m_view.title);
				MenuUtils.truncateTextfield(this.m_view.header, 1, null);
				MenuUtils.truncateTextfield(this.m_view.title, 1, null);
				this.m_textTickerUtil.callTextTicker(true);
			}
		}
		
		override public function onUnregister():void
		{
			if (this.m_view == null)
			{
				return;
			}
			this.m_textTickerUtil.onUnregister();
			this.m_textTickerUtil = null;
			removeChild(this.m_view);
			this.m_view = null;
		}
	}
}
