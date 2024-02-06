package menu3.basic
{
   import menu3.MenuElementBase;
   
   public dynamic class LoadDialTile extends MenuElementBase
   {
       
      
      private var m_loadDialView:loadDialView;
      
      public function LoadDialTile(param1:Object)
      {
         this.m_loadDialView = new loadDialView();
         super(param1);
         this.m_loadDialView.scaleX = 2;
         this.m_loadDialView.scaleY = 2;
         addChild(this.m_loadDialView);
         this.m_loadDialView.value.play();
      }
      
      override public function onUnregister() : void
      {
         this.m_loadDialView.value.stop();
         removeChild(this.m_loadDialView);
         this.m_loadDialView = null;
      }
   }
}
