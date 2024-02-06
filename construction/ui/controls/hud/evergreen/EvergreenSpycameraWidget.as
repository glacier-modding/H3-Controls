package hud.evergreen
{
   import common.Animate;
   import common.BaseControl;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import hud.photomode.PhotoModeWidget;
   
   public class EvergreenSpycameraWidget extends BaseControl
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
       
      
      private var m_view:SpyCameraView;
      
      private var minBackWidth:Number = 240;
      
      private var m_isScanning:Boolean;
      
      private var m_previousScanVal:Number = 0;
      
      public function EvergreenSpycameraWidget()
      {
         this.m_view = new SpyCameraView();
         super();
         this.m_view.visible = false;
         addChild(this.m_view);
      }
      
      public function setViewFinderStyle(param1:int) : void
      {
         switch(param1)
         {
            case PhotoModeWidget.VIEWFINDERSTYLE_NONE:
               this.m_view.visible = false;
               this.effectsStop();
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_CAMERAITEM:
               this.m_view.visible = false;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_PHOTOOPP:
               this.m_view.visible = false;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_SPYCAM:
               this.m_view.visible = true;
               break;
            default:
               this.m_view.visible = false;
         }
      }
      
      public function setScanValue(param1:Number) : void
      {
         if(!this.m_isScanning)
         {
            if(param1 >= this.m_previousScanVal)
            {
               this.m_isScanning = true;
               this.effectsStop();
            }
         }
         if(this.m_isScanning)
         {
            if(param1 <= this.m_previousScanVal)
            {
               this.m_isScanning = false;
               this.effectsStart();
            }
         }
         this.m_previousScanVal = param1;
      }
      
      public function onSetData(param1:Object) : void
      {
         MenuUtils.setupText(this.m_view.status_mc.statusHeadline_txt,Localization.get("UI_EVERGREEN_SPYCAM_STATUS").toUpperCase(),22,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         this.m_view.status_mc.gotoAndStop("suspect");
         MenuUtils.setupText(this.m_view.status_mc.statusPrime_txt,Localization.get("UI_EVERGREEN_SPYCAM_SUSPECT").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         this.m_view.status_mc.back_mc.width = Math.max(this.minBackWidth,Math.max(this.m_view.status_mc.statusHeadline_txt.textWidth + 30,this.m_view.status_mc.statusPrime_txt.textWidth + 30));
         this.setupAgenda(param1.agenda);
         this.setupTell(param1.tellA,this.m_view.tell1_mc);
         this.setupTell(param1.tellB,this.m_view.tell2_mc);
         this.setupLook(param1.lookA,this.m_view.visual1_mc);
         this.setupLook(param1.lookB,this.m_view.visual2_mc);
         this.setupLook(param1.lookC,this.m_view.visual3_mc);
         this.setupLook(param1.lookD,this.m_view.visual4_mc);
      }
      
      public function setSubjectTagState(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               this.m_view.status_mc.gotoAndStop("suspect");
               MenuUtils.setupText(this.m_view.status_mc.statusPrime_txt,Localization.get("UI_EVERGREEN_SPYCAM_SUSPECT").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case 1:
               this.m_view.status_mc.gotoAndStop("notsuspect");
               MenuUtils.setupText(this.m_view.status_mc.statusPrime_txt,Localization.get("UI_EVERGREEN_SPYCAM_NOTSUSPECT").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case 2:
               this.m_view.status_mc.gotoAndStop("prime");
               MenuUtils.setupText(this.m_view.status_mc.statusPrime_txt,Localization.get("UI_EVERGREEN_SPYCAM_PRIMESUSPECT").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            default:
               this.m_view.status_mc.gotoAndStop("nosuspect");
               MenuUtils.setupText(this.m_view.status_mc.statusPrime_txt,Localization.get("UI_EVERGREEN_SPYCAM_NOSUSPECT").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         }
         this.m_view.status_mc.back_mc.width = Math.max(this.minBackWidth,Math.max(this.m_view.status_mc.statusHeadline_txt.textWidth + 30,this.m_view.status_mc.statusPrime_txt.textWidth + 30));
      }
      
      private function setupAgenda(param1:int) : void
      {
         MenuUtils.setupText(this.m_view.agenda_mc.visualType_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_AGENDATITLE").toUpperCase(),22,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         switch(param1)
         {
            case Agenda_Unknown:
               this.m_view.agenda_mc.visualIcon_mc.gotoAndStop("Questionmark");
               MenuUtils.setupText(this.m_view.agenda_mc.visualHeadline_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Agenda_HandoverMeeting:
               this.m_view.agenda_mc.visualIcon_mc.gotoAndStop("HandoverMeeting");
               MenuUtils.setupText(this.m_view.agenda_mc.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Agenda_Courier_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Agenda_BusinessMeeting:
               this.m_view.agenda_mc.visualIcon_mc.gotoAndStop("BusinessMeeting");
               MenuUtils.setupText(this.m_view.agenda_mc.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Agenda_Business_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Agenda_SecretMeeting:
               this.m_view.agenda_mc.visualIcon_mc.gotoAndStop("SecretMeeting");
               MenuUtils.setupText(this.m_view.agenda_mc.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Agenda_Social_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Agenda_NoMeeting:
               this.m_view.agenda_mc.visualIcon_mc.gotoAndStop("NoMeeting");
               MenuUtils.setupText(this.m_view.agenda_mc.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Agenda_NoMeeting_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            default:
               this.m_view.agenda_mc.visualIcon_mc.gotoAndStop("Questionmark");
               MenuUtils.setupText(this.m_view.agenda_mc.visualHeadline_txt,"",24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         }
         this.m_view.agenda_mc.back_mc.width = Math.max(this.m_view.agenda_mc.visualHeadline_txt.textWidth + 30,this.minBackWidth);
      }
      
      private function setupTell(param1:int, param2:MovieClip) : void
      {
         MenuUtils.setupText(param2.visualType_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_TELLTITLE").toUpperCase(),22,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         switch(param1)
         {
            case Tell_Unknown:
               param2.visualIcon_mc.gotoAndStop("Questionmark");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Tell_Smoker:
               param2.visualIcon_mc.gotoAndStop("Smoker");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Tell_Smoker_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Tell_Allergic:
               param2.visualIcon_mc.gotoAndStop("Allergic");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Tell_Allergic_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Tell_SweetTooth:
               param2.visualIcon_mc.gotoAndStop("SweetTooth");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Tell_Sweettooth_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Tell_Bookworm:
               param2.visualIcon_mc.gotoAndStop("Bookworm");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Tell_Bookworm_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Tell_Nervous:
               param2.visualIcon_mc.gotoAndStop("Nervous");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Tell_Nervous_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Tell_Dehydrated:
               param2.visualIcon_mc.gotoAndStop("Thirsty");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Tell_Thirsty_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Tell_Foodie:
               param2.visualIcon_mc.gotoAndStop("Hungry");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Tell_Hungry_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            default:
               param2.visualIcon_mc.gotoAndStop("Questionmark");
               MenuUtils.setupText(param2.visualHeadline_txt,"",24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         }
         param2.back_mc.width = Math.max(param2.visualHeadline_txt.textWidth + 30,this.minBackWidth);
      }
      
      private function setupLook(param1:int, param2:MovieClip) : void
      {
         switch(param1)
         {
            case Look_Unknown:
               param2.visualIcon_mc.gotoAndStop("Questionmark");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("UI_EVERGREEN_SAFEHOUSE_INTELWALL_ANALYSING").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_Glasses:
               param2.visualIcon_mc.gotoAndStop("Glasses");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_Glasses_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_Earrings:
               param2.visualIcon_mc.gotoAndStop("Earrings");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_Earrings_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_Necklace:
               param2.visualIcon_mc.gotoAndStop("Necklace");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_Necklace_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_Watch:
               param2.visualIcon_mc.gotoAndStop("Watch");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_Watch_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_Hat:
               param2.visualIcon_mc.gotoAndStop("Hat");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_Hat_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_Tattoo:
               param2.visualIcon_mc.gotoAndStop("Tattoo");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_Tattoo_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_BlackHair:
               param2.visualIcon_mc.gotoAndStop("Hair");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_BlackHair_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_BrownHair:
               param2.visualIcon_mc.gotoAndStop("Hair");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_BrownHair_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_BlondeHair:
               param2.visualIcon_mc.gotoAndStop("Hair");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_BlondHair_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_GreyHair:
               param2.visualIcon_mc.gotoAndStop("Hair");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_GreyHair_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_RedHair:
               param2.visualIcon_mc.gotoAndStop("Hair");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_RedHair_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            case Look_NoHair:
               param2.visualIcon_mc.gotoAndStop("Bald");
               MenuUtils.setupText(param2.visualHeadline_txt,Localization.get("Evergreen_Identifiers_Look_Bald_TITLE").toUpperCase(),24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               break;
            default:
               param2.visualIcon_mc.gotoAndStop("Questionmark");
               MenuUtils.setupText(param2.visualHeadline_txt,"",24,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         }
         param2.back_mc.width = Math.max(param2.visualHeadline_txt.textWidth + 30,this.minBackWidth);
      }
      
      private function effectsStart() : void
      {
         this.effectsFillBinaryText();
      }
      
      private function effectsStop() : void
      {
         Animate.kill(this.m_view.effectBinary_txt);
         this.m_view.effectBinary_txt.text = "";
      }
      
      private function effectsFillBinaryText() : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:* = "";
         var _loc3_:int = 1;
         while(_loc3_ < 12)
         {
            _loc2_ = MenuUtils.getRandomInRange(1,6,true);
            _loc4_ = 1;
            while(_loc4_ <= _loc2_)
            {
               _loc1_ += MenuUtils.getRandomInRange(0,255,true).toString(2) + " ";
               _loc4_++;
            }
            _loc1_ += "\n";
            _loc3_++;
         }
         this.m_view.effectBinary_txt.text = _loc1_;
         Animate.delay(this.m_view.effectBinary_txt,0.4,this.effectsFillBinaryText);
      }
   }
}
