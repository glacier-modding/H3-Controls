package menu3.basic
{
   import common.CommonUtils;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import menu3.MenuElementBase;
   
   public dynamic class ProfileElement extends MenuElementBase
   {
      
      public static const STATE_UNDEFINED:int = -1;
      
      public static const STATE_OFFLINE:int = 0;
      
      public static const STATE_ONLINE:int = 1;
      
      public static const STATE_CONNECTED:int = 2;
       
      
      private var m_view:ProfileElementView;
      
      private var m_badge:Badge;
      
      private var m_state:int = -1;
      
      private var m_profileLevel:int = 0;
      
      private const BADGE_MAX_SIZE:Number = 40;
      
      public function ProfileElement(param1:Object)
      {
         super(param1);
         this.m_view = new ProfileElementView();
         addChild(this.m_view);
         this.m_badge = new Badge();
         this.m_badge.setMaxSize(this.BADGE_MAX_SIZE);
         this.m_view.badgecontainer.addChild(this.m_badge);
         this.m_badge.visible = false;
      }
      
      override public function onUnregister() : void
      {
         this.m_badge = null;
         this.m_view = null;
         super.onUnregister();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
      }
      
      public function setProfileName(param1:String) : void
      {
         MenuUtils.setupProfileName(this.m_view.usertitle,param1,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
      
      public function setProfileLevel(param1:int) : void
      {
         if(this.m_profileLevel == param1)
         {
            return;
         }
         this.m_profileLevel = param1;
         this.updateConnectionLine();
      }
      
      public function setState(param1:int) : void
      {
         if(this.m_state == param1)
         {
            return;
         }
         this.m_state = param1;
         this.updateConnectionLine();
      }
      
      private function updateConnectionLine() : void
      {
         var _loc2_:String = null;
         if(this.m_state == STATE_UNDEFINED)
         {
            return;
         }
         var _loc1_:* = this.m_profileLevel > 0;
         if(this.m_state == STATE_CONNECTED)
         {
            MenuUtils.setupTextUpper(this.m_view.onlineheader,Localization.get("UI_MENU_LOBBY_JOINED_TITLE"),12,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorYellow);
            CommonUtils.changeFontToGlobalIfNeeded(this.m_view.onlineheader);
         }
         else if(this.m_state == STATE_OFFLINE)
         {
            _loc1_ = false;
            MenuUtils.setupTextUpper(this.m_view.onlineheader,Localization.get("UI_DIALOG_USER_OFFLINE"),12,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorRed);
            CommonUtils.changeFontToGlobalIfNeeded(this.m_view.onlineheader);
         }
         else if(this.m_state == STATE_ONLINE)
         {
            _loc2_ = Localization.get("UI_DIALOG_USER_ONLINE");
            if(this.m_profileLevel > 0)
            {
               _loc2_ = _loc2_ + " - " + Localization.get("UI_DIALOG_ESCALATION_LEVEL") + " " + this.m_profileLevel.toFixed(0);
            }
            MenuUtils.setupTextUpper(this.m_view.onlineheader,_loc2_,12,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorGreen);
            CommonUtils.changeFontToGlobalIfNeeded(this.m_view.onlineheader);
         }
         this.updateBadgeLevel(this.m_profileLevel);
         this.m_badge.visible = _loc1_;
         this.m_view.line.visible = _loc1_;
      }
      
      private function updateBadgeLevel(param1:int) : void
      {
         this.m_badge.setLevel(param1,true,false);
      }
   }
}
