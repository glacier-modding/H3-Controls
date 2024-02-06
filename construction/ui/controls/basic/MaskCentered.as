package basic
{
   import common.BaseControl;
   import flash.display.Sprite;
   
   public class MaskCentered extends BaseControl
   {
       
      
      private var m_view:MaskView;
      
      private var m_cacheMaskeeAsBitmap:Boolean;
      
      private var m_maskee:Sprite;
      
      public function MaskCentered()
      {
         super();
         this.m_view = new MaskView();
         this.m_cacheMaskeeAsBitmap = false;
         addChild(this.m_view);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_maskee = param1 as Sprite;
         this.updateMask();
      }
      
      public function updateMask() : void
      {
         trace("MaskCircular attempting to set maskee: " + this.m_maskee);
         if(this.m_maskee)
         {
            trace("MaskCircular sets maskee: " + this.m_maskee);
            this.m_maskee.mask = this.m_view;
         }
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_view.width = param1;
         this.m_view.height = param2;
         this.m_view.x = -param1 / 2;
         this.m_view.y = -param2 / 2;
      }
      
      public function set CacheMaskAsBitmap(param1:Boolean) : void
      {
         this.m_cacheMaskeeAsBitmap = param1;
         this.updateMask();
      }
   }
}
