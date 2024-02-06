package menu3.basic
{
   import common.Log;
   import flash.events.MouseEvent;
   
   public dynamic class ItemTileIndicatorSmall extends ItemTileSmall
   {
       
      
      public function ItemTileIndicatorSmall(param1:Object)
      {
         super(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
      }
      
      public function handleRollOver(param1:MouseEvent) : void
      {
         Log.mouse(this,param1,"ItemTileIndicatorSmall");
         param1.stopImmediatePropagation();
         if(m_isSelected)
         {
            return;
         }
         if(stage.focus == this)
         {
            return;
         }
         stage.focus = this;
         setItemSelected(true);
         stage.stageFocusRect = false;
      }
      
      public function handleRollOut(param1:MouseEvent) : void
      {
         Log.mouse(this,param1,"ItemTileIndicatorSmall");
         param1.stopImmediatePropagation();
         if(Boolean(stage) && stage.focus == this)
         {
            stage.focus = null;
         }
         setItemSelected(false);
      }
   }
}
