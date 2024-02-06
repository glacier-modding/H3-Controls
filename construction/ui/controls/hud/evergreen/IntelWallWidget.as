package hud.evergreen
{
   import basic.DottedLine;
   import common.Animate;
   import common.BaseControl;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class IntelWallWidget extends BaseControl
   {
      
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
       
      
      private var analysingDots:Array;
      
      private var analysingIcons:Array;
      
      private var m_view:IntelWallView;
      
      private var m_lineSeparator1:DottedLine;
      
      private var m_lineSeparator2:DottedLine;
      
      private var m_lineSeparator3:DottedLine;
      
      private var m_lineSeparator4:DottedLine;
      
      public function IntelWallWidget()
      {
         this.analysingDots = new Array("",".","..","...","..",".");
         this.analysingIcons = new Array("Glasses","Earrings","Necklace","Hat","Tattoo","Hair","Bald");
         this.m_view = new IntelWallView();
         this.m_lineSeparator1 = new DottedLine(802,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,2,3);
         this.m_lineSeparator2 = new DottedLine(802,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,2,3);
         this.m_lineSeparator3 = new DottedLine(802,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,2,3);
         this.m_lineSeparator4 = new DottedLine(1286,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,2,3);
         super();
         addChild(this.m_view);
         this.m_view.dottedLine1_mc.addChild(this.m_lineSeparator1);
         this.m_view.dottedLine2_mc.addChild(this.m_lineSeparator2);
         this.m_view.dottedLine3_mc.addChild(this.m_lineSeparator3);
         this.m_view.dottedLine4_mc.addChild(this.m_lineSeparator4);
      }
      
      public function onSetData(param1:Object) : void
      {
         MenuUtils.setupText(this.m_view.headline1_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_LEADERTITLE").toUpperCase(),26,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.headline2_txt,param1.lstrLeaderCodename.toUpperCase(),68,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         MenuUtils.shrinkTextToFit(this.m_view.headline2_txt,this.m_view.headline2_txt.width,-1);
         MenuUtils.setupText(this.m_view.crime1_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_CRIMETITLE").toUpperCase(),26,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.crime2_txt,param1.lstrCrimeSector.toUpperCase(),68,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         MenuUtils.shrinkTextToFit(this.m_view.crime2_txt,this.m_view.crime2_txt.width,-1);
         switch(param1.idCrimeSector)
         {
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
         this.setupAgenda(param1.agenda);
         this.setupTell(param1.tellA,this.m_view.tellType2_txt,this.m_view.tellHeadline2_txt,this.m_view.tell2Icon_mc);
         this.setupTell(param1.tellB,this.m_view.tellType3_txt,this.m_view.tellHeadline3_txt,this.m_view.tell3Icon_mc);
         this.setupLook(param1.lookA,this.m_view.visualType1_txt,this.m_view.visualHeadline1_txt,this.m_view.visual1Icon_mc);
         this.setupLook(param1.lookB,this.m_view.visualType2_txt,this.m_view.visualHeadline2_txt,this.m_view.visual2Icon_mc);
         this.setupLook(param1.lookC,this.m_view.visualType3_txt,this.m_view.visualHeadline3_txt,this.m_view.visual3Icon_mc);
         this.setupLook(param1.lookD,this.m_view.visualType4_txt,this.m_view.visualHeadline4_txt,this.m_view.visual4Icon_mc);
         MenuUtils.setupText(this.m_view.processing_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_PROCESSING").toUpperCase(),20,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.effectsStop();
         this.effectsStart();
      }
      
      private function setupAgenda(param1:int) : void
      {
         MenuUtils.setupText(this.m_view.tellType1_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_AGENDATITLE").toUpperCase(),26,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         Animate.kill(this.m_view.tellHeadline1_txt);
         Animate.kill(this.m_view.tell1Icon_mc);
         switch(param1)
         {
            case Agenda_Unknown:
               MenuUtils.setupText(this.m_view.tellHeadline1_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               this.setAnalysingIcon(this.m_view.tell1Icon_mc,this.m_view.tellHeadline1_txt);
               break;
            case Agenda_HandoverMeeting:
               this.m_view.tell1Icon_mc.gotoAndStop("HandoverMeeting");
               MenuUtils.setupText(this.m_view.tellHeadline1_txt,Localization.get("Evergreen_Identifiers_Agenda_Courier_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Agenda_BusinessMeeting:
               this.m_view.tell1Icon_mc.gotoAndStop("BusinessMeeting");
               MenuUtils.setupText(this.m_view.tellHeadline1_txt,Localization.get("Evergreen_Identifiers_Agenda_Business_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Agenda_SecretMeeting:
               this.m_view.tell1Icon_mc.gotoAndStop("SecretMeeting");
               MenuUtils.setupText(this.m_view.tellHeadline1_txt,Localization.get("Evergreen_Identifiers_Agenda_Social_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Agenda_NoMeeting:
               this.m_view.tell1Icon_mc.gotoAndStop("NoMeeting");
               MenuUtils.setupText(this.m_view.tellHeadline1_txt,Localization.get("Evergreen_Identifiers_Agenda_NoMeeting_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            default:
               this.m_view.tell1Icon_mc.gotoAndStop("Questionmark");
               MenuUtils.setupText(this.m_view.tellHeadline1_txt,"",36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         }
      }
      
      private function setupTell(param1:int, param2:TextField, param3:TextField, param4:MovieClip) : void
      {
         MenuUtils.setupText(param2,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_TELLTITLE").toUpperCase(),26,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         Animate.kill(param3);
         Animate.kill(param4);
         switch(param1)
         {
            case Tell_Unknown:
               MenuUtils.setupText(param3,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               this.setAnalysingIcon(param4,param3);
               break;
            case Tell_Smoker:
               param4.gotoAndStop("Smoker");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Tell_Smoker_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Tell_Allergic:
               param4.gotoAndStop("Allergic");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Tell_Allergic_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Tell_SweetTooth:
               param4.gotoAndStop("SweetTooth");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Tell_Sweettooth_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Tell_Bookworm:
               param4.gotoAndStop("Bookworm");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Tell_Bookworm_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Tell_Nervous:
               param4.gotoAndStop("Nervous");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Tell_Nervous_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Tell_Dehydrated:
               param4.gotoAndStop("Thirsty");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Tell_Thirsty_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Tell_Foodie:
               param4.gotoAndStop("Hungry");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Tell_Hungry_TITLE").toUpperCase(),36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            default:
               param4.gotoAndStop("Questionmark");
               MenuUtils.setupText(param3,"",36,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         }
      }
      
      private function setupLook(param1:int, param2:TextField, param3:TextField, param4:MovieClip) : void
      {
         MenuUtils.setupText(param2,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_TELLVISUAL").toUpperCase(),20,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         Animate.kill(param3);
         Animate.kill(param4);
         switch(param1)
         {
            case Look_Unknown:
               MenuUtils.setupText(param3,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               this.setAnalysingIcon(param4,param3);
               break;
            case Look_Glasses:
               param4.gotoAndStop("Glasses");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_Glasses_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_Earrings:
               param4.gotoAndStop("Earrings");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_Earrings_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_Necklace:
               param4.gotoAndStop("Necklace");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_Necklace_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_Hat:
               param4.gotoAndStop("Hat");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_Hat_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_Tattoo:
               param4.gotoAndStop("Tattoo");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_Tattoo_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_BlackHair:
               param4.gotoAndStop("Hair");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_BlackHair_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_BrownHair:
               param4.gotoAndStop("Hair");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_BrownHair_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_BlondeHair:
               param4.gotoAndStop("Hair");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_BlondHair_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_GreyHair:
               param4.gotoAndStop("Hair");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_GreyHair_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_RedHair:
               param4.gotoAndStop("Hair");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_RedHair_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            case Look_NoHair:
               param4.gotoAndStop("Bald");
               MenuUtils.setupText(param3,Localization.get("Evergreen_Identifiers_Look_Bald_TITLE").toUpperCase(),28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
               break;
            default:
               param4.gotoAndStop("Questionmark");
               MenuUtils.setupText(param3,"",28,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         }
      }
      
      private function setAnalysingIcon(param1:MovieClip, param2:TextField) : void
      {
         param1.gotoAndStop("Questionmark");
         Animate.kill(param2);
         Animate.kill(param1);
         this.dotAnimAnalysing(param2,MenuUtils.getRandomInRange(0,this.analysingDots.length,true));
         this.iconAnimAnalysin(param1,MenuUtils.getRandomInRange(0,10,true));
      }
      
      private function iconAnimAnalysin(param1:MovieClip, param2:Number) : void
      {
         if(param2 >= 10)
         {
            if(param2 < 20)
            {
               param1.gotoAndStop(this.analysingIcons[MenuUtils.getRandomInRange(0,this.analysingIcons.length,true)]);
            }
            else
            {
               param1.gotoAndStop("Questionmark");
               param2 = 0;
            }
         }
         param2++;
         Animate.delay(param1,0.2,this.iconAnimAnalysin,param1,param2);
      }
      
      private function dotAnimAnalysing(param1:TextField, param2:Number) : void
      {
         if(param2 >= this.analysingDots.length)
         {
            param2 = 0;
         }
         param1.text = Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase() + this.analysingDots[param2];
         Animate.delay(param1,0.5,this.dotAnimAnalysing,param1,param2 + 1);
      }
      
      public function effectsStart() : void
      {
         this.effectsEQupdate();
         this.effectsRulermove();
         this.effectsGridBox(this.m_view.effectBox1_mc);
         this.effectsGridBox(this.m_view.effectBox2_mc);
         this.effectsGridBox(this.m_view.effectBox3_mc);
         this.effectsGridBox(this.m_view.effectBox4_mc);
         this.effectsGridBox(this.m_view.effectBox5_mc);
         MenuUtils.setupText(this.m_view.processing_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_PROCESSING").toUpperCase(),20,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
      
      public function effectsStop() : void
      {
         Animate.kill(this.m_view.eq_mc);
         Animate.kill(this.m_view.ruler_mc);
         Animate.kill(this.m_view.effectBox1_mc);
         Animate.kill(this.m_view.effectBox2_mc);
         Animate.kill(this.m_view.effectBox3_mc);
         Animate.kill(this.m_view.effectBox4_mc);
         Animate.kill(this.m_view.effectBox5_mc);
         MenuUtils.setupText(this.m_view.processing_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_PROCESSING_ENDED").toUpperCase(),20,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
      
      private function effectsEQupdate() : void
      {
         var _loc1_:int = 1;
         while(_loc1_ < 36)
         {
            this.m_view.eq_mc["row" + _loc1_].gotoAndStop(MenuUtils.getRandomInRange(1,15,true));
            _loc1_++;
         }
         Animate.delay(this.m_view.eq_mc,0.06,this.effectsEQupdate);
      }
      
      private function effectsRulermove() : void
      {
         this.m_view.ruler_mc.x = 94;
         Animate.to(this.m_view.ruler_mc,0.8,0,{"x":118},Animate.Linear,this.effectsRulermove);
      }
      
      private function effectsGridBox(param1:MovieClip) : void
      {
         param1.x = MenuUtils.getRandomInRange(0,11,true) * 47.1;
         param1.y = MenuUtils.getRandomInRange(0,17,true) * 47.2;
         param1.alpha = MenuUtils.getRandomInRange(0.05,0.2,false);
         Animate.to(param1,0.7,MenuUtils.getRandomInRange(0,0.3,false),{"alpha":0},Animate.Linear,this.effectsGridBox,param1);
      }
   }
}
