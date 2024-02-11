// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.VitalInfoBar

package hud.evergreen {
import common.BaseControl;

import flash.display.Sprite;

import common.Localization;
import common.Animate;

import flash.display.MovieClip;

public class VitalInfoBar extends BaseControl {

	public static const ANIMFLAG_POSITIONS_NO_SLIDE:uint = (1 << 0);
	public static const ANIMFLAG_ASSASSIN_LABEL_NO_FLASH:uint = (1 << 1);
	public static const ANIMFLAG_LOOKOUT_LABEL_NO_FLASH:uint = (1 << 2);
	public static const ANIMFLAG_TERRITORY_LABEL_NO_FLASH:uint = (1 << 3);
	public static const ANIMFLAG_PRESTIGE_LABEL_NO_FLASH:uint = (1 << 4);

	private var m_view:Sprite = new Sprite();
	private var m_assassinBar:EvergreenVitalInfoBar_view = new EvergreenVitalInfoBar_view();
	private var m_lookoutBar:EvergreenVitalInfoBar_view = new EvergreenVitalInfoBar_view();
	private var m_allertedTerriBar:EvergreenVitalInfoBar_view = new EvergreenVitalInfoBar_view();
	private var m_prestigeBar:EvergreenVitalInfoBar_view = new EvergreenVitalInfoBar_view();
	private var m_assassin_near:Boolean = false;
	private var m_assassin_allerted:Boolean = false;
	private var m_lookout_near:Boolean = false;
	private var m_lookout_allerted:Boolean = false;
	private var m_allerted_territory:Boolean = false;
	private var m_prestige_missing:Boolean = false;
	private var m_animFlags:uint = 0;
	private var str_assassin_near:String = Localization.get("Evergreen_Hud_messages_AssassinClose_TITLE");
	private var str_assassin_alerted:String = Localization.get("Evergreen_Hud_messages_AssassinAlerted_TITLE");
	private var str_lookout_near:String = Localization.get("Evergreen_Hud_messages_LookoutClose_TITLE");
	private var str_lookout_alerted:String = Localization.get("Evergreen_Hud_messages_LookoutAlerted_TITLE");
	private var str_allerted_territory:String = Localization.get("Evergreen_Hud_messages_TerritorytAlerted_TITLE");
	private var str_prestige_missing:String = Localization.get("Evergreen_Hud_messages_PrestigeMissing_TITLE");
	private var m_textDuration:Number = 5;
	private var m_verticalSpacing:Number = 28;

	public function VitalInfoBar() {
		this.m_view.name = "VitalInfoBar";
		addChild(this.m_view);
		this.m_assassinBar.name = "m_assassinBar";
		this.m_assassinBar.gotoAndStop("assassin_near");
		this.m_assassinBar.visible = false;
		this.m_assassinBar.flash_mc.visible = false;
		this.m_assassinBar.alpha = 0;
		this.m_lookoutBar.name = "m_lookoutBar";
		this.m_lookoutBar.gotoAndStop("lookout_near");
		this.m_lookoutBar.visible = false;
		this.m_lookoutBar.flash_mc.visible = false;
		this.m_lookoutBar.alpha = 0;
		this.m_allertedTerriBar.name = "m_allertedTerriBar";
		this.m_allertedTerriBar.gotoAndStop("allerted");
		this.m_allertedTerriBar.visible = false;
		this.m_allertedTerriBar.flash_mc.visible = false;
		this.m_allertedTerriBar.alpha = 1;
		this.m_prestigeBar.name = "m_prestigeBar";
		this.m_prestigeBar.gotoAndStop("prestige_incomplete");
		this.m_prestigeBar.visible = false;
		this.m_prestigeBar.flash_mc.visible = false;
		this.m_prestigeBar.alpha = 0;
		this.m_view.addChild(this.m_allertedTerriBar);
		this.m_view.addChild(this.m_assassinBar);
		this.m_view.addChild(this.m_lookoutBar);
		this.m_view.addChild(this.m_prestigeBar);
	}

	public function set animationFlags(_arg_1:uint):void {
		this.m_animFlags = _arg_1;
	}

	public function get animationFlags():uint {
		return (this.m_animFlags);
	}

	private function updatePositions():void {
		var yPos:Number = 0;
		var noSlide:Boolean = Boolean((this.m_animFlags & ANIMFLAG_POSITIONS_NO_SLIDE));
		this.m_allertedTerriBar.visible = this.m_allerted_territory;
		yPos = ((this.m_allerted_territory) ? -(this.m_verticalSpacing) : 0);
		if (((this.m_assassin_near) || (this.m_assassin_allerted))) {
			this.m_assassinBar.visible = true;
			if (noSlide) {
				this.m_assassinBar.alpha = 1;
				this.m_assassinBar.y = yPos;
			} else {
				Animate.to(this.m_assassinBar, 0.2, 0, {
					"alpha": 1,
					"y": yPos
				}, Animate.SineInOut);
			}

			yPos = (yPos - this.m_verticalSpacing);
		} else {
			Animate.to(this.m_assassinBar, 0.4, 0, {"alpha": 0}, Animate.SineInOut, function ():void {
				m_assassinBar.visible = false;
			});
		}

		if (((this.m_lookout_near) || (this.m_lookout_allerted))) {
			this.m_lookoutBar.visible = true;
			if (noSlide) {
				this.m_lookoutBar.alpha = 1;
				this.m_lookoutBar.y = yPos;
			} else {
				Animate.to(this.m_lookoutBar, 0.2, ((((this.m_assassin_near) || (this.m_assassin_allerted)) || (this.m_prestige_missing)) ? 0 : 0.3), {
					"alpha": 1,
					"y": yPos
				}, Animate.SineInOut);
			}

			yPos = (yPos - this.m_verticalSpacing);
		} else {
			Animate.to(this.m_lookoutBar, 0.4, 0, {
				"alpha": 0,
				"y": yPos
			}, Animate.SineInOut, function ():void {
				m_lookoutBar.visible = false;
			});
		}

		if (this.m_prestige_missing) {
			this.m_prestigeBar.visible = true;
			if (noSlide) {
				this.m_prestigeBar.alpha = 1;
				this.m_prestigeBar.y = yPos;
			} else {
				Animate.to(this.m_prestigeBar, 0.2, (((((this.m_assassin_near) || (this.m_assassin_allerted)) || (this.m_lookout_near)) || (this.m_lookout_allerted)) ? 0 : 0.3), {
					"alpha": 1,
					"y": yPos
				}, Animate.SineInOut);
			}

		} else {
			Animate.to(this.m_prestigeBar, 0.4, 0, {
				"alpha": 0,
				"y": yPos
			}, Animate.SineInOut, function ():void {
				m_prestigeBar.visible = false;
			});
		}

	}

	private function updateLabel(bar_mc:EvergreenVitalInfoBar_view, txt:String, noFlash:Boolean, shrink:Boolean = true):void {
		bar_mc.label_txt.text = txt;
		bar_mc.label_txt.alpha = 1;
		bar_mc.label_txt.visible = true;
		if (noFlash) {
			bar_mc.icon_mc.scaleX = (bar_mc.icon_mc.scaleY = 1);
		} else {
			bar_mc.icon_mc.scaleX = (bar_mc.icon_mc.scaleY = 1.5);
			Animate.to(bar_mc.icon_mc, 0.4, 0, {
				"scaleX": 1,
				"scaleY": 1
			}, Animate.SineOut);
		}

		var barWidth:Number = ((bar_mc.label_txt.x + bar_mc.label_txt.textWidth) + 16);
		if (noFlash) {
			if (shrink) {
				bar_mc.label_txt.visible = false;
				bar_mc.back_mc.width = 39;
			} else {
				bar_mc.back_mc.width = barWidth;
			}

		} else {
			bar_mc.back_mc.width = (barWidth + (this.m_verticalSpacing * 2));
			Animate.to(bar_mc.back_mc, 0.3, 0, {"width": barWidth}, Animate.SineOut, this.flashBar, bar_mc, 3);
			if (((this.m_textDuration > 0) && (shrink))) {
				Animate.to(bar_mc.label_txt, 0.1, this.m_textDuration, {"alpha": 0}, Animate.SineOut, function ():void {
					bar_mc.label_txt.visible = false;
					Animate.to(bar_mc.back_mc, 0.5, 0, {"width": 39}, Animate.SineOut);
				});
			}

		}

	}

	private function flashBar(_arg_1:MovieClip, _arg_2:Number):void {
		if (_arg_2 > 0) {
			_arg_1.flash_mc.visible = true;
			_arg_1.flash_mc.x = -6;
			_arg_1.flash_mc.y = -6;
			_arg_1.flash_mc.width = (_arg_1.back_mc.width + 12);
			_arg_1.flash_mc.height = (23 + 12);
			_arg_1.flash_mc.alpha = 0.7;
			Animate.to(_arg_1.flash_mc, 0.4, 0, {
				"x": -2,
				"y": -2,
				"width": (_arg_1.back_mc.width + 4),
				"height": (23 + 4),
				"alpha": 0.2
			}, Animate.ExpoInOut, this.flashBar, _arg_1, (_arg_2 - 1));
		} else {
			Animate.kill(_arg_1.flash_mc);
			_arg_1.flash_mc.visible = false;
		}

	}

	public function set textShowDuration(_arg_1:Number):void {
		this.m_textDuration = _arg_1;
	}

	public function onSetData(_arg_1:Object):void {
		var _local_2:Boolean;
		if (_arg_1.isAllertedTerritory != this.m_allerted_territory) {
			this.m_allerted_territory = _arg_1.isAllertedTerritory;
			if (this.m_allerted_territory) {
				this.updateLabel(this.m_allertedTerriBar, this.str_allerted_territory, Boolean((this.m_animFlags & ANIMFLAG_TERRITORY_LABEL_NO_FLASH)));
			}

			_local_2 = true;
		}

		if (_arg_1.isAssassinNearby != this.m_assassin_near) {
			this.m_assassin_near = _arg_1.isAssassinNearby;
			if (((!(this.m_assassin_allerted)) && (this.m_assassin_near))) {
				this.m_assassinBar.gotoAndStop("assassin_near");
				this.updateLabel(this.m_assassinBar, this.str_assassin_near, Boolean((this.m_animFlags & ANIMFLAG_ASSASSIN_LABEL_NO_FLASH)));
			}

			_local_2 = true;
		}

		if (_arg_1.isAssassinAlerted != this.m_assassin_allerted) {
			this.m_assassin_allerted = _arg_1.isAssassinAlerted;
			if (this.m_assassin_allerted) {
				this.m_assassinBar.gotoAndStop("assassin_alert");
				this.updateLabel(this.m_assassinBar, this.str_assassin_alerted, Boolean((this.m_animFlags & ANIMFLAG_ASSASSIN_LABEL_NO_FLASH)));
			}

			if (((!(this.m_assassin_allerted)) && (this.m_assassin_near))) {
				this.m_assassinBar.gotoAndStop("assassin_near");
				this.updateLabel(this.m_assassinBar, this.str_assassin_near, Boolean((this.m_animFlags & ANIMFLAG_ASSASSIN_LABEL_NO_FLASH)));
			}

			_local_2 = true;
		}

		if (_arg_1.isLookoutNearby != this.m_lookout_near) {
			this.m_lookout_near = _arg_1.isLookoutNearby;
			if (((!(this.m_lookout_allerted)) && (this.m_lookout_near))) {
				this.m_lookoutBar.gotoAndStop("lookout_near");
				this.updateLabel(this.m_lookoutBar, this.str_lookout_near, Boolean((this.m_animFlags & ANIMFLAG_LOOKOUT_LABEL_NO_FLASH)));
			}

			_local_2 = true;
		}

		if (_arg_1.isLookoutAlerted != this.m_lookout_allerted) {
			this.m_lookout_allerted = _arg_1.isLookoutAlerted;
			if (this.m_lookout_allerted) {
				this.m_lookoutBar.gotoAndStop("lookout_alert");
				this.updateLabel(this.m_lookoutBar, this.str_lookout_alerted, Boolean((this.m_animFlags & ANIMFLAG_LOOKOUT_LABEL_NO_FLASH)));
			}

			if (((!(this.m_lookout_allerted)) && (this.m_lookout_near))) {
				this.m_lookoutBar.gotoAndStop("lookout_near");
				this.updateLabel(this.m_lookoutBar, this.str_lookout_near, Boolean((this.m_animFlags & ANIMFLAG_LOOKOUT_LABEL_NO_FLASH)));
			}

			_local_2 = true;
		}

		if (_arg_1.isPrestigeObjectiveActive != this.m_prestige_missing) {
			this.m_prestige_missing = _arg_1.isPrestigeObjectiveActive;
			if (this.m_prestige_missing) {
				this.m_prestigeBar.gotoAndStop("prestige_incomplete");
				this.updateLabel(this.m_prestigeBar, this.str_prestige_missing, Boolean((this.m_animFlags & ANIMFLAG_PRESTIGE_LABEL_NO_FLASH)), false);
			}

			_local_2 = true;
		}

		if (_local_2) {
			this.updatePositions();
		}

	}


}
}//package hud.evergreen

