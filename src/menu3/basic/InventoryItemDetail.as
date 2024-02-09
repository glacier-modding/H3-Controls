package menu3.basic
{
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class InventoryItemDetail extends Sprite
	{
		
		private const DETAIL_VIEW_BEGIN_X:int = 5;
		
		private const DETAIL_VIEW_BEGIN_Y:int = 40;
		
		private const SPACE_Y:int = 40;
		
		private var m_title:TextField;
		
		private var m_views:Array;
		
		public function InventoryItemDetail()
		{
			this.m_title = new TextField();
			this.m_views = new Array();
			super();
			this.m_title.autoSize = TextFieldAutoSize.LEFT;
			addChild(this.m_title);
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc3_:InventoryItemDetailView = null;
			this.removeAllViews();
			if (param1 == null)
			{
				return;
			}
			MenuUtils.setupText(this.m_title, param1.label, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			if (param1.details == null || param1.details.length <= 0)
			{
				return;
			}
			var _loc2_:int = 0;
			while (_loc2_ < param1.details.length)
			{
				_loc3_ = this.createDetailView(param1.details[_loc2_]);
				if (_loc3_ != null)
				{
					this.m_views.push(_loc3_);
					addChild(_loc3_);
					_loc3_.x = this.DETAIL_VIEW_BEGIN_X;
					_loc3_.y = this.DETAIL_VIEW_BEGIN_Y + this.SPACE_Y * _loc2_;
				}
				_loc2_++;
			}
		}
		
		public function onUnregister():void
		{
			this.removeAllViews();
		}
		
		private function createDetailView(param1:Object):InventoryItemDetailView
		{
			var _loc3_:int = 0;
			var _loc2_:InventoryItemDetailView = new InventoryItemDetailView();
			if (param1.icon != undefined)
			{
				if (param1.icon == "frisk")
				{
					MenuUtils.setupIcon(_loc2_.icon, param1.icon, MenuConstants.COLOR_WHITE, false, true, MenuConstants.COLOR_RED);
				}
				else if (param1.icon == "warning")
				{
					MenuUtils.setupIcon(_loc2_.icon, param1.icon, MenuConstants.COLOR_BLACK, false, true, MenuConstants.COLOR_YELLOW);
				}
				else
				{
					MenuUtils.setupIcon(_loc2_.icon, param1.icon, MenuConstants.COLOR_WHITE, true, false);
				}
			}
			if (param1.title != undefined && param1.title.length > 0)
			{
				_loc2_.valuebar.visible = false;
				MenuUtils.setupText(_loc2_.title, param1.title, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorGreyUltraLight);
			}
			else if (param1.value != undefined)
			{
				_loc2_.title.visible = false;
				_loc3_ = param1.value * 6;
				_loc2_.valuebar.gotoAndStop("value" + _loc3_.toString());
			}
			return _loc2_;
		}
		
		private function removeAllViews():void
		{
			var _loc1_:int = 0;
			while (_loc1_ < this.m_views.length)
			{
				removeChild(this.m_views[_loc1_]);
				_loc1_++;
			}
			this.m_views.length = 0;
		}
	}
}
