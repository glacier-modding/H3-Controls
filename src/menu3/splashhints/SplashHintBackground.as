package menu3.splashhints
{
   import common.Animate;
   import common.BaseControl;
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class SplashHintBackground extends BaseControl implements ISplashHint
   {
       
      
      private var m_animationDelayIn:Number;
      
      private var m_animationDelayOut:Number;
      
      private var m_container:Sprite;
      
      private var m_view:Sprite;
      
      private var bgInitialPosition:Point;
      
      private var m_sizeX:Number;
      
      private var m_sizeY:Number;
      
      private var m_safeAreaRatio:Number = 1;
      
      public function SplashHintBackground()
      {
         this.m_sizeX = MenuConstants.BaseWidth;
         this.m_sizeY = MenuConstants.BaseHeight;
         super();
         this.m_container = new Sprite();
         addChild(this.m_container);
         this.m_view = new Sprite();
         this.m_view.graphics.clear();
         this.m_view.graphics.beginFill(MenuConstants.COLOR_MENU_TABS_BACKGROUND,MenuConstants.MenuElementBackgroundAlpha);
         this.m_view.graphics.drawRect(0,0,MenuConstants.BaseWidth,MenuConstants.BaseHeight);
         this.m_view.graphics.endFill();
         this.m_view.alpha = 0;
         this.m_view.y = MenuConstants.UserLineUpperYPos - 242;
         this.m_container.addChild(this.m_view);
         this.bgInitialPosition = new Point(this.m_view.x,this.m_view.y);
      }
      
      public function set AnimationDelayIn(param1:Number) : void
      {
         this.m_animationDelayIn = param1;
      }
      
      public function set AnimationDelayOut(param1:Number) : void
      {
         this.m_animationDelayOut = param1;
      }
      
      public function onSetData(param1:Object) : void
      {
         if(this.m_view != null)
         {
            this.m_view.visible = param1.hinttype != MenuConstants.SPLASH_HINT_TYPE_CONTROLLER;
         }
      }
      
      public function show() : void
      {
         Animate.fromTo(this.m_view,0.2,this.m_animationDelayIn,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         Animate.addFromTo(this.m_view,0.4,this.m_animationDelayIn,{"y":this.bgInitialPosition.y + 400},{"y":this.bgInitialPosition.y},Animate.ExpoInOut);
      }
      
      public function hide() : void
      {
         Animate.fromTo(this.m_view,0.2,this.m_animationDelayOut,{"alpha":1},{"alpha":0},Animate.ExpoOut);
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_container;
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         super.onSetSize(param1,param2);
         this.m_sizeX = param1;
         this.m_sizeY = param2;
         this.scaleBackground(this.m_sizeX,this.m_sizeY,this.m_safeAreaRatio);
      }
      
      override public function onSetViewport(param1:Number, param2:Number, param3:Number) : void
      {
         super.onSetViewport(param1,param2,param3);
         this.m_safeAreaRatio = param3;
         this.scaleBackground(this.m_sizeX,this.m_sizeY,this.m_safeAreaRatio);
      }
      
      private function scaleBackground(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = param1 / MenuConstants.BaseWidth;
         var _loc5_:Number;
         var _loc6_:Number = (_loc5_ = Math.min(_loc4_,param2 / MenuConstants.BaseHeight)) * param3;
         var _loc7_:Number = param2 - _loc6_ * MenuConstants.BaseHeight;
         var _loc8_:Number = MenuConstants.BaseHeight * (1 - param3) / 2;
         this.m_container.scaleX = _loc4_;
         this.m_container.x = 0;
         this.m_container.scaleY = _loc6_;
         this.m_container.y = _loc7_ - _loc8_;
      }
   }
}
