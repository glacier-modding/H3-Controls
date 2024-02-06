package hud
{
   import common.Animate;
   import common.BaseControl;
   import common.TaskletSequencer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   
   public class StatusMicroMarkersVR extends BaseControl
   {
      
      private static const DX_GAP_BETWEEN_INDICATORS:Number = 8;
      
      private static const ICON_SEARCHING:int = 1;
      
      private static const ICON_COMPROMISED:int = 2;
      
      private static const ICON_HUNTED:int = 3;
      
      private static const ICON_COMBAT:int = 4;
      
      private static const ICON_SECURITYCAMERA:int = 5;
      
      private static const ICON_HIDDENINLVA:int = 6;
      
      private static const ICON_QUESTIONMARK:int = 7;
      
      private static const ICON_UNCONSCIOUSWITNESS:int = 8;
       
      
      private var m_tensionIndicatorMc:MovieClip;
      
      private var m_informationBarLVA:MovieClip;
      
      private var m_trespassingIndicatorMc:MovieClip;
      
      private var m_timerView:TimerView;
      
      private var m_isTensionIndicatorVisible:Boolean = false;
      
      private var m_isLVAIndicatorVisible:Boolean = false;
      
      private var m_isTrespassingIndicatorVisible:Boolean = false;
      
      private var m_widthIndicator:Number;
      
      private var m_heightIndicator:Number;
      
      private var m_isRightAligned:Boolean = false;
      
      public function StatusMicroMarkersVR()
      {
         this.m_timerView = new TimerView();
         super();
         var _loc1_:StatusMarkerView = new StatusMarkerView();
         this.m_trespassingIndicatorMc = _loc1_.trespassingIndicatorMc;
         this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.bgGradient);
         this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.overlayMc);
         this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.pulseMc);
         this.m_trespassingIndicatorMc.removeChild(this.m_trespassingIndicatorMc.labelTxt);
         this.m_trespassingIndicatorMc.bgMc.width = this.m_trespassingIndicatorMc.bgMc.height;
         this.m_trespassingIndicatorMc.bgMc.x = this.m_trespassingIndicatorMc.bgMc.width / 2;
         this.m_trespassingIndicatorMc.x = this.m_trespassingIndicatorMc.y = 0;
         this.m_trespassingIndicatorMc.scaleX = this.m_trespassingIndicatorMc.scaleY = 0;
         addChild(this.m_trespassingIndicatorMc);
         this.m_widthIndicator = this.m_trespassingIndicatorMc.bgMc.width;
         this.m_heightIndicator = this.m_trespassingIndicatorMc.bgMc.height;
         this.m_informationBarLVA = _loc1_.informationBarLVA;
         this.m_informationBarLVA.removeChild(this.m_informationBarLVA.labelTxt);
         this.m_informationBarLVA.iconMc.gotoAndStop(ICON_HIDDENINLVA);
         var _loc2_:Number = 1;
         var _loc3_:Number = 1;
         var _loc4_:uint = 16777215;
         var _loc5_:Number = 1;
         var _loc6_:uint = 0;
         var _loc7_:Graphics;
         (_loc7_ = this.m_informationBarLVA.graphics).beginFill(_loc4_,_loc3_);
         _loc7_.drawRect(0,0,this.m_widthIndicator,this.m_heightIndicator);
         _loc7_.endFill();
         _loc7_.beginFill(_loc6_,_loc5_);
         _loc7_.drawRect(_loc2_,_loc2_,this.m_widthIndicator - 2 * _loc2_,this.m_heightIndicator - 2 * _loc2_);
         _loc7_.endFill();
         this.m_informationBarLVA.x = this.m_informationBarLVA.y = 0;
         this.m_informationBarLVA.scaleX = this.m_informationBarLVA.scaleY = 0;
         addChild(this.m_informationBarLVA);
         this.m_tensionIndicatorMc = _loc1_.tensionIndicatorMc;
         this.m_tensionIndicatorMc.removeChild(this.m_tensionIndicatorMc.bgGradient);
         this.m_tensionIndicatorMc.removeChild(this.m_tensionIndicatorMc.unconMc);
         this.m_tensionIndicatorMc.removeChild(this.m_tensionIndicatorMc.labelTxt);
         this.m_tensionIndicatorMc.bgMc.width = this.m_tensionIndicatorMc.bgMc.height;
         this.m_tensionIndicatorMc.x = this.m_tensionIndicatorMc.y = 0;
         this.m_tensionIndicatorMc.scaleX = this.m_tensionIndicatorMc.scaleY = 0;
         addChild(this.m_tensionIndicatorMc);
         addChild(this.m_timerView);
         this.m_timerView.rotationX = 1;
         this.m_timerView.rotationX = 0;
         this.m_timerView.visible = false;
      }
      
      public function set xTimerView(param1:Number) : void
      {
         this.m_timerView.x = param1;
      }
      
      public function set yTimerView(param1:Number) : void
      {
         this.m_timerView.y = param1;
      }
      
      public function set zTimerView(param1:Number) : void
      {
         this.m_timerView.z = param1;
      }
      
      public function set degRotationTimerView(param1:Number) : void
      {
         this.m_timerView.rotationX = param1;
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_isTrespassingIndicatorVisible = Boolean(param1.bTrespassing) || Boolean(param1.bDeepTrespassing);
         TaskletSequencer.getGlobalInstance().addChunk(this.updateIndicators);
      }
      
      public function setInLVA(param1:Boolean) : void
      {
         this.m_isLVAIndicatorVisible = param1;
         TaskletSequencer.getGlobalInstance().addChunk(this.updateIndicators);
      }
      
      public function setTensionMessage(param1:String, param2:Number, param3:int) : void
      {
         var msg:String = param1;
         var state:Number = param2;
         var nWitnesses:int = param3;
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            if(msg == "")
            {
               m_isTensionIndicatorVisible = false;
            }
            else
            {
               if(nWitnesses >= 1)
               {
                  m_tensionIndicatorMc.iconMc.gotoAndStop(ICON_UNCONSCIOUSWITNESS);
               }
               else
               {
                  m_tensionIndicatorMc.iconMc.gotoAndStop(state > 0 ? state : 1);
               }
               m_isTensionIndicatorVisible = true;
            }
            updateIndicators();
         });
      }
      
      private function updateIndicators() : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc3_:Number = this.m_isRightAligned ? -1 : 1;
         _loc2_ = this.m_isTensionIndicatorVisible ? 1 : 0;
         Animate.to(this.m_tensionIndicatorMc,0.5,0,{
            "x":_loc3_ * _loc1_,
            "scaleX":_loc3_ * _loc2_,
            "scaleY":_loc2_
         },Animate.ExpoOut);
         if(this.m_isTensionIndicatorVisible)
         {
            _loc1_ += this.m_widthIndicator + DX_GAP_BETWEEN_INDICATORS;
         }
         _loc2_ = this.m_isLVAIndicatorVisible ? 1 : 0;
         Animate.to(this.m_informationBarLVA,0.5,0,{
            "x":_loc3_ * _loc1_,
            "scaleX":_loc3_ * _loc2_,
            "scaleY":_loc2_
         },Animate.ExpoOut);
         if(this.m_isLVAIndicatorVisible)
         {
            _loc1_ += this.m_widthIndicator + DX_GAP_BETWEEN_INDICATORS;
         }
         _loc2_ = this.m_isTrespassingIndicatorVisible ? 1 : 0;
         Animate.to(this.m_trespassingIndicatorMc,0.5,0,{
            "x":_loc3_ * _loc1_,
            "scaleX":_loc3_ * _loc2_,
            "scaleY":_loc2_
         },Animate.ExpoOut);
      }
      
      public function updateTimers(param1:Array) : void
      {
         var timers:Array = param1;
         if(timers.length == 0)
         {
            this.m_timerView.visible = false;
            return;
         }
         this.m_timerView.visible = true;
         this.m_timerView.value_txt.text = timers[0].timerString;
         this.m_timerView.clockIcon.alpha = 0;
         Animate.to(this.m_timerView.clockIcon,1.2,0,{"alpha":1},Animate.ExpoOut,function():void
         {
            m_timerView.visible = false;
         });
      }
      
      public function setRightAligned(param1:Boolean) : void
      {
         this.m_isRightAligned = param1;
         this.updateIndicators();
         this.m_timerView.setRightAligned(param1);
      }
   }
}

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;

