package menu3.missionend
{
   import basic.DottedLine;
   import common.Animate;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import menu3.MenuElementBase;
   
   public dynamic class ActionRewardsDetail extends MenuElementBase
   {
      
      private static const WIDTH_CATEGORY:Number = 326;
      
      private static const WIDTH_CATEGORY_TITLE:Number = 227.5;
      
      private static const WIDTH_CATEGORY_VALUE:Number = 100;
      
      private static const DX_PADDING:Number = 5;
       
      
      private const CATEGORY_ELEMENTS_MAX:int = 20;
      
      private var m_view:ActionRewardsDetailView;
      
      private var m_headerMc:MovieClip;
      
      private var m_infiltrationCategoryMc:MovieClip;
      
      private var m_eliminationCategoryMc:MovieClip;
      
      private var m_missionCategoryMc:MovieClip;
      
      private var m_challengeCategoryMc:MovieClip;
      
      private var m_actionXPGain:int = 0;
      
      private var m_actionXPGainInfiltration:int = 0;
      
      private var m_actionXPGainElimination:int = 0;
      
      private var m_actionXPGainMission:int = 0;
      
      private var m_challengeXPGain:int = 0;
      
      private var m_infiltrationRewards:Array;
      
      private var m_eliminationRewards:Array;
      
      private var m_missionRewards:Array;
      
      private var m_challengeRewards:Array;
      
      private var m_fScaleTextMult:Number = 1;
      
      public function ActionRewardsDetail(param1:Object)
      {
         this.m_infiltrationRewards = [];
         this.m_eliminationRewards = [];
         this.m_missionRewards = [];
         this.m_challengeRewards = [];
         super(param1);
         this.m_view = new ActionRewardsDetailView();
         this.m_headerMc = this.m_view.headerMc;
         this.m_infiltrationCategoryMc = this.m_view.actionCategory1Mc;
         this.m_eliminationCategoryMc = this.m_view.actionCategory2Mc;
         this.m_missionCategoryMc = this.m_view.actionCategory3Mc;
         this.m_challengeCategoryMc = this.m_view.actionCategory4Mc;
         this.m_headerMc.alpha = this.m_infiltrationCategoryMc.alpha = this.m_eliminationCategoryMc.alpha = this.m_missionCategoryMc.alpha = this.m_challengeCategoryMc.alpha = 0;
         this.m_headerMc.visible = this.m_infiltrationCategoryMc.visible = this.m_eliminationCategoryMc.visible = this.m_missionCategoryMc.visible = this.m_challengeCategoryMc.visible = false;
         addChild(this.m_view);
      }
      
      override public function onUnregister() : void
      {
         this.killAnimations();
         this.m_view = null;
         super.onUnregister();
      }
      
      private function killAnimations() : void
      {
         Animate.kill(this.m_headerMc);
         Animate.kill(this.m_infiltrationCategoryMc);
         Animate.kill(this.m_eliminationCategoryMc);
         Animate.kill(this.m_missionCategoryMc);
         Animate.kill(this.m_challengeCategoryMc);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         super.onSetData(param1);
         this.m_infiltrationRewards.length = 0;
         this.m_eliminationRewards.length = 0;
         this.m_missionRewards.length = 0;
         this.m_challengeRewards.length = 0;
         this.m_actionXPGain = 0;
         this.m_challengeXPGain = 0;
         if(Boolean(param1.Challenges) && param1.Challenges.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.Challenges.length)
            {
               _loc3_ = param1.Challenges[_loc2_];
               _loc4_ = 0;
               if(_loc3_.XPGain != undefined)
               {
                  _loc4_ = int(_loc3_.XPGain);
               }
               if(_loc3_.IsActionReward === true)
               {
                  if(_loc4_ > 0)
                  {
                     if(this.hasCategoryTag(_loc3_,"infiltration"))
                     {
                        this.m_infiltrationRewards.push(_loc3_);
                        this.m_actionXPGainInfiltration += _loc4_;
                     }
                     else if(this.hasCategoryTag(_loc3_,"elimination"))
                     {
                        this.m_eliminationRewards.push(_loc3_);
                        this.m_actionXPGainElimination += _loc4_;
                     }
                     else
                     {
                        this.m_missionRewards.push(_loc3_);
                        this.m_actionXPGainMission += _loc4_;
                     }
                     this.m_actionXPGain += _loc4_;
                  }
               }
               else if(_loc4_ > 0)
               {
                  this.m_challengeRewards.push(_loc3_);
                  this.m_challengeXPGain += _loc4_;
                  this.m_actionXPGain += _loc4_;
               }
               _loc2_++;
            }
         }
         MenuUtils.setupTextUpper(this.m_headerMc.title,Localization.get("UI_MENU_MISSION_END_SCOREDETAIL_XP_TITLE"),46,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_headerMc.value,this.formatXpNumber(this.m_actionXPGain),46,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         this.m_fScaleTextMult = 1;
         if(this.m_actionXPGainInfiltration > 0)
         {
            this.setupActionCategory(this.m_infiltrationCategoryMc,Localization.get("UI_MENU_ACTIONREWARD_CATEGORY_INFILTRATION_TITLE"),this.m_actionXPGainInfiltration,this.m_infiltrationRewards);
         }
         if(this.m_actionXPGainElimination > 0)
         {
            this.setupActionCategory(this.m_eliminationCategoryMc,Localization.get("UI_MENU_ACTIONREWARD_CATEGORY_ELIMINATION_TITLE"),this.m_actionXPGainElimination,this.m_eliminationRewards);
         }
         if(this.m_actionXPGainMission > 0)
         {
            this.setupActionCategory(this.m_missionCategoryMc,Localization.get("UI_MENU_ACTIONREWARD_CATEGORY_MISSON_TITLE"),this.m_actionXPGainMission,this.m_missionRewards);
         }
         if(this.m_challengeXPGain > 0)
         {
            this.setupActionCategory(this.m_challengeCategoryMc,Localization.get("UI_MENU_PAGE_PLANNING_CHALLENGES"),this.m_challengeXPGain,this.m_challengeRewards);
         }
         this.rescaleTextInActionCategory(this.m_infiltrationCategoryMc);
         this.rescaleTextInActionCategory(this.m_eliminationCategoryMc);
         this.rescaleTextInActionCategory(this.m_missionCategoryMc);
         this.rescaleTextInActionCategory(this.m_challengeCategoryMc);
         this.repositionAndShow();
      }
      
      private function setupActionCategory(param1:MovieClip, param2:String, param3:int, param4:Array) : void
      {
         var _loc7_:ActionCategoryListElementView = null;
         param1.visible = true;
         MenuUtils.setupTextUpper(param1.title,param2,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(param1.value,this.formatXpNumber(param3),25,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         if(param4 == null || param4.length == 0)
         {
            return;
         }
         var _loc5_:Number = 0;
         var _loc6_:Number = 36;
         var _loc8_:int = Math.min(param4.length,this.CATEGORY_ELEMENTS_MAX);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            (_loc7_ = new ActionCategoryListElementView()).x = _loc5_;
            _loc7_.y = _loc6_;
            if(_loc9_ < _loc8_ - 1)
            {
               this.addDottedLine(2,32,_loc7_);
            }
            MenuUtils.setupText(_loc7_.title,Localization.get(param4[_loc9_].ChallengeName),16,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
            MenuUtils.setupText(_loc7_.value,this.formatXpNumber(param4[_loc9_].XPGain),16,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
            if(WIDTH_CATEGORY_TITLE - DX_PADDING < _loc7_.title.textWidth)
            {
               this.m_fScaleTextMult = Math.min(this.m_fScaleTextMult,(WIDTH_CATEGORY_TITLE - DX_PADDING) / _loc7_.title.textWidth);
            }
            if(WIDTH_CATEGORY_VALUE - DX_PADDING < _loc7_.value.textWidth)
            {
               this.m_fScaleTextMult = Math.min(this.m_fScaleTextMult,(WIDTH_CATEGORY_VALUE - DX_PADDING) / _loc7_.value.textWidth);
            }
            param1.addChild(_loc7_);
            _loc6_ += 32;
            _loc9_++;
         }
      }
      
      private function rescaleTextInActionCategory(param1:MovieClip) : void
      {
         var _loc3_:ActionCategoryListElementView = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_) as ActionCategoryListElementView;
            if(_loc3_ != null)
            {
               _loc3_.title.scaleX *= this.m_fScaleTextMult;
               _loc3_.title.scaleY *= this.m_fScaleTextMult;
               _loc3_.value.scaleX *= this.m_fScaleTextMult;
               _loc3_.value.scaleY *= this.m_fScaleTextMult;
               _loc3_.title.width = WIDTH_CATEGORY_TITLE / this.m_fScaleTextMult;
               _loc3_.value.width = WIDTH_CATEGORY_VALUE / this.m_fScaleTextMult;
               _loc3_.value.x = WIDTH_CATEGORY - WIDTH_CATEGORY_VALUE;
            }
            _loc2_++;
         }
      }
      
      private function repositionAndShow() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:Number = 0;
         var _loc4_:Number = 145;
         var _loc5_:Number = 328;
         var _loc6_:Number = 20;
         this.killAnimations();
         this.m_headerMc.visible = true;
         Animate.fromTo(this.m_headerMc,0.2,0,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         Animate.addFrom(this.m_headerMc,0.3,0,{"x":this.m_headerMc.x - 20},Animate.ExpoOut);
         if(this.m_infiltrationCategoryMc.visible == true)
         {
            this.m_infiltrationCategoryMc.x = _loc3_;
            this.m_infiltrationCategoryMc.y = _loc4_;
            Animate.fromTo(this.m_infiltrationCategoryMc,0.2,0.1,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            Animate.addFrom(this.m_infiltrationCategoryMc,0.3,0.1,{"x":this.m_infiltrationCategoryMc.x - 20},Animate.ExpoOut);
            _loc1_ = true;
         }
         if(_loc1_)
         {
            _loc3_ += _loc5_ + _loc6_;
         }
         if(this.m_eliminationCategoryMc.visible == true)
         {
            this.m_eliminationCategoryMc.x = _loc3_;
            this.m_eliminationCategoryMc.y = _loc4_;
            Animate.fromTo(this.m_eliminationCategoryMc,0.2,0.15,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            Animate.addFrom(this.m_eliminationCategoryMc,0.3,0.15,{"x":this.m_eliminationCategoryMc.x - 20},Animate.ExpoOut);
            _loc2_ = true;
         }
         if(this.m_missionCategoryMc.visible == true)
         {
            this.m_missionCategoryMc.x = _loc3_;
            if(this.m_eliminationCategoryMc.visible == true)
            {
               this.m_missionCategoryMc.y = this.m_eliminationCategoryMc.y + this.m_eliminationCategoryMc.height + 64 + 18;
            }
            else
            {
               this.m_missionCategoryMc.y = _loc4_;
            }
            Animate.fromTo(this.m_missionCategoryMc,0.2,0.2,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            Animate.addFrom(this.m_missionCategoryMc,0.3,0.2,{"x":this.m_missionCategoryMc.x - 20},Animate.ExpoOut);
            _loc2_ = true;
         }
         if(_loc2_)
         {
            _loc3_ += _loc5_ + _loc6_;
         }
         if(this.m_challengeCategoryMc.visible == true)
         {
            this.m_challengeCategoryMc.x = _loc3_;
            this.m_challengeCategoryMc.y = _loc4_;
            Animate.fromTo(this.m_challengeCategoryMc,0.2,0.25,{"alpha":0},{"alpha":1},Animate.ExpoOut);
            Animate.addFrom(this.m_challengeCategoryMc,0.3,0.25,{"x":this.m_challengeCategoryMc.x - 20},Animate.ExpoOut);
         }
      }
      
      private function hasCategoryTag(param1:Object, param2:String) : Boolean
      {
         var _loc3_:Array = param1.ChallengeTags;
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return false;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] === param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function formatXpNumber(param1:int) : String
      {
         return MenuUtils.formatNumber(param1) + " " + Localization.get("UI_PERFORMANCE_MASTERY_XP");
      }
      
      private function addDottedLine(param1:int, param2:int, param3:MovieClip) : void
      {
         var _loc4_:DottedLine;
         (_loc4_ = new DottedLine(WIDTH_CATEGORY,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2)).x = param1;
         _loc4_.y = param2;
         param3.addChild(_loc4_);
      }
   }
}
