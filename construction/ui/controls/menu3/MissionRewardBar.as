package menu3
{
   import common.Animate;
   import common.Localization;
   import common.Log;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class MissionRewardBar
   {
       
      
      private const ANIMATION_DIR_IN:String = "in";
      
      private const ANIMATION_DIR_OUT:String = "out";
      
      private var m_view:Object;
      
      private var m_levelPointsAccum:Array;
      
      private var m_levelMaxed:Boolean = false;
      
      private var m_startXPDisp:Number;
      
      private var m_endXPDisp:Number;
      
      private var m_barRatio:Number;
      
      private var m_displayLevel:Number;
      
      private var m_last_level:Number;
      
      private var m_last_barScale:Number;
      
      public function MissionRewardBar(param1:Object)
      {
         super();
         this.m_view = param1;
      }
      
      public function init(param1:Array) : void
      {
         this.m_view.mastery_txt.visible = false;
         this.m_view.xpnum_txt.visible = false;
         this.m_view.masteryLevelMc.visible = false;
         this.m_view.masteryBarFrameMc.visible = false;
         this.m_view.masteryBarFrameMc.top.scaleY = 0;
         this.m_view.masteryBarFrameMc.bottom.scaleY = 0;
         this.m_view.masteryBarFrameMc.left.scaleY = 0;
         this.m_view.masteryBarFrameMc.right.scaleY = 0;
         this.m_view.masteryBarFillMc.visible = false;
         this.m_view.masteryBarFillMc.scaleX = 0;
         if(param1 != null)
         {
            this.m_levelPointsAccum = param1;
         }
      }
      
      public function onUnregister() : void
      {
         Animate.kill(this.m_view);
         Animate.kill(this.m_view.xpnum_txt);
         this.m_view = null;
      }
      
      public function animateShowBar() : void
      {
         this.m_view.masteryBarFrameMc.visible = true;
         this.m_view.masteryBarFillMc.visible = true;
         Animate.delay(this.m_view.masteryBarFrameMc,0.4,this.animateMasteryBar,this.ANIMATION_DIR_IN,this.m_view.masteryBarFrameMc.left,0.2,Animate.ExpoOut);
         Animate.delay(this.m_view.masteryBarFrameMc,0.45,this.animateMasteryBar,this.ANIMATION_DIR_IN,this.m_view.masteryBarFrameMc.top,0.3,Animate.ExpoIn);
         Animate.delay(this.m_view.masteryBarFrameMc,0.48,this.animateMasteryBar,this.ANIMATION_DIR_IN,this.m_view.masteryBarFrameMc.bottom,0.3,Animate.ExpoIn,true);
         Animate.delay(this.m_view.masteryBarFrameMc,0.95,this.animateMasteryBar,this.ANIMATION_DIR_IN,this.m_view.masteryBarFrameMc.right,0.2,Animate.ExpoOut);
      }
      
      public function animateHideBar() : void
      {
         Animate.to(this.m_view.masteryBarFillMc,0.3,0,{"scaleX":0},Animate.ExpoOut,function():void
         {
            m_view.masteryBarFillMc.alpha = 0;
         });
         Animate.to(this.m_view.mastery_txt,0.2,0,{
            "alpha":0,
            "y":this.m_view.mastery_txt.y + 10
         },Animate.ExpoOut);
         Animate.to(this.m_view.xpnum_txt,0.4,0,{
            "alpha":0,
            "x":this.m_view.xpnum_txt.x - 15
         },Animate.ExpoOut);
         Animate.delay(this.m_view.masteryBarFrameMc,0,this.animateMasteryBar,this.ANIMATION_DIR_OUT,this.m_view.masteryBarFrameMc.right,0.1,Animate.ExpoOut);
         Animate.delay(this.m_view.masteryBarFrameMc,0.1,this.animateMasteryBar,this.ANIMATION_DIR_OUT,this.m_view.masteryBarFrameMc.bottom,0.15,Animate.ExpoIn);
         Animate.delay(this.m_view.masteryBarFrameMc,0.1,this.animateMasteryBar,this.ANIMATION_DIR_OUT,this.m_view.masteryBarFrameMc.top,0.15,Animate.ExpoIn);
         Animate.delay(this.m_view.masteryBarFrameMc,0.25,this.animateMasteryBar,this.ANIMATION_DIR_OUT,this.m_view.masteryBarFrameMc.left,0.1,Animate.ExpoOut,true);
      }
      
      public function setXpValues(param1:Number, param2:Number, param3:String) : void
      {
         this.m_startXPDisp = param1;
         this.m_endXPDisp = param2;
         this.m_levelMaxed = this.isLevelMaxed(this.m_startXPDisp);
         this.m_displayLevel = Math.floor(this.getLevelFromList(this.m_startXPDisp));
         this.m_last_level = this.m_displayLevel;
         MenuUtils.setupText(this.m_view.mastery_txt,param3,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyDark);
      }
      
      public function getLevelFromList(param1:Number) : Number
      {
         if(!this.m_levelPointsAccum)
         {
            return 1;
         }
         var _loc2_:int = int(this.m_levelPointsAccum.length);
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(param1 <= this.m_levelPointsAccum[_loc4_])
            {
               break;
            }
            _loc3_ = _loc4_;
            _loc4_++;
         }
         var _loc5_:Number = param1 - this.m_levelPointsAccum[_loc3_];
         var _loc6_:Number = 0;
         if(_loc3_ < _loc2_ - 1)
         {
            _loc6_ = _loc5_ / (this.m_levelPointsAccum[_loc3_ + 1] - this.m_levelPointsAccum[_loc3_]);
         }
         return _loc3_ + 1 + _loc6_;
      }
      
      public function isLevelMaxed(param1:Number) : Boolean
      {
         var _loc2_:int = int(this.m_levelPointsAccum.length - 1);
         if(param1 >= this.m_levelPointsAccum[_loc2_])
         {
            return true;
         }
         return false;
      }
      
      private function animateMasteryBar(param1:String, param2:MovieClip, param3:Number, param4:int, param5:Boolean = false) : void
      {
         switch(param1)
         {
            case this.ANIMATION_DIR_IN:
               if(param5)
               {
                  Animate.legacyTo(param2,param3,{"scaleY":1},param4,this.onMasteryBarInComplete,null);
               }
               else
               {
                  Animate.legacyTo(param2,param3,{"scaleY":1},param4);
               }
               break;
            case this.ANIMATION_DIR_OUT:
               if(param5)
               {
                  Animate.legacyTo(param2,param3,{"scaleY":0},param4,this.onMasteryBarOutComplete,null);
               }
               else
               {
                  Animate.legacyTo(param2,param3,{"scaleY":0},param4);
               }
               break;
            default:
               Log.info(Log.ChannelCommon,this,"MissionRewardBar --> unhandled case in animateMasteryBar(): " + param1);
         }
      }
      
      private function onMasteryBarInComplete(param1:*) : void
      {
         this.initXPBar();
      }
      
      private function onMasteryBarOutComplete(param1:*) : void
      {
      }
      
      public function showXPLeft() : void
      {
         if(this.m_levelMaxed)
         {
            return;
         }
         this.m_view.xpnum_txt.visible = true;
         this.m_view.xpnum_txt.alpha = 0;
         this.m_view.xpnum_txt.x -= 15;
         Animate.legacyTo(this.m_view.xpnum_txt,0.5,{
            "alpha":1,
            "x":this.m_view.xpnum_txt.x + 15
         },Animate.ExpoOut);
      }
      
      private function initXPBar() : void
      {
         if(this.m_levelMaxed)
         {
            Animate.legacyTo(this.m_view.masteryBarFillMc,0.3,{"scaleX":1},Animate.ExpoOut);
            this.m_last_barScale = 1;
         }
         else
         {
            this.m_barRatio = this.getLevelFromList(this.m_startXPDisp) - this.m_displayLevel;
            this.m_last_barScale = this.m_barRatio;
            Animate.legacyTo(this.m_view.masteryBarFillMc,0.3,{"scaleX":this.m_barRatio},Animate.ExpoOut);
         }
         this.updateXPFields();
         this.m_view.mastery_txt.visible = true;
         this.m_view.mastery_txt.alpha = 0;
         this.m_view.mastery_txt.y += 15;
         Animate.legacyTo(this.m_view.mastery_txt,0.3,{
            "alpha":1,
            "y":this.m_view.mastery_txt.y - 15
         },Animate.ExpoOut);
         this.m_view.masteryLevelMc.visible = true;
         this.m_view.masteryLevelMc.alpha = 0;
         this.m_view.masteryLevelMc.scaleX = 0;
         this.m_view.masteryLevelMc.scaleY = 0;
         Animate.legacyTo(this.m_view.masteryLevelMc,0.4,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1
         },Animate.ExpoOut);
         var _loc1_:String = String(this.m_displayLevel) + "/" + String(this.m_levelPointsAccum.length);
         MenuUtils.setupText(this.m_view.masteryLevelMc.label_txt,_loc1_,30,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyDark);
      }
      
      public function updateXPBar(param1:Number) : void
      {
         var oldXP:Number = NaN;
         var xpGain:Number = param1;
         oldXP = this.m_startXPDisp;
         this.m_startXPDisp += xpGain;
         this.m_startXPDisp = Math.min(this.m_startXPDisp,this.m_endXPDisp);
         this.m_displayLevel = Math.floor(this.getLevelFromList(this.m_startXPDisp));
         this.m_levelMaxed = this.isLevelMaxed(this.m_startXPDisp);
         Animate.delay(this.m_view,0.3,function():void
         {
            if(m_levelMaxed)
            {
               Animate.legacyTo(m_view.masteryBarFillMc,0.3,{"scaleX":1},Animate.ExpoOut);
            }
            else
            {
               m_barRatio = getLevelFromList(m_startXPDisp) - m_displayLevel;
               if(m_startXPDisp > oldXP)
               {
                  if(m_barRatio > m_last_barScale)
                  {
                     Animate.legacyTo(m_view.masteryBarFillMc,0.3,{"scaleX":m_barRatio},Animate.ExpoOut);
                  }
                  else
                  {
                     Animate.legacyTo(m_view.masteryBarFillMc,0.3,{"scaleX":1},Animate.ExpoOut,function():void
                     {
                        m_view.masteryBarFillMc.scaleX = 0;
                        Animate.legacyTo(m_view.masteryBarFillMc,0.2,{"scaleX":m_barRatio},Animate.ExpoIn);
                     });
                  }
               }
               m_last_barScale = m_barRatio;
            }
            updateXPFields();
         });
      }
      
      private function updateXPFields() : void
      {
         var points:Number = NaN;
         var pointsToNextLevel:String = null;
         if(this.m_displayLevel > this.m_last_level)
         {
            this.playSound("LevelUp");
            Animate.legacyTo(this.m_view.masteryLevelMc,0.3,{
               "alpha":0,
               "scaleX":0,
               "scaleY":0
            },Animate.ExpoOut);
            Animate.delay(this.m_view.masteryLevelMc,0.2,function():void
            {
               m_view.masteryLevelMc.alpha = 0;
               m_view.masteryLevelMc.scaleX = 2;
               m_view.masteryLevelMc.scaleY = 2;
               var _loc1_:String = String(m_displayLevel) + "/" + String(m_levelPointsAccum.length);
               MenuUtils.setupText(m_view.masteryLevelMc.label_txt,_loc1_,30,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyDark);
               Animate.legacyTo(m_view.masteryLevelMc,0.4,{
                  "alpha":1,
                  "scaleX":1,
                  "scaleY":1
               },Animate.ExpoOut);
            });
         }
         this.m_last_level = this.m_displayLevel;
         if(this.m_startXPDisp > this.m_levelPointsAccum[this.m_levelPointsAccum.length - 1])
         {
            MenuUtils.setupText(this.m_view.xpnum_txt,"",18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyDark);
         }
         else
         {
            if(!this.m_levelMaxed)
            {
               points = this.m_levelPointsAccum[this.m_displayLevel] - this.m_startXPDisp;
               pointsToNextLevel = Localization.get("UI_MENU_PAGE_REWARD_POINTS_TO_NEXT_LEVEL").replace("{p}",points);
               MenuUtils.setupText(this.m_view.xpnum_txt,pointsToNextLevel,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyDark);
            }
            this.textFieldAutosize(this.m_view.xpnum_txt);
            this.m_view.xpnum_txt.x = this.m_view.masteryBarFrameMc.x + this.m_view.masteryBarFrameMc.width - this.m_view.xpnum_txt.width;
         }
      }
      
      private function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
      
      private function textFieldAutosize(param1:TextField) : void
      {
         var tempHeight:Number = NaN;
         var padding:Number = NaN;
         var tf:TextField = param1;
         try
         {
            padding = 2;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tempHeight = tf.height;
            tf.autoSize = TextFieldAutoSize.NONE;
            tf.height = tempHeight + padding;
         }
         catch(error:Error)
         {
            trace("[TextFieldAutosize] " + error);
         }
      }
   }
}
