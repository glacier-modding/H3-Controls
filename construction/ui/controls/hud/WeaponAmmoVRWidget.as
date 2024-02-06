package hud
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class WeaponAmmoVRWidget extends BaseControl
   {
      
      private static const LEGALSTATE_CLEAR:int = 0;
      
      private static const LEGALSTATE_SUSPICIOUS:int = 1;
      
      private static const LEGALSTATE_ILLEGAL:int = 2;
      
      private static const UIOPTFLAG_WEAPON:uint = 1 << 0;
      
      private static const UIOPTFLAG_RELOAD:uint = 1 << 1;
      
      private static const DX_PADDING_BETWEEN_AMMO_COUNTERS:Number = 2;
       
      
      private var m_reload_mc:ReloadView;
      
      private var m_illegalIcon_mc:WeaponView_illegalIcon;
      
      private var m_ammoCurrent_txt:TextField;
      
      private var m_ammoTotal_txt:TextField;
      
      private var m_container:Sprite;
      
      private var m_containerOffsetLegal:Sprite;
      
      private var m_containerAmmoText:Sprite;
      
      private var m_isRightSide:Boolean = true;
      
      private var m_dxFlipOffset:Number;
      
      public function WeaponAmmoVRWidget()
      {
         this.m_illegalIcon_mc = new WeaponView_illegalIcon();
         this.m_ammoCurrent_txt = new TextField();
         this.m_ammoTotal_txt = new TextField();
         this.m_container = new Sprite();
         this.m_containerOffsetLegal = new Sprite();
         this.m_containerAmmoText = new Sprite();
         super();
         this.m_illegalIcon_mc.name = "illegalIcon_mc";
         this.m_ammoCurrent_txt.name = "ammoCurrent_txt";
         this.m_ammoTotal_txt.name = "ammoTotal_txt";
         this.m_container.name = "container";
         this.m_containerOffsetLegal.name = "containerOffsetLegal";
         this.m_containerAmmoText.name = "containerAmmoText";
         this.m_container.x = this.m_dxFlipOffset;
         this.m_ammoCurrent_txt.autoSize = "left";
         this.m_ammoTotal_txt.autoSize = "left";
         MenuUtils.addDropShadowFilter(this.m_ammoCurrent_txt);
         MenuUtils.addDropShadowFilter(this.m_ammoTotal_txt);
         MenuUtils.setupText(this.m_ammoCurrent_txt,"",36,MenuConstants.FONT_TYPE_BOLD);
         MenuUtils.setupText(this.m_ammoTotal_txt,"",18,MenuConstants.FONT_TYPE_MEDIUM);
         this.m_ammoCurrent_txt.y = -46;
         this.m_ammoTotal_txt.y = -29;
         this.m_containerAmmoText.addChild(this.m_ammoCurrent_txt);
         this.m_containerAmmoText.addChild(this.m_ammoTotal_txt);
         this.m_containerOffsetLegal.addChild(this.m_containerAmmoText);
         this.m_illegalIcon_mc.alpha = 0;
         this.m_illegalIcon_mc.scaleX = 0.46;
         this.m_illegalIcon_mc.scaleY = 0.46;
         this.m_illegalIcon_mc.x = this.m_illegalIcon_mc.width / 2;
         this.m_illegalIcon_mc.y = -this.m_illegalIcon_mc.height / 2 - 9;
         this.m_container.addChild(this.m_illegalIcon_mc);
         this.m_container.addChild(this.m_containerOffsetLegal);
         addChild(this.m_container);
      }
      
      public function set dxFlipOffset(param1:Number) : void
      {
         this.m_dxFlipOffset = param1;
         this.m_container.x = this.m_dxFlipOffset;
      }
      
      public function set enableReloadElement(param1:Boolean) : void
      {
         if(param1 && this.m_reload_mc == null)
         {
            this.m_reload_mc = new ReloadView();
            this.m_containerOffsetLegal.addChild(this.m_reload_mc);
         }
         if(!param1 && this.m_reload_mc != null)
         {
            this.m_containerOffsetLegal.removeChild(this.m_reload_mc);
            this.m_reload_mc = null;
         }
      }
      
      public function showFirearm(param1:int, param2:int, param3:int, param4:Boolean, param5:uint) : void
      {
         var _loc6_:int = 0;
         if(!param4)
         {
            this.m_containerOffsetLegal.visible = false;
         }
         else
         {
            this.m_containerOffsetLegal.visible = true;
            if(param5 & UIOPTFLAG_WEAPON)
            {
               this.m_ammoCurrent_txt.visible = true;
               this.m_ammoCurrent_txt.text = param1.toString();
               if(param3 > 0)
               {
                  this.m_ammoTotal_txt.visible = true;
                  this.m_ammoTotal_txt.text = "/" + param3.toString();
               }
               else
               {
                  this.m_ammoTotal_txt.visible = false;
               }
               this.m_ammoTotal_txt.x = this.m_ammoCurrent_txt.textWidth + DX_PADDING_BETWEEN_AMMO_COUNTERS;
            }
            else
            {
               this.m_ammoCurrent_txt.visible = false;
               this.m_ammoTotal_txt.visible = false;
            }
            this.applyMirrorOffsets();
            if(this.m_reload_mc)
            {
               _loc6_ = int(ReloadView.WARNLEVEL_NONE);
               if(param3 > 0 && Boolean(param5 & UIOPTFLAG_RELOAD))
               {
                  if(param1 == 1 && param2 > 1)
                  {
                     _loc6_ = int(ReloadView.WARNLEVEL_YELLOW);
                  }
                  else if(param1 == 0)
                  {
                     _loc6_ = int(ReloadView.WARNLEVEL_RED);
                  }
               }
               this.m_reload_mc.setWarnLevel(_loc6_);
            }
         }
      }
      
      public function showMelee(param1:int) : void
      {
         if(param1 > 1)
         {
            this.m_containerOffsetLegal.visible = true;
            this.m_ammoTotal_txt.visible = false;
            this.m_ammoCurrent_txt.text = "x" + param1.toString();
         }
         else
         {
            this.m_containerOffsetLegal.visible = false;
         }
      }
      
      public function changeLegalState(param1:int) : void
      {
         var _loc2_:String = null;
         if(param1 != LEGALSTATE_CLEAR)
         {
            _loc2_ = param1 == LEGALSTATE_ILLEGAL ? "visarmed" : "susarmed";
            this.m_illegalIcon_mc.gotoAndStop(_loc2_);
            this.m_containerOffsetLegal.x = this.m_illegalIcon_mc.width + 5;
            this.m_illegalIcon_mc.alpha = 0;
            Animate.fromTo(this.m_illegalIcon_mc,0.5,0.25,{
               "alpha":0,
               "scaleX":1,
               "scaleY":1
            },{
               "alpha":1,
               "scaleX":0.46,
               "scaleY":0.46
            },Animate.ExpoOut);
         }
         else
         {
            Animate.kill(this.m_illegalIcon_mc);
            this.m_containerOffsetLegal.x = 0;
            this.m_illegalIcon_mc.alpha = 0;
         }
      }
      
      public function setRightSide(param1:Boolean) : void
      {
         if(this.m_isRightSide == param1)
         {
            return;
         }
         if(param1)
         {
            this.m_container.x = this.m_dxFlipOffset;
            this.m_container.alpha = 0;
            this.m_container.scaleX = 1;
            this.m_containerOffsetLegal.scaleX = 1;
            Animate.to(this.m_container,0.5,0,{"alpha":1},Animate.SineOut);
         }
         else
         {
            this.m_container.x = -this.m_dxFlipOffset;
            this.m_container.alpha = 0;
            this.m_container.scaleX = -1;
            this.m_containerOffsetLegal.scaleX = -1;
            Animate.to(this.m_container,0.5,0,{"alpha":1},Animate.SineOut);
         }
         this.m_isRightSide = param1;
         this.applyMirrorOffsets();
      }
      
      public function set layoutOnRightSide(param1:Boolean) : void
      {
         this.setRightSide(param1);
      }
      
      private function applyMirrorOffsets() : void
      {
         var _loc1_:Number = NaN;
         if(this.m_isRightSide)
         {
            this.m_containerAmmoText.x = 0;
            if(this.m_reload_mc != null)
            {
               this.m_reload_mc.x = 0;
            }
         }
         else
         {
            _loc1_ = this.m_ammoCurrent_txt.width;
            if(this.m_ammoTotal_txt.visible)
            {
               _loc1_ += this.m_ammoTotal_txt.width + DX_PADDING_BETWEEN_AMMO_COUNTERS;
            }
            this.m_containerAmmoText.x = -_loc1_;
            if(this.m_reload_mc != null)
            {
               this.m_reload_mc.x = -this.m_reload_mc.width;
            }
         }
      }
   }
}

