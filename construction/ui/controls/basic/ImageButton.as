package basic
{
   import common.Animate;
   import common.BaseControl;
   import common.ImageLoader;
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class ImageButton extends BaseControl
   {
       
      
      private var m_loader:ImageLoader;
      
      private var m_outline:Sprite;
      
      private var m_sizeX:Number;
      
      private var m_sizeY:Number;
      
      public function ImageButton()
      {
         this.m_loader = new ImageLoader();
         this.m_outline = new Sprite();
         super();
      }
      
      override public function onAttached() : void
      {
         addChild(this.m_loader);
         addChild(this.m_outline);
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_loader.width = param1;
         this.m_loader.height = param2;
         this.m_sizeX = param1;
         this.m_sizeY = param2;
      }
      
      public function loadImage(param1:String) : void
      {
         var rid:String = param1;
         this.m_loader.loadImage(rid,function():void
         {
            m_loader.width = m_sizeX;
            m_loader.height = m_sizeY;
         });
      }
      
      public function onSetData(param1:Object) : void
      {
         var _loc2_:String = param1 as String;
         if(_loc2_)
         {
            this.loadImage(_loc2_);
         }
      }
      
      public function onSetFocused(param1:Boolean) : void
      {
         var _loc2_:Graphics = null;
         if(param1)
         {
            _loc2_ = this.m_outline.graphics;
            _loc2_.moveTo(0,0);
            _loc2_.clear();
            _loc2_.lineStyle(2,255,1);
            _loc2_.drawRect(0,0,this.m_sizeX,this.m_sizeY);
            this.m_outline.visible = true;
         }
         else
         {
            this.m_outline.visible = false;
         }
      }
      
      public function onButtonPressed() : void
      {
         this.m_loader.alpha = 0;
         Animate.legacyTo(this.m_loader,0.4,{"alpha":1},Animate.ExpoOut);
      }
   }
}
