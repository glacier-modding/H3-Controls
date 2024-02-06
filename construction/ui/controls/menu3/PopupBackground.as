package menu3
{
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public dynamic class PopupBackground extends MenuElementBase
   {
       
      
      private var m_background:Sprite;
      
      private var m_screenHeight:Number = 0;
      
      private var m_addedToStage:Boolean = false;
      
      public function PopupBackground(param1:Object)
      {
         this.m_background = new Sprite();
         super(param1);
         addChild(this.m_background);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,true,0,true);
      }
      
      override public function onUnregister() : void
      {
         this.m_addedToStage = false;
         super.onUnregister();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         if(this.m_addedToStage)
         {
            this.drawBackground();
         }
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,true);
         this.m_addedToStage = true;
         this.drawBackground();
         stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.onScreenResize,true,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false);
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false);
         stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.onScreenResize,true);
         this.m_addedToStage = false;
      }
      
      protected function onScreenResize(param1:ScreenResizeEvent) : void
      {
         this.m_screenHeight = param1.screenSize.sizeY;
         this.drawBackground();
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         this.m_background.graphics.clear();
         this.m_background.graphics.beginFill(0,0.75);
         if(!ControlsMain.isVrModeActive())
         {
            _loc1_ = stage.stageWidth;
            _loc2_ = stage.stageHeight;
            _loc3_ = globalToLocal(new Point(0,0));
            _loc4_ = globalToLocal(new Point(_loc1_,_loc2_));
            this.m_background.graphics.moveTo(_loc3_.x,_loc3_.y);
            this.m_background.graphics.lineTo(_loc4_.x,_loc3_.y);
            this.m_background.graphics.lineTo(_loc4_.x,_loc4_.y);
            this.m_background.graphics.lineTo(_loc3_.x,_loc4_.y);
            this.m_background.graphics.moveTo(_loc3_.x,_loc3_.y);
         }
         else
         {
            this.m_background.graphics.drawRect(-MenuConstants.BaseWidth,-MenuConstants.BaseHeight,3 * MenuConstants.BaseWidth,3 * MenuConstants.BaseHeight);
         }
         this.m_background.graphics.endFill();
      }
   }
}