import common.Animate;
import common.Localization;
import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;

class ReloadView extends Sprite
{
   
   public static const WARNLEVEL_NONE:int = 0;
   
   public static const WARNLEVEL_YELLOW:int = 1;
   
   public static const WARNLEVEL_RED:int = 2;
   
   private static const DT_BLINK_YELLOW:Number = 0.3;
   
   private static const DT_BLINK_RED:Number = 0.15;
    
   
   private var m_txtYellow:TextField;
   
   private var m_txtRed:TextField;
   
   private var m_bgYellow:Shape;
   
   private var m_bgRed:Shape;
   
   private var m_level:int = 0;
   
   public function ReloadView()
   {
      this.m_txtYellow = new TextField();
      this.m_txtRed = new TextField();
      this.m_bgYellow = new Shape();
      this.m_bgRed = new Shape();
      super();
      var _loc1_:Number = 24;
      this.m_txtYellow.name = "txtYellow";
      this.m_txtYellow.autoSize = "left";
      this.m_txtYellow.x = _loc1_;
      MenuUtils.setupTextUpper(this.m_txtYellow,Localization.get("EUI_TEXT_BUTTON_RELOAD"),18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
      this.m_txtRed.name = "txtRed";
      this.m_txtRed.autoSize = "left";
      this.m_txtRed.x = _loc1_;
      MenuUtils.setupTextUpper(this.m_txtRed,Localization.get("EUI_TEXT_BUTTON_RELOAD"),18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      this.m_bgYellow.name = "bgYellow";
      this.m_bgYellow.graphics.beginFill(MenuConstants.COLOR_YELLOW);
      this.m_bgYellow.graphics.drawRect(0,0,this.m_txtYellow.width + 2 * _loc1_,this.m_txtYellow.height);
      this.m_bgYellow.graphics.endFill();
      this.m_bgRed.name = "bgRed";
      this.m_bgRed.graphics.beginFill(MenuConstants.COLOR_RED);
      this.m_bgRed.graphics.drawRect(0,0,this.m_txtRed.width + 2 * _loc1_,this.m_txtRed.height);
      this.m_bgRed.graphics.endFill();
      this.addChild(this.m_bgYellow);
      this.addChild(this.m_bgRed);
      this.addChild(this.m_txtYellow);
      this.addChild(this.m_txtRed);
      this.visible = false;
   }
   
   public function setWarnLevel(param1:int) : void
   {
      if(this.m_level == param1)
      {
         return;
      }
      Animate.kill(this);
      switch(param1)
      {
         case WARNLEVEL_YELLOW:
            this.m_txtYellow.visible = true;
            this.m_bgYellow.visible = true;
            this.m_txtRed.visible = false;
            this.m_bgRed.visible = false;
            this.visible = true;
            Animate.delay(this,DT_BLINK_YELLOW,this.toggleBlinkState,DT_BLINK_YELLOW);
            break;
         case WARNLEVEL_RED:
            this.m_txtYellow.visible = false;
            this.m_bgYellow.visible = false;
            this.m_txtRed.visible = true;
            this.m_bgRed.visible = true;
            this.visible = true;
            Animate.delay(this,DT_BLINK_RED,this.toggleBlinkState,DT_BLINK_RED);
            break;
         default:
            this.visible = false;
      }
      this.m_level = param1;
   }
   
   private function toggleBlinkState(param1:Number) : void
   {
      this.visible = !this.visible;
      Animate.delay(this,param1,this.toggleBlinkState,param1);
   }
}
