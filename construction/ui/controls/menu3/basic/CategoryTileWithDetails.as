package menu3.basic
{
	import common.Animate;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public dynamic class CategoryTileWithDetails extends CategoryTile
	{
		
		private const HEADER_HEIGHT:Number = 70;
		
		private const GAP_BETWEEN_HEADER_AND_DETAILS:Number = 30;
		
		private const DETAILS_PADDING_X:Number = 15;
		
		private const DETAILS_PADDING_Y:Number = 20;
		
		private const DETAILS_HEIGHT_MAX:Number = MenuConstants.MenuTileTallHeight - HEADER_HEIGHT - GAP_BETWEEN_HEADER_AND_DETAILS - DETAILS_PADDING_Y;
		
		private var m_detailBg:Sprite;
		
		private var m_details:TextField;
		
		private var m_detailsHeight:Number = 0;
		
		private var m_originalTileSelectPosY:Number = 0;
		
		private var m_originalHeaderPosY:Number = 0;
		
		private var m_originalTitlePosY:Number = 0;
		
		private var m_originalTileIconPosY:Number = 0;
		
		private var m_showDetailsOnSelect:Boolean = true;
		
		public function CategoryTileWithDetails(param1:Object)
		{
			super(param1);
		}
		
		override protected function createView():*
		{
			var _loc1_:* = super.createView();
			var _loc2_:int = int(_loc1_.getChildIndex(_loc1_.image));
			this.m_detailBg = new Sprite();
			_loc1_.addChildAt(this.m_detailBg, _loc2_ + 1);
			this.m_detailBg.graphics.clear();
			this.m_detailBg.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
			this.m_detailBg.graphics.drawRect(0, 0, MenuConstants.MenuTileTallWidth, -1);
			this.m_detailBg.graphics.endFill();
			this.m_detailBg.x = 0;
			this.m_detailBg.y = MenuConstants.MenuTileTallHeight;
			this.m_details = new TextField();
			this.m_details.multiline = true;
			this.m_details.wordWrap = true;
			_loc1_.addChildAt(this.m_details, _loc2_ + 2);
			this.m_details.x = this.DETAILS_PADDING_X;
			this.m_details.width = MenuConstants.MenuTileTallWidth - this.DETAILS_PADDING_X * 2;
			this.m_details.y = this.DETAILS_PADDING_Y;
			this.m_details.height = this.DETAILS_HEIGHT_MAX;
			this.m_details.visible = false;
			this.m_originalTitlePosY = _loc1_.title.y;
			this.m_originalHeaderPosY = _loc1_.header.y;
			this.m_originalTileIconPosY = _loc1_.tileIcon.y;
			this.m_originalTileSelectPosY = _loc1_.tileSelect.y;
			return _loc1_;
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc3_:int = 0;
			super.onSetData(param1);
			this.m_details.visible = false;
			if (param1.description != null)
			{
				_loc3_ = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 22 : 14;
				MenuUtils.setupText(this.m_details, param1.description, _loc3_, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
				this.m_detailsHeight = Math.min(this.m_details.textHeight, this.DETAILS_HEIGHT_MAX);
				this.m_details.y = MenuConstants.MenuTileTallHeight - this.DETAILS_PADDING_Y - this.m_detailsHeight;
			}
			this.m_showDetailsOnSelect = true;
			if (param1.showDetailsOnSelect === false)
			{
				this.m_showDetailsOnSelect = false;
			}
			var _loc2_:* = param1.showDetails === true;
			this.setDetailsVisible(_loc2_);
		}
		
		override protected function handleSelectionChange():void
		{
			super.handleSelectionChange();
			if (m_loading)
			{
				return;
			}
			if (!this.m_showDetailsOnSelect)
			{
				return;
			}
			if (m_isSelected)
			{
				this.setDetailsVisible(true);
			}
			else
			{
				this.setDetailsVisible(false);
			}
		}
		
		public function setDetailsVisible(param1:Boolean):void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:int = 0;
			this.killAnimations();
			if (param1)
			{
				_loc2_ = this.m_detailsHeight + this.GAP_BETWEEN_HEADER_AND_DETAILS;
				_loc3_ = 0.3;
				_loc4_ = Animate.ExpoOut;
				Animate.to(this.m_detailBg, _loc3_, 0, {"height": _loc2_ - 2}, _loc4_);
				Animate.to(m_view.header, _loc3_, 0, {"y": this.m_originalHeaderPosY - _loc2_}, _loc4_);
				Animate.to(m_view.title, _loc3_, 0, {"y": this.m_originalTitlePosY - _loc2_}, _loc4_);
				Animate.to(m_view.tileIcon, _loc3_, 0, {"y": this.m_originalTileIconPosY - _loc2_}, _loc4_);
				Animate.to(m_view.tileSelect, _loc3_, 0, {"y": this.m_originalTileSelectPosY - _loc2_}, _loc4_);
				this.m_details.visible = true;
				this.m_details.alpha = 0;
				Animate.to(this.m_details, 0.1, _loc3_ - 0.1, {"alpha": 1}, Animate.Linear);
			}
			else
			{
				this.m_detailBg.height = 1;
				m_view.header.y = this.m_originalHeaderPosY;
				m_view.title.y = this.m_originalTitlePosY;
				m_view.tileIcon.y = this.m_originalTileIconPosY;
				m_view.tileSelect.y = this.m_originalTileSelectPosY;
				this.m_details.visible = false;
			}
		}
		
		private function killAnimations():void
		{
			Animate.kill(m_view.header);
			Animate.kill(m_view.title);
			Animate.kill(m_view.tileIcon);
			Animate.kill(m_view.tileSelect);
			if (this.m_detailBg != null)
			{
				Animate.kill(this.m_detailBg);
			}
			if (this.m_details != null)
			{
				Animate.kill(this.m_details);
			}
		}
		
		override public function onUnregister():void
		{
			if (m_view != null)
			{
				this.killAnimations();
				if (this.m_detailBg != null)
				{
					m_view.removeChild(this.m_detailBg);
					this.m_detailBg = null;
				}
				if (this.m_details != null)
				{
					m_view.removeChild(this.m_details);
					this.m_details = null;
				}
			}
			super.onUnregister();
		}
	}
}
