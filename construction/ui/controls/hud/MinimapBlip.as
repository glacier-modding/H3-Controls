package hud
{
   import common.BaseControl;
   
   public class MinimapBlip extends BaseControl
   {
       
      
      public function MinimapBlip()
      {
         super();
      }
      
      override public function onSetVisible(param1:Boolean) : void
      {
         this.visible = param1;
      }
   }
}
