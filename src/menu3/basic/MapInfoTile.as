// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.MapInfoTile

package menu3.basic {
import menu3.MenuElementBase;
import menu3.MenuImageLoader;

import flash.display.MovieClip;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.events.MouseEvent;

import common.Animate;
import common.CommonUtils;
import common.menu.ObjectiveUtil;
import common.Localization;

import flash.text.TextFieldAutoSize;
import flash.display.Sprite;
import flash.text.*;

public dynamic class MapInfoTile extends MenuElementBase {

	private const IMAGE_WIDTH:Number = 350;
	private const IMAGE_HEIGHT:Number = 261;
	private const CONDITION_TYPE_KILL:String = "kill";
	private const CONDITION_TYPE_CUSTOMKILL:String = "customkill";
	private const CONDITION_TYPE_DEFAULTKILL:String = "defaultkill";
	private const CONDITION_TYPE_SETPIECE:String = "setpiece";
	private const CONDITION_TYPE_CUSTOM:String = "custom";
	private const CONDITION_TYPE_GAMECHANGER:String = "gamechanger";
	private const CONDITION_TYPE_STASHPOINT_ITEM:String = "stashpointitem";
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

	private var m_contractType:String;
	private var m_view:MapInfoTileView;
	private var m_loader:MenuImageLoader;
	private var m_toggleField:MovieClip;
	private var m_toggleFieldOrigX:Number = 0;
	private var m_toggleFieldHiddenX:Number = 0;
	private var m_indicatorTextObjArray:Array = [];
	private var m_conditionsYOffset:int = 0;
	private var m_initialTileBgHeight:Number;
	private var m_initialIndicatorBgHeight:Number;
	private var m_sendEventWithValue:Function = null;

	public function MapInfoTile(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new MapInfoTileView();
		this.m_view.alpha = 0;
		this.m_view.visible = false;
		this.m_view.tileBg.alpha = 0;
		this.m_toggleField = this.m_view.togglefield;
		this.m_toggleField.alpha = 0;
		this.m_initialTileBgHeight = this.m_view.tileBg.height;
		this.m_initialIndicatorBgHeight = this.m_view.indicatorbg.height;
		MenuUtils.setColor(this.m_view.indicatorbg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
		this.m_toggleField.toggleIconLeft.addEventListener(MouseEvent.MOUSE_UP, this.handleToggleIconLeftMouseUp);
		this.m_toggleField.toggleIconRight.addEventListener(MouseEvent.MOUSE_UP, this.handleToggleIconRightMouseUp);
		MenuUtils.setColor(this.m_view.tileDarkBg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
		addChild(this.m_view);
		if (ControlsMain.isVrModeActive()) {
			this.z = -(MenuConstants.VRNotebookMapZOffset);
		}
		;
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.showInfo(_arg_1);
	}

	public function showInfo(_arg_1:Object):void {
		this.m_conditionsYOffset = 0;
		Animate.complete(this.m_view);
		this.m_view.indicator.removeChildren();
		this.m_view.visible = true;
		Animate.to(this.m_view, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
		var _local_2:int = MenuConstants.COLOR_WHITE;
		var _local_3:int = MenuConstants.COLOR_RED;
		switch (_arg_1.icon) {
			case "target":
				_local_2 = MenuConstants.COLOR_WHITE;
				_local_3 = MenuConstants.COLOR_RED;
				break;
			case "objective":
				_local_2 = MenuConstants.COLOR_WHITE;
				_local_3 = MenuConstants.COLOR_BLUE;
				break;
			case "stashpointfull":
				_local_2 = MenuConstants.COLOR_GREY_ULTRA_DARK;
				_local_3 = MenuConstants.COLOR_TURQUOISE;
				break;
		}
		;
		MenuUtils.setupIcon(this.m_view.tileIcon, _arg_1.icon, _local_2, false, true, _local_3);
		MenuUtils.setupTextUpper(this.m_view.header, _arg_1.header, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_view.header, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
		MenuUtils.setupTextUpper(this.m_view.title, _arg_1.title, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_view.title, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
		if (_arg_1.contracttype != undefined) {
			this.m_contractType = _arg_1.contracttype;
		}
		;
		if (_arg_1.location) {
			this.setLocation(_arg_1.location, ((_arg_1.conditions) ? true : false));
		}
		;
		if (_arg_1.displayaskill) {
			this.setConditions(ObjectiveUtil.prepareConditions([]));
		} else {
			if (_arg_1.conditions) {
				this.setConditions(ObjectiveUtil.prepareConditions(_arg_1.conditions));
			}
			;
		}
		;
		var _local_4:int;
		var _local_5:int;
		while (_local_5 < m_children.length) {
			m_children[_local_5].y = (this.getView().height + _local_4);
			_local_4 = (_local_4 + m_children[_local_5].getView().height);
			_local_5++;
		}
		;
		this.setIndex(_arg_1);
		if (_arg_1.image) {
			this.loadImage(_arg_1.image);
		}
		;
	}

	public function hideInfo():void {
		this.m_toggleField.alpha = 0;
		Animate.complete(this.m_view);
		Animate.to(this.m_view, 0.3, 0, {"alpha": 0}, Animate.ExpoOut, function ():void {
			m_view.visible = false;
		});
	}

	public function setIndex(_arg_1:Object):void {
		if (_arg_1.elementcount >= 2) {
			this.setupToggleField(_arg_1.elementindex, _arg_1.elementcount);
			this.m_toggleField.alpha = 1;
		}
		;
	}

	private function setLocation(_arg_1:Object, _arg_2:Boolean):void {
		var _local_3:ConditionIndicatorSmallView = new ConditionIndicatorSmallView();
		_local_3.y = this.m_conditionsYOffset;
		MenuUtils.setupIcon(_local_3.valueIcon, _arg_1.icon, MenuConstants.COLOR_WHITE, true, false);
		MenuUtils.setupTextUpper(_local_3.header, Localization.get("UI_MENU_PAGE_MASTERY_UNLOCKABLE_NAME_LOCATION"), 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(_local_3.header, 1, null, CommonUtils.changeFontToGlobalIfNeeded(_local_3.header));
		MenuUtils.setupTextUpper(_local_3.title, _arg_1.level, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(_local_3.title, 1, null, CommonUtils.changeFontToGlobalIfNeeded(_local_3.title));
		this.m_view.indicator.addChild(_local_3);
		this.m_conditionsYOffset = (this.m_conditionsYOffset + MenuConstants.ValueIndicatorHeight);
	}

	private function setConditions(_arg_1:Array):void {
		var _local_6:ConditionIndicatorSmallView;
		var _local_2:Number = 11;
		var _local_3:int = (this.m_conditionsYOffset + (_local_2 - 2));
		var _local_4:int = _arg_1.length;
		this.m_indicatorTextObjArray = [];
		var _local_5:int;
		while (_local_5 < _local_4) {
			_local_6 = new ConditionIndicatorSmallView();
			_local_6.y = _local_3;
			MenuUtils.setupIcon(_local_6.valueIcon, _arg_1[_local_5].icon, MenuConstants.COLOR_WHITE, true, false);
			if (_arg_1[_local_5].type == this.CONDITION_TYPE_STASHPOINT_ITEM) {
				MenuUtils.setupTextUpper(_local_6.header, Localization.get("UI_MENU_PAGE_LOADOUT_CONTENT"), 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
				MenuUtils.truncateTextfield(_local_6.header, 1, null, CommonUtils.changeFontToGlobalIfNeeded(_local_6.header));
				MenuUtils.setupTextUpper(_local_6.title, _arg_1[_local_5].title, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
				MenuUtils.truncateTextfield(_local_6.title, 1, null, CommonUtils.changeFontToGlobalIfNeeded(_local_6.title));
			} else {
				if (((_arg_1[_local_5].type == this.CONDITION_TYPE_DEFAULTKILL) || (_arg_1[_local_5].type == this.CONDITION_TYPE_KILL))) {
					ObjectiveUtil.setupConditionIndicator(_local_6, _arg_1[_local_5], this.m_indicatorTextObjArray, MenuConstants.FontColorWhite);
				} else {
					if ((((_arg_1[_local_5].type == this.CONDITION_TYPE_CUSTOMKILL) || (_arg_1[_local_5].type == this.CONDITION_TYPE_SETPIECE)) || (_arg_1[_local_5].type == this.CONDITION_TYPE_GAMECHANGER))) {
						_local_6.description.autoSize = TextFieldAutoSize.LEFT;
						_local_6.description.width = 276;
						_local_6.description.multiline = true;
						_local_6.description.wordWrap = true;
						MenuUtils.setupText(_local_6.description, _arg_1[_local_5].summary, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
						MenuUtils.truncateTextfield(_local_6.description, 7, null, CommonUtils.changeFontToGlobalIfNeeded(_local_6.description));
					}
					;
				}
				;
			}
			;
			this.m_view.indicator.addChild(_local_6);
			if ((((_arg_1[_local_5].type == this.CONDITION_TYPE_CUSTOMKILL) || (_arg_1[_local_5].type == this.CONDITION_TYPE_SETPIECE)) || (_arg_1[_local_5].type == this.CONDITION_TYPE_GAMECHANGER))) {
				if (_local_6.description.numLines > 2) {
					_local_3 = (_local_3 + ((_local_6.description.height - MenuConstants.ValueIndicatorHeight) + 12));
				}
				;
			}
			;
			this.m_view.indicatorbg.height = (this.m_initialIndicatorBgHeight + (_local_3 - (_local_2 + 4)));
			this.m_view.tileBg.height = (this.m_initialTileBgHeight + (_local_3 - _local_2));
			this.m_view.tileBg.y = ((this.m_initialTileBgHeight >> 1) + ((_local_3 - (_local_2 + 4)) >> 1));
			if (((_arg_1[_local_5].type == this.CONDITION_TYPE_KILL) || (_arg_1[_local_5].type == this.CONDITION_TYPE_DEFAULTKILL))) {
				_local_3 = (_local_3 + (MenuConstants.ValueIndicatorHeight + ((20 - _local_2) - 2)));
			}
			;
			_local_5++;
		}
		;
	}

	private function loadImage(imagePath:String):void {
		if (this.m_loader != null) {
			this.m_loader.cancelIfLoading();
			this.m_view.image.removeChild(this.m_loader);
			this.m_loader = null;
		}
		;
		this.m_loader = new MenuImageLoader();
		this.m_view.image.addChild(this.m_loader);
		this.m_loader.center = true;
		this.m_loader.loadImage(imagePath, function ():void {
			m_loader.getImage().smoothing = true;
			Animate.to(m_view.tileDarkBg, 0.3, 0, {"alpha": 0}, Animate.Linear);
			MenuUtils.scaleProportionalByWidth(m_view.image, IMAGE_WIDTH);
		});
	}

	public function toggleLeft(_arg_1:Object):void {
		Animate.complete(this.m_toggleField.toggleIconLeft);
		this.setToggleTitle((_arg_1.elementindex + 1).toString(), _arg_1.elementcount);
		this.m_toggleField.toggleIconLeft.alpha = 0.6;
		Animate.to(this.m_toggleField.toggleIconLeft, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
	}

	public function toggleRight(_arg_1:Object):void {
		Animate.complete(this.m_toggleField.toggleIconRight);
		this.setToggleTitle((_arg_1.elementindex + 1).toString(), _arg_1.elementcount);
		this.m_toggleField.toggleIconRight.alpha = 0.6;
		Animate.to(this.m_toggleField.toggleIconRight, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
	}

	private function setupToggleField(_arg_1:int, _arg_2:int):void {
		this.m_toggleField.toggletitle.alpha = 0;
		this.m_toggleField.toggletitle.autoSize = TextFieldAutoSize.RIGHT;
		this.setToggleTitle((_arg_1 + 1).toString(), _arg_2.toString());
		this.m_toggleField.toggleIconLeft.x = ((this.m_toggleField.toggleIconRight.x - this.m_toggleField.toggleIconRight.width) - this.m_toggleField.toggletitle.width);
		this.m_toggleField.toggleIconLeft.alpha = 1;
		this.m_toggleField.toggleIconRight.alpha = 1;
		this.m_toggleField.toggletitle.alpha = 1;
		this.m_toggleFieldOrigX = this.m_toggleField.x;
		this.m_toggleFieldHiddenX = (this.m_toggleField.x - this.m_toggleField.width);
	}

	private function setToggleTitle(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupText(this.m_toggleField.toggletitle, ((_arg_1 + "  /  ") + _arg_2), 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	override public function setEngineCallbacks(_arg_1:Function, _arg_2:Function):void {
		this.m_sendEventWithValue = _arg_2;
	}

	override public function getView():Sprite {
		return (this.m_view.tileBg);
	}

	override public function onUnregister():void {
		var _local_1:int;
		if (this.m_view) {
			Animate.complete(this.m_view);
			if (this.m_indicatorTextObjArray.length > 0) {
				_local_1 = 0;
				while (_local_1 < this.m_indicatorTextObjArray.length) {
					this.m_indicatorTextObjArray[_local_1].textticker.stopTextTicker(this.m_indicatorTextObjArray[_local_1].indicatortextfield, this.m_indicatorTextObjArray[_local_1].title);
					this.m_indicatorTextObjArray[_local_1].textticker = null;
					_local_1++;
				}
				;
				this.m_indicatorTextObjArray = [];
			}
			;
			if (this.m_toggleField) {
				Animate.complete(this.m_toggleField.toggleIconLeft);
				Animate.complete(this.m_toggleField.toggleIconRight);
			}
			;
			if (this.m_loader) {
				this.m_loader.cancelIfLoading();
				this.m_view.image.removeChild(this.m_loader);
				this.m_loader = null;
			}
			;
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}

	override public function handleMouseUp(_arg_1:Function, _arg_2:MouseEvent):void {
		var _local_3:int;
		_arg_2.stopImmediatePropagation();
		if (stage.focus == this) {
			return;
		}
		;
		if (this["_nodedata"]) {
			_local_3 = (this["_nodedata"]["id"] as int);
			(_arg_1("onElementSelect", _local_3));
		}
		;
	}

	override public function handleMouseDown(_arg_1:Function, _arg_2:MouseEvent):void {
		_arg_2.stopImmediatePropagation();
	}

	private function handleToggleIconLeftMouseUp(_arg_1:MouseEvent):void {
		var _local_2:int;
		if (((this["_nodedata"]) && (!(this.m_sendEventWithValue == null)))) {
			_local_2 = (this["_nodedata"]["id"] as int);
			this.m_sendEventWithValue("onElementPrev", _local_2);
		}
		;
	}

	private function handleToggleIconRightMouseUp(_arg_1:MouseEvent):void {
		var _local_2:int;
		if (((this["_nodedata"]) && (!(this.m_sendEventWithValue == null)))) {
			_local_2 = (this["_nodedata"]["id"] as int);
			this.m_sendEventWithValue("onElementNext", _local_2);
		}
		;
	}


}
}//package menu3.basic

