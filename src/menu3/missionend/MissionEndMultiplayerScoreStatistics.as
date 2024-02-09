package menu3.missionend
{
   import basic.DottedLine;
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import menu3.MenuElementBase;
   
   public dynamic class MissionEndMultiplayerScoreStatistics extends MenuElementBase
   {
       
      
      private var m_view:MissionEndMultiplayerScoreStatisticsView;
      
      private var m_listElements:Array;
      
      public function MissionEndMultiplayerScoreStatistics(param1:Object)
      {
         super(param1);
         this.m_view = new MissionEndMultiplayerScoreStatisticsView();
         this.m_view.line_static.visible = false;
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MissionEndMultiplayerScoreStatisticsElementView = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         super.onSetData(param1);
         this.m_view.line_static.visible = false;
         this.cleanupElements();
         if(param1.stats != null)
         {
            param1.stats.reverse();
            this.m_listElements = new Array();
            this.m_view.line_static.visible = true;
            _loc2_ = 0;
            while(_loc2_ < param1.stats.length)
            {
               _loc3_ = new MissionEndMultiplayerScoreStatisticsElementView();
               this.m_listElements.push(_loc3_);
               _loc3_.alpha = 0;
               _loc3_.y = 493 - 33 * _loc2_;
               _loc3_.playervalue.x = -231;
               _loc3_.opponentvalue.x = 161;
               this.m_view.addChild(_loc3_);
               _loc4_ = param1.stats[_loc2_].player1 == null ? "-" : String(param1.stats[_loc2_].player1);
               _loc5_ = param1.stats[_loc2_].player2 == null ? "-" : String(param1.stats[_loc2_].player2);
               _loc6_ = param1.stats[_loc2_].player1 == null ? MenuConstants.FontColorGreyMedium : (param1.stats[_loc2_].player1 >= param1.stats[_loc2_].player2 ? MenuConstants.FontColorWhite : MenuConstants.FontColorGreyMedium);
               _loc7_ = param1.stats[_loc2_].player2 == null ? MenuConstants.FontColorGreyMedium : (param1.stats[_loc2_].player2 >= param1.stats[_loc2_].player1 ? MenuConstants.FontColorWhite : MenuConstants.FontColorGreyMedium);
               this.setupStatisticElements(_loc3_,param1.stats[_loc2_].name,_loc4_,_loc5_,_loc6_,_loc7_,_loc2_ >= 1 ? true : false,_loc2_);
               _loc8_ = (462 - 33 * _loc2_) / 100;
               _loc2_++;
            }
            Animate.to(this.m_view.line,0.4 + _loc2_ / 20,0,{"scaleY":_loc8_},Animate.ExpoOut);
         }
      }
      
      private function setupStatisticElements(param1:MissionEndMultiplayerScoreStatisticsElementView, param2:String, param3:String, param4:String, param5:String, param6:String, param7:Boolean, param8:int) : void
      {
         var _loc9_:DottedLine = null;
         MenuUtils.setupTextUpper(param1.title,param2,20,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         if(param7)
         {
            (_loc9_ = new DottedLine(460,MenuConstants.COLOR_GREY_LIGHT,DottedLine.TYPE_HORIZONTAL,1,2)).x = 460 / -2;
            _loc9_.y = 33;
            param1.addChild(_loc9_);
         }
         Animate.offset(param1,0.4,param8 / 20,{"y":-33},Animate.ExpoOut);
         Animate.addTo(param1,0.4,param8 / 20,{"alpha":1},Animate.ExpoOut);
         if(param3 != "-")
         {
            MenuUtils.setupText(param1.playervalue,"0",20,MenuConstants.FONT_TYPE_MEDIUM,param5);
            Animate.fromTo(param1.playervalue,0.6,param8 / 20,{"intAnimation":"0"},{"intAnimation":param3},Animate.Linear);
         }
         else
         {
            MenuUtils.setupText(param1.playervalue,param3,20,MenuConstants.FONT_TYPE_MEDIUM,param5);
         }
         if(param4 != "-")
         {
            MenuUtils.setupText(param1.opponentvalue,"0",20,MenuConstants.FONT_TYPE_MEDIUM,param6);
            Animate.fromTo(param1.opponentvalue,0.6,param8 / 20,{"intAnimation":"0"},{"intAnimation":param4},Animate.Linear);
         }
         else
         {
            MenuUtils.setupText(param1.opponentvalue,param4,20,MenuConstants.FONT_TYPE_MEDIUM,param6);
         }
      }
      
      private function cleanupElements() : void
      {
         var _loc1_:int = 0;
         Animate.kill(this.m_view.line);
         if(this.m_listElements)
         {
            _loc1_ = 0;
            while(_loc1_ < this.m_listElements.length)
            {
               Animate.kill(this.m_listElements[_loc1_]);
               Animate.kill(this.m_listElements[_loc1_].playervalue);
               Animate.kill(this.m_listElements[_loc1_].opponentvalue);
               this.m_view.removeChild(this.m_listElements[_loc1_]);
               _loc1_++;
            }
            this.m_listElements = [];
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.cleanupElements();
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
   }
}
