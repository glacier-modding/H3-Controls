package common
{
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class MouseUtil
   {
      
      public static const MODE_DISABLE:int = 0;
      
      public static const MODE_ONOVER_SELECT_ONUP_CLICK:int = 1;
      
      public static const MODE_ONOVER_HOVER_ONUP_SELECT:int = 2;
      
      public static const MODE_ONOVER_HOVER_ONUP_SELECTCLICK:int = 3;
      
      public static const MODE_WHEEL_IGNORE:int = 0;
      
      public static const MODE_WHEEL_GROUP:int = 1;
       
      
      public function MouseUtil()
      {
         super();
      }
      
      public static function getModeFromName(param1:String) : int
      {
         if(param1 == "disable")
         {
            return MODE_DISABLE;
         }
         if(param1 == "onover-select-onup-click")
         {
            return MODE_ONOVER_SELECT_ONUP_CLICK;
         }
         if(param1 == "onover-hover-onup-select")
         {
            return MODE_ONOVER_HOVER_ONUP_SELECT;
         }
         if(param1 == "onover-hover-onup-selectclick")
         {
            return MODE_ONOVER_HOVER_ONUP_SELECTCLICK;
         }
         return -1;
      }
      
      public static function getWheelModeFromName(param1:String) : int
      {
         if(param1 == "ignore")
         {
            return MODE_WHEEL_IGNORE;
         }
         if(param1 == "group-prev-next")
         {
            return MODE_WHEEL_GROUP;
         }
         return -1;
      }
      
      public static function handleMouseUp(param1:int, param2:Sprite, param3:Function, param4:MouseEvent) : void
      {
         Log.mouse(param2,param4);
         param4.stopImmediatePropagation();
         if(param1 == MODE_ONOVER_SELECT_ONUP_CLICK)
         {
            doClick(param2,param3,param4);
         }
         else if(param1 == MODE_ONOVER_HOVER_ONUP_SELECT)
         {
            doSelect(param2,param3,param4);
         }
         else if(param1 == MODE_ONOVER_HOVER_ONUP_SELECTCLICK)
         {
            doSelect(param2,param3,param4);
            doClick(param2,param3,param4);
         }
      }
      
      public static function handleMouseRollOver(param1:int, param2:Sprite, param3:Function, param4:MouseEvent) : void
      {
         param4.stopImmediatePropagation();
         if(param1 == MODE_ONOVER_SELECT_ONUP_CLICK)
         {
            doSelect(param2,param3,param4);
         }
         else if(param1 == MODE_ONOVER_HOVER_ONUP_SELECT || param1 == MODE_ONOVER_HOVER_ONUP_SELECTCLICK)
         {
            doHover(param2,param3,param4,true);
         }
      }
      
      public static function handleMouseRollOut(param1:int, param2:Sprite, param3:Function, param4:MouseEvent) : void
      {
         param4.stopImmediatePropagation();
         if(param1 == MODE_ONOVER_HOVER_ONUP_SELECT || param1 == MODE_ONOVER_HOVER_ONUP_SELECTCLICK)
         {
            doHover(param2,param3,param4,false);
         }
      }
      
      private static function doClick(param1:Sprite, param2:Function, param3:MouseEvent) : void
      {
         var _loc4_:int = 0;
         if(param1["_nodedata"])
         {
            _loc4_ = param1["_nodedata"]["id"] as int;
            param2("onElementClick",_loc4_);
         }
      }
      
      private static function doSelect(param1:Sprite, param2:Function, param3:MouseEvent) : void
      {
         var _loc4_:Function = null;
         var _loc5_:int = 0;
         if("isSelected" in param1)
         {
            if((_loc4_ = param1["isSelected"] as Function) != null && _loc4_() == true)
            {
               return;
            }
         }
         if(param1["_nodedata"])
         {
            _loc5_ = param1["_nodedata"]["id"] as int;
            param2("onElementSelect",_loc5_);
         }
      }
      
      private static function doHover(param1:Sprite, param2:Function, param3:MouseEvent, param4:Boolean) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         if(param1["_nodedata"])
         {
            _loc5_ = param1["_nodedata"]["id"] as int;
            _loc6_ = new Array(_loc5_,param4);
            param2("onElementHover",_loc6_);
         }
      }
      
      public static function handleMouseWheel(param1:int, param2:Sprite, param3:Function, param4:MouseEvent) : void
      {
         if(param1 == MODE_WHEEL_IGNORE)
         {
            return;
         }
         param4.stopImmediatePropagation();
         if(param1 == MODE_WHEEL_GROUP)
         {
            doWheelGroupPrevNext(param2,param3,param4);
         }
      }
      
      private static function doWheelGroupPrevNext(param1:Sprite, param2:Function, param3:MouseEvent) : void
      {
         var _loc4_:Function = null;
         var _loc5_:int = 0;
         if(param3.delta == 0)
         {
            return;
         }
         if("isWheelDelayActive" in param1)
         {
            if((_loc4_ = param1["isWheelDelayActive"] as Function) != null && _loc4_() == true)
            {
               return;
            }
            startWheelDelay(param1);
         }
         if(param1["_nodedata"])
         {
            _loc5_ = param1["_nodedata"]["id"] as int;
            if(param3.delta > 0)
            {
               param2("onGroupPrev",_loc5_);
            }
            else
            {
               param2("onGroupNext",_loc5_);
            }
         }
      }
      
      private static function startWheelDelay(param1:Sprite) : void
      {
         var setWheelDelayActiveFunc:Function = null;
         var obj:Sprite = param1;
         if("setWheelDelayActive" in obj)
         {
            setWheelDelayActiveFunc = obj["setWheelDelayActive"] as Function;
            if(setWheelDelayActiveFunc != null)
            {
               setWheelDelayActiveFunc(true);
               Animate.delay(obj,MenuConstants.WheelScrollTime,function(param1:Sprite):void
               {
                  var _loc2_:Function = param1["setWheelDelayActive"] as Function;
                  if(_loc2_ != null)
                  {
                     _loc2_(false);
                  }
               },obj);
            }
         }
      }
   }
}
