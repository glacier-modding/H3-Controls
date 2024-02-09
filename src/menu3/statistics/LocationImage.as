package menu3.statistics
{
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class LocationImage extends Sprite
   {
       
      
      private var m_view:LocationImageView;
      
      private var m_imageMask:Sprite;
      
      private var m_data:Object;
      
      private var m_totalCompletion:Boolean;
      
      public function LocationImage(param1:Object)
      {
         super();
         this.m_data = param1;
         this.m_totalCompletion = this.m_data.completionValue == 100;
         this.m_view = new LocationImageView();
         this.m_view.tileImages.gotoAndStop(this.m_data.tileImage);
         this.m_view.tileImagesBg.gotoAndStop(this.m_data.tileImage);
         MenuUtils.setColor(this.m_view.tileImages,MenuConstants.COLOR_WHITE);
         MenuUtils.setColor(this.m_view.tileImagesBg,MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
         this.m_imageMask = new Sprite();
         this.m_imageMask.graphics.beginFill(16711680);
         this.m_imageMask.graphics.drawRect(0,-this.m_view.tileImages.height,this.m_view.tileImages.width,this.m_view.tileImages.height);
         this.m_imageMask.graphics.endFill();
         this.m_imageMask.scaleX = 0;
         this.m_view.tileImages.mask = this.m_imageMask;
         this.m_view.addChild(this.m_imageMask);
         addChild(this.m_view);
         if(!this.m_totalCompletion)
         {
            Animate.legacyFrom(this.m_view,0.3,{"alpha":0},Animate.ExpoOut);
         }
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Number = this.m_data.completionValue / 100;
         var _loc2_:Number = Math.min(0.6,Math.max(0.4,_loc1_));
         if(!this.m_totalCompletion)
         {
            Animate.legacyTo(this.m_imageMask,0.6,{"scaleX":this.m_data.completionValue / 100},Animate.ExpoInOut);
         }
         else
         {
            this.m_imageMask.scaleX = 1;
         }
      }
      
      public function destroy() : void
      {
         Animate.kill(this.m_view);
         Animate.kill(this.m_imageMask);
         while(this.m_view.numChildren > 0)
         {
            if(this.m_view.getChildAt(0) is MovieClip)
            {
               MovieClip(this.m_view.getChildAt(0)).gotoAndStop(1);
            }
            this.m_view.removeChild(this.m_view.getChildAt(0));
         }
         removeChild(this.m_view);
         this.m_view = null;
         this.m_imageMask = null;
      }
   }
}
