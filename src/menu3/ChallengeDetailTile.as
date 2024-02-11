// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.ChallengeDetailTile

package menu3 {
import basic.DottedLine;

import menu3.basic.TextTickerUtil;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Animate;
import common.Localization;

import flash.display.DisplayObject;

public dynamic class ChallengeDetailTile extends MenuElementBase {

	private var m_view:ChallengeDetailsView;
	private var m_unlocksImageLoader:MenuImageLoader;
	private var m_verticalSeparator:DottedLine;
	private var m_textTickerUtilTitle:TextTickerUtil = new TextTickerUtil();

	public function ChallengeDetailTile(_arg_1:Object) {
		super(_arg_1);
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

	override public function onSetData(_arg_1:Object):void {
		var _local_4:Object;
		var _local_5:Object;
		super.onSetData(_arg_1);
		this.setupHeader(_arg_1.header, _arg_1.title, _arg_1.icon, _arg_1.completed);
		this.setupBody(_arg_1.description);
		if (_arg_1.progress != null) {
			this.setupProgress(_arg_1.progress.count, _arg_1.progress.total);
		}
		;
		var _local_2:Boolean;
		var _local_3:Boolean;
		if (_arg_1.rewards) {
			if (_arg_1.rewards.length > 0) {
				_local_4 = _arg_1.rewards[0];
				if (_local_4.amount >= 0.1) {
					_local_2 = true;
					this.setupMasteryReward(_local_4, _arg_1.completed);
				}
				;
			}
			;
		}
		;
		if (_arg_1.unlocks) {
			if (_arg_1.unlocks.length > 0) {
				_local_5 = _arg_1.unlocks[0];
				_local_3 = true;
				this.setupChallengeUnlocks(_local_5, _arg_1.completed);
			}
			;
		}
		;
		if (((_local_2) || (_local_3))) {
			this.createSeparatorLine();
			MenuUtils.setupText(this.m_view.rewardsTitle, _arg_1.rewardsTitle, 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			this.m_view.rewardsTitle.visible = true;
			if (((_local_2) && (!(_local_3)))) {
				this.m_view.challengeMastery.y = this.m_view.challengeUnlocks.y;
			}
			;
		} else {
			this.m_view.rewardsTitle.visible = false;
		}
		;
	}

	override public function onUnregister():void {
		if (this.m_view) {
			Animate.kill(this.m_view.progressClip.progressbar);
			this.m_textTickerUtilTitle.onUnregister();
			while (this.m_view.challengeUnlocks.perks.numChildren > 0) {
				this.m_view.challengeUnlocks.perks.removeChildAt(0);
			}
			;
			if (this.m_unlocksImageLoader != null) {
				this.m_unlocksImageLoader.cancelIfLoading();
				this.m_view.challengeUnlocks.image.removeChild(this.m_unlocksImageLoader);
				this.m_unlocksImageLoader = null;
			}
			;
			if (this.m_verticalSeparator != null) {
				this.m_view.removeChild(this.m_verticalSeparator);
				this.m_verticalSeparator = null;
			}
			;
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
		super.onUnregister();
	}

	private function setupHeader(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Boolean):void {
		MenuUtils.setupText(this.m_view.headerClip.header, _arg_1, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.headerClip.title, _arg_2, 54, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		this.m_textTickerUtilTitle.addTextTickerHtml(this.m_view.headerClip.title);
		MenuUtils.truncateTextfield(this.m_view.headerClip.title, 1, MenuConstants.FontColorWhite);
		this.m_textTickerUtilTitle.callTextTicker(true);
		if (((_arg_3 == null) || (_arg_3 == ""))) {
			this.m_view.headerClip.icon.visible = false;
		} else {
			MenuUtils.setupIcon(this.m_view.headerClip.icon, _arg_3, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
			this.m_view.headerClip.icon.visible = true;
		}
		;
	}

	private function setupBody(_arg_1:String):void {
		var _local_2:int = ((ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL) ? 22 : 18);
		MenuUtils.setupText(this.m_view.bodyClip.description, _arg_1, _local_2, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	private function createSeparatorLine():void {
		this.m_verticalSeparator = new DottedLine(254, MenuConstants.COLOR_WHITE, DottedLine.TYPE_VERTICAL, 1, 2);
		this.m_verticalSeparator.x = 704;
		this.m_verticalSeparator.y = 56;
		this.m_view.addChild(this.m_verticalSeparator);
	}

	private function setupProgress(_arg_1:int, _arg_2:int):void {
		if (_arg_2 <= 0) {
			this.m_view.progressClip.visible = false;
		} else {
			this.m_view.progressClip.visible = true;
			MenuUtils.setupText(this.m_view.progressClip.value, ((String(_arg_1) + "/") + String(_arg_2)), 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			Animate.to(this.m_view.progressClip.progressbar, 0.6, 0.1, {"scaleX": (_arg_1 / _arg_2)}, Animate.ExpoOut);
		}
		;
	}

	private function setupMasteryReward(_arg_1:Object, _arg_2:Boolean):void {
		this.m_view.challengeMastery.visible = true;
		MenuUtils.setupText(this.m_view.challengeMastery.header, _arg_1.name, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.challengeMastery.amount, ("+" + _arg_1.amount), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
	}

	private function setupChallengeUnlocks(_arg_1:Object, _arg_2:Boolean):void {
		var _local_4:Number;
		var _local_3:* = (!(_arg_1.multiplier == null));
		if (_local_3) {
			this.m_view.challengeUnlocksMultiplier.visible = true;
			MenuUtils.setupIcon(this.m_view.challengeUnlocksMultiplier.icon, "featured", MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE);
			MenuUtils.setupText(this.m_view.challengeUnlocksMultiplier.title, _arg_1.name, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			_local_4 = _arg_1.multiplier;
			_local_4 = (_local_4 + 1);
			MenuUtils.setupText(this.m_view.challengeUnlocksMultiplier.valueLabel, _local_4.toFixed(2), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		} else {
			this.m_view.challengeUnlocks.visible = true;
			MenuUtils.setupText(this.m_view.challengeUnlocks.textContainer.title, _arg_1.name, 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.setupUnlockRarity(_arg_1.rarity);
			this.setupUnlockPerks(_arg_1.perks);
			this.setupUnlockImage(_arg_1.image);
		}
		;
	}

	private function setupUnlockRarity(_arg_1:String):void {
		var _local_2:String;
		if ((((_arg_1) && (_arg_1.length > 0)) && (!(_arg_1 == "common")))) {
			_local_2 = ("UI_ITEM_RARITY_" + _arg_1.toUpperCase());
			MenuUtils.setupText(this.m_view.challengeUnlocks.rarityIcon.rarity, Localization.get(_local_2), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_view.challengeUnlocks.rarityIcon.gotoAndStop(_arg_1);
			this.m_view.challengeUnlocks.rarityIcon.visible = true;
		} else {
			this.m_view.challengeUnlocks.rarityIcon.visible = false;
		}
		;
	}

	private function setupUnlockPerks(_arg_1:Array):void {
		var _local_3:iconsAll40x40View;
		var _local_4:String;
		while (this.m_view.challengeUnlocks.perks.numChildren > 0) {
			this.m_view.challengeUnlocks.perks.removeChildAt(0);
		}
		;
		if (((_arg_1 == null) || (_arg_1.length == 0))) {
			return;
		}
		;
		if (((_arg_1.length == 1) && (_arg_1[0] == "NONE"))) {
			return;
		}
		;
		var _local_2:int;
		var _local_5:int;
		while (_local_5 < _arg_1.length) {
			_local_4 = _arg_1[_local_5];
			_local_3 = new iconsAll40x40View();
			MenuUtils.setupIcon(_local_3, _local_4, MenuConstants.COLOR_BLACK, false, true, MenuConstants.COLOR_WHITE);
			this.m_view.challengeUnlocks.perks.addChild(_local_3);
			_local_3.x = _local_2;
			_local_2 = (_local_2 + 50);
			_local_5++;
		}
		;
	}

	private function setupUnlockImage(imagePath:String):void {
		if (this.m_unlocksImageLoader != null) {
			this.m_unlocksImageLoader.cancelIfLoading();
			this.m_view.challengeUnlocks.image.removeChild(this.m_unlocksImageLoader);
		}
		;
		if (((imagePath) && (imagePath.length > 0))) {
			this.m_unlocksImageLoader = new MenuImageLoader();
			this.m_view.challengeUnlocks.image.addChild(this.m_unlocksImageLoader);
			this.m_unlocksImageLoader.center = false;
			this.m_unlocksImageLoader.loadImage(imagePath, function ():void {
				m_unlocksImageLoader.getImage().smoothing = true;
				MenuUtils.scaleProportionalByHeight(DisplayObject(m_unlocksImageLoader.getImage()), 152);
			});
		}
		;
	}


}
}//package menu3

