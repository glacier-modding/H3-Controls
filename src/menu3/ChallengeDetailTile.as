package menu3
{
	import basic.DottedLine;
	import common.Animate;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.DisplayObject;
	import menu3.basic.TextTickerUtil;
	
	public dynamic class ChallengeDetailTile extends MenuElementBase
	{
		
		private var m_view:ChallengeDetailsView;
		
		private var m_unlocksImageLoader:MenuImageLoader;
		
		private var m_verticalSeparator:DottedLine;
		
		private var m_textTickerUtilTitle:TextTickerUtil;
		
		public function ChallengeDetailTile(param1:Object)
		{
			this.m_textTickerUtilTitle = new TextTickerUtil();
			super(param1);
			this.m_view = new ChallengeDetailsView();
			this.m_view.challengeUnlocks.visible = false;
			this.m_view.challengeUnlocks.imageBG.visible = false;
			this.m_view.challengeUnlocksMultiplier.visible = false;
			this.m_view.challengeMastery.visible = false;
			this.m_view.progressClip.visible = false;
			this.m_view.progressClip.progressbar.scaleX = 0;
			MenuUtils.setColor(this.m_view.progressClip.bg, MenuConstants.COLOR_WHITE, true, 0.5);
			MenuUtils.setColor(this.m_view.progressClip.progressbar, MenuConstants.COLOR_RED);
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc4_:Object = null;
			var _loc5_:Object = null;
			super.onSetData(param1);
			this.setupHeader(param1.header, param1.title, param1.icon, param1.completed);
			this.setupBody(param1.description);
			if (param1.progress != null)
			{
				this.setupProgress(param1.progress.count, param1.progress.total);
			}
			var _loc2_:Boolean = false;
			var _loc3_:Boolean = false;
			if (param1.rewards)
			{
				if (param1.rewards.length > 0)
				{
					if ((_loc4_ = param1.rewards[0]).amount >= 0.1)
					{
						_loc2_ = true;
						this.setupMasteryReward(_loc4_, param1.completed);
					}
				}
			}
			if (param1.unlocks)
			{
				if (param1.unlocks.length > 0)
				{
					_loc5_ = param1.unlocks[0];
					_loc3_ = true;
					this.setupChallengeUnlocks(_loc5_, param1.completed);
				}
			}
			if (_loc2_ || _loc3_)
			{
				this.createSeparatorLine();
				MenuUtils.setupText(this.m_view.rewardsTitle, param1.rewardsTitle, 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				this.m_view.rewardsTitle.visible = true;
				if (_loc2_ && !_loc3_)
				{
					this.m_view.challengeMastery.y = this.m_view.challengeUnlocks.y;
				}
			}
			else
			{
				this.m_view.rewardsTitle.visible = false;
			}
		}
		
		override public function onUnregister():void
		{
			if (this.m_view)
			{
				Animate.kill(this.m_view.progressClip.progressbar);
				this.m_textTickerUtilTitle.onUnregister();
				while (this.m_view.challengeUnlocks.perks.numChildren > 0)
				{
					this.m_view.challengeUnlocks.perks.removeChildAt(0);
				}
				if (this.m_unlocksImageLoader != null)
				{
					this.m_unlocksImageLoader.cancelIfLoading();
					this.m_view.challengeUnlocks.image.removeChild(this.m_unlocksImageLoader);
					this.m_unlocksImageLoader = null;
				}
				if (this.m_verticalSeparator != null)
				{
					this.m_view.removeChild(this.m_verticalSeparator);
					this.m_verticalSeparator = null;
				}
				removeChild(this.m_view);
				this.m_view = null;
			}
			super.onUnregister();
		}
		
		private function setupHeader(param1:String, param2:String, param3:String, param4:Boolean):void
		{
			MenuUtils.setupText(this.m_view.headerClip.header, param1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_view.headerClip.title, param2, 54, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			this.m_textTickerUtilTitle.addTextTickerHtml(this.m_view.headerClip.title);
			MenuUtils.truncateTextfield(this.m_view.headerClip.title, 1, MenuConstants.FontColorWhite);
			this.m_textTickerUtilTitle.callTextTicker(true);
			if (param3 == null || param3 == "")
			{
				this.m_view.headerClip.icon.visible = false;
			}
			else
			{
				MenuUtils.setupIcon(this.m_view.headerClip.icon, param3, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
				this.m_view.headerClip.icon.visible = true;
			}
		}
		
		private function setupBody(param1:String):void
		{
			var _loc2_:int = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 22 : 18;
			MenuUtils.setupText(this.m_view.bodyClip.description, param1, _loc2_, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		}
		
		private function createSeparatorLine():void
		{
			this.m_verticalSeparator = new DottedLine(254, MenuConstants.COLOR_WHITE, DottedLine.TYPE_VERTICAL, 1, 2);
			this.m_verticalSeparator.x = 704;
			this.m_verticalSeparator.y = 56;
			this.m_view.addChild(this.m_verticalSeparator);
		}
		
		private function setupProgress(param1:int, param2:int):void
		{
			if (param2 <= 0)
			{
				this.m_view.progressClip.visible = false;
			}
			else
			{
				this.m_view.progressClip.visible = true;
				MenuUtils.setupText(this.m_view.progressClip.value, String(param1) + "/" + String(param2), 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				Animate.to(this.m_view.progressClip.progressbar, 0.6, 0.1, {"scaleX": param1 / param2}, Animate.ExpoOut);
			}
		}
		
		private function setupMasteryReward(param1:Object, param2:Boolean):void
		{
			this.m_view.challengeMastery.visible = true;
			MenuUtils.setupText(this.m_view.challengeMastery.header, param1.name, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_view.challengeMastery.amount, "+" + param1.amount, 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		}
		
		private function setupChallengeUnlocks(param1:Object, param2:Boolean):void
		{
			var _loc4_:Number = NaN;
			var _loc3_:* = param1.multiplier != null;
			if (_loc3_)
			{
				this.m_view.challengeUnlocksMultiplier.visible = true;
				MenuUtils.setupIcon(this.m_view.challengeUnlocksMultiplier.icon, "featured", MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE);
				MenuUtils.setupText(this.m_view.challengeUnlocksMultiplier.title, param1.name, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				_loc4_ = (_loc4_ = Number(param1.multiplier)) + 1;
				MenuUtils.setupText(this.m_view.challengeUnlocksMultiplier.valueLabel, _loc4_.toFixed(2), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			}
			else
			{
				this.m_view.challengeUnlocks.visible = true;
				MenuUtils.setupText(this.m_view.challengeUnlocks.textContainer.title, param1.name, 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				this.setupUnlockRarity(param1.rarity);
				this.setupUnlockPerks(param1.perks);
				this.setupUnlockImage(param1.image);
			}
		}
		
		private function setupUnlockRarity(param1:String):void
		{
			var _loc2_:String = null;
			if (param1 && param1.length > 0 && param1 != "common")
			{
				_loc2_ = "UI_ITEM_RARITY_" + param1.toUpperCase();
				MenuUtils.setupText(this.m_view.challengeUnlocks.rarityIcon.rarity, Localization.get(_loc2_), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				this.m_view.challengeUnlocks.rarityIcon.gotoAndStop(param1);
				this.m_view.challengeUnlocks.rarityIcon.visible = true;
			}
			else
			{
				this.m_view.challengeUnlocks.rarityIcon.visible = false;
			}
		}
		
		private function setupUnlockPerks(param1:Array):void
		{
			var _loc3_:iconsAll40x40View = null;
			var _loc4_:String = null;
			while (this.m_view.challengeUnlocks.perks.numChildren > 0)
			{
				this.m_view.challengeUnlocks.perks.removeChildAt(0);
			}
			if (param1 == null || param1.length == 0)
			{
				return;
			}
			if (param1.length == 1 && param1[0] == "NONE")
			{
				return;
			}
			var _loc2_:int = 0;
			var _loc5_:int = 0;
			while (_loc5_ < param1.length)
			{
				_loc4_ = String(param1[_loc5_]);
				_loc3_ = new iconsAll40x40View();
				MenuUtils.setupIcon(_loc3_, _loc4_, MenuConstants.COLOR_BLACK, false, true, MenuConstants.COLOR_WHITE);
				this.m_view.challengeUnlocks.perks.addChild(_loc3_);
				_loc3_.x = _loc2_;
				_loc2_ += 50;
				_loc5_++;
			}
		}
		
		private function setupUnlockImage(param1:String):void
		{
			var imagePath:String = param1;
			if (this.m_unlocksImageLoader != null)
			{
				this.m_unlocksImageLoader.cancelIfLoading();
				this.m_view.challengeUnlocks.image.removeChild(this.m_unlocksImageLoader);
			}
			if (Boolean(imagePath) && imagePath.length > 0)
			{
				this.m_unlocksImageLoader = new MenuImageLoader();
				this.m_view.challengeUnlocks.image.addChild(this.m_unlocksImageLoader);
				this.m_unlocksImageLoader.center = false;
				this.m_unlocksImageLoader.loadImage(imagePath, function():void
				{
					m_unlocksImageLoader.getImage().smoothing = true;
					MenuUtils.scaleProportionalByHeight(DisplayObject(m_unlocksImageLoader.getImage()), 152);
				});
			}
		}
	}
}
