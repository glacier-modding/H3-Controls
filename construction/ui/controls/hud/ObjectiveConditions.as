package hud
{
   import common.BaseControl;
   import common.CommonUtils;
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import common.menu.ObjectiveUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import scaleform.gfx.Extensions;
   
   public class ObjectiveConditions extends BaseControl
   {
       
      
      private var m_container:Sprite;
      
      private var m_aTargetInfos:Array;
      
      private var m_targetInfosActive:int = 0;
      
      private var i:int;
      
      private var j:int;
      
      private var conditionsXOffset:int = 25;
      
      private var lineYOffset:int = 30;
      
      private var lineXWidthOffset:int = 15;
      
      private var targetInfoYOffset:int = -50;
      
      private var maxNrOfConditions:int = 3;
      
      private var nrOfPooledTargets:int = 5;
      
      private var scaleFactor:Number = 1;
      
      public function ObjectiveConditions()
      {
         var _loc1_:TargetInfoContainer = null;
         this.m_container = new Sprite();
         this.m_aTargetInfos = new Array();
         super();
         addChild(this.m_container);
         this.m_container.x = 0;
         this.m_container.y = 0;
         this.i = 0;
         while(this.i < this.nrOfPooledTargets)
         {
            _loc1_ = this.instantiateTargetInfo();
            this.m_aTargetInfos.push(_loc1_);
            this.m_container.addChild(_loc1_);
            ++this.i;
         }
      }
      
      public function instantiateTargetInfo() : TargetInfoContainer
      {
         var _loc4_:ValueIndicatorSmallView = null;
         var _loc1_:TargetInfoContainer = new TargetInfoContainer();
         _loc1_.visible = false;
         _loc1_.alpha = 1;
         var _loc2_:int = 0;
         while(_loc2_ < this.maxNrOfConditions)
         {
            _loc4_ = new ValueIndicatorSmallView();
            _loc1_.addChild(_loc4_);
            _loc4_.x = this.conditionsXOffset;
            _loc1_.m_aObjectiveConditions.push(_loc4_);
            _loc2_++;
         }
         var _loc3_:line = new line();
         _loc3_.width = this.conditionsXOffset + this.lineXWidthOffset;
         _loc3_.height = 1;
         _loc1_.addChild(_loc3_);
         _loc3_.x = 0;
         _loc3_.y = this.lineYOffset;
         return _loc1_;
      }
      
      private function ResetConditions(param1:TargetInfoContainer) : void
      {
         var _loc2_:Number = param1.m_aObjectiveConditions.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            param1.m_aObjectiveConditions[_loc3_].visible = false;
            _loc3_++;
         }
      }
      
      public function hideAll() : void
      {
         this.m_container.visible = false;
      }
      
      public function onSetData(param1:Array) : void
      {
         var _loc2_:TargetInfoContainer = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         this.m_container.visible = true;
         while(param1.length > this.m_aTargetInfos.length)
         {
            _loc2_ = this.instantiateTargetInfo();
            this.m_aTargetInfos.push(_loc2_);
            this.m_container.addChild(_loc2_);
         }
         this.i = 0;
         while(this.i < param1.length)
         {
            _loc3_ = param1[this.i];
            _loc2_ = this.m_aTargetInfos[this.i];
            this.ResetConditions(_loc2_);
            _loc2_.visible = true;
            _loc2_.x = _loc3_.fX;
            _loc2_.y = _loc3_.fY + this.targetInfoYOffset * this.scaleFactor;
            _loc2_.scaleX = _loc2_.scaleY = this.scaleFactor;
            _loc2_.alpha = _loc3_.fAlpha;
            _loc2_.bIsTarget = _loc3_.bIsTarget;
            _loc5_ = "npc";
            if(_loc3_.bIsTarget)
            {
               _loc5_ = "target";
            }
            if(_loc3_.disguiseName == _loc3_.npcName)
            {
               _loc4_ = {
                  "header":"",
                  "title":_loc3_.npcName,
                  "icon":_loc5_,
                  "line":true,
                  "hardCondition":true
               };
            }
            else
            {
               _loc4_ = {
                  "header":_loc3_.disguiseName,
                  "title":_loc3_.npcName,
                  "icon":_loc5_,
                  "line":true,
                  "hardCondition":true
               };
            }
            if(_loc3_.objectiveConditions)
            {
               if(_loc3_.bIsTarget)
               {
                  _loc6_ = _loc3_.objectiveConditions;
                  if(_loc3_.objectiveType == "kill")
                  {
                     _loc6_ = ObjectiveUtil.prepareConditions(_loc6_,false,false,false);
                  }
                  _loc6_.unshift(_loc4_);
                  this.addConditions(_loc6_,_loc2_);
               }
               else
               {
                  this.addConditions([_loc4_],_loc2_);
               }
            }
            else
            {
               this.addConditions([_loc4_],_loc2_);
            }
            ++this.i;
         }
         while(this.i < this.m_aTargetInfos.length)
         {
            this.m_aTargetInfos[this.i].visible = false;
            ++this.i;
         }
      }
      
      private function addConditions(param1:Array, param2:MovieClip) : void
      {
         var _loc5_:ValueIndicatorSmallView = null;
         var _loc6_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length && _loc4_ < param2.m_aObjectiveConditions.length)
         {
            (_loc5_ = param2.m_aObjectiveConditions[_loc4_]).visible = true;
            _loc5_.y = _loc3_;
            if(_loc4_ == 0)
            {
               if(param2.bIsTarget)
               {
                  MenuUtils.setupIcon(_loc5_.valueIcon,param1[_loc4_].icon,MenuConstants.COLOR_WHITE,true,true,MenuConstants.COLOR_RED);
               }
               else
               {
                  MenuUtils.setupIcon(_loc5_.valueIcon,param1[_loc4_].icon,MenuConstants.COLOR_WHITE,true,false);
               }
            }
            else
            {
               MenuUtils.setupIcon(_loc5_.valueIcon,param1[_loc4_].icon,MenuConstants.COLOR_BLACK,false,true,MenuConstants.COLOR_WHITE);
            }
            _loc6_ = Boolean(param1[_loc4_].hardCondition) || Boolean(param1[_loc4_].hardcondition) ? String(param1[_loc4_].header) : Localization.get("UI_DIALOG_OPTIONAL") + " " + param1[_loc4_].header;
            MenuUtils.setupText(_loc5_.header,_loc6_,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGreyUltraLight);
            _loc5_.header.width = _loc5_.header.textWidth + 10;
            MenuUtils.setupText(_loc5_.title,param1[_loc4_].title,24,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
            CommonUtils.changeFontToGlobalIfNeeded(_loc5_.title);
            _loc5_.title.width = _loc5_.title.textWidth + 10;
            _loc3_ += _loc5_.valueIcon.height + 10;
            _loc4_++;
         }
      }
      
      public function test(param1:Number) : void
      {
         var _loc5_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:Number = 5;
         var _loc4_:Number = 0;
         while(_loc4_ < _loc3_)
         {
            (_loc5_ = new Object()).icon = "target";
            _loc5_.targetName = "Mr. Kill Me Mr. Kill Me Mr. Kill Me Mr. Kill Me";
            _loc5_.fX = _loc4_ * param1;
            _loc5_.fY = 200;
            _loc5_.bWithinScreen = true;
            _loc5_.disguiseName = "Bodyguard";
            _loc5_.fAlpha = 1;
            _loc5_.bIsTarget = _loc4_ == 2 ? true : false;
            _loc2_.push(_loc5_);
            _loc4_++;
         }
         this.onSetData(_loc2_);
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         if(ControlsMain.isVrModeActive())
         {
            this.scaleFactor = 1;
         }
         else
         {
            this.scaleFactor = Extensions.visibleRect.height / 1080;
         }
      }
   }
}

import flash.display.MovieClip;

class TargetInfoContainer extends MovieClip
{
    
   
   public var m_aObjectiveConditions:Array;
   
   public var bIsTarget:Boolean = false;
   
   public function TargetInfoContainer()
   {
      this.m_aObjectiveConditions = new Array();
      super();
   }
}
