// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.ObjectiveTile

package menu3.basic {
import menu3.MenuElementAvailabilityBase;
import menu3.IScreenVisibilityReceiver;
import menu3.MenuImageLoader;

import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Rectangle;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Localization;
import common.menu.ObjectiveUtil;
import common.Animate;

import flash.display.MovieClip;

import common.CommonUtils;

public dynamic class ObjectiveTile extends MenuElementAvailabilityBase implements IScreenVisibilityReceiver {

	public static const TILETYPE_NEW:String = "new";
	public static const TILETYPE_CURRENT:String = "current";

	private const CONTRACT_STATE_COMPLETED:String = "completed";
	private const CONTRACT_STATE_FAILED:String = "failed";
	private const CONTRACT_STATE_INPROGRESS:String = "inprogress";
	private const CONTRACT_STATE_UNKNOWN:String = "unknown";
	private const CONTRACT_STATE_AVAILABLE:String = "available";
	private const CONTRACT_STATE_LOCKED:String = "locked";
	private const CONTRACT_STATE_DOWNLOADING:String = "downloading";
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

	private var m_contractState:String;
	private var m_contractType:String;
	private var m_view:ObjectiveTileView;
	private var m_descriptionInitalY:Number;
	private var m_descriptionInitalHeight:Number;
	private var m_loader:MenuImageLoader;
	private var m_newObjectiveIndicator:NewObjectiveIndicatorView;
	private var m_perkElements:Array = [];
	private var m_textObj:Object = {};
	private var m_indicatorTextObjArray:Array = [];
	private var m_pressable:Boolean = true;
	private var m_markedForRemoval:Boolean = false;
	private var m_isLocked:Boolean = false;
	private var m_isAvailable:Boolean = true;
	private var m_loadOnVisibleOnScreen:Boolean = false;
	private var m_isVisibleOnScreen:Boolean = false;
	private var m_animateConditions:Boolean = true;
	private var m_conditionsContainer:Array = [];
	private var m_newConditionsContainer:Array = [];
	private var m_conditionCompletionIndicators:Array = [];
	private var m_conditionCompletionIndicatorCount:int = 0;
	private var m_conditionCompletionIndicatorDelay:Number = 0;
	private var m_useZoomedImage:Boolean = false;
	private var m_iconLabel:String;

	public function ObjectiveTile(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ObjectiveTileView();
		this.m_view.tileBg.alpha = 0;
		this.m_view.tileDarkBg.alpha = 0.3;
		this.m_view.dropShadow.alpha = 0;
		this.m_descriptionInitalY = this.m_view.description.y;
		this.m_descriptionInitalHeight = this.m_view.description.height;
		var _local_2:Shape = new Shape();
		_local_2.width = this.m_view.tileBg.width;
		_local_2.height = this.m_view.tileBg.height;
		addChild(_local_2);
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_5:String;
		var _local_6:Sprite;
		var _local_7:Rectangle;
		var _local_8:Number;
		var _local_9:Number;
		super.onSetData(_arg_1);
		this.m_iconLabel = _arg_1.icon;
		this.m_useZoomedImage = (_arg_1.useZoomedImage === true);
		this.m_loadOnVisibleOnScreen = (_arg_1.loadonvisibleonscreen == true);
		this.m_view.visible = ((!(this.m_loadOnVisibleOnScreen)) || (this.m_isVisibleOnScreen));
		var _local_2:String = ((_arg_1.state != null) ? String(_arg_1.state).toLowerCase() : this.CONTRACT_STATE_UNKNOWN);
		var _local_3:Boolean = (((_local_2 == this.CONTRACT_STATE_COMPLETED) || (_local_2 == this.CONTRACT_STATE_FAILED)) || (_local_2 == this.CONTRACT_STATE_INPROGRESS));
		if (_local_3) {
			this.m_useZoomedImage = false;
		}

		if (this.m_useZoomedImage) {
			MenuUtils.setColorFilter(this.m_view.image);
		} else {
			MenuUtils.setColorFilter(this.m_view.imagesmall);
		}

		if (this.m_useZoomedImage == true) {
			this.m_view.conditionsBg.visible = false;
		}

		this.m_markedForRemoval = (_arg_1.markedforremoval == true);
		this.m_isLocked = (_arg_1.islocked == true);
		this.m_isAvailable = ((_arg_1.availability == null) || (_arg_1.availability.available == true));
		MenuUtils.setColor(this.m_view.conditionsBg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
		MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
		this.m_pressable = getNodeProp(this, "pressable");
		MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY), true, false);
		if (_arg_1.contracttype != undefined) {
			this.m_contractType = _arg_1.contracttype;
		}

		if ((this.m_view.indicator.numChildren > 0)) {
			this.m_animateConditions = false;
		} else {
			this.m_animateConditions = true;
		}

		this.m_view.indicator.removeChildren();
		this.setupTextFields(_arg_1.header, _arg_1.title);
		this.changeTextColor(((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY), ((this.m_pressable) ? MenuConstants.COLOR_WHITE : MenuConstants.COLOR_GREY));
		if (this.m_markedForRemoval) {
			this.changeTextColor(MenuConstants.COLOR_GREY, MenuConstants.COLOR_GREY);
		}

		if (!this.m_isAvailable) {
			setAvailablity(this.m_view, _arg_1, "tall");
		} else {
			if (_local_3) {
				this.setContractState(_local_2);
				m_valueIndicator = new ValueIndicatorSmallView();
				m_valueIndicator.y = ((((this.m_view.tileBg.height / 2) - MenuConstants.ValueIndicatorYOffset) + MenuConstants.ValueIndicatorHeight) + 1);
				_local_5 = this.m_contractState;
				if (_local_2 == this.CONTRACT_STATE_INPROGRESS) {
					_local_5 = "arrowright";
				}

				if (_local_2 == this.CONTRACT_STATE_FAILED) {
					MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_MENU_PAGE_PLANNING_ELEMENT_FAILED"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.setupIcon(m_valueIndicator.valueIcon, _local_5, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_RED, MenuConstants.MenuElementBackgroundAlpha);
				} else {
					if (_local_2 == this.CONTRACT_STATE_INPROGRESS) {
						MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_MENU_PAGE_PLANNING_ELEMENT_INPROGRESS"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
						MenuUtils.setupIcon(m_valueIndicator.valueIcon, _local_5, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
					} else {
						MenuUtils.setupIcon(m_valueIndicator.valueIcon, _local_5, MenuConstants.COLOR_WHITE, true, true, 2728241, MenuConstants.MenuElementBackgroundAlpha);
						if (this.m_iconLabel == "target") {
							MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
						} else {
							MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_MENU_PAGE_PLANNING_ELEMENT_COMPLETED"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
						}

					}

				}

				MenuUtils.truncateTextfield(m_valueIndicator.title, 1);
				this.m_view.indicator.addChild(m_valueIndicator);
			} else {
				this.setContractState(this.CONTRACT_STATE_AVAILABLE);
				if (this.m_markedForRemoval) {
					m_valueIndicator = new ValueIndicatorSmallView();
					m_valueIndicator.y = ((((this.m_view.tileBg.height / 2) - MenuConstants.ValueIndicatorYOffset) + MenuConstants.ValueIndicatorHeight) + 1);
					MenuUtils.setupIcon(m_valueIndicator.valueIcon, this.CONTRACT_STATE_FAILED, MenuConstants.COLOR_GREY, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
					MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_CONTRACT_STATE_REMOVED"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
					MenuUtils.truncateTextfield(m_valueIndicator.title, 1);
					this.m_view.indicator.addChild(m_valueIndicator);
				}

			}

		}

		var _local_4:* = (!(this.m_useZoomedImage));
		if (_arg_1.displayaskill) {
			this.setConditions(ObjectiveUtil.prepareConditions([], _local_4));
		} else {
			if (_arg_1.conditions) {
				this.setConditions(ObjectiveUtil.prepareConditions(_arg_1.conditions, _local_4));
			}

		}

		if (_arg_1.perks != undefined) {
			if (_arg_1.perks[0] != "NONE") {
				this.setupPerks(_arg_1.perks);
			}

		}

		this.setOverlayColor();
		if (_arg_1.image) {
			this.loadImage(_arg_1.image);
		}

		this.m_view.description.text = "";
		this.m_view.description.y = this.m_descriptionInitalY;
		this.m_view.description.height = this.m_descriptionInitalHeight;
		if (((this.m_conditionsContainer.length <= 1) && (!(_arg_1.description == null)))) {
			if (this.m_conditionsContainer.length == 1) {
				_local_6 = this.m_conditionsContainer[0];
				_local_7 = _local_6.getBounds(this);
				_local_8 = _local_7.height;
				this.m_view.description.height = (this.m_view.description.height - _local_8);
				if (m_valueIndicator != null) {
					this.m_view.description.height = (this.m_view.description.height - m_valueIndicator.height);
				}

			}

			MenuUtils.setupText(this.m_view.description, _arg_1.description, 18, MenuConstants.FONT_TYPE_NORMAL, (((this.m_isLocked) || (!(this.m_isAvailable))) ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite));
			MenuUtils.truncateHTMLField(this.m_view.description, this.m_view.description.htmlText);
			if (_arg_1.descriptionAlignment == "top") {
				this.m_view.description.y = (this.m_descriptionInitalY + _local_8);
			} else {
				_local_9 = this.m_view.description.textHeight;
				this.m_view.description.y = (this.m_descriptionInitalY + (this.m_descriptionInitalHeight - _local_9));
			}

		}

	}

	override public function setContractState(_arg_1:String):void {
		this.m_contractState = _arg_1;
		switch (_arg_1) {
			case this.CONTRACT_STATE_AVAILABLE:
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_markedForRemoval) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE), true, false);
				break;
			case this.CONTRACT_STATE_LOCKED:
				this.m_view.tileIcon.icons.gotoAndStop(_arg_1);
				break;
			case this.CONTRACT_STATE_DOWNLOADING:
				this.m_view.tileIcon.icons.gotoAndStop(_arg_1);
				break;
			case this.CONTRACT_STATE_COMPLETED:
				break;
			case this.CONTRACT_STATE_FAILED:
				break;
		}

		this.setOverlayColor();
	}

	override public function setOverlayColor(_arg_1:Boolean = false):void {
		if (!this.m_isAvailable) {
			if (this.m_useZoomedImage) {
				MenuUtils.setColorFilter(this.m_view.image, "available");
			} else {
				MenuUtils.setColorFilter(this.m_view.imagesmall, "selected");
			}

		} else {
			if (_arg_1) {
				if (this.m_useZoomedImage) {
					MenuUtils.setColorFilter(this.m_view.image, "selected");
				} else {
					MenuUtils.setColorFilter(this.m_view.imagesmall, "selected");
				}

			} else {
				if (!m_isSelected) {
					if (this.m_useZoomedImage) {
						MenuUtils.setColorFilter(this.m_view.image, this.m_contractState);
					} else {
						MenuUtils.setColorFilter(this.m_view.imagesmall, this.m_contractState);
					}

				}

			}

		}

	}

	private function setConditions(_arg_1:Array):void {
		var _local_5:ConditionIndicatorSmallView;
		this.m_indicatorTextObjArray = [];
		this.m_newConditionsContainer = [];
		this.m_conditionsContainer = [];
		this.m_conditionCompletionIndicators = [];
		this.m_conditionCompletionIndicatorCount = 0;
		var _local_2:Boolean = getData().isnew;
		var _local_3:int = (MenuConstants.ValueIndicatorHeight * 2);
		var _local_4:int;
		while (_local_4 < _arg_1.length) {
			_local_5 = new ConditionIndicatorSmallView();
			_local_5.y = ((this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset) - _local_3);
			if (((_arg_1[_local_4].type == this.CONDITION_TYPE_DEFAULTKILL) || (_arg_1[_local_4].type == this.CONDITION_TYPE_KILL))) {
				ObjectiveUtil.setupConditionIndicator(_local_5, _arg_1[_local_4], this.m_indicatorTextObjArray, MenuConstants.FontColorWhite);
			} else {
				if ((((_arg_1[_local_4].type == this.CONDITION_TYPE_SETPIECE) || (_arg_1[_local_4].type == this.CONDITION_TYPE_GAMECHANGER)) || (_arg_1[_local_4].type == this.CONDITION_TYPE_CUSTOMKILL))) {
					_local_5.description.autoSize = "left";
					_local_5.description.width = 276;
					_local_5.description.multiline = true;
					_local_5.description.wordWrap = true;
					MenuUtils.setupText(_local_5.description, _arg_1[_local_4].summary, 18, MenuConstants.FONT_TYPE_NORMAL, (((this.m_isLocked) || (!(this.m_isAvailable))) ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite));
					MenuUtils.truncateTextfield(_local_5.description, 7, (((this.m_isLocked) || (!(this.m_isAvailable))) ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite));
				}

			}

			if (this.m_useZoomedImage) {
				MenuUtils.setupIcon(_local_5.valueIcon, _arg_1[_local_4].icon, (((this.m_isLocked) || (!(this.m_isAvailable))) ? MenuConstants.COLOR_GREY_MEDIUM : MenuConstants.COLOR_WHITE), true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
			} else {
				MenuUtils.setupIcon(_local_5.valueIcon, _arg_1[_local_4].icon, (((this.m_isLocked) || (!(this.m_isAvailable))) ? MenuConstants.COLOR_GREY_MEDIUM : MenuConstants.COLOR_WHITE), true, false);
			}

			if (this.m_contractState == this.CONTRACT_STATE_COMPLETED) {
				if (_arg_1[_local_4].hardcondition === false) {
					this.setupConditionCompletion(_local_5, _arg_1[_local_4].satisfied);
				}

			}

			if (((_arg_1[_local_4].type == null) && (_arg_1.length == 1))) {
				if (_arg_1[_local_4].header) {
					MenuUtils.setupText(_local_5.header, _arg_1[_local_4].header, 18, MenuConstants.FONT_TYPE_NORMAL, (((this.m_isLocked) || (!(this.m_isAvailable))) ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite));
				}

				if (_arg_1[_local_4].title) {
					MenuUtils.setupText(_local_5.title, _arg_1[_local_4].title, 24, MenuConstants.FONT_TYPE_MEDIUM, (((this.m_isLocked) || (!(this.m_isAvailable))) ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite));
					_local_5.title.autoSize = "left";
					_local_5.title.width = 276;
					_local_5.title.multiline = true;
					_local_5.title.wordWrap = true;
					MenuUtils.truncateTextfield(_local_5.title, 3, (((this.m_isLocked) || (!(this.m_isAvailable))) ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite));
				}

			}

			_local_5.alpha = 0;
			if (_local_2) {
				this.m_newConditionsContainer.push(_local_5);
			} else {
				this.m_conditionsContainer.push(_local_5);
			}

			if (this.m_useZoomedImage) {
				MenuUtils.addDropShadowFilter(_local_5);
			}

			this.m_view.indicator.addChild(_local_5);
			if (((_arg_1[_local_4].type == this.CONDITION_TYPE_KILL) || (_arg_1[_local_4].type == this.CONDITION_TYPE_DEFAULTKILL))) {
				_local_3 = (_local_3 - (MenuConstants.ValueIndicatorHeight + 14));
			}

			_local_4++;
		}

		if (!_local_2) {
			this.showConditions(TILETYPE_CURRENT, 0.2);
		}

	}

	private function showNewIndicator():void {
		this.m_newObjectiveIndicator = new NewObjectiveIndicatorView();
		this.m_newObjectiveIndicator.x = 22;
		this.m_newObjectiveIndicator.alpha = 0;
		this.m_newObjectiveIndicator.icon.scaleX = (this.m_newObjectiveIndicator.icon.scaleY = 0);
		this.m_newObjectiveIndicator.icon.rotation = -90;
		this.m_view.indicator.addChild(this.m_newObjectiveIndicator);
		Animate.legacyTo(this.m_newObjectiveIndicator, 0.2, {"alpha": 1}, Animate.ExpoOut);
		Animate.legacyFrom(this.m_newObjectiveIndicator.bg, 0.3, {"scaleY": 0.25}, Animate.ExpoOut);
		Animate.delay(this.m_newObjectiveIndicator.icon, 0.1, function ():void {
			Animate.legacyTo(m_newObjectiveIndicator.icon, 0.2, {
				"rotation": 0,
				"scaleX": 1,
				"scaleY": 1
			}, Animate.ExpoOut);
		});
	}

	public function showConditions(tileType:String, delay:Number = 0):void {
		var arr:Array;
		var iconCount:int;
		var headerCount:int;
		var titleCount:int;
		var descriptionCount:int;
		var xOffset:Number;
		var index:int;
		if (tileType == TILETYPE_NEW) {
			arr = this.m_newConditionsContainer;
			this.showNewIndicator();
		} else {
			arr = this.m_conditionsContainer;
		}

		this.m_conditionCompletionIndicatorCount = 0;
		iconCount = 0;
		headerCount = 0;
		titleCount = 0;
		descriptionCount = 0;
		xOffset = 15;
		var len:int = arr.length;
		var i:int;
		while (i < len) {
			arr[i].alpha = 1;
			if (this.m_animateConditions) {
				arr[i].valueIcon.scaleX = (arr[i].valueIcon.scaleY = (arr[i].valueIcon.alpha = 0));
				Animate.delay(arr[i].valueIcon, delay, function ():void {
					Animate.legacyTo(arr[iconCount].valueIcon, 0.25, {
						"scaleX": 1,
						"scaleY": 1,
						"alpha": 1
					}, Animate.ExpoOut);
					if (m_conditionCompletionIndicators.length > 0) {
						showConditionCompletion();
					}

					iconCount = (iconCount + 1);
				});
				if (arr[i].description.length > 1) {
					arr[i].description.x = (arr[i].description.x - xOffset);
					arr[i].description.alpha = 0;
					Animate.delay(arr[i].description, (delay + 0.05), function ():void {
						Animate.legacyTo(arr[descriptionCount].description, 0.2, {
							"x": (arr[descriptionCount].description.x + xOffset),
							"alpha": 1
						}, Animate.ExpoOut);
						descriptionCount = (descriptionCount + 1);
					});
				} else {
					arr[i].header.x = (arr[i].header.x - xOffset);
					arr[i].header.alpha = 0;
					arr[i].title.x = (arr[i].title.x - xOffset);
					arr[i].title.alpha = 0;
					arr[i].method.x = (arr[i].method.x - xOffset);
					arr[i].method.alpha = 0;
					Animate.delay(arr[i].header, (delay + 0.05), function ():void {
						Animate.legacyTo(arr[headerCount].header, 0.2, {
							"x": (arr[headerCount].header.x + xOffset),
							"alpha": 1
						}, Animate.ExpoOut);
						headerCount = (headerCount + 1);
					});
					Animate.delay(arr[i].title, (delay + 0.1), function ():void {
						Animate.legacyTo(arr[titleCount].title, 0.2, {
							"x": (arr[titleCount].title.x + xOffset),
							"alpha": 1
						}, Animate.ExpoOut);
						Animate.legacyTo(arr[titleCount].method, 0.2, {
							"x": (arr[titleCount].method.x + xOffset),
							"alpha": 1
						}, Animate.ExpoOut);
						titleCount = (titleCount + 1);
					});
				}

			}

			delay = (delay + 0.1);
			i = (i + 1);
		}

		if (!this.m_animateConditions) {
			index = 0;
			while (index < this.m_conditionCompletionIndicators.length) {
				this.m_conditionCompletionIndicators[index].scaleX = 1;
				this.m_conditionCompletionIndicators[index].scaleY = 1;
				this.m_conditionCompletionIndicators[index].alpha = 1;
				index = (index + 1);
			}

		}

	}

	private function setupConditionCompletion(_arg_1:ConditionIndicatorSmallView, _arg_2:Boolean):void {
		var _local_3:MovieClip;
		if (_arg_2) {
			_local_3 = new KillConditionCompleteIndicatorView();
		} else {
			_local_3 = new KillConditionFailIndicatorView();
		}

		_local_3.x = ((_arg_1.valueIcon.x + (_arg_1.valueIcon.width / 2)) - 5);
		_local_3.y = ((_arg_1.valueIcon.y + (_arg_1.valueIcon.height / 2)) - (_local_3.height / 2));
		_local_3.scaleX = 0;
		_local_3.scaleY = 0;
		_local_3.alpha = 0;
		_arg_1.addChild(_local_3);
		this.m_conditionCompletionIndicators.push(_local_3);
	}

	private function showConditionCompletion():void {
		Animate.delay(this.m_conditionCompletionIndicators[this.m_conditionCompletionIndicatorCount], this.m_conditionCompletionIndicatorDelay, function ():void {
			Animate.legacyTo(m_conditionCompletionIndicators[m_conditionCompletionIndicatorCount], 0.25, {
				"scaleX": 1,
				"scaleY": 1,
				"alpha": 1
			}, Animate.ExpoOut);
			m_conditionCompletionIndicatorCount = (m_conditionCompletionIndicatorCount + 1);
		});
		this.m_conditionCompletionIndicatorDelay = (this.m_conditionCompletionIndicatorDelay + 0.1);
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	private function setupPerks(_arg_1:Array):void {
		var _local_6:MovieClip;
		var _local_2:int = _arg_1.length;
		var _local_3:Number = 5;
		var _local_4:Number = this.m_view.tileIcon.x;
		var _local_5:Number = (((this.m_view.tileIcon.y - (this.m_view.tileIcon.height >> 1)) - (_local_3 * 2)) - 215);
		this.m_perkElements = [];
		var _local_7:int;
		while (_local_7 < _local_2) {
			_local_6 = new iconsAll76x76View();
			MenuUtils.setupIcon(_local_6, _arg_1[_local_7], MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE, 1);
			_local_6.width = (_local_6.height = 32);
			_local_6.x = _local_4;
			_local_6.y = (_local_5 - (_local_6.height >> 1));
			_local_5 = (_local_5 - MenuConstants.perksIconYOffset);
			this.m_perkElements[_local_7] = _local_6;
			this.m_view.addChild(_local_6);
			_local_7++;
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

	private function changeTextColor(_arg_1:uint, _arg_2:uint):void {
		this.m_view.header.textColor = _arg_1;
		this.m_view.title.textColor = _arg_2;
	}

	private function showText(_arg_1:Boolean):void {
		this.m_view.header.visible = _arg_1;
		this.m_view.title.visible = _arg_1;
	}

	private function callTextTicker(_arg_1:Boolean):void {
		var _local_2:int;
		if (this.m_indicatorTextObjArray.length > 0) {
			_local_2 = 0;
			while (_local_2 < this.m_indicatorTextObjArray.length) {
				if (_arg_1) {
					this.m_indicatorTextObjArray[_local_2].textticker.startTextTickerHtml(this.m_indicatorTextObjArray[_local_2].indicatortextfield, this.m_indicatorTextObjArray[_local_2].title);
				} else {
					this.m_indicatorTextObjArray[_local_2].textticker.stopTextTicker(this.m_indicatorTextObjArray[_local_2].indicatortextfield, this.m_indicatorTextObjArray[_local_2].title);
					MenuUtils.truncateTextfield(this.m_indicatorTextObjArray[_local_2].indicatortextfield, 1, MenuConstants.FontColorWhite);
				}

				_local_2++;
			}

		}

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

		this.m_loader = new MenuImageLoader(ControlsMain.isVrModeActive(), this.m_loadOnVisibleOnScreen);
		if (this.m_useZoomedImage) {
			this.m_view.image.addChild(this.m_loader);
		} else {
			this.m_view.imagesmall.addChild(this.m_loader);
		}

		this.m_loader.center = true;
		this.m_loader.loadImage(imagePath, function ():void {
			Animate.legacyTo(m_view.tileDarkBg, 0.3, {"alpha": 0}, Animate.Linear);
			if (m_useZoomedImage) {
				MenuUtils.trySetCacheAsBitmap(m_view.image, true);
				m_view.image.height = MenuConstants.MenuTileLargeHeight;
				m_view.image.scaleX = m_view.image.scaleY;
				if (m_view.image.width < MenuConstants.MenuTileTallWidth) {
					m_view.image.width = MenuConstants.MenuTileTallWidth;
					m_view.image.scaleY = m_view.image.scaleX;
				}

			} else {
				MenuUtils.trySetCacheAsBitmap(m_view.imagesmall, true);
				m_view.imagesmall.height = MenuConstants.MenuTileSmallHeight;
				m_view.imagesmall.scaleX = m_view.imagesmall.scaleY;
				if (m_view.imagesmall.width < MenuConstants.MenuTileSmallWidth) {
					m_view.imagesmall.width = MenuConstants.MenuTileSmallWidth;
					m_view.imagesmall.scaleY = m_view.imagesmall.scaleX;
				}

			}

		});
		this.m_loader.setVisibleOnScreen(this.m_isVisibleOnScreen);
		if (this.m_isLocked) {
			MenuUtils.setColorFilter(this.m_loader, "unknown");
		} else {
			if (this.m_markedForRemoval) {
				MenuUtils.setColorFilter(this.m_loader, "markedforremoval");
			} else {
				if (!this.m_isAvailable) {
					MenuUtils.setColorFilter(this.m_loader, "shop");
				}

			}

		}

	}

	override protected function handleSelectionChange():void {
		var delayTime:Number;
		Animate.complete(this.m_view);
		if (m_loading) {
			return;
		}

		if (m_isSelected) {
			if (!this.m_loadOnVisibleOnScreen) {
				setPopOutScale(this.m_view, true);
				Animate.to(this.m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
			} else {
				delayTime = ((ControlsMain.isVrModeActive()) ? 0.2 : 0.05);
				Animate.delay(this.m_view.dropShadow, delayTime, function ():void {
					setPopOutScale(m_view, true);
					Animate.to(m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
				});
			}

			this.setOverlayColor(true);
			if (this.m_pressable) {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
				this.callTextTicker(true);
			}

		} else {
			setPopOutScale(this.m_view, false);
			Animate.kill(this.m_view.dropShadow);
			this.m_view.dropShadow.alpha = 0;
			this.setOverlayColor(false);
			if (this.m_pressable) {
				MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, ((this.m_markedForRemoval) ? MenuConstants.COLOR_GREY : MenuConstants.COLOR_WHITE), true, false);
				this.callTextTicker(false);
			}

		}

	}

	override public function onUnregister():void {
		var _local_1:int;
		if (this.m_view) {
			Animate.complete(this.m_view.tileDarkBg);
			Animate.complete(this.m_view.tileSelect);
			Animate.kill(this.m_view.dropShadow);
			if (this.m_indicatorTextObjArray.length > 0) {
				_local_1 = 0;
				while (_local_1 < this.m_indicatorTextObjArray.length) {
					this.m_indicatorTextObjArray[_local_1].textticker.stopTextTicker(this.m_indicatorTextObjArray[_local_1].indicatortextfield, this.m_indicatorTextObjArray[_local_1].title);
					this.m_indicatorTextObjArray[_local_1].textticker = null;
					_local_1++;
				}

				this.m_indicatorTextObjArray = [];
			}

			if (this.m_conditionsContainer.length > 0) {
				_local_1 = 0;
				while (_local_1 < this.m_conditionsContainer.length) {
					Animate.kill(this.m_conditionsContainer[_local_1].valueIcon);
					Animate.kill(this.m_conditionsContainer[_local_1].header);
					Animate.kill(this.m_conditionsContainer[_local_1].title);
					Animate.kill(this.m_conditionsContainer[_local_1].description);
					_local_1++;
				}

				this.m_conditionsContainer = [];
			}

			if (this.m_newConditionsContainer.length > 0) {
				_local_1 = 0;
				while (_local_1 < this.m_newConditionsContainer.length) {
					Animate.kill(this.m_newConditionsContainer[_local_1].valueIcon);
					Animate.kill(this.m_newConditionsContainer[_local_1].header);
					Animate.kill(this.m_newConditionsContainer[_local_1].title);
					Animate.kill(this.m_newConditionsContainer[_local_1].description);
					_local_1++;
				}

				this.m_newConditionsContainer = [];
			}

			if (this.m_conditionCompletionIndicators.length > 0) {
				_local_1 = 0;
				while (_local_1 < this.m_conditionCompletionIndicators.length) {
					Animate.kill(this.m_conditionCompletionIndicators[_local_1]);
					_local_1++;
				}

				this.m_conditionCompletionIndicators = [];
			}

			while (this.m_view.indicator.numChildren > 0) {
				this.m_view.indicator.removeChild(this.m_view.indicator.getChildAt(0));
			}

			if (this.m_loader) {
				this.m_loader.cancelIfLoading();
				if (this.m_useZoomedImage) {
					this.m_view.image.removeChild(this.m_loader);
				} else {
					this.m_view.imagesmall.removeChild(this.m_loader);
				}

				this.m_loader = null;
			}

			if (this.m_perkElements.length > 0) {
				_local_1 = 0;
				while (_local_1 < this.m_perkElements.length) {
					removeChild(this.m_perkElements[_local_1]);
					this.m_perkElements[_local_1] = null;
					_local_1++;
				}

				this.m_perkElements = [];
			}

			removeChild(this.m_view);
			this.m_view = null;
		}

		super.onUnregister();
	}

	public function setVisibleOnScreen(_arg_1:Boolean):void {
		this.m_isVisibleOnScreen = _arg_1;
		if (!this.m_loadOnVisibleOnScreen) {
			return;
		}

		if (this.m_loader != null) {
			this.m_loader.setVisibleOnScreen(_arg_1);
		}

		if (this.m_view != null) {
			this.m_view.visible = _arg_1;
		}

	}


}
}//package menu3.basic

