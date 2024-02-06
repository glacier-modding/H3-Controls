package menu3.basic
{
   import flash.display.Sprite;
   import menu3.containers.CollapsableListContainer;
   
   public dynamic class CategoryElementBase extends CollapsableListContainer implements ICategoryElement
   {
       
      
      protected const STATE_DEFAULT:int = 0;
      
      protected const STATE_SELECTED:int = 1;
      
      protected const STATE_HOVER:int = 2;
      
      protected var m_isCategorySelected:Boolean = false;
      
      public function CategoryElementBase(param1:Object)
      {
         super(param1);
      }
      
      override public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         super.addChild2(param1,param2);
         if(getNodeProp(param1,"col") === undefined)
         {
            if(this.getData().direction != "horizontal" && this.getData().direction != "horizontalWrap")
            {
               param1.x = 32;
            }
         }
      }
      
      public function enableSpacer() : void
      {
      }
      
      public function disableSpacer() : void
      {
      }
      
      override protected function handleSelectionChange() : void
      {
      }
      
      public function setCategorySelected(param1:Boolean) : void
      {
         this.m_isCategorySelected = param1;
         var _loc2_:int = param1 ? this.STATE_SELECTED : this.STATE_DEFAULT;
         this.setSelectedAnimationState(_loc2_);
         if(param1)
         {
            bubbleEvent("categorySelected",this);
         }
      }
      
      public function setItemHover(param1:Boolean) : void
      {
         if(this.m_isCategorySelected)
         {
            return;
         }
         var _loc2_:int = param1 ? this.STATE_HOVER : this.STATE_DEFAULT;
         this.setSelectedAnimationState(_loc2_);
      }
      
      protected function setSelectedAnimationState(param1:int) : void
      {
      }
      
      override public function setItemSelected(param1:Boolean) : void
      {
         super.setItemSelected(param1);
         if(getNodeProp(this,"ismenusystem") != true)
         {
            return;
         }
         this.m_isCategorySelected = param1;
         var _loc2_:int = param1 ? this.STATE_SELECTED : this.STATE_DEFAULT;
         this.setSelectedAnimationState(_loc2_);
      }
   }
}
