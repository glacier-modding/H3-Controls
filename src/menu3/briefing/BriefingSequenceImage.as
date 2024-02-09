package menu3.briefing
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import menu3.MenuImageLoader;
   
   public class BriefingSequenceImage extends BaseControl
   {
       
      
      private var m_animateStartRow:Number;
      
      private var m_animateEndRow:Number;
      
      private var m_animateStartCol:Number;
      
      private var m_animateEndCol:Number;
      
      private var m_animateStartScale:Number;
      
      private var m_animateEndScale:Number;
      
      private var m_animateEasingType:int;
      
      private var m_imageSequenceDuration:Number;
      
      private var m_imageContainer:Sprite;
      
      private var m_loader:MenuImageLoader;
      
      private var m_imagePath:String;
      
      private var m_unitWidth:Number;
      
      private var m_unitHeight:Number;
      
      public function BriefingSequenceImage()
      {
         this.m_unitWidth = MenuConstants.BaseWidth / 10;
         this.m_unitHeight = MenuConstants.BaseHeight / 6;
         super();
         trace("ETBriefing | BriefingSequenceImage CALLED!!!");
         this.m_imageContainer = new Sprite();
         this.m_imageContainer.name = "m_imageContainer";
         addChild(this.m_imageContainer);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.m_imagePath = param1 as String;
      }
      
      public function start(param1:Number, param2:Number) : void
      {
         this.loadImage(param1,param2);
      }
      
      private function loadImage(param1:Number, param2:Number) : void
      {
         var baseduration:Number = param1;
         var containeranimateinduration:Number = param2;
         if(this.m_imageSequenceDuration)
         {
            baseduration = this.m_imageSequenceDuration;
         }
         if(this.m_loader != null)
         {
            this.m_loader.cancelIfLoading();
            this.m_imageContainer.removeChild(this.m_loader);
            this.m_loader = null;
         }
         this.m_loader = new MenuImageLoader();
         this.m_imageContainer.addChild(this.m_loader);
         this.m_loader.center = false;
         this.m_loader.loadImage(this.m_imagePath,function():void
         {
            MenuUtils.trySetCacheAsBitmap(m_imageContainer,true);
            var _loc1_:Number = (m_imageContainer.width - m_imageContainer.width * m_animateStartScale) / 2;
            var _loc2_:Number = (m_imageContainer.width - m_imageContainer.width * m_animateEndScale) / 2;
            var _loc3_:Number = (m_imageContainer.height - m_imageContainer.height * m_animateStartScale) / 2;
            var _loc4_:Number = (m_imageContainer.height - m_imageContainer.height * m_animateEndScale) / 2;
            m_imageContainer.x = m_unitWidth * m_animateStartRow + _loc1_;
            m_imageContainer.y = m_unitHeight * m_animateStartCol + _loc3_;
            m_imageContainer.scaleX = m_imageContainer.scaleY = m_animateStartScale;
            Animate.to(m_imageContainer,baseduration,containeranimateinduration,{
               "x":m_unitWidth * m_animateEndRow + _loc2_,
               "y":m_unitHeight * m_animateEndCol + _loc4_,
               "scaleX":m_animateEndScale,
               "scaleY":m_animateEndScale
            },m_animateEasingType);
         });
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_imageContainer;
      }
      
      public function set SequenceDurationOverride(param1:Number) : void
      {
         this.m_imageSequenceDuration = param1;
      }
      
      public function set AnimateStartRow(param1:Number) : void
      {
         this.m_animateStartRow = param1;
      }
      
      public function set AnimateEndRow(param1:Number) : void
      {
         this.m_animateEndRow = param1;
      }
      
      public function set AnimateStartCol(param1:Number) : void
      {
         this.m_animateStartCol = param1;
      }
      
      public function set AnimateEndCol(param1:Number) : void
      {
         this.m_animateEndCol = param1;
      }
      
      public function set AnimateStartScale(param1:Number) : void
      {
         this.m_animateStartScale = param1;
      }
      
      public function set AnimateEndScale(param1:Number) : void
      {
         this.m_animateEndScale = param1;
      }
      
      public function set AnimateEasingType(param1:String) : void
      {
         this.m_animateEasingType = MenuUtils.getEaseType(param1);
      }
   }
}
