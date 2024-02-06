package hud.evergreen
{
   import common.Animate;
   import common.BaseControl;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   
   public class EconomyWidget extends BaseControl
   {
       
      
      private var m_view:EvergreenEconomyWidgetView;
      
      private var m_mercesPrev:int = 2147483647;
      
      private var m_notificationsPending:Vector.<Notification>;
      
      private var m_isNotificationAnimating:Boolean = false;
      
      private const m_lstrMerces:String = Localization.get("UI_EVERGREEN_MERCES");
      
      private const m_lstrMoney:String = Localization.get("EVERGREEN_HUD_MONEY").toUpperCase();
      
      private var notifEndX:Number = 0;
      
      public function EconomyWidget()
      {
         this.m_view = new EvergreenEconomyWidgetView();
         this.m_notificationsPending = new Vector.<Notification>();
         super();
         addChild(this.m_view);
         MenuUtils.setupText(this.m_view.money_txt,"",18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.notification_txt,"",18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_view.notification_txt.alpha = 0;
         this.notifEndX = this.m_view.notification_txt.x;
      }
      
      public function onSetData(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.m_mercesPrev == int.MAX_VALUE)
         {
            this.updateMoney(param1);
         }
         else
         {
            _loc2_ = param1 - this.m_mercesPrev;
            if(_loc2_ != 0)
            {
               if(this.m_isNotificationAnimating)
               {
                  this.m_notificationsPending.push(new Notification(_loc2_,param1));
               }
               else
               {
                  this.startNotificationAnimation(_loc2_,param1);
               }
            }
         }
         this.m_mercesPrev = param1;
      }
      
      private function updateMoney(param1:int) : void
      {
         this.m_view.money_txt.htmlText = this.m_lstrMoney.replace(/\{0\}/g,MenuUtils.formatNumber(param1,false));
      }
      
      private function startNotificationAnimation(param1:int, param2:int) : void
      {
         var yTop:Number;
         var yMid:Number;
         var yLow:Number;
         var yStart:Number;
         var xStart:Number;
         var xEnd:Number;
         var yEnd:Number = NaN;
         var diffMerces:int = param1;
         var mercesAfter:int = param2;
         this.m_isNotificationAnimating = true;
         if(diffMerces < 0)
         {
            this.updateMoney(mercesAfter);
            this.animateIcon();
         }
         MenuUtils.setTextColor(this.m_view.notification_txt,diffMerces > 0 ? MenuConstants.COLOR_GREEN : MenuConstants.COLOR_RED);
         this.m_view.notification_txt.htmlText = (diffMerces > 0 ? "+" : "") + MenuUtils.formatNumber(diffMerces,false) + " " + this.m_lstrMerces;
         yTop = this.m_view.money_txt.y + this.m_view.money_txt.height - this.m_view.notification_txt.height;
         yMid = this.m_view.money_txt.y + this.m_view.money_txt.height;
         yLow = this.m_view.money_txt.y + this.m_view.money_txt.height + this.m_view.notification_txt.height;
         yStart = diffMerces < 0 ? yTop : yMid;
         yEnd = diffMerces < 0 ? yMid : yTop;
         xStart = diffMerces < 0 ? this.notifEndX : this.notifEndX - 100;
         xEnd = diffMerces < 0 ? this.notifEndX - 100 : this.notifEndX;
         this.m_view.notification_txt.x = xStart;
         this.m_view.notification_txt.y = yStart;
         this.m_view.notification_txt.alpha = 0;
         Animate.to(this.m_view.notification_txt,0.2,0,{
            "alpha":1,
            "y":yMid,
            "x":this.notifEndX
         },Animate.SineOut,Animate.to,this.m_view.notification_txt,0.2,1,{
            "alpha":0,
            "y":yEnd,
            "x":xEnd
         },Animate.SineIn,function():void
         {
            var _loc1_:Notification = null;
            if(diffMerces > 0)
            {
               updateMoney(mercesAfter);
               animateIcon();
            }
            if(m_notificationsPending.length == 0)
            {
               m_isNotificationAnimating = false;
            }
            else
            {
               _loc1_ = m_notificationsPending.shift();
               startNotificationAnimation(_loc1_.diffMerces,_loc1_.mercesAfter);
            }
         });
      }
      
      private function animateIcon() : void
      {
         this.m_view.icon_mc.scaleX = this.m_view.icon_mc.scaleY = 1.3;
         Animate.to(this.m_view.icon_mc,0.2,0.07,{
            "scaleX":1,
            "scaleY":1
         },Animate.SineOut);
      }
   }
}

class Notification
{
    
   
   public var diffMerces:int;
   
   public var mercesAfter:int;
   
   public function Notification(param1:int, param2:int)
   {
      super();
      this.diffMerces = param1;
      this.mercesAfter = param2;
   }
}
