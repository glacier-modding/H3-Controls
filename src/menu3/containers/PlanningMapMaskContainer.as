package menu3.containers
{
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   import menu3.ScreenResizeEvent;
   
   public dynamic class PlanningMapMaskContainer extends BaseContainer
   {
       
      
      private var m_view:Sprite;
      
      public function PlanningMapMaskContainer(param1:Object)
      {
         super(param1);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,true,0,true);
         var _loc2_:int = MenuConstants.menuXOffset;
         var _loc3_:int = MenuConstants.tileGap + MenuConstants.TabsLineUpperYPos + MenuConstants.GridUnitHeight;
         this.m_view = new Sprite();
         this.m_view.x = 0 - _loc2_;
         this.m_view.y = 0 - _loc3_;
         addChild(this.m_view);
         this.scaleMask(param1.sizeX,param1.sizeY);
         getContainer().mask = this.m_view;
         if(ControlsMain.isVrModeActive())
         {
            this.z = MenuConstants.VRNotebookMapZOffset;
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleStageMouseUp,true);
         stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.screenResizeEventHandler,true,0,true);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleStageMouseUp,true);
         stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.screenResizeEventHandler,true);
         if(m_sendEvent != null)
         {
            m_sendEvent("onDragEnd");
         }
      }
      
      private function scaleMask(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = Math.min(param1 / MenuConstants.BaseWidth,param2 / MenuConstants.BaseHeight);
         var _loc4_:Number = MenuConstants.BaseWidth * _loc3_;
         var _loc5_:Number = MenuConstants.BaseHeight * _loc3_;
         var _loc6_:Number;
         var _loc7_:Number = (_loc6_ = (param1 - _loc4_) / 2) * (1 / _loc3_);
         var _loc8_:Number = 1 + _loc7_ * 2 / MenuConstants.BaseWidth;
         var _loc9_:Number;
         var _loc10_:Number = (_loc9_ = (param2 - _loc5_) / 2) * (1 / _loc3_);
         var _loc11_:Number = 1 + _loc10_ * 2 / MenuConstants.BaseHeight;
         var _loc12_:Number = MenuConstants.BaseWidth * _loc8_;
         this.m_view.graphics.clear();
         this.m_view.graphics.beginFill(16741183,1);
         this.m_view.graphics.moveTo(0 - _loc7_,MenuConstants.TabsLineLowerYPos);
         this.m_view.graphics.lineTo(_loc12_,MenuConstants.TabsLineLowerYPos);
         this.m_view.graphics.lineTo(_loc12_,MenuConstants.UserLineUpperYPos);
         this.m_view.graphics.lineTo(0 - _loc7_,MenuConstants.UserLineUpperYPos);
         this.m_view.graphics.endFill();
      }
      
      public function screenResizeEventHandler(param1:ScreenResizeEvent) : void
      {
         var _loc2_:Object = param1.screenSize;
         this.scaleMask(_loc2_.sizeX,_loc2_.sizeY);
      }
      
      override public function handleMouseDown(param1:Function, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         trace(getQualifiedClassName(this) + ": mousedown " + name + " mousedowntarget " + (param2.target == null ? "" : param2.target.name));
         param2.stopImmediatePropagation();
         if(stage.focus == this)
         {
            return;
         }
         if(this["_nodedata"])
         {
            _loc3_ = this["_nodedata"]["id"] as int;
            param1("onElementSelect",_loc3_);
            param1("onElementClick",_loc3_);
         }
      }
      
      override public function handleMouseUp(param1:Function, param2:MouseEvent) : void
      {
         trace(getQualifiedClassName(this) + ": mouseup " + name + " mouseuptarget " + (param2.target == null ? "" : param2.target.name));
         param2.stopImmediatePropagation();
      }
      
      private function handleStageMouseUp(param1:MouseEvent) : void
      {
         trace(getQualifiedClassName(this) + ": stage mouseup " + name + " mouseuptarget " + (param1.target == null ? "" : param1.target.name));
         if(m_sendEvent != null)
         {
            m_sendEvent("onDragEnd");
         }
      }
   }
}
