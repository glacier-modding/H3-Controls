package hud
{
   import common.BaseControl;
   
   public class DifficultyIcon extends BaseControl
   {
       
      
      private var m_view:DifficultyIconView;
      
      public function DifficultyIcon()
      {
         super();
         this.m_view = new DifficultyIconView();
         this.m_view.bg.alpha = 0.5;
         addChild(this.m_view);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_view.gotoAndStop(param1.difficulty);
      }
   }
}
