package hud.evergreen
{
   import common.Animate;
   import common.BaseControl;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class MenuOverlayContainer extends BaseControl
   {
       
      
      private var m_slideContainerL:Sprite;
      
      private var m_slideContainerR:Sprite;
      
      private var m_componentByName:Dictionary;
      
      private var m_isMenuOpen:Boolean = false;
      
      private var m_dxWidthLayout:Number = 0;
      
      private var m_dyHeightLayout:Number = 0;
      
      private var m_xLeft:Number = 0;
      
      private var m_xRight:Number = 0;
      
      private var m_yTop:Number = 0;
      
      private var m_yBottom:Number = 0;
      
      private var m_pxGutter:Number = 0;
      
      private var m_dtSlideAnimDuration:Number = 0;
      
      private var m_dxSlideAnimOffset:Number = 0;
      
      private var m_drawDebug:Boolean = false;
      
      public function MenuOverlayContainer()
      {
         this.m_slideContainerL = new Sprite();
         this.m_slideContainerR = new Sprite();
         this.m_componentByName = new Dictionary();
         super();
         this.m_slideContainerL.name = "m_slideContainerL";
         this.m_slideContainerR.name = "m_slideContainerR";
         addChild(this.m_slideContainerL);
         addChild(this.m_slideContainerR);
      }
      
      [PROPERTY(CATEGORY="Evergreen Menu Overlay Container",CONSTRAINT="Step(1) MinValue(0)")]
      public function set pxGutter(param1:Number) : void
      {
         this.m_pxGutter = param1;
         this.updateLayout();
      }
      
      [PROPERTY(CATEGORY="Evergreen Menu Overlay Container",CONSTRAINT="MinValue(0)")]
      public function set dtSlideAnimDuration(param1:Number) : void
      {
         this.m_dtSlideAnimDuration = param1;
      }
      
      [PROPERTY(CATEGORY="Evergreen Menu Overlay Container",CONSTRAINT="Step(1)")]
      public function set dxSlideAnimOffset(param1:Number) : void
      {
         this.m_dxSlideAnimOffset = param1;
      }
      
      [PROPERTY(CATEGORY="Evergreen Menu Overlay Container")]
      public function set DrawDebug(param1:Boolean) : void
      {
         this.m_drawDebug = param1;
         this.updateLayout();
      }
      
      public function onControlLayoutChanged() : void
      {
         var _loc1_:IMenuOverlayComponent = null;
         for each(_loc1_ in this.m_componentByName)
         {
            _loc1_.onControlLayoutChanged();
         }
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_dxWidthLayout = param1;
         this.m_dyHeightLayout = param2;
         this.updateLayout();
      }
      
      public function onMenuOpening(param1:Number) : void
      {
         this.m_isMenuOpen = true;
         var _loc2_:Number = Math.min(param1,this.m_dtSlideAnimDuration);
         Animate.to(this.m_slideContainerL,_loc2_,param1 - _loc2_,{
            "alpha":1,
            "x":this.m_xLeft
         },Animate.ExpoOut);
         Animate.to(this.m_slideContainerR,_loc2_,param1 - _loc2_,{
            "alpha":1,
            "x":this.m_xRight
         },Animate.ExpoOut);
      }
      
      public function onMenuClosing(param1:Number) : void
      {
         this.m_isMenuOpen = false;
         var _loc2_:Number = Math.min(param1,this.m_dtSlideAnimDuration);
         Animate.to(this.m_slideContainerL,_loc2_,0,{
            "alpha":0,
            "x":this.m_xLeft - this.m_dxSlideAnimOffset
         },Animate.ExpoIn);
         Animate.to(this.m_slideContainerR,_loc2_,0,{
            "alpha":0,
            "x":this.m_xRight + this.m_dxSlideAnimOffset
         },Animate.ExpoIn);
      }
      
      public function routeDataToComponent(param1:String, param2:Object) : void
      {
         var _loc4_:Class = null;
         var _loc3_:IMenuOverlayComponent = this.m_componentByName[param1];
         if(_loc3_ == null)
         {
            _loc3_ = new (_loc4_ = Class(getDefinitionByName("hud.evergreen.menuoverlay." + param1 + "Component")))();
            this.m_componentByName[param1] = _loc3_;
            (_loc3_.isLeftAligned() ? this.m_slideContainerL : this.m_slideContainerR).addChild(_loc3_);
            _loc3_.onUsableSizeChanged(this.m_xRight - this.m_xLeft,this.m_yTop,this.m_yBottom);
         }
         _loc3_.onSetData(param2);
      }
      
      private function updateLayout() : void
      {
         var _loc1_:Number = NaN;
         var _loc4_:IMenuOverlayComponent = null;
         _loc1_ = Math.min(this.m_dxWidthLayout / 1920,this.m_dyHeightLayout / 1080);
         var _loc2_:Number = 1920 * _loc1_;
         var _loc3_:Number = this.m_dyHeightLayout;
         this.m_xLeft = this.m_dxWidthLayout / 2 - _loc2_ / 2 + this.m_pxGutter;
         this.m_yTop = this.m_dyHeightLayout / 2 - _loc3_ / 2 + this.m_pxGutter;
         this.m_xRight = this.m_xLeft + _loc2_ - 2 * this.m_pxGutter;
         this.m_yBottom = this.m_yTop + _loc3_ - 2 * this.m_pxGutter;
         Animate.kill(this.m_slideContainerL);
         Animate.kill(this.m_slideContainerR);
         this.m_slideContainerL.alpha = this.m_isMenuOpen ? 1 : 0;
         this.m_slideContainerR.alpha = this.m_isMenuOpen ? 1 : 0;
         this.m_slideContainerL.x = this.m_xLeft - (this.m_isMenuOpen ? 0 : this.m_dxSlideAnimOffset);
         this.m_slideContainerR.x = this.m_xRight + (this.m_isMenuOpen ? 0 : this.m_dxSlideAnimOffset);
         graphics.clear();
         this.m_slideContainerL.graphics.clear();
         this.m_slideContainerR.graphics.clear();
         if(this.m_drawDebug)
         {
            graphics.lineStyle(3,16776960,1);
            graphics.drawRect(4,4,this.m_dxWidthLayout - 2 * 4,this.m_dyHeightLayout - 2 * 4);
            graphics.lineStyle();
            graphics.beginFill(16711680,0.25);
            graphics.drawRect(this.m_xLeft,this.m_yTop,this.m_xRight - this.m_xLeft,this.m_yBottom - this.m_yTop);
            this.m_slideContainerL.graphics.lineStyle(3,65280,1);
            this.m_slideContainerL.graphics.moveTo(0,-9999);
            this.m_slideContainerL.graphics.lineTo(0,9999);
            this.m_slideContainerR.graphics.lineStyle(3,65280,1);
            this.m_slideContainerR.graphics.moveTo(0,-9999);
            this.m_slideContainerR.graphics.lineTo(0,9999);
         }
         for each(_loc4_ in this.m_componentByName)
         {
            _loc4_.onUsableSizeChanged(this.m_xRight - this.m_xLeft,this.m_yTop,this.m_yBottom);
         }
      }
   }
}
