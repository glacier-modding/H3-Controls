package hud
{
   import basic.DottedLine;
   import common.Animate;
   import common.BaseControl;
   import common.CommonUtils;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import flash.external.ExternalInterface;
   import flash.text.TextFieldAutoSize;
   
   public class OpportunityPreview extends BaseControl
   {
      
      public static const TRANSITION_TIME:Number = 0.3;
      
      public static const STATE_NEAR:String = "Near";
      
      public static const STATE_FAR:String = "Far";
      
      public static const STATE_TIMEOUT:String = "TimeoutBar";
      
      public static const STATE_DEFAULT:String = "";
       
      
      private var m_state:String = "";
      
      private var m_view:OpportunityView;
      
      private var m_headerFarClip:MovieClip;
      
      private var m_headerNearClip:MovieClip;
      
      private var m_titleClip:MovieClip;
      
      private var m_promptClip:MovieClip;
      
      private var m_timeoutClip:MovieClip;
      
      private var m_headerDottedLine:DottedLine;
      
      private var m_timeoutClipWidth:Number;
      
      private var m_headerFarInitPosY:Number;
      
      private var m_Loc_UI_HUD_OPPORTUNITY_NEARBY:String;
      
      private var m_Loc_UI_HUD_OPPORTUNITY_DISCOVERED:String;
      
      private var m_Loc_UI_MAP_BUTTON_TRACK_OPPORTUNITY:String;
      
      private var m_timeOutRunning:Boolean;
      
      public function OpportunityPreview()
      {
         super();
         this.m_view = new OpportunityView();
         this.m_headerFarClip = this.m_view.headerFarClip;
         this.m_headerNearClip = this.m_view.headerNearClip;
         this.m_titleClip = this.m_view.titleClip;
         this.m_promptClip = this.m_view.promptClip;
         this.m_timeoutClip = this.m_view.timeoutClip;
         this.m_headerFarInitPosY = this.m_headerFarClip.y;
         this.m_timeoutClipWidth = this.m_timeoutClip.width;
         MenuUtils.setColor(this.m_timeoutClip.fill,MenuConstants.COLOR_TURQUOISE);
         MenuUtils.setColor(this.m_timeoutClip.bg,MenuConstants.COLOR_BLACK);
         this.m_timeoutClip.bg.alpha = 0.5;
         addChild(this.m_view);
         this.m_view.visible = false;
         this.m_Loc_UI_HUD_OPPORTUNITY_NEARBY = Localization.get("UI_HUD_OPPORTUNITY_NEARBY").toUpperCase();
         this.m_Loc_UI_HUD_OPPORTUNITY_DISCOVERED = Localization.get("UI_HUD_OPPORTUNITY_DISCOVERED").toUpperCase();
         this.m_Loc_UI_MAP_BUTTON_TRACK_OPPORTUNITY = Localization.get("UI_MAP_BUTTON_TRACK_OPPORTUNITY").toUpperCase();
         MenuUtils.setupText(this.m_headerFarClip.txtLabel,this.m_Loc_UI_HUD_OPPORTUNITY_NEARBY,26,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite,true);
         this.m_headerFarClip.txtLabel.autoSize = TextFieldAutoSize.CENTER;
         MenuUtils.setupText(this.m_headerNearClip.txtLabel,this.m_Loc_UI_HUD_OPPORTUNITY_DISCOVERED,26,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite,true);
         this.m_headerNearClip.txtLabel.autoSize = TextFieldAutoSize.CENTER;
         this.addDottedLine();
         MenuUtils.setupText(this.m_titleClip.txtLabel,this.m_Loc_UI_MAP_BUTTON_TRACK_OPPORTUNITY,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_promptClip.txtLabel,getOpportunityAcceptLocalized(),15,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
      
      private static function getOpportunityAcceptLocalized() : String
      {
         if(CommonUtils.getPlatformString() == CommonUtils.PLATFORM_ORBIS)
         {
            return Localization.get("UI_HUD_OPPORTUNITY_ACCEPT_PS4");
         }
         if(CommonUtils.isPCVRControllerUsed())
         {
            return Localization.get("UI_HUD_OPPORTUNITY_ACCEPT_PCVR");
         }
         return Localization.get("UI_HUD_OPPORTUNITY_ACCEPT");
      }
      
      public function onControlLayoutChanged() : void
      {
         this.m_promptClip.txtLabel.htmlText = getOpportunityAcceptLocalized();
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_state = param1.state;
         switch(param1.state)
         {
            case STATE_NEAR:
               this.handleUpdatedNearView(param1);
               break;
            case STATE_FAR:
               this.handleUpdatedFarView(param1);
               break;
            case STATE_TIMEOUT:
               this.handleUpdateTimeoutBar(param1);
               break;
            default:
               this.handleUpdatedViewBlendOut(param1);
         }
      }
      
      private function handleUpdateTimeoutBar(param1:Object) : void
      {
         if(!this.m_timeOutRunning)
         {
            this.m_timeOutRunning = true;
            this.playSound("play_gui_opportunity_timer");
         }
         var _loc2_:Number = param1.durationTimeLeft / param1.duration;
         _loc2_ = Math.max(0,Math.min(_loc2_,1));
         this.m_timeoutClip.fill.scaleX = _loc2_;
      }
      
      private function handleUpdatedFarView(param1:Object) : void
      {
         this.m_titleClip.visible = false;
         this.m_timeoutClip.visible = false;
         this.m_promptClip.visible = false;
         this.m_headerNearClip.visible = false;
         this.m_headerFarClip.visible = true;
         this.m_view.visible = true;
         this.m_view.alpha = 1;
         this.m_headerFarClip.alpha = 0;
         this.m_headerFarClip.y = this.m_headerFarInitPosY + 20;
         Animate.to(this.m_headerFarClip,0.2,0,{"alpha":1},Animate.ExpoOut);
         Animate.addTo(this.m_headerFarClip,0.5,0,{"y":this.m_headerFarInitPosY},Animate.ExpoOut);
         this.m_headerDottedLine.alpha = 0;
         Animate.to(this.m_headerDottedLine,TRANSITION_TIME,0.3,{"alpha":1},Animate.ExpoOut);
      }
      
      private function handleUpdatedNearView(param1:Object) : void
      {
         this.m_headerFarClip.visible = false;
         this.m_headerDottedLine.alpha = 0;
         this.m_headerNearClip.visible = true;
         this.m_timeoutClip.width = this.m_headerNearClip.width;
         this.m_timeoutClip.fill.scaleX = 1;
         this.m_view.visible = true;
         this.m_view.alpha = 1;
         this.m_headerNearClip.alpha = 1;
         Animate.fromTo(this.m_headerNearClip,0.2,0,{
            "scaleX":1.5,
            "scaleY":1.5
         },{
            "scaleX":1,
            "scaleY":1
         },Animate.ExpoOut);
         this.m_timeoutClip.visible = true;
         this.m_timeoutClip.alpha = 0;
         Animate.to(this.m_timeoutClip,TRANSITION_TIME,0.2,{"alpha":1},Animate.ExpoOut);
         this.m_titleClip.visible = true;
         this.m_titleClip.alpha = 0;
         Animate.to(this.m_titleClip,TRANSITION_TIME,0.3,{"alpha":1},Animate.ExpoOut);
         this.m_promptClip.visible = true;
         this.m_promptClip.alpha = 0;
         Animate.to(this.m_promptClip,1,0.6,{"alpha":1},Animate.ExpoOut);
      }
      
      private function handleUpdatedViewBlendOut(param1:Object) : void
      {
         var iData:Object = param1;
         Animate.delay(this.m_view,0.5,function():void
         {
            if(m_timeOutRunning)
            {
               m_timeOutRunning = false;
               playSound("stop_gui_opportunity_timer");
            }
            if(m_state != STATE_DEFAULT)
            {
               return;
            }
            Animate.to(m_view,TRANSITION_TIME,0,{"alpha":0},Animate.ExpoOut,function():void
            {
               m_view.visible = false;
            });
         });
      }
      
      private function addDottedLine() : void
      {
         this.removeDottedLine();
         var _loc1_:Number = this.m_headerFarClip.width;
         this.m_headerDottedLine = new DottedLine(_loc1_,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,2,4);
         this.m_headerDottedLine.x = -(_loc1_ >> 1);
         this.m_headerDottedLine.y = this.m_timeoutClip.y;
         this.m_headerDottedLine.alpha = 0;
         this.m_view.addChild(this.m_headerDottedLine);
      }
      
      private function removeDottedLine() : void
      {
         if(this.m_headerDottedLine != null)
         {
            this.m_view.removeChild(this.m_headerDottedLine);
            this.m_headerDottedLine = null;
         }
      }
      
      public function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
   }
}