class TimerView extends Sprite
{
    
   
   public var clockIcon:DisplayObject;
   
   public var bg:DisplayObject;
   
   public var value_txt:TextField;
   
   public function TimerView()
   {
      super();
      this.name = "timerView";
      var _loc1_:LevelObjectiveView = new LevelObjectiveView();
      this.bg = _loc1_.counterTimer_mc.static_bg.getChildAt(0);
      this.bg.x = -1;
      this.bg.y = -1;
      this.addChild(this.bg);
      _loc1_.iconAnim_mc.icon_mc.gotoAndStop(1);
      _loc1_.iconAnim_mc.icon_mc.type_mc.gotoAndStop(4);
      this.clockIcon = _loc1_.iconAnim_mc.icon_mc.type_mc.getChildAt(0);
      this.addChild(this.clockIcon);
      this.value_txt = _loc1_.counterTimer_mc.value_txt;
      this.value_txt.y = -5;
      this.value_txt.x = this.clockIcon.width + 5;
      MenuUtils.setupText(this.value_txt,"",24,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorGreyUltraDark);
      this.addChild(this.value_txt);
      this.value_txt.text = "00:00";
      this.bg.width = this.value_txt.x + this.value_txt.textWidth + 10;
      this.bg.height = this.clockIcon.height + 2;
      this.bg.scaleX *= -1;
   }
   
   public function setRightAligned(param1:Boolean) : void
   {
      if(!param1)
      {
         this.bg.x = -1;
      }
      else
      {
         this.bg.x = -this.bg.width - 1;
      }
      this.clockIcon.x = this.bg.x + 1;
      this.value_txt.x = this.clockIcon.x + this.clockIcon.width + 5;
   }
}
