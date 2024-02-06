package hud
{
   import common.Animate;
   import common.BaseControl;
   import common.CommonUtils;
   import common.Localization;
   import common.ObjectPool;
   import common.TaskletSequencer;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import mx.utils.StringUtil;
   
   public class ObjectivesBar extends BaseControl
   {
      
      public static const BAR_ELEMENT_FADE_ANIM_TIME:Number = 0.3;
      
      public static const OBJ_MARGIN_HEIGHT:Number = 10;
      
      public static const LABEL_TEXT_LEADING:Number = 22;
      
      public static const SINGLE_LINE_NOTIFICATION_HEIGHT:Number = 23;
      
      public static const COUNTDOWN_OBJ_HEIGHT:Number = 23;
      
      public static const COUNTDOWN_OBJ_BG_XPOS:Number = 33;
      
      public static const COUNTDOWN_OBJ_HEADER_XPOS:Number = 34;
      
      public static const COUNTDOWN_OBJ_TEXT_GAP:Number = 10;
      
      public static const PERCENTAGE_BG_INIT_WIDTH:Number = 300;
      
      public static const HINT_INDENTATON:Number = 33;
       
      
      private var m_view:Sprite;
      
      private var m_objectivesHolder:Sprite;
      
      private var m_oppHolder:Sprite;
      
      private var m_oppMoveHolder:Sprite;
      
      private var m_intelHolder:Sprite;
      
      private var m_intelMoveHolder:Sprite;
      
      private var m_securityHolder:Sprite;
      
      private var m_securityMoveHolder:Sprite;
      
      private var m_startX:Number = 0;
      
      private var m_startY:Number = 0;
      
      private var m_intelPrevposY:Number = 0;
      
      private var m_OpportunityPrevPosY:Number = 0;
      
      private var m_SecurityPrevPosY:Number = 0;
      
      private var m_objectivesPosY:Number;
      
      private var m_timers:Dictionary;
      
      private var m_percentCounters:Dictionary;
      
      private var m_counters:Dictionary;
      
      private var m_oppLastIcon:String;
      
      private var m_oppLastTask:String;
      
      private var m_oppNotification:OpportunityBarView;
      
      private var m_intelIndicator:IntelIndicatorView;
      
      private var m_securityIndicator:SecurityIndicatorView;
      
      private var m_counterFieldTimerWidth:Number = -1;
      
      private var m_counterFieldPercentWidth:Number = -1;
      
      private var m_counterFieldSingleDigitWidth:Number = -1;
      
      private var m_counterFieldDoubleDigitWidth:Number = -1;
      
      private var m_counterFieldTripleDigitWidth:Number = -1;
      
      private var m_prevData:Object = null;
      
      private var m_objectiveViewPool:ObjectPool = null;
      
      private const m_lstrOptional:String = Localization.get("UI_DIALOG_OPTIONAL");
      
      private var m_zIconsVR:Number;
      
      private var m_evergreenHardcore:Boolean = false;
      
      public function ObjectivesBar()
      {
         super();
         this.m_view = new Sprite();
         addChild(this.m_view);
         this.m_objectivesHolder = new Sprite();
         this.m_view.addChild(this.m_objectivesHolder);
         this.m_oppLastIcon = "";
         this.m_oppLastTask = "";
         this.m_oppHolder = new Sprite();
         this.m_oppNotification = new OpportunityBarView();
         this.m_oppNotification.icon_mc.z = this.m_zIconsVR;
         this.m_oppMoveHolder = new Sprite();
         this.m_view.addChild(this.m_oppHolder);
         this.m_oppHolder.addChild(this.m_oppMoveHolder);
         this.m_oppMoveHolder.addChild(this.m_oppNotification);
         this.m_oppHolder.visible = false;
         this.m_intelHolder = new Sprite();
         this.m_intelIndicator = new IntelIndicatorView();
         this.m_intelIndicator.icon_mc.z = this.m_zIconsVR;
         this.m_intelMoveHolder = new Sprite();
         this.m_view.addChild(this.m_intelHolder);
         this.m_intelHolder.addChild(this.m_intelMoveHolder);
         this.m_intelMoveHolder.addChild(this.m_intelIndicator);
         this.m_intelHolder.visible = false;
         this.m_securityHolder = new Sprite();
         this.m_securityIndicator = new SecurityIndicatorView();
         this.m_securityMoveHolder = new Sprite();
         this.m_view.addChild(this.m_securityHolder);
         this.m_securityHolder.addChild(this.m_securityMoveHolder);
         this.m_securityMoveHolder.addChild(this.m_securityIndicator);
         this.m_securityHolder.visible = false;
         this.m_securityIndicator.header_txt.autoSize = "left";
         this.m_objectivesPosY = this.m_startY;
         this.onControlLayoutChanged();
         MenuUtils.setupText(this.m_oppNotification.desc_txt,"",18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         this.m_objectiveViewPool = new ObjectPool(LevelObjectiveView,10,this.initialiseObjectiveView);
         this.m_timers = new Dictionary();
         this.m_percentCounters = new Dictionary();
         this.m_counters = new Dictionary();
      }
      
      public function set zIconsVR(param1:Number) : void
      {
         this.m_zIconsVR = param1;
         this.m_oppNotification.icon_mc.z = param1;
         this.m_intelIndicator.icon_mc.z = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_objectivesHolder.numChildren)
         {
            (this.m_objectivesHolder.getChildAt(_loc2_) as LevelObjectiveView).iconAnim_mc.z = param1;
            _loc2_++;
         }
      }
      
      public function setEvergreenHardcore(param1:Boolean) : void
      {
         this.m_evergreenHardcore = param1;
      }
      
      private function initialiseObjectiveView(param1:LevelObjectiveView) : void
      {
         param1.visible = false;
         param1.counterTimer_mc.visible = false;
         param1.iconAnim_mc.z = this.m_zIconsVR;
         param1.label_txt.autoSize = "left";
         param1.label_txt.multiline = true;
         param1.label_txt.wordWrap = true;
         param1.label_txt.y = -1;
         MenuUtils.setupText(param1.label_txt,"",18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         param1.counterTimer_mc.header_txt.autoSize = "left";
         MenuUtils.setupText(param1.counterTimer_mc.header_txt,"",12,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
         MenuUtils.setupText(param1.counterTimer_mc.value_txt,"",24,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorGreyUltraDark);
         if(this.m_counterFieldTimerWidth == -1)
         {
            param1.counterTimer_mc.value_txt.text = "00:00";
            this.m_counterFieldTimerWidth = param1.counterTimer_mc.value_txt.textWidth;
            param1.counterTimer_mc.value_txt.text = "100%";
            this.m_counterFieldPercentWidth = param1.counterTimer_mc.value_txt.textWidth;
            param1.counterTimer_mc.value_txt.text = "0";
            this.m_counterFieldSingleDigitWidth = param1.counterTimer_mc.value_txt.textWidth;
            param1.counterTimer_mc.value_txt.text = "00";
            this.m_counterFieldDoubleDigitWidth = param1.counterTimer_mc.value_txt.textWidth;
            param1.counterTimer_mc.value_txt.text = "000";
            this.m_counterFieldTripleDigitWidth = param1.counterTimer_mc.value_txt.textWidth;
            param1.counterTimer_mc.value_txt.text = "";
         }
      }
      
      private function resetObjectiveView(param1:LevelObjectiveView) : void
      {
         param1.visible = false;
         param1.counterTimer_mc.visible = false;
         param1.label_txt.text = "";
         param1.counterTimer_mc.header_txt.text = "";
         param1.counterTimer_mc.value_txt.text = "";
      }
      
      public function onControlLayoutChanged() : void
      {
         MenuUtils.setupText(this.m_intelIndicator.header_txt,Localization.get("UI_HUD_INTEL_VIEW_INTEL"),18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.updateAndShowObjectives(param1);
      }
      
      public function updateAndShowObjectives(param1:Object, param2:Boolean = true) : void
      {
         var obj:Object = null;
         var lstr:String = null;
         var data:Object = param1;
         var bAnimate:Boolean = param2;
         if(data.contracttype == "arcade")
         {
            for each(obj in data.secondary)
            {
               for each(lstr in [this.m_lstrOptional,"[Доп.]","[Дополнительно]"])
               {
                  obj.objTitle = obj.objTitle.replace(lstr,"");
               }
               obj.objTitle = this.m_lstrOptional + " " + StringUtil.trim(obj.objTitle);
            }
         }
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            Animate.kill(m_objectivesHolder);
            m_objectivesHolder.visible = true;
            m_objectivesHolder.alpha = 1;
            m_objectivesHolder.removeChildren();
            m_objectivesPosY = m_startY;
            if(data.primary.length > 0)
            {
               addObjLines(data.primary);
            }
            if(data.secondary.length > 0)
            {
               addObjLines(data.secondary);
            }
            updateHeights(bAnimate);
         });
         if(this.m_prevData != null)
         {
            TaskletSequencer.getGlobalInstance().addChunk(function():void
            {
               releaseObjectiveViews(m_prevData.primary);
               releaseObjectiveViews(m_prevData.secondary);
            });
         }
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            m_prevData = data;
         });
      }
      
      private function releaseObjectiveViews(param1:Array) : void
      {
         var _loc2_:Number = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].view != null)
            {
               this.resetObjectiveView(param1[_loc2_].view);
               this.m_objectiveViewPool.releaseObject(param1[_loc2_].view);
               param1[_loc2_].view = null;
               if(param1[_loc2_].timerData)
               {
                  this.m_timers[param1[_loc2_].timerData.id] = null;
               }
               if(param1[_loc2_].percentCounterData)
               {
                  this.m_percentCounters[param1[_loc2_].percentCounterData.id] = null;
               }
               if(param1[_loc2_].counterData)
               {
                  this.m_counters[param1[_loc2_].counterData.id] = null;
               }
            }
            _loc2_++;
         }
      }
      
      public function updateTimers(param1:Array) : void
      {
         var timersArray:Array = param1;
         if(timersArray.length == 0)
         {
            return;
         }
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            var _loc1_:Object = null;
            for each(_loc1_ in timersArray)
            {
               if(m_timers[_loc1_.id])
               {
                  if(CommonUtils.getActiveTextLocaleIndex() == 11)
                  {
                     m_timers[_loc1_.id].y = 33;
                     m_timers[_loc1_.id].htmlText = _loc1_.timerString;
                  }
                  else
                  {
                     m_timers[_loc1_.id].y = 28;
                     m_timers[_loc1_.id].htmlText = _loc1_.timerString;
                  }
               }
            }
         });
      }
      
      public function updatePercentCounters(param1:Array) : void
      {
         var percentCountersArray:Array = param1;
         if(percentCountersArray.length == 0)
         {
            return;
         }
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            var _loc2_:Object = null;
            var _loc3_:Object = null;
            var _loc1_:Number = 0;
            while(_loc1_ < percentCountersArray.length)
            {
               _loc2_ = percentCountersArray[_loc1_];
               _loc3_ = m_percentCounters[_loc2_.id];
               if(_loc3_ != null)
               {
                  if(CommonUtils.getActiveTextLocaleIndex() == 11)
                  {
                     _loc3_.theField.y = 33;
                     _loc3_.theField = String(_loc2_.percent) + "%";
                  }
                  else
                  {
                     _loc3_.theField.y = 28;
                     _loc3_.theField = String(_loc2_.percent) + "%";
                  }
                  _loc3_.theBackground.width = PERCENTAGE_BG_INIT_WIDTH * (_loc2_.percent / 100);
               }
               _loc1_++;
            }
         });
      }
      
      public function updateCounters(param1:Array) : void
      {
         var countersArray:Array = param1;
         if(countersArray.length == 0)
         {
            return;
         }
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            var _loc2_:Object = null;
            var _loc3_:Object = null;
            var _loc1_:Number = 0;
            while(_loc1_ < countersArray.length)
            {
               _loc2_ = countersArray[_loc1_];
               _loc3_ = m_counters[_loc2_.id];
               if(_loc3_ != null)
               {
                  updateCounter(_loc3_,_loc2_.counterString,_loc2_.counterHeader);
               }
               _loc1_++;
            }
         });
      }
      
      private function findPrevObjectiveWithAvailableView(param1:String, param2:String) : Object
      {
         var _loc3_:Object = null;
         if(this.m_prevData != null)
         {
            if(this.m_prevData.primary != null)
            {
               _loc3_ = this.findPrevObjectiveHelper(param1,param2,this.m_prevData.primary);
            }
            if(_loc3_ == null && this.m_prevData.secondary != null)
            {
               _loc3_ = this.findPrevObjectiveHelper(param1,param2,this.m_prevData.secondary);
            }
         }
         return _loc3_;
      }
      
      private function findPrevObjectiveHelper(param1:String, param2:String, param3:Array) : Object
      {
         var _loc4_:Number = 0;
         while(_loc4_ < param3.length)
         {
            if(param3[_loc4_].id == param1 && param3[_loc4_].objTitle == param2 && param3[_loc4_].view != null)
            {
               return param3[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      private function addObjLines(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Number = 0;
         for(; _loc2_ < param1.length; _loc2_++)
         {
            if(this.m_prevData != null)
            {
               _loc3_ = this.findPrevObjectiveWithAvailableView(param1[_loc2_].id,param1[_loc2_].objTitle);
               if(_loc3_ != null)
               {
                  if(param1[_loc2_].isHint)
                  {
                     this.updateHint(param1[_loc2_],_loc3_);
                  }
                  else
                  {
                     this.updateObjective(param1[_loc2_],_loc3_);
                  }
                  continue;
               }
            }
            if(param1[_loc2_].isHint)
            {
               this.addHint(param1[_loc2_]);
            }
            else
            {
               this.addObjective(param1[_loc2_]);
            }
         }
      }
      
      private function updateYPosition(param1:Object) : void
      {
         param1.view.y = this.m_objectivesPosY;
         var _loc2_:Number = 0;
         if(param1.view.label_txt.numLines - 1 > 0)
         {
            _loc2_ = -6;
         }
         this.m_objectivesPosY += SINGLE_LINE_NOTIFICATION_HEIGHT + (param1.view.label_txt.numLines - 1) * LABEL_TEXT_LEADING + _loc2_ + OBJ_MARGIN_HEIGHT;
         if(Boolean(param1.timerData) || Boolean(param1.percentCounterData) || Boolean(param1.counterData))
         {
            param1.view.counterTimer_mc.y = (param1.view.label_txt.numLines - 1) * LABEL_TEXT_LEADING + _loc2_;
            this.m_objectivesPosY += OBJ_MARGIN_HEIGHT + COUNTDOWN_OBJ_HEIGHT;
         }
      }
      
      private function addObjective(param1:Object) : void
      {
         var _loc2_:String = null;
         param1.view = this.m_objectiveViewPool.acquireObject();
         param1.view.visible = true;
         param1.view.label_txt.width = 670;
         if(!param1.objSuccess && !param1.objFail)
         {
            _loc2_ = MenuConstants.FontColorWhite;
            this.setObjectiveOpenIcon(param1);
         }
         else
         {
            _loc2_ = MenuConstants.FontColorGreyMedium;
            this.setObjectiveResolvedIcon(param1);
         }
         if(param1.objChanged)
         {
            param1.view.x = this.m_startX + 150;
            Animate.legacyTo(param1.view,1,{"x":this.m_startX},Animate.ExpoOut);
         }
         else
         {
            param1.view.x = this.m_startX;
         }
         if(param1.timerData)
         {
            this.initialiseObjectiveTimer(param1.view,param1.objTitle,param1.timerData);
            _loc2_ = MenuConstants.FontColorWhite;
         }
         else if(param1.percentCounterData)
         {
            this.initialiseObjectivePercentCounter(param1.view,param1.objTitle,param1.percentCounterData);
            _loc2_ = MenuConstants.FontColorWhite;
         }
         else if(param1.counterData)
         {
            this.initialiseObjectiveCounter(param1.view,param1.objTitle,param1.objType,param1.counterData);
            _loc2_ = MenuConstants.FontColorWhite;
         }
         param1.view.label_txt.htmlText = param1.objTitle.toUpperCase();
         MenuUtils.setTextColor(param1.view.label_txt,MenuConstants.ColorNumber(_loc2_));
         this.updateYPosition(param1);
         this.m_objectivesHolder.addChild(param1.view);
      }
      
      private function updateObjective(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         param1.view = param2.view;
         param2.view = null;
         if(Boolean(param1.timerData) && this.m_timers[param1.timerData.id] == null)
         {
            this.initialiseObjectiveTimer(param1.view,param1.objTitle,param1.timerData);
         }
         else if(param1.timerData == null && this.m_timers[param1.id] != null)
         {
            this.m_timers[param1.id] = null;
            param1.view.counterTimer_mc.visible = false;
         }
         if(Boolean(param1.percentCounterData) && this.m_percentCounters[param1.percentCounterData.id] == null)
         {
            this.initialiseObjectivePercentCounter(param1.view,param1.objTitle,param1.percentCounterData);
         }
         else if(param1.percentCounterData == null && this.m_percentCounters[param1.id] != null)
         {
            this.m_percentCounters[param1.id] = null;
            param1.view.counterTimer_mc.visible = false;
         }
         if(Boolean(param1.counterData) && this.m_counters[param1.counterData.id] == null)
         {
            this.initialiseObjectiveCounter(param1.view,param1.objTitle,param1.objType,param1.counterData);
         }
         else if(param1.counterData == null && this.m_counters[param1.id] != null)
         {
            this.m_counters[param1.id] = null;
            param1.view.counterTimer_mc.visible = false;
         }
         this.updateYPosition(param1);
         if(param1.objChanged)
         {
            param1.view.x = this.m_startX + 150;
            Animate.legacyTo(param1.view,1,{"x":this.m_startX},Animate.ExpoOut);
            if(!param1.objSuccess && !param1.objFail)
            {
               _loc3_ = MenuConstants.FontColorWhite;
               this.setObjectiveOpenIcon(param1);
            }
            else
            {
               _loc3_ = MenuConstants.FontColorGreyMedium;
               this.setObjectiveResolvedIcon(param1);
            }
            if(!param1.timerData && !param1.percentCounterData && !param1.counterData)
            {
               MenuUtils.setTextColor(param1.view.label_txt,MenuConstants.ColorNumber(_loc3_));
            }
         }
         this.m_objectivesHolder.addChild(param1.view);
      }
      
      private function setObjectiveOpenIcon(param1:Object) : void
      {
         param1.view.iconAnim_mc.z = this.m_zIconsVR;
         param1.view.iconAnim_mc.icon_mc.gotoAndStop(1);
         param1.view.iconAnim_mc.icon_mc.type_mc.gotoAndStop(this.iconNormalOrEvergreenHardcore(this.m_evergreenHardcore,param1.objType));
      }
      
      private function setObjectiveResolvedIcon(param1:Object) : void
      {
         param1.view.iconAnim_mc.z = 0;
         if(Boolean(param1.objSuccess) && !param1.objFail)
         {
            param1.view.iconAnim_mc.icon_mc.gotoAndStop(3);
         }
         else if(!param1.objSuccess && Boolean(param1.objFail))
         {
            param1.view.iconAnim_mc.icon_mc.gotoAndStop(2);
         }
         else
         {
            param1.view.iconAnim_mc.icon_mc.gotoAndStop(4);
         }
      }
      
      private function addHint(param1:Object) : void
      {
         param1.view = this.m_objectiveViewPool.acquireObject();
         param1.view.visible = true;
         var _loc2_:Number = this.m_startX + HINT_INDENTATON;
         param1.view.iconAnim_mc.icon_mc.gotoAndStop(1);
         param1.view.iconAnim_mc.icon_mc.type_mc.gotoAndStop(param1.objType + 1);
         param1.view.label_txt.width = 670 - HINT_INDENTATON;
         if(param1.objChanged)
         {
            param1.view.x = _loc2_ + 150;
            Animate.legacyTo(param1.view,1,{"x":_loc2_},Animate.ExpoOut);
         }
         else
         {
            param1.view.x = _loc2_;
         }
         var _loc3_:Boolean = param1.objType == 14 || param1.objType == 15 || param1.objType == 16;
         param1.view.label_txt.htmlText = param1.objTitle.toUpperCase();
         MenuUtils.setTextColor(param1.view.label_txt,MenuConstants.ColorNumber(_loc3_ ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite));
         param1.view.iconAnim_mc.z = _loc3_ ? 0 : this.m_zIconsVR;
         this.updateYPosition(param1);
         this.m_objectivesHolder.addChild(param1.view);
      }
      
      private function updateHint(param1:Object, param2:Object) : void
      {
         param1.view = param2.view;
         param2.view = null;
         this.updateYPosition(param1);
         if(param1.objChanged)
         {
            param1.view.x = this.m_startX + HINT_INDENTATON + 150;
            Animate.legacyTo(param1.view,1,{"x":this.m_startX + HINT_INDENTATON},Animate.ExpoOut);
         }
         this.m_objectivesHolder.addChild(param1.view);
      }
      
      private function iconNormalOrEvergreenHardcore(param1:Boolean, param2:int) : int
      {
         if(param1 && param2 >= 60 && param2 <= 62)
         {
            return param2 + 6;
         }
         if(param1 && param2 == 59)
         {
            return 73;
         }
         if(param1 && param2 >= 4 && param2 <= 7)
         {
            return 72;
         }
         return param2 + 1;
      }
      
      public function showOpportunity(param1:String, param2:String, param3:Boolean) : void
      {
         var sIcon:String = param1;
         var sTask:String = param2;
         var bNoDupes:Boolean = param3;
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            if(bNoDupes && m_oppHolder.visible && sIcon == m_oppLastIcon && sTask == m_oppLastTask)
            {
               return;
            }
            Animate.kill(m_oppHolder);
            Animate.kill(m_oppNotification.icon_mc);
            Animate.kill(m_oppNotification);
            m_oppHolder.visible = true;
            m_oppHolder.alpha = 0;
            updateHeights();
            Animate.legacyTo(m_oppHolder,BAR_ELEMENT_FADE_ANIM_TIME,{"alpha":1},Animate.ExpoIn);
            m_oppNotification.desc_txt.htmlText = sTask;
            m_oppNotification.icon_mc.gotoAndStop(sIcon);
            m_oppNotification.x = 100;
            Animate.legacyTo(m_oppNotification,1,{"x":0},Animate.ExpoOut);
            m_oppNotification.icon_mc.scaleX = m_oppNotification.icon_mc.scaleY = 2.5;
            Animate.legacyTo(m_oppNotification.icon_mc,2,{
               "scaleX":1,
               "scaleY":1
            },Animate.ExpoOut);
            m_oppLastIcon = sIcon;
            m_oppLastTask = sTask;
         });
      }
      
      public function hideOpportunity() : void
      {
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            Animate.kill(m_oppNotification);
            Animate.kill(m_oppHolder);
            Animate.kill(m_oppMoveHolder);
            m_oppHolder.visible = false;
            updateHeights();
         });
      }
      
      public function hideObjectives(param1:Boolean = true) : void
      {
         var bAnimate:Boolean = param1;
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            Animate.kill(m_objectivesHolder);
            fadeOutObjectives(bAnimate);
         });
      }
      
      public function showIntelData(param1:Object) : void
      {
         this.showIntel(param1.headline,param1.showDuration);
      }
      
      public function showIntel(param1:String, param2:Number) : void
      {
         var sHeadline:String = param1;
         var showDuration:Number = param2;
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            Animate.kill(m_intelHolder);
            Animate.kill(m_intelIndicator.icon_mc);
            Animate.kill(m_intelIndicator);
            m_intelHolder.visible = true;
            m_intelHolder.alpha = 0;
            updateHeights();
            Animate.legacyTo(m_intelHolder,BAR_ELEMENT_FADE_ANIM_TIME,{"alpha":1},Animate.ExpoIn);
            m_intelIndicator.x = 100;
            Animate.legacyTo(m_intelIndicator,1,{"x":0},Animate.ExpoOut);
            m_intelIndicator.icon_mc.scaleX = m_intelIndicator.icon_mc.scaleY = 2.5;
            Animate.legacyTo(m_intelIndicator.icon_mc,2,{
               "scaleX":1,
               "scaleY":1
            },Animate.ExpoOut);
            Animate.delay(m_intelIndicator,showDuration + 2,fadeOutIntelIndicator);
         });
      }
      
      public function showSecurityIndicator(param1:String) : void
      {
         var sText:String = param1;
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            Animate.kill(m_securityHolder);
            Animate.kill(m_securityIndicator.icon_mc);
            Animate.kill(m_securityIndicator);
            m_securityHolder.visible = true;
            m_securityHolder.alpha = 0;
            updateHeights();
            Animate.legacyTo(m_securityHolder,BAR_ELEMENT_FADE_ANIM_TIME,{"alpha":1},Animate.ExpoIn);
            MenuUtils.setupText(m_securityIndicator.header_txt,sText,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            m_securityIndicator.x = 100;
            Animate.legacyTo(m_securityIndicator,1,{"x":0},Animate.ExpoOut);
            m_securityIndicator.icon_mc.scaleX = m_securityIndicator.icon_mc.scaleY = 1;
            Animate.legacyTo(m_securityIndicator.icon_mc,2,{
               "scaleX":1,
               "scaleY":1
            },Animate.ExpoOut);
            Animate.delay(m_securityIndicator,14,fadeOutSecurityIndicator);
         });
      }
      
      private function fadeOutIntelIndicator() : void
      {
         Animate.legacyTo(this.m_intelHolder,BAR_ELEMENT_FADE_ANIM_TIME,{"alpha":0},Animate.Linear,this.hideIntelIndicator);
      }
      
      public function hideIntelIndicator() : void
      {
         TaskletSequencer.getGlobalInstance().addChunk(function():void
         {
            ExternalInterface.call("OnIntelNotificationHidden");
            Animate.kill(m_intelIndicator);
            Animate.kill(m_intelHolder);
            Animate.kill(m_intelMoveHolder);
            m_intelHolder.visible = false;
            m_intelHolder.alpha = 0;
            updateHeights();
         });
      }
      
      private function fadeOutSecurityIndicator() : void
      {
         Animate.legacyTo(this.m_securityHolder,BAR_ELEMENT_FADE_ANIM_TIME,{"alpha":0},Animate.Linear,this.hideSecurityIndicator);
      }
      
      private function hideSecurityIndicator() : void
      {
         Animate.kill(this.m_securityIndicator);
         Animate.kill(this.m_securityHolder);
         Animate.kill(this.m_securityMoveHolder);
         this.m_securityHolder.visible = false;
         this.m_securityHolder.alpha = 0;
         this.updateHeights();
      }
      
      private function fadeOutObjectives(param1:Boolean = true) : void
      {
         Animate.legacyTo(this.m_objectivesHolder,param1 ? BAR_ELEMENT_FADE_ANIM_TIME : 0,{"alpha":0},Animate.Linear,this.hideObjectivesHolder,param1);
      }
      
      private function hideObjectivesHolder(param1:Boolean = true) : void
      {
         Animate.kill(this.m_objectivesHolder);
         this.m_objectivesHolder.visible = false;
         this.m_objectivesHolder.alpha = 0;
         this.updateHeights(param1);
      }
      
      private function updateHeights(param1:Boolean = true) : void
      {
         var _loc2_:Number = param1 ? 1 : 0;
         var _loc3_:Number = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 1.2 : 1;
         this.m_view.scaleX = _loc3_;
         this.m_view.scaleY = _loc3_;
         if(!this.m_objectivesHolder.visible)
         {
            this.m_objectivesPosY = this.m_startY;
         }
         var _loc4_:Number;
         var _loc5_:Number = _loc4_ = this.m_objectivesPosY;
         if(this.m_oppHolder.visible)
         {
            _loc5_ = _loc5_ + SINGLE_LINE_NOTIFICATION_HEIGHT + OBJ_MARGIN_HEIGHT;
         }
         var _loc6_:Number = _loc5_;
         if(this.m_intelHolder.visible)
         {
            _loc6_ = _loc6_ + SINGLE_LINE_NOTIFICATION_HEIGHT + OBJ_MARGIN_HEIGHT;
         }
         if(this.m_OpportunityPrevPosY != _loc4_)
         {
            if(this.m_oppHolder.visible)
            {
               Animate.kill(this.m_oppMoveHolder);
               Animate.legacyTo(this.m_oppMoveHolder,_loc2_,{"y":_loc4_},Animate.ExpoOut);
            }
            else
            {
               this.m_oppMoveHolder.y = _loc4_;
            }
         }
         if(this.m_intelPrevposY != _loc5_)
         {
            if(this.m_intelHolder.visible)
            {
               Animate.kill(this.m_intelMoveHolder);
               Animate.legacyTo(this.m_intelMoveHolder,_loc2_,{"y":_loc5_},Animate.ExpoOut);
            }
            else
            {
               this.m_intelMoveHolder.y = _loc5_;
            }
         }
         if(this.m_SecurityPrevPosY != _loc6_)
         {
            if(this.m_securityHolder.visible)
            {
               Animate.kill(this.m_securityMoveHolder);
               Animate.legacyTo(this.m_securityMoveHolder,_loc2_,{"y":_loc6_},Animate.ExpoOut);
            }
            else
            {
               this.m_securityMoveHolder.y = _loc6_;
            }
         }
         this.m_OpportunityPrevPosY = _loc4_;
         this.m_intelPrevposY = _loc5_;
         this.m_SecurityPrevPosY = _loc6_;
      }
      
      private function initialiseObjectiveTimer(param1:LevelObjectiveView, param2:String, param3:Object) : void
      {
         param1.iconAnim_mc.icon_mc.gotoAndStop(1);
         param1.iconAnim_mc.icon_mc.type_mc.gotoAndStop(this.iconNormalOrEvergreenHardcore(this.m_evergreenHardcore,4));
         if(this.m_evergreenHardcore)
         {
            MenuUtils.setColor(param1.counterTimer_mc.value_txt,MenuConstants.COLOR_WHITE,false);
            MenuUtils.setColor(param1.counterTimer_mc.header_txt,MenuConstants.COLOR_WHITE,false);
            MenuUtils.setColor(param1.counterTimer_mc.static_bg,MenuConstants.COLOR_RED,false);
            MenuUtils.setColor(param1.counterTimer_mc.dynamic_bg,MenuConstants.COLOR_RED,false);
         }
         param1.counterTimer_mc.static_bg.visible = false;
         param1.counterTimer_mc.visible = true;
         param1.counterTimer_mc.value_txt.autoSize = "left";
         if(CommonUtils.getActiveTextLocaleIndex() == 11)
         {
            param1.counterTimer_mc.value_txt.y = 33;
         }
         else
         {
            param1.counterTimer_mc.value_txt.y = 28;
         }
         param3.timerHeader = Localization.get("UI_BRIEFING_DIAL_TIME");
         if(param3.timerHeader)
         {
            param1.counterTimer_mc.header_txt.htmlText = param3.timerHeader;
         }
         param1.counterTimer_mc.value_txt.htmlText = param3.timerString;
         if(param3.timerHeader)
         {
            param1.counterTimer_mc.value_txt.x = COUNTDOWN_OBJ_HEADER_XPOS + param1.counterTimer_mc.header_txt.textWidth + COUNTDOWN_OBJ_TEXT_GAP;
            param1.counterTimer_mc.dynamic_bg.width = param1.counterTimer_mc.header_txt.textWidth + COUNTDOWN_OBJ_TEXT_GAP + this.m_counterFieldTimerWidth + 3;
         }
         else
         {
            param1.counterTimer_mc.value_txt.x = COUNTDOWN_OBJ_HEADER_XPOS;
            param1.counterTimer_mc.dynamic_bg.width = this.m_counterFieldTimerWidth + 3;
         }
         this.m_timers[param3.id] = param1.counterTimer_mc.value_txt;
      }
      
      private function initialiseObjectivePercentCounter(param1:LevelObjectiveView, param2:String, param3:Object) : void
      {
         var _loc4_:Number = 0;
         param1.iconAnim_mc.icon_mc.gotoAndStop(1);
         param1.iconAnim_mc.icon_mc.type_mc.gotoAndStop(20);
         param1.counterTimer_mc.static_bg.visible = true;
         param1.counterTimer_mc.visible = true;
         param1.counterTimer_mc.value_txt.autoSize = "right";
         if(CommonUtils.getActiveTextLocaleIndex() == 11)
         {
            param1.counterTimer_mc.value_txt.y = 33;
         }
         else
         {
            param1.counterTimer_mc.value_txt.y = 28;
         }
         param3.percentCounterHeader = Localization.get("UI_HUD_INFECTION_IN_BODY");
         if(param3.percentCounterHeader)
         {
            param1.counterTimer_mc.header_txt.htmlText = param3.percentCounterHeader;
         }
         param1.counterTimer_mc.value_txt.text = String(param3.percent) + "%";
         param1.counterTimer_mc.value_txt.x = COUNTDOWN_OBJ_HEADER_XPOS + PERCENTAGE_BG_INIT_WIDTH + 3 - COUNTDOWN_OBJ_TEXT_GAP - this.m_counterFieldPercentWidth;
         param1.counterTimer_mc.dynamic_bg.width = PERCENTAGE_BG_INIT_WIDTH;
         param1.counterTimer_mc.static_bg.width = PERCENTAGE_BG_INIT_WIDTH;
         param1.counterTimer_mc.static_bg.alpha = 0.5;
         var _loc5_:TextField = param1.counterTimer_mc.value_txt as TextField;
         this.m_percentCounters[param3.id] = {
            "theField":_loc5_,
            "theBackground":param1.counterTimer_mc.dynamic_bg
         };
      }
      
      private function initialiseObjectiveCounter(param1:LevelObjectiveView, param2:String, param3:Number, param4:Object) : void
      {
         param1.iconAnim_mc.icon_mc.gotoAndStop(1);
         param1.iconAnim_mc.icon_mc.type_mc.gotoAndStop(this.iconNormalOrEvergreenHardcore(this.m_evergreenHardcore,param3 + 1));
         param1.counterTimer_mc.static_bg.visible = false;
         param1.counterTimer_mc.visible = true;
         param1.counterTimer_mc.value_txt.autoSize = "left";
         var _loc5_:TextField = param1.counterTimer_mc.value_txt as TextField;
         this.m_counters[param4.id] = {
            "theField":_loc5_,
            "background":param1.counterTimer_mc.dynamic_bg,
            "headerField":param1.counterTimer_mc.header_txt,
            "counterString":param4.counterString
         };
         _loc5_.scaleX = 1;
         _loc5_.scaleY = 1;
         var _loc6_:Object = this.m_counters[param4.id];
         this.updateCounter(_loc6_,param4.counterString,param4.counterHeader);
      }
      
      private function updateCounter(param1:Object, param2:String, param3:String) : void
      {
         var _loc4_:TextField = param1.theField as TextField;
         var _loc5_:Object = param1.background;
         var _loc6_:TextField = param1.headerField as TextField;
         var _loc7_:String = String(param1.counterString);
         Animate.kill(_loc4_);
         _loc4_.scaleX = _loc4_.scaleY = 1;
         if(CommonUtils.getActiveTextLocaleIndex() == 11)
         {
            _loc4_.y = 33;
         }
         else
         {
            _loc4_.y = 28;
         }
         if(param3)
         {
            _loc6_.htmlText = param3;
         }
         _loc4_.htmlText = param2;
         _loc4_.x = COUNTDOWN_OBJ_HEADER_XPOS;
         _loc5_.width = this.determineCounterBackgroundCounterTextWidth(param2) + 5;
         if(param3)
         {
            _loc4_.x += _loc6_.textWidth + COUNTDOWN_OBJ_TEXT_GAP;
            _loc6_.x = COUNTDOWN_OBJ_HEADER_XPOS;
            _loc5_.width += _loc6_.textWidth + COUNTDOWN_OBJ_TEXT_GAP;
         }
         if(param2 != _loc7_)
         {
            this.animateCounterTextScale(_loc4_,_loc6_);
         }
      }
      
      private function animateCounterTextScale(param1:TextField, param2:TextField) : void
      {
         var _loc3_:Number = param1.scaleX;
         var _loc4_:Number = param1.scaleY;
         var _loc5_:Number = param1.width;
         var _loc6_:Number = param1.height;
         var _loc7_:Number = param1.x;
         var _loc8_:Number = param1.y;
         param1.scaleX = param1.scaleY = 1.3;
         param1.x = _loc7_ - (param1.width - _loc5_) / 2;
         param1.y = _loc8_ - (param1.height - _loc6_) / 2;
         Animate.to(param1,0.6,0,{
            "x":_loc7_,
            "y":_loc8_,
            "scaleX":_loc3_,
            "scaleY":_loc4_
         },Animate.ExpoOut);
      }
      
      private function determineCounterBackgroundCounterTextWidth(param1:String) : Number
      {
         if(param1.length <= 1)
         {
            return this.m_counterFieldSingleDigitWidth;
         }
         if(param1.length == 2)
         {
            return this.m_counterFieldDoubleDigitWidth;
         }
         return this.m_counterFieldTripleDigitWidth;
      }
   }
}
