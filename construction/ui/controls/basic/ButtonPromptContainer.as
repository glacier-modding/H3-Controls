package basic
{
   import common.Log;
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   
   public class ButtonPromptContainer extends Sprite
   {
       
      
      public function ButtonPromptContainer(param1:Object, param2:Boolean = false, param3:Function = null)
      {
         super();
         if(param2)
         {
            this.addTabNavigationLayout(param1,param3);
         }
         else
         {
            this.addRegularButtonPrompts(param1,param3);
         }
      }
      
      private function addTabNavigationLayout(param1:Object, param2:Function) : void
      {
         var _loc5_:Object = null;
         var _loc6_:ActionType = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Number = NaN;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.buttonprompts.length)
         {
            _loc5_ = param1.buttonprompts[_loc4_];
            if((_loc6_ = this.getActionType(_loc5_)).actionTypes == null)
            {
               Log.xerror(Log.ChannelButtonPrompt,"TabNav: no action types found ...");
            }
            else
            {
               _loc7_ = 0;
               while(_loc7_ < _loc6_.actionTypes.length)
               {
                  _loc8_ = _loc6_.actionTypes[_loc7_];
                  _loc3_ -= 62;
                  _loc9_ = {
                     "actiontype":_loc8_.name,
                     "hidePrompt":_loc8_.hidePrompt,
                     "actionlabel":"",
                     "transparentPrompt":_loc8_.transparentPrompt,
                     "disabledPrompt":_loc8_.disabledPrompt
                  };
                  _loc10_ = this.addTabPrompt(_loc3_,_loc9_,param2);
                  _loc3_ += Math.ceil(MenuConstants.CategoryElementWidth + 2 * 62 + 10);
                  _loc7_++;
               }
            }
            _loc4_++;
         }
      }
      
      private function addRegularButtonPrompts(param1:Object, param2:Function) : void
      {
         var _loc4_:Number = NaN;
         var _loc6_:Object = null;
         var _loc7_:ActionType = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:* = false;
         var _loc11_:Object = null;
         var _loc3_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < param1.buttonprompts.length)
         {
            _loc6_ = param1.buttonprompts[_loc5_];
            if(!ButtonPrompt.shouldSkipPrompt(_loc6_))
            {
               if((_loc7_ = this.getActionType(_loc6_)).actionType != null)
               {
                  _loc4_ = this.addPrompt(_loc3_,_loc6_,param2);
                  _loc3_ += Math.ceil(_loc4_ + MenuConstants.ButtonPromptsXOffset);
               }
               else if(_loc7_.actionTypes != null)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.actionTypes.length)
                  {
                     _loc9_ = _loc7_.actionTypes[_loc8_];
                     _loc10_ = _loc8_ == _loc7_.actionTypes.length - 1;
                     _loc11_ = {
                        "actiontype":_loc9_.name,
                        "hidePrompt":_loc9_.hidePrompt,
                        "actionlabel":(_loc10_ ? _loc6_.actionlabel : ""),
                        "transparentPrompt":_loc9_.transparentPrompt,
                        "disabledPrompt":_loc9_.disabledPrompt
                     };
                     _loc4_ = this.addPrompt(_loc3_,_loc11_,param2);
                     _loc3_ += Math.ceil(_loc4_ + MenuConstants.ButtonPromptsXOffset);
                     _loc8_++;
                  }
               }
            }
            _loc5_++;
         }
      }
      
      private function addPrompt(param1:Number, param2:Object, param3:Function) : Number
      {
         var _loc4_:ButtonPrompt = new ButtonPrompt(param2,false,param3,param1,true);
         addChild(_loc4_);
         return _loc4_.getWidth();
      }
      
      private function addTabPrompt(param1:Number, param2:Object, param3:Function) : Number
      {
         var _loc4_:ButtonPrompt = new ButtonPrompt(param2,true,param3,param1);
         addChild(_loc4_);
         return _loc4_.getWidth();
      }
      
      private function getActionType(param1:Object) : ActionType
      {
         var _loc3_:Object = null;
         var _loc2_:ActionType = new ActionType();
         if(param1 == null || param1.actiontype == null)
         {
            return _loc2_;
         }
         if(typeof param1.actiontype == "string")
         {
            _loc2_.actionType = param1.actiontype;
         }
         else if(typeof param1.actiontype == "object")
         {
            _loc2_.actionTypes = [];
            for each(_loc3_ in param1.actiontype)
            {
               if(_loc3_ is String)
               {
                  _loc2_.actionTypes.push({
                     "name":_loc3_ as String,
                     "hidePrompt":false
                  });
               }
               else
               {
                  _loc2_.actionTypes.push(_loc3_);
               }
            }
         }
         return _loc2_;
      }
      
      public function onUnregister() : void
      {
         var _loc1_:ButtonPrompt = null;
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(0) as ButtonPrompt;
            if(_loc1_ != null)
            {
               _loc1_.onUnregister();
            }
            removeChildAt(0);
         }
      }
   }
}

class ActionType
{
    
   
   public var actionType:String = null;
   
   public var actionTypes:Array = null;
   
   public function ActionType()
   {
      super();
   }
}
