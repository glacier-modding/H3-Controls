package menu3.basic
{
   import common.Log;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import menu3.MenuElementBase;
   import menu3.ScreenResizeEvent;
   import menu3.VisibilityChangedEvent;
   
   public dynamic class MenuElementRender3D extends MenuElementBase
   {
       
      
      private var m_rectangle:Shape;
      
      private var m_GUIGroupName:String;
      
      private var m_localBounds:Rectangle = null;
      
      private var m_isVisibleOnScreen:Boolean = false;
      
      public function MenuElementRender3D(param1:Object)
      {
         super(param1);
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler,false,0,true);
         this.m_rectangle = new Shape();
         addChild(this.m_rectangle);
      }
      
      override public function onUnregister() : void
      {
         if(hasEventListener(Event.ADDED_TO_STAGE))
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler,false);
         }
         this.nodeUpdate(0,0,0,0,false);
         super.onUnregister();
      }
      
      override public function onSetData(param1:Object) : void
      {
         this.m_GUIGroupName = param1.guiGroupName;
         this.m_rectangle.graphics.clear();
         this.m_rectangle.graphics.lineStyle(1,16711680);
         this.m_rectangle.graphics.drawRect(0,0,param1.width,param1.height);
         this.m_localBounds = this.getBounds(this);
         if(param1.showBorder !== true)
         {
            this.m_rectangle.graphics.clear();
         }
      }
      
      private function addedToStageHandler() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler,false);
         this.m_isVisibleOnScreen = false;
         this.updateVisibilityAndNotifySize();
         stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.screenResizeEventHandler,true,0,true);
         this.addVisibilityChangedEventListener();
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler,false);
      }
      
      private function removedFromStageHandler(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler,false);
         this.removeVisibilityChangedEventListener();
         stage.removeEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.screenResizeEventHandler,true);
      }
      
      private function screenResizeEventHandler(param1:ScreenResizeEvent) : void
      {
         this.updateNotifySize();
      }
      
      private function visibilityChangedHandler(param1:VisibilityChangedEvent) : void
      {
         this.updateVisibilityAndNotifySize();
      }
      
      private function updateVisibilityAndNotifySize() : void
      {
         var _loc1_:Boolean = this.getVisibilityOnScreen();
         if(this.m_isVisibleOnScreen == _loc1_)
         {
            return;
         }
         this.m_isVisibleOnScreen = _loc1_;
         this.updateNotifySize();
      }
      
      private function updateNotifySize() : void
      {
         if(this.m_localBounds == null)
         {
            return;
         }
         var _loc1_:Point = new Point(this.m_localBounds.x,this.m_localBounds.y);
         var _loc2_:Point = _loc1_.add(new Point(this.m_localBounds.width,this.m_localBounds.height));
         var _loc3_:Point = this.localToGlobal(_loc1_);
         var _loc4_:Point;
         var _loc5_:Point = (_loc4_ = this.localToGlobal(_loc2_)).subtract(_loc3_);
         var _loc6_:Rectangle = new Rectangle(_loc3_.x,_loc3_.y,_loc5_.x,_loc5_.y);
         this.nodeUpdate(_loc6_.x,_loc6_.y,_loc6_.width,_loc6_.height,this.m_isVisibleOnScreen);
      }
      
      private function nodeUpdate(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean) : void
      {
         if(this.m_GUIGroupName != null && this.m_GUIGroupName.length > 0)
         {
            Log.info(Log.ChannelDebug,this,"Render3DNodeUpdate: " + this.m_GUIGroupName + " x=" + param1 + " y=" + param2 + " width=" + param3 + " height=" + param4 + " visible=" + param5);
            ExternalInterface.call("Render3DNodeUpdate",this.m_GUIGroupName,param1,param2,param3,param4,param5);
         }
      }
      
      private function getVisibilityOnScreen() : Boolean
      {
         var _loc1_:DisplayObject = this;
         while(_loc1_ != null)
         {
            if(_loc1_.visible == false)
            {
               return false;
            }
            _loc1_ = _loc1_.parent;
         }
         return true;
      }
      
      private function addVisibilityChangedEventListener() : void
      {
         var _loc1_:DisplayObject = this;
         while(_loc1_ != null)
         {
            _loc1_.addEventListener(VisibilityChangedEvent.VISIBILITY_CHANGED,this.visibilityChangedHandler,false,0,true);
            _loc1_ = _loc1_.parent;
         }
      }
      
      private function removeVisibilityChangedEventListener() : void
      {
         var _loc1_:DisplayObject = this;
         while(_loc1_ != null)
         {
            _loc1_.removeEventListener(VisibilityChangedEvent.VISIBILITY_CHANGED,this.visibilityChangedHandler,false);
            _loc1_ = _loc1_.parent;
         }
      }
   }
}
