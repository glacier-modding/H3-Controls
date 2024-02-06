package menu3
{
   import basic.VideoBox;
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MenuVideoBox extends VideoBox
   {
       
      
      private var m_isPlaying:Boolean = false;
      
      private var m_background:Sprite;
      
      private var m_drawBackground:Boolean = false;
      
      private var m_backgroundX:Number = 0;
      
      private var m_backgroundY:Number = 0;
      
      private var m_backgroundWidth:Number;
      
      private var m_backgroundHeight:Number;
      
      public function MenuVideoBox()
      {
         this.m_backgroundWidth = MenuConstants.BaseWidth;
         this.m_backgroundHeight = MenuConstants.BaseHeight;
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,true,0,true);
         this.m_background = new Sprite();
         addChildAt(this.m_background,0);
      }
      
      public function set DrawBackground(param1:Boolean) : void
      {
         if(this.m_drawBackground == param1)
         {
            return;
         }
         this.m_drawBackground = param1;
         if(this.m_drawBackground)
         {
            this.redrawBackground();
         }
         else
         {
            this.clearBackground();
         }
      }
      
      override public function play(param1:String) : void
      {
         super.play(param1);
         this.m_isPlaying = true;
         this.redrawBackground();
      }
      
      override public function stop() : void
      {
         super.stop();
         this.m_isPlaying = false;
         this.clearBackground();
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         super.onSetSize(param1,param2);
         this.updateBackgroundPosition();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,true);
         stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED,this.screenResizeEventHandler,true,0,true);
      }
      
      private function screenResizeEventHandler(param1:ScreenResizeEvent) : void
      {
         var _loc2_:Object = param1.screenSize;
         if(this.m_backgroundWidth == _loc2_.sizeX && this.m_backgroundHeight == _loc2_.sizeY)
         {
            return;
         }
         this.m_backgroundWidth = _loc2_.sizeX;
         this.m_backgroundHeight = _loc2_.sizeY;
         this.redrawBackground();
      }
      
      private function updateBackgroundPosition() : void
      {
         var _loc1_:Number = -x;
         var _loc2_:Number = -y;
         if(this.m_backgroundX == _loc1_ && this.m_backgroundY == _loc2_)
         {
            return;
         }
         this.m_backgroundX = _loc1_;
         this.m_backgroundY = _loc2_;
         this.redrawBackground();
      }
      
      private function redrawBackground() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         this.clearBackground();
         if(this.m_drawBackground && this.m_isPlaying)
         {
            _loc1_ = 0;
            _loc2_ = 1;
            this.m_background.graphics.beginFill(_loc1_,_loc2_);
            this.m_background.graphics.drawRect(this.m_backgroundX,this.m_backgroundY,this.m_backgroundWidth,this.m_backgroundHeight);
            this.m_background.graphics.endFill();
         }
      }
      
      private function clearBackground() : void
      {
         this.m_background.graphics.clear();
      }
   }
}
