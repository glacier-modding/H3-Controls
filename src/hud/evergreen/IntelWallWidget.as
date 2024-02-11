// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.IntelWallWidget

package hud.evergreen {
import common.BaseControl;

import basic.DottedLine;

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import common.Localization;
import common.Animate;

import flash.text.TextField;
import flash.display.MovieClip;

public class IntelWallWidget extends BaseControl {

	public static const Agenda_Unknown:int = -1;
	public static const Agenda_HandoverMeeting:int = 0;
	public static const Agenda_BusinessMeeting:int = 1;
	public static const Agenda_SecretMeeting:int = 2;
	public static const Agenda_NoMeeting:int = 3;
	public static const Tell_Unknown:int = -1;
	public static const Tell_Smoker:int = 0;
	public static const Tell_Allergic:int = 1;
	public static const Tell_SweetTooth:int = 2;
	public static const Tell_Bookworm:int = 3;
	public static const Tell_Nervous:int = 4;
	public static const Tell_Dehydrated:int = 5;
	public static const Tell_Foodie:int = 6;
	public static const Look_Unknown:int = -1;
	public static const Look_Glasses:int = 0;
	public static const Look_Earrings:int = 1;
	public static const Look_Necklace:int = 2;
	public static const Look_Watch:int = 3;
	public static const Look_Hat:int = 4;
	public static const Look_Tattoo:int = 5;
	public static const Look_BlackHair:int = 6;
	public static const Look_BrownHair:int = 7;
	public static const Look_BlondeHair:int = 8;
	public static const Look_GreyHair:int = 9;
	public static const Look_RedHair:int = 10;
	public static const Look_NoHair:int = 11;

	private var analysingDots:Array = ["", ".", "..", "...", "..", "."];
	private var analysingIcons:Array = ["Glasses", "Earrings", "Necklace", "Hat", "Tattoo", "Hair", "Bald"];
	private var m_view:IntelWallView = new IntelWallView();
	private var m_lineSeparator1:DottedLine = new DottedLine(802, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 2, 3);
	private var m_lineSeparator2:DottedLine = new DottedLine(802, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 2, 3);
	private var m_lineSeparator3:DottedLine = new DottedLine(802, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 2, 3);
	private var m_lineSeparator4:DottedLine = new DottedLine(1286, MenuConstants.COLOR_WHITE, DottedLine.TYPE_HORIZONTAL, 2, 3);

	public function IntelWallWidget() {
		addChild(this.m_view);
		this.m_view.dottedLine1_mc.addChild(this.m_lineSeparator1);
		this.m_view.dottedLine2_mc.addChild(this.m_lineSeparator2);
		this.m_view.dottedLine3_mc.addChild(this.m_lineSeparator3);
		this.m_view.dottedLine4_mc.addChild(this.m_lineSeparator4);
	}

	public function onSetData(_arg_1:Object):void {
		MenuUtils.setupText(this.m_view.headline1_txt, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_LEADERTITLE").toUpperCase(), 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.headline2_txt, _arg_1.lstrLeaderCodename.toUpperCase(), 68, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.shrinkTextToFit(this.m_view.headline2_txt, this.m_view.headline2_txt.width, -1);
		MenuUtils.setupText(this.m_view.crime1_txt, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_CRIMETITLE").toUpperCase(), 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_view.crime2_txt, _arg_1.lstrCrimeSector.toUpperCase(), 68, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		MenuUtils.shrinkTextToFit(this.m_view.crime2_txt, this.m_view.crime2_txt.width, -1);
		switch (_arg_1.idCrimeSector) {
			case EvergreenUtils.CRIMESECTOR_ARMSTRAFFICKING:
				this.m_view.crimeIcon_mc.gotoAndStop("crime_arms");
				break;
			case EvergreenUtils.CRIMESECTOR_ASSASSINATION:
				this.m_view.crimeIcon_mc.gotoAndStop("crime_assassin");
				break;
			case EvergreenUtils.CRIMESECTOR_BIGPHARMA:
				this.m_view.crimeIcon_mc.gotoAndStop("crime_pharma");
				break;
			case EvergreenUtils.CRIMESECTOR_ECOCRIME:
				this.m_view.crimeIcon_mc.gotoAndStop("crime_eco");
				break;
			case EvergreenUtils.CRIMESECTOR_ESPIONAGE:
				this.m_view.crimeIcon_mc.gotoAndStop("crime_espionage");
				break;
			case EvergreenUtils.CRIMESECTOR_ORGANTRAFFICKING:
				this.m_view.crimeIcon_mc.gotoAndStop("crime_organ");
				break;
			case EvergreenUtils.CRIMESECTOR_PSYOPS:
				this.m_view.crimeIcon_mc.gotoAndStop("crime_psyops");
				break;
			case EvergreenUtils.CRIMESECTOR_SICKGAMES:
				this.m_view.crimeIcon_mc.gotoAndStop("crime_sick");
				break;
			default:
				this.m_view.crimeIcon_mc.gotoAndStop("Questionmark");
		}

		this.setupAgenda(_arg_1.agenda);
		this.setupTell(_arg_1.tellA, this.m_view.tellType2_txt, this.m_view.tellHeadline2_txt, this.m_view.tell2Icon_mc);
		this.setupTell(_arg_1.tellB, this.m_view.tellType3_txt, this.m_view.tellHeadline3_txt, this.m_view.tell3Icon_mc);
		this.setupLook(_arg_1.lookA, this.m_view.visualType1_txt, this.m_view.visualHeadline1_txt, this.m_view.visual1Icon_mc);
		this.setupLook(_arg_1.lookB, this.m_view.visualType2_txt, this.m_view.visualHeadline2_txt, this.m_view.visual2Icon_mc);
		this.setupLook(_arg_1.lookC, this.m_view.visualType3_txt, this.m_view.visualHeadline3_txt, this.m_view.visual3Icon_mc);
		this.setupLook(_arg_1.lookD, this.m_view.visualType4_txt, this.m_view.visualHeadline4_txt, this.m_view.visual4Icon_mc);
		MenuUtils.setupText(this.m_view.processing_txt, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_PROCESSING").toUpperCase(), 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.effectsStop();
		this.effectsStart();
	}

	private function setupAgenda(_arg_1:int):void {
		MenuUtils.setupText(this.m_view.tellType1_txt, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_AGENDATITLE").toUpperCase(), 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		Animate.kill(this.m_view.tellHeadline1_txt);
		Animate.kill(this.m_view.tell1Icon_mc);
		switch (_arg_1) {
			case Agenda_Unknown:
				MenuUtils.setupText(this.m_view.tellHeadline1_txt, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				this.setAnalysingIcon(this.m_view.tell1Icon_mc, this.m_view.tellHeadline1_txt);
				return;
			case Agenda_HandoverMeeting:
				this.m_view.tell1Icon_mc.gotoAndStop("HandoverMeeting");
				MenuUtils.setupText(this.m_view.tellHeadline1_txt, Localization.get("Evergreen_Identifiers_Agenda_Courier_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Agenda_BusinessMeeting:
				this.m_view.tell1Icon_mc.gotoAndStop("BusinessMeeting");
				MenuUtils.setupText(this.m_view.tellHeadline1_txt, Localization.get("Evergreen_Identifiers_Agenda_Business_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Agenda_SecretMeeting:
				this.m_view.tell1Icon_mc.gotoAndStop("SecretMeeting");
				MenuUtils.setupText(this.m_view.tellHeadline1_txt, Localization.get("Evergreen_Identifiers_Agenda_Social_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Agenda_NoMeeting:
				this.m_view.tell1Icon_mc.gotoAndStop("NoMeeting");
				MenuUtils.setupText(this.m_view.tellHeadline1_txt, Localization.get("Evergreen_Identifiers_Agenda_NoMeeting_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			default:
				this.m_view.tell1Icon_mc.gotoAndStop("Questionmark");
				MenuUtils.setupText(this.m_view.tellHeadline1_txt, "", 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		}

	}

	private function setupTell(_arg_1:int, _arg_2:TextField, _arg_3:TextField, _arg_4:MovieClip):void {
		MenuUtils.setupText(_arg_2, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_TELLTITLE").toUpperCase(), 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		Animate.kill(_arg_3);
		Animate.kill(_arg_4);
		switch (_arg_1) {
			case Tell_Unknown:
				MenuUtils.setupText(_arg_3, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				this.setAnalysingIcon(_arg_4, _arg_3);
				return;
			case Tell_Smoker:
				_arg_4.gotoAndStop("Smoker");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Tell_Smoker_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Tell_Allergic:
				_arg_4.gotoAndStop("Allergic");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Tell_Allergic_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Tell_SweetTooth:
				_arg_4.gotoAndStop("SweetTooth");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Tell_Sweettooth_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Tell_Bookworm:
				_arg_4.gotoAndStop("Bookworm");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Tell_Bookworm_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Tell_Nervous:
				_arg_4.gotoAndStop("Nervous");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Tell_Nervous_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Tell_Dehydrated:
				_arg_4.gotoAndStop("Thirsty");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Tell_Thirsty_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Tell_Foodie:
				_arg_4.gotoAndStop("Hungry");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Tell_Hungry_TITLE").toUpperCase(), 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			default:
				_arg_4.gotoAndStop("Questionmark");
				MenuUtils.setupText(_arg_3, "", 36, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		}

	}

	private function setupLook(_arg_1:int, _arg_2:TextField, _arg_3:TextField, _arg_4:MovieClip):void {
		MenuUtils.setupText(_arg_2, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_TELLVISUAL").toUpperCase(), 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		Animate.kill(_arg_3);
		Animate.kill(_arg_4);
		switch (_arg_1) {
			case Look_Unknown:
				MenuUtils.setupText(_arg_3, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				this.setAnalysingIcon(_arg_4, _arg_3);
				return;
			case Look_Glasses:
				_arg_4.gotoAndStop("Glasses");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_Glasses_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_Earrings:
				_arg_4.gotoAndStop("Earrings");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_Earrings_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_Necklace:
				_arg_4.gotoAndStop("Necklace");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_Necklace_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_Hat:
				_arg_4.gotoAndStop("Hat");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_Hat_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_Tattoo:
				_arg_4.gotoAndStop("Tattoo");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_Tattoo_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_BlackHair:
				_arg_4.gotoAndStop("Hair");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_BlackHair_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_BrownHair:
				_arg_4.gotoAndStop("Hair");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_BrownHair_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_BlondeHair:
				_arg_4.gotoAndStop("Hair");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_BlondHair_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_GreyHair:
				_arg_4.gotoAndStop("Hair");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_GreyHair_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_RedHair:
				_arg_4.gotoAndStop("Hair");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_RedHair_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			case Look_NoHair:
				_arg_4.gotoAndStop("Bald");
				MenuUtils.setupText(_arg_3, Localization.get("Evergreen_Identifiers_Look_Bald_TITLE").toUpperCase(), 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				return;
			default:
				_arg_4.gotoAndStop("Questionmark");
				MenuUtils.setupText(_arg_3, "", 28, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
		}

	}

	private function setAnalysingIcon(_arg_1:MovieClip, _arg_2:TextField):void {
		_arg_1.gotoAndStop("Questionmark");
		Animate.kill(_arg_2);
		Animate.kill(_arg_1);
		this.dotAnimAnalysing(_arg_2, MenuUtils.getRandomInRange(0, this.analysingDots.length, true));
		this.iconAnimAnalysin(_arg_1, MenuUtils.getRandomInRange(0, 10, true));
	}

	private function iconAnimAnalysin(_arg_1:MovieClip, _arg_2:Number):void {
		if (_arg_2 >= 10) {
			if (_arg_2 < 20) {
				_arg_1.gotoAndStop(this.analysingIcons[MenuUtils.getRandomInRange(0, this.analysingIcons.length, true)]);
			} else {
				_arg_1.gotoAndStop("Questionmark");
				_arg_2 = 0;
			}

		}

		_arg_2++;
		Animate.delay(_arg_1, 0.2, this.iconAnimAnalysin, _arg_1, _arg_2);
	}

	private function dotAnimAnalysing(_arg_1:TextField, _arg_2:Number):void {
		if (_arg_2 >= this.analysingDots.length) {
			_arg_2 = 0;
		}

		_arg_1.text = (Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase() + this.analysingDots[_arg_2]);
		Animate.delay(_arg_1, 0.5, this.dotAnimAnalysing, _arg_1, (_arg_2 + 1));
	}

	public function effectsStart():void {
		this.effectsEQupdate();
		this.effectsRulermove();
		this.effectsGridBox(this.m_view.effectBox1_mc);
		this.effectsGridBox(this.m_view.effectBox2_mc);
		this.effectsGridBox(this.m_view.effectBox3_mc);
		this.effectsGridBox(this.m_view.effectBox4_mc);
		this.effectsGridBox(this.m_view.effectBox5_mc);
		MenuUtils.setupText(this.m_view.processing_txt, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_PROCESSING").toUpperCase(), 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	public function effectsStop():void {
		Animate.kill(this.m_view.eq_mc);
		Animate.kill(this.m_view.ruler_mc);
		Animate.kill(this.m_view.effectBox1_mc);
		Animate.kill(this.m_view.effectBox2_mc);
		Animate.kill(this.m_view.effectBox3_mc);
		Animate.kill(this.m_view.effectBox4_mc);
		Animate.kill(this.m_view.effectBox5_mc);
		MenuUtils.setupText(this.m_view.processing_txt, Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_PROCESSING_ENDED").toUpperCase(), 20, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

	private function effectsEQupdate():void {
		var _local_1:int = 1;
		while (_local_1 < 36) {
			this.m_view.eq_mc[("row" + _local_1)].gotoAndStop(MenuUtils.getRandomInRange(1, 15, true));
			_local_1++;
		}

		Animate.delay(this.m_view.eq_mc, 0.06, this.effectsEQupdate);
	}

	private function effectsRulermove():void {
		this.m_view.ruler_mc.x = 94;
		Animate.to(this.m_view.ruler_mc, 0.8, 0, {"x": 118}, Animate.Linear, this.effectsRulermove);
	}

	private function effectsGridBox(_arg_1:MovieClip):void {
		_arg_1.x = (MenuUtils.getRandomInRange(0, 11, true) * 47.1);
		_arg_1.y = (MenuUtils.getRandomInRange(0, 17, true) * 47.2);
		_arg_1.alpha = MenuUtils.getRandomInRange(0.05, 0.2, false);
		Animate.to(_arg_1, 0.7, MenuUtils.getRandomInRange(0, 0.3, false), {"alpha": 0}, Animate.Linear, this.effectsGridBox, _arg_1);
	}


}
}//package hud.evergreen

