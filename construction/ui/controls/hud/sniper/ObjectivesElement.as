package hud.sniper
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public class ObjectivesElement extends BaseControl
   {
      
      public static const BAR_ELEMENT_FADE_ANIM_TIME:Number = 0.3;
      
      public static const OBJ_MARGIN_HEIGHT:Number = 10;
      
      public static const OBJ_HINT_MARGIN_HEIGHT:Number = 3;
      
      public static const LABEL_TEXT_LEADING:Number = 16;
      
      public static const HINT_INDENTATON:Number = 60;
       
      
      private var m_view:Sprite;
      
      private var m_objectivesHolder:Sprite;
      
      private var m_startX:Number = 0;
      
      private var m_startY:Number = 0;
      
      private var m_objectivesPosY:Number;
      
      public function ObjectivesElement()
      {
         super();
         this.m_view = new Sprite();
         addChild(this.m_view);
         this.m_objectivesHolder = new Sprite();
         this.m_view.addChild(this.m_objectivesHolder);
         this.m_objectivesPosY = this.m_startY;
      }
      
      public function onSetData(param1:Object) : void
      {
         this.updateAndShowObjectives(param1);
      }
      
      public function updateAndShowObjectives(param1:Object) : void
      {
         Animate.kill(this.m_objectivesHolder);
         this.m_objectivesHolder.visible = true;
         this.m_objectivesHolder.alpha = 1;
         while(this.m_objectivesHolder.numChildren > 0)
         {
            this.m_objectivesHolder.removeChildAt(0);
         }
         this.addObjectives(param1);
         this.updateHeights();
      }
      
      private function addObjectives(param1:Object) : void
      {
         this.m_objectivesPosY = this.m_startY;
         if(param1.primary.length > 0)
         {
            this.addObjLines(param1.primary);
         }
         if(param1.secondary.length > 0)
         {
            this.addObjLines(param1.secondary);
         }
      }
      
      private function addObjLines(param1:Array) : void
      {
         var _loc2_:Number = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_].isHint == true)
            {
               this.addHint(param1[_loc2_],this.m_startX);
            }
            else
            {
               this.addObjective(param1[_loc2_].objTitle,this.m_startX,this.m_objectivesPosY,param1[_loc2_].objType,param1[_loc2_].objSuccess,param1[_loc2_].objFail,param1[_loc2_].objChanged,param1[_loc2_].timerData,param1[_loc2_].counterData);
            }
            _loc2_++;
         }
      }
      
      private function addObjective(param1:String, param2:Number, param3:Number, param4:Number, param5:Boolean, param6:Boolean, param7:Boolean, param8:Object, param9:Object) : void
      {
         var _loc10_:ObjectivesElementView = new ObjectivesElementView();
         var _loc11_:String = MenuConstants.FontColorWhite;
         _loc10_.objective_txt.autoSize = "left";
         _loc10_.objective_txt.multiline = true;
         _loc10_.objective_txt.wordWrap = true;
         _loc10_.objective_txt.width = 670;
         if(!param5 && !param6)
         {
            _loc10_.icons.gotoAndStop(1);
            _loc10_.icons.typeicons.gotoAndStop(param4 + 1);
         }
         if(param5 && !param6)
         {
            _loc11_ = MenuConstants.FontColorGreyMedium;
            _loc10_.icons.gotoAndStop(3);
         }
         if(!param5 && param6)
         {
            _loc11_ = MenuConstants.FontColorGreyMedium;
            _loc10_.icons.gotoAndStop(2);
         }
         if(param5 && param6)
         {
            _loc11_ = MenuConstants.FontColorGreyMedium;
            _loc10_.icons.gotoAndStop(4);
         }
         if(param7)
         {
            _loc10_.x = param2 + 150;
            Animate.legacyTo(_loc10_,1,{"x":param2},Animate.ExpoOut);
         }
         else
         {
            _loc10_.x = param2;
         }
         _loc10_.y = param3;
         MenuUtils.setupText(_loc10_.objective_txt,param1,18,MenuConstants.FONT_TYPE_MEDIUM,_loc11_);
         this.m_objectivesPosY += _loc10_.objective_txt.numLines * LABEL_TEXT_LEADING + OBJ_MARGIN_HEIGHT;
         this.m_objectivesHolder.addChild(_loc10_);
      }
      
      private function addHint(param1:Object, param2:Number) : void
      {
         param2 += HINT_INDENTATON;
         var _loc3_:ObjectivesElementView = new ObjectivesElementView();
         _loc3_.icons.gotoAndStop(1);
         _loc3_.icons.typeicons.gotoAndStop(param1.objType + 1);
         _loc3_.x += 11;
         _loc3_.icons.scaleX = 0.8;
         _loc3_.icons.scaleY = 0.8;
         _loc3_.objective_txt.autoSize = "left";
         _loc3_.objective_txt.multiline = true;
         _loc3_.objective_txt.wordWrap = true;
         _loc3_.objective_txt.width = 670 - HINT_INDENTATON;
         if(param1.objChanged)
         {
            _loc3_.x = param2 + 300;
            Animate.legacyTo(_loc3_,1,{"x":param2},Animate.ExpoOut);
         }
         else
         {
            _loc3_.x = param2;
         }
         _loc3_.y = this.m_objectivesPosY;
         MenuUtils.setupText(_loc3_.objective_txt,param1.objTitle,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         var _loc4_:TextFormat;
         (_loc4_ = _loc3_.objective_txt.getTextFormat()).size = int(_loc4_.size) - 5;
         _loc3_.objective_txt.setTextFormat(_loc4_);
         this.m_objectivesPosY += _loc3_.objective_txt.numLines * LABEL_TEXT_LEADING + OBJ_HINT_MARGIN_HEIGHT;
         this.m_objectivesHolder.addChild(_loc3_);
      }
      
      public function hideObjectives() : void
      {
         Animate.kill(this.m_objectivesHolder);
         this.fadeOutObjectives();
      }
      
      public function fadeOutObjectives() : void
      {
         Animate.legacyTo(this.m_objectivesHolder,BAR_ELEMENT_FADE_ANIM_TIME,{"alpha":0},Animate.Linear,function():void
         {
            hideObjectivesHolder();
         });
      }
      
      public function hideObjectivesHolder() : void
      {
         Animate.kill(this.m_objectivesHolder);
         this.m_objectivesHolder.visible = false;
         this.m_objectivesHolder.alpha = 0;
         this.updateHeights();
      }
      
      public function updateHeights() : void
      {
         if(!this.m_objectivesHolder.visible)
         {
            this.m_objectivesPosY = this.m_startY;
         }
      }
   }
}
