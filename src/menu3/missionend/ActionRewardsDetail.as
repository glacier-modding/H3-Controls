// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.missionend.ActionRewardsDetail

package menu3.missionend {
import menu3.MenuElementBase;

import flash.display.MovieClip;

import common.Animate;
import common.menu.MenuUtils;
import common.Localization;
import common.menu.MenuConstants;

import basic.DottedLine;

public dynamic class ActionRewardsDetail extends MenuElementBase {

	private static const WIDTH_CATEGORY:Number = 326;
	private static const WIDTH_CATEGORY_TITLE:Number = 227.5;
	private static const WIDTH_CATEGORY_VALUE:Number = 100;
	private static const DX_PADDING:Number = 5;

	private const CATEGORY_ELEMENTS_MAX:int = 20;

	private var m_view:ActionRewardsDetailView;
	private var m_headerMc:MovieClip;
	private var m_infiltrationCategoryMc:MovieClip;
	private var m_eliminationCategoryMc:MovieClip;
	private var m_missionCategoryMc:MovieClip;
	private var m_challengeCategoryMc:MovieClip;
	private var m_actionXPGain:int = 0;
	private var m_actionXPGainInfiltration:int = 0;
	private var m_actionXPGainElimination:int = 0;
	private var m_actionXPGainMission:int = 0;
	private var m_challengeXPGain:int = 0;
	private var m_infiltrationRewards:Array = [];
	private var m_eliminationRewards:Array = [];
	private var m_missionRewards:Array = [];
	private var m_challengeRewards:Array = [];
	private var m_fScaleTextMult:Number = 1;

	public function ActionRewardsDetail(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new ActionRewardsDetailView();
		this.m_headerMc = this.m_view.headerMc;
		this.m_infiltrationCategoryMc = this.m_view.actionCategory1Mc;
		this.m_eliminationCategoryMc = this.m_view.actionCategory2Mc;
		this.m_missionCategoryMc = this.m_view.actionCategory3Mc;
		this.m_challengeCategoryMc = this.m_view.actionCategory4Mc;
		this.m_headerMc.alpha = (this.m_infiltrationCategoryMc.alpha = (this.m_eliminationCategoryMc.alpha = (this.m_missionCategoryMc.alpha = (this.m_challengeCategoryMc.alpha = 0))));
		this.m_headerMc.visible = (this.m_infiltrationCategoryMc.visible = (this.m_eliminationCategoryMc.visible = (this.m_missionCategoryMc.visible = (this.m_challengeCategoryMc.visible = false))));
		addChild(this.m_view);
	}

	override public function onUnregister():void {
		this.killAnimations();
		this.m_view = null;
		super.onUnregister();
	}

	private function killAnimations():void {
		Animate.kill(this.m_headerMc);
		Animate.kill(this.m_infiltrationCategoryMc);
		Animate.kill(this.m_eliminationCategoryMc);
		Animate.kill(this.m_missionCategoryMc);
		Animate.kill(this.m_challengeCategoryMc);
	}

	override public function onSetData(_arg_1:Object):void {
		var _local_2:int;
		var _local_3:Object;
		var _local_4:int;
		super.onSetData(_arg_1);
		this.m_infiltrationRewards.length = 0;
		this.m_eliminationRewards.length = 0;
		this.m_missionRewards.length = 0;
		this.m_challengeRewards.length = 0;
		this.m_actionXPGain = 0;
		this.m_challengeXPGain = 0;
		if (((_arg_1.Challenges) && (_arg_1.Challenges.length > 0))) {
			_local_2 = 0;
			while (_local_2 < _arg_1.Challenges.length) {
				_local_3 = _arg_1.Challenges[_local_2];
				_local_4 = 0;
				if (_local_3.XPGain != undefined) {
					_local_4 = _local_3.XPGain;
				}
				;
				if (_local_3.IsActionReward === true) {
					if (_local_4 > 0) {
						if (this.hasCategoryTag(_local_3, "infiltration")) {
							this.m_infiltrationRewards.push(_local_3);
							this.m_actionXPGainInfiltration = (this.m_actionXPGainInfiltration + _local_4);
						} else {
							if (this.hasCategoryTag(_local_3, "elimination")) {
								this.m_eliminationRewards.push(_local_3);
								this.m_actionXPGainElimination = (this.m_actionXPGainElimination + _local_4);
							} else {
								this.m_missionRewards.push(_local_3);
								this.m_actionXPGainMission = (this.m_actionXPGainMission + _local_4);
							}
							;
						}
						;
						this.m_actionXPGain = (this.m_actionXPGain + _local_4);
					}
					;
				} else {
					if (_local_4 > 0) {
						this.m_challengeRewards.push(_local_3);
						this.m_challengeXPGain = (this.m_challengeXPGain + _local_4);
						this.m_actionXPGain = (this.m_actionXPGain + _local_4);
					}
					;
				}
				;
				_local_2++;
			}
			;
		}
		;
		MenuUtils.setupTextUpper(this.m_headerMc.title, Localization.get("UI_MENU_MISSION_END_SCOREDETAIL_XP_TITLE"), 46, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_headerMc.value, this.formatXpNumber(this.m_actionXPGain), 46, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.m_fScaleTextMult = 1;
		if (this.m_actionXPGainInfiltration > 0) {
			this.setupActionCategory(this.m_infiltrationCategoryMc, Localization.get("UI_MENU_ACTIONREWARD_CATEGORY_INFILTRATION_TITLE"), this.m_actionXPGainInfiltration, this.m_infiltrationRewards);
		}
		;
		if (this.m_actionXPGainElimination > 0) {
			this.setupActionCategory(this.m_eliminationCategoryMc, Localization.get("UI_MENU_ACTIONREWARD_CATEGORY_ELIMINATION_TITLE"), this.m_actionXPGainElimination, this.m_eliminationRewards);
		}
		;
		if (this.m_actionXPGainMission > 0) {
			this.setupActionCategory(this.m_missionCategoryMc, Localization.get("UI_MENU_ACTIONREWARD_CATEGORY_MISSON_TITLE"), this.m_actionXPGainMission, this.m_missionRewards);
		}
		;
		if (this.m_challengeXPGain > 0) {
			this.setupActionCategory(this.m_challengeCategoryMc, Localization.get("UI_MENU_PAGE_PLANNING_CHALLENGES"), this.m_challengeXPGain, this.m_challengeRewards);
		}
		;
		this.rescaleTextInActionCategory(this.m_infiltrationCategoryMc);
		this.rescaleTextInActionCategory(this.m_eliminationCategoryMc);
		this.rescaleTextInActionCategory(this.m_missionCategoryMc);
		this.rescaleTextInActionCategory(this.m_challengeCategoryMc);
		this.repositionAndShow();
	}

	private function setupActionCategory(_arg_1:MovieClip, _arg_2:String, _arg_3:int, _arg_4:Array):void {
		var _local_7:ActionCategoryListElementView;
		_arg_1.visible = true;
		MenuUtils.setupTextUpper(_arg_1.title, _arg_2, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(_arg_1.value, this.formatXpNumber(_arg_3), 25, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		if (((_arg_4 == null) || (_arg_4.length == 0))) {
			return;
		}
		;
		var _local_5:Number = 0;
		var _local_6:Number = 36;
		var _local_8:int = Math.min(_arg_4.length, this.CATEGORY_ELEMENTS_MAX);
		var _local_9:int;
		while (_local_9 < _local_8) {
			_local_7 = new ActionCategoryListElementView();
			_local_7.x = _local_5;
			_local_7.y = _local_6;
			if (_local_9 < (_local_8 - 1)) {
				this.addDottedLine(2, 32, _local_7);
			}
			;
			MenuUtils.setupText(_local_7.title, Localization.get(_arg_4[_local_9].ChallengeName), 16, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupText(_local_7.value, this.formatXpNumber(_arg_4[_local_9].XPGain), 16, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			if ((WIDTH_CATEGORY_TITLE - DX_PADDING) < _local_7.title.textWidth) {
				this.m_fScaleTextMult = Math.min(this.m_fScaleTextMult, ((WIDTH_CATEGORY_TITLE - DX_PADDING) / _local_7.title.textWidth));
			}
			;
			if ((WIDTH_CATEGORY_VALUE - DX_PADDING) < _local_7.value.textWidth) {
				this.m_fScaleTextMult = Math.min(this.m_fScaleTextMult, ((WIDTH_CATEGORY_VALUE - DX_PADDING) / _local_7.value.textWidth));
			}
			;
			_arg_1.addChild(_local_7);
			_local_6 = (_local_6 + 32);
			_local_9++;
		}
		;
	}

	private function rescaleTextInActionCategory(_arg_1:MovieClip):void {
		var _local_3:ActionCategoryListElementView;
		var _local_2:int;
		while (_local_2 < _arg_1.numChildren) {
			_local_3 = (_arg_1.getChildAt(_local_2) as ActionCategoryListElementView);
			if (_local_3 != null) {
				_local_3.title.scaleX = (_local_3.title.scaleX * this.m_fScaleTextMult);
				_local_3.title.scaleY = (_local_3.title.scaleY * this.m_fScaleTextMult);
				_local_3.value.scaleX = (_local_3.value.scaleX * this.m_fScaleTextMult);
				_local_3.value.scaleY = (_local_3.value.scaleY * this.m_fScaleTextMult);
				_local_3.title.width = (WIDTH_CATEGORY_TITLE / this.m_fScaleTextMult);
				_local_3.value.width = (WIDTH_CATEGORY_VALUE / this.m_fScaleTextMult);
				_local_3.value.x = (WIDTH_CATEGORY - WIDTH_CATEGORY_VALUE);
			}
			;
			_local_2++;
		}
		;
	}

	private function repositionAndShow():void {
		var _local_1:Boolean;
		var _local_2:Boolean;
		var _local_3:Number = 0;
		var _local_4:Number = 145;
		var _local_5:Number = 328;
		var _local_6:Number = 20;
		this.killAnimations();
		this.m_headerMc.visible = true;
		Animate.fromTo(this.m_headerMc, 0.2, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
		Animate.addFrom(this.m_headerMc, 0.3, 0, {"x": (this.m_headerMc.x - 20)}, Animate.ExpoOut);
		if (this.m_infiltrationCategoryMc.visible == true) {
			this.m_infiltrationCategoryMc.x = _local_3;
			this.m_infiltrationCategoryMc.y = _local_4;
			Animate.fromTo(this.m_infiltrationCategoryMc, 0.2, 0.1, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.addFrom(this.m_infiltrationCategoryMc, 0.3, 0.1, {"x": (this.m_infiltrationCategoryMc.x - 20)}, Animate.ExpoOut);
			_local_1 = true;
		}
		;
		if (_local_1) {
			_local_3 = (_local_3 + (_local_5 + _local_6));
		}
		;
		if (this.m_eliminationCategoryMc.visible == true) {
			this.m_eliminationCategoryMc.x = _local_3;
			this.m_eliminationCategoryMc.y = _local_4;
			Animate.fromTo(this.m_eliminationCategoryMc, 0.2, 0.15, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.addFrom(this.m_eliminationCategoryMc, 0.3, 0.15, {"x": (this.m_eliminationCategoryMc.x - 20)}, Animate.ExpoOut);
			_local_2 = true;
		}
		;
		if (this.m_missionCategoryMc.visible == true) {
			this.m_missionCategoryMc.x = _local_3;
			if (this.m_eliminationCategoryMc.visible == true) {
				this.m_missionCategoryMc.y = (((this.m_eliminationCategoryMc.y + this.m_eliminationCategoryMc.height) + 64) + 18);
			} else {
				this.m_missionCategoryMc.y = _local_4;
			}
			;
			Animate.fromTo(this.m_missionCategoryMc, 0.2, 0.2, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.addFrom(this.m_missionCategoryMc, 0.3, 0.2, {"x": (this.m_missionCategoryMc.x - 20)}, Animate.ExpoOut);
			_local_2 = true;
		}
		;
		if (_local_2) {
			_local_3 = (_local_3 + (_local_5 + _local_6));
		}
		;
		if (this.m_challengeCategoryMc.visible == true) {
			this.m_challengeCategoryMc.x = _local_3;
			this.m_challengeCategoryMc.y = _local_4;
			Animate.fromTo(this.m_challengeCategoryMc, 0.2, 0.25, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.addFrom(this.m_challengeCategoryMc, 0.3, 0.25, {"x": (this.m_challengeCategoryMc.x - 20)}, Animate.ExpoOut);
		}
		;
	}

	private function hasCategoryTag(_arg_1:Object, _arg_2:String):Boolean {
		var _local_3:Array = _arg_1.ChallengeTags;
		if (((_local_3 == null) || (_local_3.length == 0))) {
			return (false);
		}
		;
		var _local_4:int;
		while (_local_4 < _local_3.length) {
			if (_local_3[_local_4] === _arg_2) {
				return (true);
			}
			;
			_local_4++;
		}
		;
		return (false);
	}

	private function formatXpNumber(_arg_1:int):String {
		return ((MenuUtils.formatNumber(_arg_1) + " ") + Localization.get("UI_PERFORMANCE_MASTERY_XP"));
	}

	private function addDottedLine(_arg_1:int, _arg_2:int, _arg_3:MovieClip):void {
		var _local_4:DottedLine = new DottedLine(WIDTH_CATEGORY, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 1, 2);
		_local_4.x = _arg_1;
		_local_4.y = _arg_2;
		_arg_3.addChild(_local_4);
	}


}
}//package menu3.missionend

