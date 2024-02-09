package menu3.containers
{
   import common.Log;
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import menu3.MenuElementBase;
   
   public dynamic class IndicatorHandler
   {
       
      
      private var m_container:BaseContainer = null;
      
      private var m_sendEventWithValue:Function = null;
      
      private var m_prevIndicator:Sprite = null;
      
      private var m_nextIndicator:Sprite = null;
      
      private var indicatorCount:int = 0;
      
      public function IndicatorHandler(param1:BaseContainer, param2:Object)
      {
         super();
         this.m_container = param1;
         if(param2.hasOwnProperty("showprevnext") && param2.showprevnext == true)
         {
            if(param2.hasOwnProperty("currentpage") && param2.currentpage > 0)
            {
               Log.info("IndicatorHandler",this,"has previous pages - trying to add previous indicators");
               this.m_prevIndicator = new Sprite();
               this.addIndicators(this.m_prevIndicator,param2.previousindicator,this.handleMouseUpPrevIndicator);
            }
            if(param2.hasOwnProperty("hasmorepages") && Boolean(param2.hasmorepages))
            {
               Log.info("IndicatorHandler",this,"has more pages - trying to add next indicators");
               this.m_nextIndicator = new Sprite();
               this.addIndicators(this.m_nextIndicator,param2.nextindicator,this.handleMouseUpNextIndicator,this.m_container.getScrollBounds().width);
            }
         }
      }
      
      public function setEngineCallback(param1:Function) : void
      {
         this.m_sendEventWithValue = param1;
      }
      
      public function destroy() : void
      {
         if(!this.m_container)
         {
            return;
         }
         if(this.m_prevIndicator)
         {
            this.destroyIndicator(this.m_prevIndicator,this.handleMouseUpPrevIndicator);
            this.m_prevIndicator = null;
         }
         if(this.m_nextIndicator)
         {
            this.destroyIndicator(this.m_nextIndicator,this.handleMouseUpNextIndicator);
            this.m_nextIndicator = null;
         }
         this.m_container = null;
      }
      
      private function destroyIndicator(param1:Sprite, param2:Function) : void
      {
         var _loc3_:MenuElementBase = null;
         while(param1.numChildren)
         {
            _loc3_ = param1.getChildAt(0) as MenuElementBase;
            _loc3_.removeEventListener(MouseEvent.MOUSE_UP,param2,false);
            _loc3_.removeEventListener(MouseEvent.ROLL_OVER,_loc3_.handleRollOver,false);
            _loc3_.removeEventListener(MouseEvent.ROLL_OUT,_loc3_.handleRollOut,false);
            _loc3_.onUnregister();
            param1.removeChildAt(0);
         }
         this.m_container.removeChild(param1);
      }
      
      private function addIndicators(param1:Sprite, param2:Object, param3:Function, param4:Number = 0) : void
      {
         var _loc6_:Sprite = null;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         if(param2 == null)
         {
            Log.error("IndicatorHandler",this.m_container,"indicator data is invalid");
            return;
         }
         var _loc5_:Number = 0;
         if(param2 is Array)
         {
            _loc7_ = param2 as Array;
            _loc8_ = 0;
            _loc9_ = 0;
            while(_loc9_ < _loc7_.length)
            {
               _loc6_ = this.addIndicator(param1,_loc7_[_loc9_],_loc8_,param3);
               _loc8_ += _loc6_.height + 1;
               _loc5_ = _loc6_.width;
               _loc9_++;
            }
         }
         else
         {
            _loc5_ = (_loc6_ = this.addIndicator(param1,param2,0,param3)).width;
            if(_loc6_.height < MenuConstants.MenuTileLargeHeight)
            {
               _loc6_ = this.addIndicator(param1,param2,_loc6_.height + 1,param3);
            }
         }
         if(param4 == 0)
         {
            param1.x -= _loc5_ + 1;
         }
         else
         {
            param1.x += param4;
         }
         this.m_container.addChild(param1);
         Log.info("IndicatorHandler",this.m_container,"added indicators at " + param4);
      }
      
      private function addIndicator(param1:Sprite, param2:Object, param3:Number, param4:Function) : Sprite
      {
         var _loc5_:Class;
         if((_loc5_ = getDefinitionByName(param2.view) as Class) == null)
         {
            Log.error("IndicatorHandler",this.m_container,"Could not read \'view\' from indicator handler");
            return new Sprite();
         }
         var _loc6_:Object = param2.data;
         var _loc7_:MenuElementBase;
         (_loc7_ = new _loc5_(_loc6_) as MenuElementBase).onSetData(_loc6_);
         _loc7_.name = "indicator" + this.indicatorCount;
         this.indicatorCount += 1;
         _loc7_.y += param3;
         _loc7_.addEventListener(MouseEvent.MOUSE_UP,param4,false,0,false);
         _loc7_.addEventListener(MouseEvent.ROLL_OVER,_loc7_.handleRollOver,false,0,false);
         _loc7_.addEventListener(MouseEvent.ROLL_OUT,_loc7_.handleRollOut,false,0,false);
         param1.addChild(_loc7_);
         return _loc7_;
      }
      
      private function handleMouseUpPrevIndicator(param1:MouseEvent) : void
      {
         Log.mouse(this.m_container,param1,"PrevIndicator");
         this.triggerPaginate(-1);
      }
      
      private function handleMouseUpNextIndicator(param1:MouseEvent) : void
      {
         Log.mouse(this.m_container,param1,"NextIndicator");
         this.triggerPaginate(1);
      }
      
      private function triggerPaginate(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         if(this.m_container["_nodedata"])
         {
            if(this.m_sendEventWithValue != null)
            {
               _loc2_ = this.m_container["_nodedata"]["id"] as int;
               _loc3_ = new Array(_loc2_,param1);
               this.m_sendEventWithValue("onTriggerPaginate",_loc3_);
            }
            else
            {
               Log.error("IndicatorHandler",this.m_container,"Callback handling not set-up properly!");
            }
         }
      }
   }
}
