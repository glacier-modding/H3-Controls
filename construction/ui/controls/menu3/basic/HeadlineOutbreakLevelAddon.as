package menu3.basic
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import menu3.MenuElementBase;
   
   public dynamic class HeadlineOutbreakLevelAddon extends MenuElementBase
   {
       
      
      private var m_view:HeadlineOutbreakLevelAddonView;
      
      public function HeadlineOutbreakLevelAddon(param1:Object)
      {
         super(param1);
         this.m_view = new HeadlineOutbreakLevelAddonView();
         this.m_view.indicator.x = 114;
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         this.showEscalationLevel(param1);
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            this.completeAnimations();
            removeChild(this.m_view);
            this.m_view = null;
         }
      }
      
      private function showEscalationLevel(param1:Object) : void
      {
         var _loc5_:OutbreakLevelIconView = null;
         var _loc2_:int = 0;
         var _loc3_:int = 1;
         var _loc4_:int = 0;
         while(_loc4_ < param1.totallevels)
         {
            _loc5_ = new OutbreakLevelIconView();
            MenuUtils.setTintColor(_loc5_,MenuUtils.TINT_COLOR_WHITE,true);
            _loc5_.alpha = 0.4;
            if(_loc3_ <= param1.completedlevels + 1)
            {
               _loc5_.alpha = 1;
            }
            this.m_view.indicator.addChild(_loc5_);
            _loc5_.x = _loc2_;
            _loc2_ += MenuConstants.outbreakLevelIconXOffset;
            _loc3_ += 1;
            _loc4_++;
         }
      }
      
      private function completeAnimations() : void
      {
      }
   }
}
