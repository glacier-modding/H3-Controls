package menu3.missionend
{
   import common.Animate;
   import common.Log;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import menu3.MenuImageLoader;
   
   public dynamic class ImageItemView extends MissionRewardItemView
   {
       
      
      private var m_loader:MenuImageLoader;
      
      private var m_bitmapImage:Bitmap;
      
      private var m_bitmapContainer:Sprite;
      
      private var m_selectionFrameView:ChallengeSelectionFrameView;
      
      public function ImageItemView()
      {
         super();
         this.visible = false;
         this.tileDarkBg.alpha = 0;
         this.icon.visible = false;
         this.m_bitmapContainer = new Sprite();
         image.addChild(this.m_bitmapContainer);
         this.addSelectionFrame();
      }
      
      public function killAnimation() : void
      {
         Animate.kill(this);
         Animate.kill(this.image);
         Animate.kill(this.icon);
         Animate.kill(this.m_selectionFrameView);
      }
      
      public function getImageWidth() : int
      {
         return imageMask.width;
      }
      
      public function getImageHeight() : int
      {
         return imageMask.height;
      }
      
      private function addSelectionFrame() : void
      {
         if(this.m_selectionFrameView != null)
         {
            return;
         }
         this.m_selectionFrameView = new ChallengeSelectionFrameView();
         this.m_selectionFrameView.x = image.x;
         this.m_selectionFrameView.y = image.y;
         this.m_selectionFrameView.width = imageMask.width;
         this.m_selectionFrameView.height = imageMask.height;
         this.m_selectionFrameView.alpha = 0;
         addChild(this.m_selectionFrameView);
      }
      
      public function setVisible(param1:Boolean, param2:Number = 1) : void
      {
         this.killAnimation();
         if(param1)
         {
            this.image.visible = true;
            this.image.alpha = param2;
            this.image.scaleX = 1;
            this.image.scaleY = 1;
            this.visible = true;
         }
         else
         {
            this.visible = false;
            this.image.visible = false;
         }
      }
      
      public function animateIn(param1:String) : void
      {
         switch(param1)
         {
            case MissionEndChallengePage.CHALLENGE_STATE_NEW:
               MenuUtils.setColor(this.m_selectionFrameView,MenuConstants.COLOR_WHITE,false);
               Animate.fromTo(this.m_selectionFrameView,0.8,0,{"alpha":0},{"alpha":1},Animate.ExpoOut);
               this.image.filters = [];
               Animate.to(this.image,0.5,0,{"alpha":1},Animate.ExpoOut);
               break;
            case MissionEndChallengePage.CHALLENGE_STATE_NEW_UNLOCKED:
               Animate.fromTo(this.m_selectionFrameView,0.4,0,{"alpha":1},{"alpha":0},Animate.ExpoOut);
               this.icon.scaleX = this.icon.scaleY = 0;
               this.icon.visible = true;
               MenuUtils.setupIcon(this.icon,"completed",MenuConstants.COLOR_WHITE,false,true,MenuConstants.COLOR_RED);
               Animate.to(this.icon,0.2,0,{
                  "scaleX":1,
                  "scaleY":1
               },Animate.BackOut);
               break;
            case MissionEndChallengePage.CHALLENGE_STATE_COMPLETE:
               Animate.fromTo(this.m_selectionFrameView,0.4,0,{"alpha":1},{"alpha":0},Animate.ExpoOut);
               this.image.filters = [];
               Animate.to(this.image,0.3,0,{"alpha":1},Animate.ExpoOut);
               break;
            case MissionEndChallengePage.CHALLENGE_STATE_UNCOMPLETE:
               Animate.fromTo(this.m_selectionFrameView,0.4,0,{"alpha":1},{"alpha":0},Animate.ExpoOut);
               break;
            default:
               Log.info(Log.ChannelDebug,this," No state set for challenge-tile!?");
         }
      }
      
      public function animateOut(param1:*) : void
      {
         var val:* = param1;
         Animate.legacyTo(this,0.2,{"alpha":0},Animate.ExpoOut,function(param1:MovieClip):void
         {
            param1.visible = false;
            param1.image.visible = false;
         },this);
         Animate.legacyTo(this.image,0.3,{
            "scaleX":0,
            "scaleY":0
         },Animate.ExpoOut);
      }
      
      public function loadImage(param1:String, param2:Function = null, param3:Function = null, param4:Number = 1) : void
      {
         var imagePath:String = param1;
         var callback:Function = param2;
         var failedCallback:Function = param3;
         var scale:Number = param4;
         this.unloadImage();
         this.m_loader = new MenuImageLoader();
         this.m_loader.center = true;
         image.addChild(this.m_loader);
         this.m_loader.loadImage(imagePath,function():void
         {
            var _loc5_:Bitmap = null;
            var _loc6_:Matrix = null;
            var _loc7_:BitmapData = null;
            var _loc1_:Object = null;
            var _loc2_:Number = 1;
            if(scale < 0.95)
            {
               _loc5_ = m_loader.getImage();
               (_loc6_ = new Matrix()).scale(scale,scale);
               (_loc7_ = new BitmapData(_loc5_.width * scale,_loc5_.height * scale,true)).draw(_loc5_,_loc6_);
               image.removeChild(m_loader);
               m_loader = null;
               m_bitmapImage = new Bitmap(_loc7_,"auto",true);
               m_bitmapImage.x = -m_bitmapImage.width / 2;
               m_bitmapImage.y = -m_bitmapImage.height / 2;
               m_bitmapContainer.addChild(m_bitmapImage);
               _loc2_ = m_bitmapImage.width / m_bitmapImage.height;
               _loc1_ = m_bitmapContainer;
            }
            else
            {
               _loc2_ = m_loader.width / m_loader.height;
               _loc1_ = m_loader;
            }
            var _loc3_:int = imageMask.width;
            var _loc4_:int = imageMask.height;
            _loc1_.width = _loc3_;
            _loc1_.height = _loc3_ / _loc2_;
            if(_loc1_.height < _loc4_)
            {
               _loc1_.height = _loc4_;
               _loc1_.width = _loc4_ * _loc2_;
            }
            if(callback != null)
            {
               callback();
            }
         },failedCallback);
      }
      
      public function unloadImage() : void
      {
         if(this.m_loader != null)
         {
            this.m_loader.cancelIfLoading();
            if(this.m_loader.parent != null)
            {
               this.m_loader.parent.removeChild(this.m_loader);
            }
            this.m_loader = null;
         }
         if(this.m_bitmapImage != null)
         {
            if(this.m_bitmapImage.parent != null)
            {
               this.m_bitmapImage.parent.removeChild(this.m_bitmapImage);
            }
            this.m_bitmapImage = null;
         }
      }
   }
}
