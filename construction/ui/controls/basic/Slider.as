package basic
{
   import common.BaseControl;
   
   public class Slider extends BaseControl
   {
       
      
      private var m_view:SliderView;
      
      public function Slider()
      {
         super();
         this.m_view = new SliderView();
         addChild(this.m_view);
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_view.track_mc.width = param1;
      }
      
      public function onSetValue(param1:Number) : void
      {
         this.m_view.thumb_mc.x = param1 * this.m_view.track_mc.width;
      }
      
      public function onSetData(param1:Number) : void
      {
         this.onSetValue(param1);
      }
   }
}
