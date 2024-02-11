// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.LoadingScreenObjectiveTile

package basic {
import flash.display.Sprite;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.menu.ObjectiveUtil;
import common.CommonUtils;

public dynamic class LoadingScreenObjectiveTile extends Sprite {

	private const CONTRACT_TYPE_MISSION:String = "mission";
	private const CONTRACT_TYPE_FLASHBACK:String = "flashback";
	private const CONTRACT_TYPE_ELUSIVE:String = "elusive";
	private const CONTRACT_TYPE_ESCALATION:String = "escalation";
	private const CONTRACT_TYPE_USER_CREATED:String = "usercreated";
	private const CONTRACT_TYPE_TUTORIAL:String = "tutorial";
	private const CONTRACT_TYPE_CREATION:String = "creation";
	private const CONTRACT_TYPE_ORBIS:String = "orbis";
	private const CONTRACT_TYPE_FEATURED:String = "featured";
	private const CONTRACT_TYPE_INVALID:String = "";
	private const CONDITION_TYPE_KILL:String = "kill";
	private const CONDITION_TYPE_CUSTOMKILL:String = "customkill";
	private const CONDITION_TYPE_DEFAULTKILL:String = "defaultkill";
	private const CONDITION_TYPE_SETPIECE:String = "setpiece";
	private const CONDITION_TYPE_CUSTOM:String = "custom";
	private const CONDITION_TYPE_GAMECHANGER:String = "gamechanger";

	private var m_contractType:String;
	private var m_view:LoadingObjectiveTileView;
	private var m_loader:LoadingScreenImageLoader;
	private var m_textObj:Object = {};
	private var m_indicatorTextObjArray:Array = [];
	private var m_pressable:Boolean = true;
	private var m_isLocked:Boolean = false;
	private var m_conditionsContainer:Array = [];
	private var m_useZoomedImage:Boolean = false;
	private var m_iconLabel:String;

	public function LoadingScreenObjectiveTile() {
		this.m_view = new LoadingObjectiveTileView();
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0.3;
		this.m_view.dropShadow.alpha = 0;
		addChild(this.m_view);
	}

	public function setData(_arg_1:Object):void {
		this.m_useZoomedImage = (!(_arg_1.useZoomedImage === false));
		if (this.m_useZoomedImage) {
			MenuUtils.setColorFilter(this.m_view.image);
		} else {
			MenuUtils.setColorFilter(this.m_view.imagesmall);
		}

		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		MenuUtils.setColor(this.m_view.conditionsBg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
		if (this.m_useZoomedImage == true) {
			this.m_view.conditionsBg.visible = false;
		}

		this.m_iconLabel = _arg_1.icon;
		MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_WHITE, true, false);
		if (_arg_1.contracttype != undefined) {
			this.m_contractType = _arg_1.contracttype;
		}

		this.setupTextFields(_arg_1.header, _arg_1.title);
		if (_arg_1.displayaskill) {
			this.setConditions(ObjectiveUtil.prepareConditions([], false));
		} else {
			if (_arg_1.conditions) {
				this.setConditions(ObjectiveUtil.prepareConditions(_arg_1.conditions, false));
			}

		}

		if (_arg_1.image) {
			this.loadImage(_arg_1.image);
		}

	}

	private function setConditions(_arg_1:Array):void {
		var _local_5:LoadingConditionIndicatorSmallView;
		this.m_conditionsContainer = [];
		var _local_2:int = (MenuConstants.ValueIndicatorHeight * 2);
		var _local_3:int = _arg_1.length;
		var _local_4:int;
		while (_local_4 < _local_3) {
			_local_5 = new LoadingConditionIndicatorSmallView();
			_local_5.y = ((this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset) - _local_2);
			if (_arg_1[_local_4].type == this.CONDITION_TYPE_DEFAULTKILL) {
				ObjectiveUtil.setupConditionIndicator(_local_5, _arg_1[_local_4], this.m_indicatorTextObjArray, MenuConstants.FontColorWhite);
			} else {
				if (_arg_1[_local_4].type == this.CONDITION_TYPE_KILL) {
					ObjectiveUtil.setupConditionIndicator(_local_5, _arg_1[_local_4], this.m_indicatorTextObjArray, MenuConstants.FontColorWhite);
				} else {
					if ((((_arg_1[_local_4].type == this.CONDITION_TYPE_SETPIECE) || (_arg_1[_local_4].type == this.CONDITION_TYPE_GAMECHANGER)) || (_arg_1[_local_4].type == this.CONDITION_TYPE_CUSTOMKILL))) {
						_local_5.description.autoSize = "left";
						_local_5.description.width = 276;
						_local_5.description.multiline = true;
						_local_5.description.wordWrap = true;
						MenuUtils.setupText(_local_5.description, _arg_1[_local_4].summary, 18, MenuConstants.FONT_TYPE_NORMAL, ((this.m_isLocked) ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite));
						MenuUtils.truncateTextfield(_local_5.description, 7, ((this.m_isLocked) ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite));
					}

				}

			}

			if (this.m_useZoomedImage) {
				MenuUtils.setupIcon(_local_5.valueIcon, _arg_1[_local_4].icon, ((this.m_isLocked) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE), true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
			} else {
				MenuUtils.setupIcon(_local_5.valueIcon, _arg_1[_local_4].icon, ((this.m_isLocked) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE), true, false);
			}

			if (((_arg_1[_local_4].type == null) && (_arg_1.length == 1))) {
				if (_arg_1[_local_4].header) {
					MenuUtils.setupText(_local_5.header, _arg_1[_local_4].header, 18, MenuConstants.FONT_TYPE_NORMAL, ((this.m_isLocked) ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite));
				}

				if (_arg_1[_local_4].title) {
					MenuUtils.setupText(_local_5.title, _arg_1[_local_4].title, 24, MenuConstants.FONT_TYPE_MEDIUM, ((this.m_isLocked) ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite));
					_local_5.title.autoSize = "left";
					_local_5.title.width = 276;
					_local_5.title.multiline = true;
					_local_5.title.wordWrap = true;
					MenuUtils.truncateTextfield(_local_5.title, 3, ((this.m_isLocked) ? MenuConstants.FontColorGrey : MenuConstants.FontColorWhite));
				}

			}

			_local_5.alpha = 0;
			this.m_conditionsContainer.push(_local_5);
			if (this.m_useZoomedImage) {
				MenuUtils.addDropShadowFilter(_local_5);
			}

			this.m_view.indicator.addChild(_local_5);
			if (((_arg_1[_local_4].type == this.CONDITION_TYPE_KILL) || (_arg_1[_local_4].type == this.CONDITION_TYPE_DEFAULTKILL))) {
				_local_2 = (_local_2 - (MenuConstants.ValueIndicatorHeight + 14));
			}

			_local_4++;
		}

		this.showConditions();
	}

	public function showConditions():void {
		var _local_1:int = this.m_conditionsContainer.length;
		var _local_2:int;
		while (_local_2 < _local_1) {
			this.m_conditionsContainer[_local_2].alpha = 1;
			this.m_conditionsContainer[_local_2].valueIcon.scaleX = (this.m_conditionsContainer[_local_2].valueIcon.scaleY = (this.m_conditionsContainer[_local_2].valueIcon.alpha = 1));
			if (this.m_conditionsContainer[_local_2].description.length > 1) {
				this.m_conditionsContainer[_local_2].description.alpha = 1;
			} else {
				this.m_conditionsContainer[_local_2].header.alpha = 1;
				this.m_conditionsContainer[_local_2].title.alpha = 1;
				this.m_conditionsContainer[_local_2].method.alpha = 1;
			}

			_local_2++;
		}

	}

	private function setupTextFields(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupTextUpper(this.m_view.header, _arg_1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupTextUpper(this.m_view.title, _arg_2, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_textObj.header = this.m_view.header.htmlText;
		this.m_textObj.title = this.m_view.title.htmlText;
		MenuUtils.truncateTextfield(this.m_view.header, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
		MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
	}

	private function loadImage(imagePath:String):void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			if (this.m_useZoomedImage) {
				this.m_view.image.removeChild(this.m_loader);
			} else {
				this.m_view.imagesmall.removeChild(this.m_loader);
			}

			this.m_loader = null;
		}

		this.m_loader = new LoadingScreenImageLoader();
		if (this.m_useZoomedImage) {
			this.m_view.image.addChild(this.m_loader);
		} else {
			this.m_view.imagesmall.addChild(this.m_loader);
		}

		this.m_loader.center = true;
		this.m_loader.loadImage(imagePath, function ():void {
			if (m_useZoomedImage) {
				m_view.image.cacheAsBitmap = true;
				m_view.image.height = MenuConstants.MenuTileLargeHeight;
				m_view.image.scaleX = m_view.image.scaleY;
				if (m_view.image.width < MenuConstants.MenuTileTallWidth) {
					m_view.image.width = MenuConstants.MenuTileTallWidth;
					m_view.image.scaleY = m_view.image.scaleX;
				}

			} else {
				m_view.imagesmall.cacheAsBitmap = true;
				m_view.imagesmall.height = MenuConstants.MenuTileSmallHeight;
				m_view.imagesmall.scaleX = m_view.imagesmall.scaleY;
				if (m_view.imagesmall.width < MenuConstants.MenuTileSmallWidth) {
					m_view.imagesmall.width = MenuConstants.MenuTileSmallWidth;
					m_view.imagesmall.scaleY = m_view.imagesmall.scaleX;
				}

			}

		});
	}


}
}//package basic

