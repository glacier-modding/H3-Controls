package hud.versus.scoring
{
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.external.ExternalInterface;
   import hud.notification.NotificationListener;
   
   public class ActionXpBarElement extends NotificationListener
   {
       
      
      private var m_container:Sprite;
      
      private var m_view:ActionXpBarView;
      
      private var m_elementYOffset:int = 33;
      
      private var m_elementCount:int = 0;
      
      private var m_yposArray:Array;
      
      public function ActionXpBarElement()
      {
         super();
         this.m_container = new Sprite();
         this.m_container.y = this.m_elementYOffset * 20;
         addChild(this.m_container);
         this.m_yposArray = new Array();
      }
      
      override public function ShowNotification(param1:String, param2:String, param3:Object) : void
      {
         var _loc9_:String = null;
         var _loc4_:ActionXpBarView;
         (_loc4_ = new ActionXpBarView()).header.autoSize = "left";
         _loc4_.value.autoSize = "left";
         var _loc5_:String = param3.xpGain <= 0 ? param2 : param2 + "     +";
         var _loc6_:String = param3.xpGain <= 0 ? MenuConstants.FontColorRed : MenuConstants.FontColorWhite;
         _loc6_ = !!param3.isRepeated ? MenuConstants.FontColorGreyMedium : _loc6_;
         MenuUtils.setupTextUpper(_loc4_.header,_loc5_,18,MenuConstants.FONT_TYPE_MEDIUM,_loc6_);
         MenuUtils.setupTextUpper(_loc4_.info.infotxt,param3.additionaldescription != null ? MenuUtils.removeHtmlLineBreaks(param3.additionaldescription) : "",18,MenuConstants.FONT_TYPE_MEDIUM,_loc6_);
         _loc4_.info.scaleX = _loc4_.info.scaleY = 0;
         _loc4_.info.alpha = 0;
         MenuUtils.setupText(_loc4_.value,param3.xpGain <= 0 ? "" : String(param3.xpGain),18,MenuConstants.FONT_TYPE_MEDIUM,_loc6_);
         var _loc7_:int = Math.floor(_loc4_.header.textWidth + _loc4_.value.textWidth);
         var _loc8_:int = Math.floor(_loc4_.value.textWidth);
         _loc4_.header.x = Math.floor(_loc4_.header.textWidth) / -2;
         _loc4_.value.x = _loc7_ / 2 - _loc8_;
         MenuUtils.setupTextUpper(_loc4_.header,param2,18,MenuConstants.FONT_TYPE_MEDIUM,_loc6_);
         MenuUtils.setupText(_loc4_.value,"",18,MenuConstants.FONT_TYPE_MEDIUM,_loc6_);
         _loc4_.bg.alpha = 0;
         _loc4_.bg.width = _loc7_ + 40;
         _loc4_.alpha = 0;
         switch(true)
         {
            case param3.xpGain <= 0:
               _loc9_ = "fail";
               break;
            case param3.xpGain > 0 && param3.xpGain < 100:
               _loc9_ = "common";
               break;
            case param3.xpGain >= 100 && param3.xpGain < 200:
               _loc9_ = "fair";
               break;
            case param3.xpGain >= 200 && param3.xpGain < 300:
               _loc9_ = "good";
               break;
            case param3.xpGain >= 300 && param3.xpGain < 400:
               _loc9_ = "excellent";
               break;
            case param3.xpGain >= 400:
               _loc9_ = "awesome";
               break;
            default:
               _loc9_ = "common";
         }
         var _loc10_:int = this.m_yposArray[this.m_yposArray.length - 1] + this.m_elementYOffset;
         this.m_yposArray.push(_loc10_ + (param3.additionaldescription != null ? 26 : 0));
         _loc4_.y = _loc10_ - this.m_elementYOffset * 20;
         this.m_container.addChild(_loc4_);
         var _loc11_:Object = {
            "element":_loc4_,
            "elementindex":this.m_yposArray.length,
            "description":_loc5_,
            "xpgain":param3.xpGain,
            "headerxoffset":_loc7_ / -2,
            "awesomeness":_loc9_,
            "fontColor":_loc6_,
            "isRepeated":param3.isRepeated
         };
         this.startAnimation(_loc11_);
      }
      
      private function startAnimation(param1:Object) : void
      {
         Animate.kill(param1.element);
         Animate.offset(param1.element,0.6,param1.elementindex * 0.1,{"y":-this.m_elementYOffset},Animate.ExpoOut,this.endAnimation,param1);
         Animate.addTo(param1.element,0.6,param1.elementindex * 0.1,{"alpha":1},Animate.ExpoOut);
         if(this.m_yposArray.length >= 2)
         {
            Animate.offset(this.m_container,0.2,0,{"y":-this.m_elementYOffset},Animate.ExpoOut);
         }
      }
      
      private function endAnimation(param1:Object) : void
      {
         Animate.kill(param1.element);
         Animate.kill(param1.element.bg);
         Animate.to(param1.element.header,0.2,0,{"x":param1.headerxoffset},Animate.ExpoOut);
         MenuUtils.setupTextUpper(param1.element.header,param1.description,18,MenuConstants.FONT_TYPE_MEDIUM,param1.fontColor);
         Animate.to(param1.element.info,0.2,0.2,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1
         },Animate.ExpoOut);
         var _loc2_:Number = param1.xpgain / 500;
         if(param1.xpgain > 0)
         {
            Animate.fromTo(param1.element.value,_loc2_,0,{"intAnimation":"0"},{"intAnimation":String(param1.xpgain)},Animate.ExpoOut);
         }
         var _loc3_:Number = param1.element.bg.scaleX + 0.6;
         var _loc4_:Number = 0;
         if(param1.awesomeness == "common")
         {
            this.playSound("ScoreCommon");
            _loc4_ = 0.3;
         }
         else if(param1.awesomeness == "fair")
         {
            this.playSound("ScoreFair");
            _loc4_ = 0.6;
         }
         else if(param1.awesomeness == "good")
         {
            this.playSound("ScoreGood");
            _loc4_ = 0.8;
         }
         else if(param1.awesomeness == "excellent")
         {
            this.playSound("ScoreGood");
            _loc4_ = 0.8;
         }
         else if(param1.awesomeness == "awesome")
         {
            this.playSound("ScoreAwesome");
            _loc4_ = 1;
         }
         else if(param1.awesomeness == "fail")
         {
            this.playSound("ScoreFail");
            MenuUtils.setTintColor(param1.element.bg,MenuUtils.TINT_COLOR_MAGENTA_DARK,false);
         }
         if(!param1.isRepeated)
         {
            param1.element.bg.alpha = _loc4_;
            Animate.to(param1.element.bg,0.8,0,{
               "scaleX":_loc3_,
               "alpha":0
            },Animate.ExpoOut);
         }
         Animate.offset(param1.element,0.4,0.8 + param1.elementindex * 0.1,{"y":param1.elementindex * -this.m_elementYOffset},Animate.ExpoIn,this.finishAnimation,param1.element);
      }
      
      private function finishAnimation(param1:ActionXpBarView) : void
      {
         Animate.kill(param1);
         this.m_yposArray.shift();
         if(this.m_yposArray.length == 0)
         {
            this.m_container.y = this.m_elementYOffset * 20;
         }
         this.m_container.removeChild(param1);
         param1 = null;
      }
      
      public function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
   }
}
