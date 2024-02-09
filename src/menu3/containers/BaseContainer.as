package menu3.containers
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import menu3.MenuElementBase;
   
   public dynamic class BaseContainer extends MenuElementBase
   {
       
      
      protected var m_emptyView:Sprite;
      
      protected var m_container:Sprite;
      
      protected var m_isSelected:Boolean = false;
      
      protected var m_isGroupSelected:Boolean = false;
      
      protected var m_isChildSelected:Boolean = false;
      
      protected var m_sendEvent:Function = null;
      
      protected var m_sendEventWithValue:Function = null;
      
      public function BaseContainer(param1:Object)
      {
         super(param1);
         this.m_emptyView = new Sprite();
         addChild(this.m_emptyView);
         this.m_container = new Sprite();
         addChild(this.m_container);
      }
      
      override public function setEngineCallbacks(param1:Function, param2:Function) : void
      {
         this.m_sendEvent = param1;
         this.m_sendEventWithValue = param2;
      }
      
      public function onScroll(param1:int) : void
      {
      }
      
      override public function getView() : Sprite
      {
         return this.m_emptyView;
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_container;
      }
      
      public function getVisibleContainerBounds() : Rectangle
      {
         return getMenuElementBounds(this,this,function(param1:MenuElementBase):Boolean
         {
            return param1.visible;
         });
      }
      
      public function setItemSelected(param1:Boolean) : void
      {
         if(this.m_isSelected == param1)
         {
            return;
         }
         this.m_isSelected = param1;
         this.handleSelectionChange();
      }
      
      public function setItemGroupSelected(param1:Boolean) : void
      {
         if(this.m_isGroupSelected == param1)
         {
            return;
         }
         this.m_isGroupSelected = param1;
         this.handleSelectionChange();
      }
      
      public function setChildSelected(param1:Boolean) : void
      {
         if(this.m_isChildSelected == param1)
         {
            return;
         }
         this.m_isChildSelected = param1;
         this.handleChildSelectionChange();
      }
      
      public function isSelected() : Boolean
      {
         return this.m_isSelected;
      }
      
      protected function handleSelectionChange() : void
      {
      }
      
      protected function handleChildSelectionChange() : void
      {
      }
   }
}
