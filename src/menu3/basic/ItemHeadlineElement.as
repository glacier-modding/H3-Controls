package menu3.basic
{
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.textTicker;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import hud.evergreen.EvergreenUtils;
	import menu3.MenuElementBase;
	
	public dynamic class ItemHeadlineElement extends MenuElementBase
	{
		
		private static const PADDING:Number = 7;
		
		private var m_view:ItemHeadlineElementView;
		
		private var m_textObj:Object;
		
		private var m_textTicker:textTicker;
		
		private var m_perkElements:Array;
		
		private var m_evergreenRarityLabel:DisplayObject;
		
		public function ItemHeadlineElement(param1:Object)
		{
			this.m_textObj = new Object();
			this.m_perkElements = [];
			super(param1);
			this.m_view = new ItemHeadlineElementView();
			MenuUtils.addDropShadowFilter(this.m_view.typeIcon);
			MenuUtils.addDropShadowFilter(this.m_view.header);
			MenuUtils.addDropShadowFilter(this.m_view.title);
			MenuUtils.addDropShadowFilter(this.m_view.rarityIcon);
			this.m_view.typeIcon.visible = false;
			var _loc2_:String = String(param1.typeicon);
			if (_loc2_ == null)
			{
				_loc2_ = String(param1.icon);
			}
			if (_loc2_ != null)
			{
				this.m_view.typeIcon.visible = true;
				MenuUtils.setupIcon(this.m_view.typeIcon, _loc2_, MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
			}
			this.m_view.rarityIcon.visible = false;
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			if (Boolean(param1.typeicon) || Boolean(param1.icon))
			{
				this.m_view.typeIcon.visible = true;
			}
			var _loc2_:Number = this.m_view.rarityIcon.x - this.m_view.rarityIcon.width / 2;
			var _loc3_:Number = this.m_view.rarityIcon.y;
			var _loc4_:Array;
			if ((_loc4_ = param1.perks) == null || _loc4_[0] == "NONE")
			{
				_loc4_ = [];
			}
			if (param1.currentContractType == "evergreen")
			{
				if (param1.evergreenCapacityCost > 0)
				{
					_loc4_.unshift("evergreen_gearcost_" + param1.evergreenCapacityCost.toString());
				}
				if (param1.evergreenRarity != null && EvergreenUtils.isValidRarityLabel(param1.evergreenRarity))
				{
					this.m_evergreenRarityLabel = EvergreenUtils.createRarityLabel(param1.evergreenRarity);
					this.m_evergreenRarityLabel.height = 30;
					this.m_evergreenRarityLabel.scaleX = this.m_evergreenRarityLabel.scaleY;
					this.m_evergreenRarityLabel.x = _loc2_ + this.m_evergreenRarityLabel.width / 2;
					this.m_evergreenRarityLabel.y = _loc3_;
					this.m_view.addChild(this.m_evergreenRarityLabel);
					_loc2_ += this.m_evergreenRarityLabel.width + PADDING;
				}
			}
			_loc2_ = this.setupPerks(_loc2_, _loc3_, _loc4_);
			this.setupTextFields(param1.header, param1.title);
		}
		
		private function setupPerks(param1:Number, param2:Number, param3:Array):Number
		{
			var _loc5_:MovieClip = null;
			var _loc4_:int = int(param3.length);
			this.m_perkElements = [];
			var _loc6_:int = 0;
			while (_loc6_ < _loc4_)
			{
				_loc5_ = new iconsAll76x76View();
				MenuUtils.setupIcon(_loc5_, param3[_loc6_], MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE, 1);
				_loc5_.width = _loc5_.height = 30;
				_loc5_.x = param1 + (_loc5_.width >> 1);
				_loc5_.y = param2;
				param1 += _loc5_.width + PADDING;
				this.m_perkElements[_loc6_] = _loc5_;
				this.m_view.addChild(_loc5_);
				_loc6_++;
			}
			return param1;
		}
		
		private function setupTextFields(param1:String, param2:String):void
		{
			MenuUtils.setupTextUpper(this.m_view.header, param1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupTextUpper(this.m_view.title, param2, 54, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			this.m_textObj.header = this.m_view.header.htmlText;
			this.m_textObj.title = this.m_view.title.htmlText;
			MenuUtils.truncateTextfield(this.m_view.header, 1, null);
			MenuUtils.truncateTextfield(this.m_view.title, 1, null);
			this.callTextTicker(true);
		}
		
		private function callTextTicker(param1:Boolean):void
		{
			if (!this.m_textTicker)
			{
				this.m_textTicker = new textTicker();
			}
			if (param1)
			{
				this.m_textTicker.startTextTickerHtml(this.m_view.title, this.m_textObj.title);
			}
			else
			{
				this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
				MenuUtils.truncateTextfield(this.m_view.title, 1, null);
			}
		}
		
		override public function onUnregister():void
		{
			var _loc1_:int = 0;
			if (this.m_view)
			{
				if (this.m_textTicker)
				{
					this.m_textTicker.stopTextTicker(this.m_view.title, this.m_textObj.title);
					this.m_textTicker = null;
				}
				if (this.m_evergreenRarityLabel != null)
				{
					this.m_view.removeChild(this.m_evergreenRarityLabel);
					this.m_evergreenRarityLabel = null;
				}
				if (this.m_perkElements.length > 0)
				{
					_loc1_ = 0;
					while (_loc1_ < this.m_perkElements.length)
					{
						this.m_view.removeChild(this.m_perkElements[_loc1_]);
						this.m_perkElements[_loc1_] = null;
						_loc1_++;
					}
					this.m_perkElements = [];
				}
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
	}
}
