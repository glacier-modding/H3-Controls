package basic
{
   import common.Animate;
   import common.BaseControl;
   import flash.display.Sprite;
   
   public class ItemBg extends BaseControl
   {
       
      
      private var m_view:ItemBgView;
      
      private var m_container:Sprite;
      
      public function ItemBg()
      {
         super();
         this.m_view = new ItemBgView();
         addChild(this.m_view);
         this.m_view.selected_mc.alpha = 0;
         this.m_container = new Sprite();
         addChild(this.m_container);
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_container;
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_view.bg_mc.width = this.m_view.selected_mc.width = param1;
         this.m_view.bg_mc.height = this.m_view.selected_mc.height = param2;
         this.m_view.focusIndicator_mc.height = param2;
      }
      
      public function onSetSelected(param1:Boolean) : void
      {
         Animate.legacyTo(this.m_view.selected_mc,0.2,{"alpha":(param1 ? 1 : 0)},Animate.ExpoOut);
      }
      
      public function onSetFocused(param1:Boolean) : void
      {
         Animate.legacyTo(this.m_view.focusIndicator_mc,0.2,{"alpha":(param1 ? 1 : 0)},Animate.ExpoOut);
      }
      
      public function onButtonPressed() : void
      {
         this.m_view.alpha = 0;
         Animate.legacyTo(this.m_view,0.4,{"alpha":1},Animate.ExpoOut);
      }
   }
}
