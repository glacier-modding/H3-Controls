// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogTargetObjectives

package menu3.modal {
import basic.DottedLine;

import menu3.MenuImageLoader;

import common.menu.MenuConstants;
import common.menu.MenuUtils;

import flash.display.DisplayObject;

import common.CommonUtils;
import common.menu.ObjectiveUtil;

import flash.display.MovieClip;

import common.Animate;

import flash.text.TextFieldAutoSize;
import flash.text.TextField;

public class ModalDialogTargetObjectives extends ModalDialogContainerBase {

	private const TARGET_IMAGE_WIDTH:Number = 693;
	private const TARGET_IMAGE_HEIGHT:Number = 517;
	private const CONDITION_IMAGE_WIDTH:Number = 315;
	private const CONDITION_IMAGE_HEIGHT:Number = 235;
	private const CONDITION_ICON_TYPE_WEAPON:String = "weapon";
	private const CONDITION_ICON_TYPE_DISGUISE:String = "disguise";
	private const CONDITION_TYPE_DEFAULT_KILL:String = "defaultkill";
	private const CONDITION_TYPE_CUSTOM_KILL:String = "customkill";
	private const CONDITION_TYPE_KILL:String = "kill";
	private const CONDITION_TYPE_SET_PIECE:String = "setpiece";
	private const CONDITION_TYPE_GAME_CHANGER:String = "gamechanger";
	private const CONDITION_TYPE_CUSTOM:String = "custom";
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
	private var m_objectiveType:String;
	private var m_view:ModalDialogTargetObjectivesTileView;
	private var m_scrollingContainer:ModalScrollingContainer;
	private var m_scrollPosX:Number;
	private var m_scrollPosY:Number;
	private var m_scrollWidth:Number;
	private var m_scrollHeight:Number;
	private var m_headerSeparatorLine:DottedLine;
	private var m_targetLoader:MenuImageLoader;
	private var m_weaponLoader:MenuImageLoader;
	private var m_disguiseLoader:MenuImageLoader;
	private var m_objectiveLoader:MenuImageLoader;
	private var m_useConditions:Boolean;
	private var m_showingConditions:Boolean;
	private var m_hasConditions:Boolean = true;
	private var m_conditionTitle:String;
	private var m_conditionIcon:String;
	private var m_conditions:Array = [];
	private var m_hasDescription:Boolean = false;
	private var m_infoTitle:String;
	private var m_infoIcon:String;
	private var m_objectiveTitle:String;
	private var m_objectiveIcon:String;
	private var m_indicatorTextObjArray:Array = [];
	private var m_anyweapon:String;
	private var m_anydisguise:String;
	private var m_killWithAnything:String;
	private var m_briefingFocus:Boolean;
	private var m_isNew:Boolean = false;
	private var m_selectButton:Object;
	private var m_backButton:Object;

	public function ModalDialogTargetObjectives(_arg_1:Object) {
		super(_arg_1);
		m_dialogInformation.IsButtonSelectionEnabled = false;
		m_dialogInformation.AllButtonsClose = false;
		this.m_view = new ModalDialogTargetObjectivesTileView();
		this.m_view.scrollAreaReferenceClip.visible = false;
		addChild(this.m_view);
		this.m_scrollWidth = this.m_view.scrollAreaReferenceClip.width;
		this.m_scrollHeight = this.m_view.scrollAreaReferenceClip.height;
		this.m_scrollPosX = this.m_view.scrollAreaReferenceClip.x;
		this.m_scrollPosY = this.m_view.scrollAreaReferenceClip.y;
		this.m_headerSeparatorLine = new DottedLine(this.m_scrollWidth, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		this.m_headerSeparatorLine.name = "m_headerSeparatorLine";
		this.m_headerSeparatorLine.x = this.m_scrollPosX;
		this.m_headerSeparatorLine.y = (this.m_scrollPosY - 25);
		this.m_view.addChild(this.m_headerSeparatorLine);
		this.createScrollContainer();
	}

	override public function hide():void {
		this.m_scrollingContainer.onUnregister();
		super.hide();
	}

	override public function getModalWidth():Number {
		return (1406);
	}

	override public function getModalHeight():Number {
		return (517);
	}

	override public function onSetData(data:Object):void {
		var nonAnyConditions:Array;
		super.onSetData(data);
		this.m_objectiveType = data.type;
		this.m_contractType = data.objective.contracttype;
		this.m_useConditions = ((data.useconditions) || (data.objective.displayaskill));
		this.m_briefingFocus = data.objective.briefingfocus;
		this.m_infoTitle = data.infotitle;
		this.m_infoIcon = data.infoicon;
		this.m_conditionTitle = data.conditionstitle;
		this.m_conditionIcon = data.conditionsicon;
		this.m_objectiveTitle = data.objective.title;
		this.m_objectiveIcon = data.objective.icon;
		this.m_anydisguise = data.objective.anydisguise;
		this.m_anyweapon = data.objective.anyweapon;
		this.m_killWithAnything = data.objective.killwithanything;
		var preferDescription:Boolean = data.preferdescription;
		var descriptionText:String;
		if (((data.objective.longdescription) && (data.objective.longdescription.length > 1))) {
			descriptionText = data.objective.longdescription;
			this.m_hasDescription = true;
		} else {
			if (data.description) {
				descriptionText = data.description;
				this.m_hasDescription = true;
			}

		}

		if (((this.m_briefingFocus) && (!(this.m_hasDescription)))) {
			descriptionText = data.objective.conditions[0].summary;
			this.m_hasDescription = true;
		}

		if (descriptionText != null) {
			this.createDescriptionText(descriptionText);
		}

		if (this.m_useConditions) {
			this.m_showingConditions = true;
		}

		this.m_targetLoader = new MenuImageLoader();
		this.m_weaponLoader = new MenuImageLoader();
		this.m_disguiseLoader = new MenuImageLoader();
		this.m_objectiveLoader = new MenuImageLoader();
		this.m_view.targetImage.addChild(this.m_targetLoader);
		this.m_targetLoader.center = false;
		this.m_weaponLoader.center = false;
		this.m_disguiseLoader.center = false;
		this.m_objectiveLoader.center = false;
		this.m_targetLoader.loadImage(data.objective.image, function ():void {
			m_targetLoader.getImage().smoothing = true;
			MenuUtils.scaleProportionalByHeight(DisplayObject(m_targetLoader.getImage()), TARGET_IMAGE_HEIGHT);
		});
		if (((this.m_objectiveType == this.CONDITION_TYPE_KILL) || (this.m_objectiveType == this.CONDITION_TYPE_DEFAULT_KILL))) {
			MenuUtils.setupText(this.m_view.targetLabel, this.m_objectiveTitle, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			CommonUtils.changeFontToGlobalIfNeeded(this.m_view.targetLabel);
			MenuUtils.setupIcon(this.m_view.targetIcon, this.m_objectiveIcon, MenuConstants.COLOR_WHITE, true, false);
		} else {
			this.m_view.targetIcon.visible = false;
		}

		var allConditionsAreAny:Boolean = true;
		if (data.objective.displayaskill) {
			this.setConditions(ObjectiveUtil.prepareConditions([]));
		} else {
			if (data.objective.conditions) {
				nonAnyConditions = ObjectiveUtil.prepareConditions(data.objective.conditions, false);
				if (nonAnyConditions.length > 0) {
					allConditionsAreAny = false;
				}

				this.setConditions(ObjectiveUtil.prepareConditions(data.objective.conditions));
			}

		}

		if ((((this.m_showingConditions) && (preferDescription)) && (allConditionsAreAny))) {
			this.m_showingConditions = false;
		}

		this.updateContent();
		var obj:Object = {};
		obj.buttonprompts = data.displaybuttons;
		this.setButtonPrompts(obj);
	}

	private function updateContent():void {
		var _local_2:MovieClip;
		var _local_3:String;
		var _local_4:String;
		var _local_1:Number = 0.1;
		for each (_local_2 in this.m_conditions) {
			Animate.kill(_local_2.header);
			Animate.kill(_local_2.title);
			Animate.kill(_local_2.icon);
			Animate.kill(_local_2);
		}

		_local_3 = this.m_conditionTitle;
		_local_4 = this.m_conditionIcon;
		if ((((this.m_showingConditions) && (this.m_hasConditions)) && (!(this.m_briefingFocus)))) {
			this.m_scrollingContainer.visible = false;
			for each (_local_2 in this.m_conditions) {
				_local_2.header.alpha = 0;
				_local_2.header.x = 30;
				_local_2.title.alpha = 0;
				_local_2.title.x = 30;
				_local_2.method.alpha = 0;
				_local_2.method.x = 30;
				_local_2.icon.alpha = 0;
				_local_2.icon.scaleX = (_local_2.icon.scaleY = 0);
				Animate.delay(_local_2, _local_1, this.showCondition, _local_2, _local_1);
				_local_1 = (_local_1 + 0.05);
			}

		} else {
			if (this.m_hasDescription) {
				_local_3 = this.m_objectiveTitle;
				_local_4 = this.m_objectiveIcon;
				if (!this.m_briefingFocus) {
					if (((this.m_objectiveType == this.CONDITION_TYPE_KILL) || (this.m_objectiveType == this.CONDITION_TYPE_DEFAULT_KILL))) {
						_local_3 = this.m_infoTitle;
						_local_4 = this.m_infoIcon;
					}

				}

				this.m_scrollingContainer.visible = true;
				for each (_local_2 in this.m_conditions) {
					_local_2.visible = false;
				}

			}

		}

		MenuUtils.setupText(this.m_view.infoLabel, _local_3, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.shrinkTextToFit(this.m_view.infoLabel, (this.m_scrollWidth - (this.m_view.infoLabel.x - this.m_scrollPosX)), -1);
		MenuUtils.setupIcon(this.m_view.infoIcon, _local_4, MenuConstants.COLOR_WHITE, true, false);
	}

	private function setConditions(_arg_1:Array):void {
		var _local_5:ModalKillCondition;
		this.m_indicatorTextObjArray = [];
		var _local_2:int = this.m_scrollPosX;
		var _local_3:int = _arg_1.length;
		var _local_4:int;
		while (_local_4 < _local_3) {
			_local_5 = new ModalKillCondition();
			this.m_conditions.push(_local_5);
			_local_5.x = _local_2;
			_local_5.y = this.m_scrollPosY;
			MenuUtils.setupIcon(_local_5.icon, _arg_1[_local_4].icon, MenuConstants.COLOR_WHITE, true, false);
			if (((_arg_1[_local_4].type == this.CONDITION_TYPE_KILL) || (_arg_1[_local_4].type == this.CONDITION_TYPE_DEFAULT_KILL))) {
				ObjectiveUtil.setupConditionIndicator(_local_5, _arg_1[_local_4], this.m_indicatorTextObjArray, MenuConstants.FontColorWhite);
				this.setConditionImages(_arg_1[_local_4], _local_5);
			} else {
				_local_5.description.autoSize = TextFieldAutoSize.LEFT;
				_local_5.description.width = 270;
				_local_5.description.multiline = true;
				_local_5.description.wordWrap = true;
				MenuUtils.setupText(_local_5.description, _arg_1[_local_4].summary, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
				MenuUtils.truncateTextfield(_local_5.description, 9, MenuConstants.FontColorWhite);
				if (_arg_1[_local_4].type == this.CONDITION_TYPE_SET_PIECE) {
					this.m_hasConditions = false;
					this.setConditionImages(_arg_1[_local_4], _local_5);
				} else {
					if (_arg_1[_local_4].type == this.CONDITION_TYPE_CUSTOM_KILL) {
						this.setConditionImages(_arg_1[_local_4], _local_5);
					}

				}

			}

			this.m_view.addChild(_local_5);
			if (((_arg_1[_local_4].type == this.CONDITION_TYPE_KILL) || (_arg_1[_local_4].type == this.CONDITION_TYPE_DEFAULT_KILL))) {
				_local_2 = (_local_2 + (this.CONDITION_IMAGE_WIDTH + (this.m_scrollWidth - (this.CONDITION_IMAGE_WIDTH * 2))));
			}

			_local_4++;
		}

	}

	private function setConditionImages(condition:Object, conditionView:ModalKillCondition):void {
		var imgLoader:MenuImageLoader;
		var defaultImage:String = this.getDefaultImage(condition.icon);
		imgLoader = this.getImageLoader(condition.icon);
		imgLoader.loadImage(((condition.image) ? condition.image : defaultImage), function ():void {
			imgLoader.getImage().smoothing = true;
			MenuUtils.scaleProportionalByHeight(imgLoader.getImage(), CONDITION_IMAGE_HEIGHT);
		});
		conditionView.image.addChild(imgLoader);
	}

	private function showCondition(_arg_1:Object, _arg_2:Number):void {
		_arg_1.visible = true;
		Animate.to(_arg_1.icon, 0.25, 0, {
			"scaleX": 1,
			"scaleY": 1,
			"alpha": 1
		}, Animate.ExpoOut);
		Animate.to(_arg_1.header, 0.2, 0.05, {
			"alpha": 1,
			"x": 45
		}, Animate.ExpoOut);
		Animate.to(_arg_1.title, 0.2, 0.1, {
			"alpha": 1,
			"x": 45
		}, Animate.ExpoOut);
		Animate.to(_arg_1.method, 0.2, 0.1, {
			"alpha": 1,
			"x": 45
		}, Animate.ExpoOut);
	}

	private function setButtonPrompts(_arg_1:Object):void {
		if (_arg_1.buttonprompts) {
			this.m_selectButton = _arg_1.buttonprompts[0];
			this.m_backButton = _arg_1.buttonprompts[1];
		}

		this.updateButtonPrompts();
	}

	override public function updateButtonPrompts():void {
		this.m_view.buttonPrompts.removeChildren();
		this.m_view.selectButtonPrompt.removeChildren();
		var _local_1:Object = {};
		_local_1.buttonprompts = [this.m_backButton];
		addMouseEventListeners(this.m_view.buttonPrompts, 1);
		MenuUtils.parsePrompts(_local_1, null, this.m_view.buttonPrompts);
		_local_1.buttonprompts = [this.m_selectButton];
		if ((((!(this.m_hasDescription)) || (!(this.m_hasConditions))) || (this.m_briefingFocus))) {
			this.m_view.selectButtonPrompt.visible = false;
		} else {
			addMouseEventListeners(this.m_view.selectButtonPrompt, 0);
		}

		MenuUtils.parsePrompts(_local_1, null, this.m_view.selectButtonPrompt);
	}

	override public function onButtonPressed(_arg_1:Number):void {
		super.onButtonPressed(_arg_1);
		if (((_arg_1 == 0) && (this.m_useConditions))) {
			this.m_showingConditions = (!(this.m_showingConditions));
			this.updateContent();
		}

	}

	private function getImageLoader(_arg_1:String):MenuImageLoader {
		switch (_arg_1) {
			case this.CONDITION_ICON_TYPE_WEAPON:
				return (this.m_weaponLoader);
			case this.CONDITION_ICON_TYPE_DISGUISE:
				return (this.m_disguiseLoader);
			default:
				return (this.m_objectiveLoader);
		}

	}

	private function getDefaultImage(_arg_1:String):String {
		switch (_arg_1) {
			case this.CONDITION_ICON_TYPE_WEAPON:
				return (this.m_anyweapon);
			case this.CONDITION_ICON_TYPE_DISGUISE:
				return (this.m_anydisguise);
			default:
				return (this.m_killWithAnything);
		}

	}

	private function createDescriptionText(_arg_1:String):void {
		var _local_2:TextField = new TextField();
		_local_2.autoSize = TextFieldAutoSize.LEFT;
		_local_2.width = this.m_scrollWidth;
		_local_2.multiline = true;
		_local_2.wordWrap = true;
		_local_2.selectable = false;
		MenuUtils.setupText(_local_2, _arg_1, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(_local_2);
		this.m_scrollingContainer.appendEntry(_local_2, false, _local_2.height);
	}

	private function createScrollContainer():void {
		if (this.m_scrollingContainer != null) {
			this.m_view.removeChild(this.m_scrollingContainer);
			this.m_scrollingContainer = null;
		}

		var _local_1:Number = 30;
		this.m_scrollingContainer = new ModalScrollingContainer((this.m_scrollWidth + _local_1), this.m_scrollHeight, _local_1, true, "targetobjectives");
		this.m_view.addChild(this.m_scrollingContainer);
		this.m_scrollingContainer.x = this.m_scrollPosX;
		this.m_scrollingContainer.y = this.m_scrollPosY;
		this.m_scrollingContainer.visible = false;
		addMouseWheelEventListener(this.m_scrollingContainer);
	}

	override public function onScroll(_arg_1:Number, _arg_2:Boolean):void {
		super.onScroll(_arg_1, _arg_2);
		this.m_scrollingContainer.scroll(_arg_1, _arg_2);
	}


}
}//package menu3.modal

