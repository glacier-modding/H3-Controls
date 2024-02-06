package menu3.basic
{
	import basic.Box;
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import menu3.MenuElementBase;
	
	public dynamic class PlayerProfileBadgeElement extends MenuElementBase
	{
		
		private var m_view:Sprite;
		
		private var m_badgeClip:Badge;
		
		private var m_levelClip:Sprite;
		
		private var m_titleClip:Sprite;
		
		private var m_isPressable:Boolean;
		
		private var m_isSelectable:Boolean;
		
		private var m_badgeSize:Number = 200;
		
		private var m_useBadgeAnimation:Boolean = false;
		
		private var m_level:int = 1;
		
		private var m_title:String = "";
		
		public function PlayerProfileBadgeElement(param1:Object)
		{
			super(param1);
			this.m_view = new Sprite();
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.m_isPressable = getNodeProp(this, "pressable");
			this.m_isSelectable = getNodeProp(this, "selectable");
			this.m_title = param1.title;
			this.m_level = param1.level;
			this.m_badgeSize = param1.badgesize;
			this.m_useBadgeAnimation = param1.animate;
			this.createBadge();
			this.m_badgeClip.setLevel(this.m_level, true, this.m_useBadgeAnimation);
		}
		
		private function createBadge():void
		{
			this.m_badgeClip = new Badge();
			this.m_badgeClip.x = this.m_badgeSize / 2;
			this.m_badgeClip.y = this.m_badgeSize / 2;
			this.m_badgeClip.setMaxSize(this.m_badgeSize);
			this.m_view.addChild(this.m_badgeClip);
		}
		
		private function createLevelDisplay():void
		{
			this.m_levelClip = new Sprite();
			this.m_levelClip.x = this.m_badgeSize / 2;
			this.m_levelClip.y = this.m_badgeSize + 30;
			this.m_levelClip.alpha = 0;
			var _loc1_:TextField = new TextField();
			_loc1_.autoSize = TextFieldAutoSize.CENTER;
			_loc1_.selectable = false;
			MenuUtils.setupTextUpper(_loc1_, Localization.get("UI_DIALOG_ESCALATION_LEVEL") + " " + this.m_level, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
			_loc1_.x = -(_loc1_.textWidth / 2);
			_loc1_.y = -(_loc1_.textHeight / 2);
			this.m_levelClip.addChild(_loc1_);
			var _loc2_:Sprite = new Box(_loc1_.textWidth + 20, _loc1_.textHeight + 16, MenuConstants.COLOR_WHITE, Box.ALIGN_CENTERED, Box.TYPE_SOLID);
			this.m_levelClip.addChildAt(_loc2_, 0);
			this.m_view.addChild(this.m_levelClip);
		}
		
		private function createTitleDisplay():void
		{
			this.m_titleClip = new Sprite();
			this.m_titleClip.x = this.m_levelClip.x;
			this.m_titleClip.y = this.m_levelClip.y + 70;
			this.m_titleClip.alpha = 0;
			var _loc1_:TextField = new TextField();
			_loc1_.autoSize = TextFieldAutoSize.CENTER;
			_loc1_.selectable = false;
			MenuUtils.setupText(_loc1_, this.m_title, 50, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			CommonUtils.changeFontToGlobalIfNeeded(_loc1_);
			MenuUtils.truncateTextfieldWithCharLimit(_loc1_, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
			MenuUtils.shrinkTextToFit(_loc1_, _loc1_.width, -1);
			_loc1_.x = -(_loc1_.textWidth / 2);
			_loc1_.y = -(_loc1_.textHeight / 2);
			this.m_titleClip.addChild(_loc1_);
			this.m_view.addChild(this.m_titleClip);
		}
		
		override public function getView():Sprite
		{
			return this.m_view;
		}
		
		override public function onUnregister():void
		{
			super.onUnregister();
			if (this.m_view)
			{
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
	}
}
