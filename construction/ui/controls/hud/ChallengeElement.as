package hud
{
   import common.Animate;
   import common.BaseControl;
   import common.ImageLoader;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.external.ExternalInterface;
   
   public class ChallengeElement extends BaseControl
   {
       
      
      private var m_view:ChallengeElementView;
      
      private var m_viewTotal:ChallengeElementView;
      
      private var m_loader:ImageLoader;
      
      public function ChallengeElement()
      {
         super();
         this.m_view = new ChallengeElementView();
         this.m_view.visible = false;
         this.m_viewTotal = new ChallengeElementView();
         this.m_viewTotal.visible = false;
         MenuUtils.setupTextUpper(this.m_view.challenge_large_txt,"",18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupTextUpper(this.m_view.challenge_txt,"",16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_view.progress_txt,"",12,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupTextUpper(this.m_viewTotal.challenge_large_txt,"",18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupTextUpper(this.m_viewTotal.challenge_txt,"",16,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupText(this.m_viewTotal.progress_txt,"",12,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         addChild(this.m_viewTotal);
         addChild(this.m_view);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.onSetDataWithDelay(param1,1);
      }
      
      public function onSetDataWithDelay(param1:Object, param2:Number) : void
      {
         var data:Object = param1;
         var dtDelay:Number = param2;
         Animate.kill(this.m_view.progressbar.value);
         Animate.kill(this.m_view.overlay);
         Animate.kill(this.m_view.completediconsoverlay);
         Animate.kill(this.m_view.imageoverlay);
         Animate.kill(this.m_view.image);
         Animate.kill(this.m_view);
         Animate.kill(this);
         Animate.kill(this.m_viewTotal.progressbar.value);
         Animate.kill(this.m_viewTotal.overlay);
         Animate.kill(this.m_viewTotal);
         this.m_view.progressbar.bg.alpha = 0.25;
         this.m_view.progressbar.value.ScaleX = 0;
         this.m_view.completedicons.alpha = 0;
         this.m_view.completedicons.gotoAndStop(2);
         this.m_view.completediconsoverlay.alpha = 0;
         this.m_view.imageoverlay.alpha = 0;
         this.m_view.image.alpha = 0;
         this.m_view.y = 0;
         this.m_view.visible = false;
         this.m_viewTotal.progressbar.bg.alpha = 0.25;
         this.m_viewTotal.progressbar.value.ScaleX = 0;
         this.m_viewTotal.completedicons.visible = false;
         this.m_viewTotal.completediconsoverlay.visible = false;
         this.m_viewTotal.imageoverlay.visible = false;
         this.m_viewTotal.image.visible = false;
         this.m_viewTotal.visible = false;
         if(!data.imagePath)
         {
            data.imagePath = "";
         }
         Animate.delay(this,dtDelay,function():void
         {
            ShowNotification(data.title,data.total,data.count,data.completed,data.timeRemaining - 1,data.imagePath);
         });
         if(data.overallChallenges)
         {
            Animate.delay(this.m_viewTotal,dtDelay + 0.7,function():void
            {
               ShowTotalNotification(data.overallChallenges.title,data.overallChallenges.total,data.overallChallenges.count,data.timeRemaining - 1.5);
            });
         }
      }
      
      public function ShowNotification(param1:String, param2:uint, param3:uint, param4:Boolean, param5:Number, param6:String) : void
      {
         var scaleFactorX:Number = NaN;
         var overlaySize:Number = NaN;
         var title:String = param1;
         var total:uint = param2;
         var count:uint = param3;
         var completed:Boolean = param4;
         var timeRemaining:Number = param5;
         var imagePath:String = param6;
         Animate.kill(this.m_view.progressbar.value);
         Animate.kill(this.m_view.overlay);
         Animate.kill(this.m_view.completediconsoverlay);
         Animate.kill(this.m_view.imageoverlay);
         Animate.kill(this.m_view.image);
         Animate.kill(this);
         this.m_view.completediconsoverlay.alpha = 0;
         this.m_view.imageoverlay.alpha = 0;
         this.m_view.progressbar.alpha = 0;
         this.m_view.challenge_txt.alpha = 0;
         this.m_view.progress_txt.alpha = 0;
         this.m_view.challenge_large_txt.alpha = 0;
         this.m_view.completedicons.alpha = 0;
         this.m_view.image.alpha = 0;
         if(this.m_loader != null)
         {
            this.m_loader.cancel();
            this.m_view.image.removeChild(this.m_loader);
            this.m_loader = null;
         }
         this.m_view.x = 0;
         this.m_view.alpha = 1;
         if(total == 1)
         {
            this.m_view.challenge_large_txt.htmlText = title;
            overlaySize = this.m_view.challenge_large_txt.textWidth + 50;
            this.m_view.overlay.alpha = 0;
            this.m_view.overlay.x = overlaySize / -2 + 5;
            this.m_view.overlay.width = overlaySize * 2.5;
            scaleFactorX = this.m_view.overlay.scaleX;
            this.m_view.overlay.width = overlaySize;
            this.m_view.overlay.alpha = 1;
            this.m_view.challenge_large_txt.alpha = 1;
         }
         else
         {
            this.m_view.overlay.alpha = 0;
            this.m_view.overlay.x = -216;
            this.m_view.overlay.width = 632;
            scaleFactorX = this.m_view.overlay.scaleX;
            this.m_view.overlay.width = 432;
            this.m_view.overlay.alpha = 1;
            this.m_view.challenge_txt.htmlText = title;
            MenuUtils.truncateTextfield(this.m_view.challenge_txt,1);
            this.m_view.progress_txt.htmlText = String(count) + "/" + String(total);
            if(count >= 1)
            {
               this.m_view.progressbar.value.scaleX = (count - 1) / total;
            }
            this.m_view.challenge_txt.alpha = 1;
            this.m_view.progress_txt.alpha = 1;
            this.m_view.progressbar.alpha = 1;
         }
         this.m_view.visible = true;
         if(total != 1)
         {
            Animate.to(this.m_view.progressbar.value,0.6,0,{"scaleX":count / total},Animate.ExpoOut);
         }
         Animate.to(this.m_view.overlay,0.8,0,{
            "scaleX":scaleFactorX,
            "alpha":0
         },Animate.ExpoOut);
         if(completed && imagePath != "")
         {
            this.playSound("ChallengeComplete");
            this.showCompleted(imagePath);
         }
         else
         {
            this.playSound("ChallengePartiallyComplete");
         }
         Animate.delay(this,timeRemaining - 0.5,function():void
         {
            Animate.kill(m_view.progressbar.value);
            Animate.kill(m_view.overlay);
            Animate.to(m_view,0.5,0,{
               "x":400,
               "alpha":0
            },Animate.ExpoOut);
         });
      }
      
      private function showCompleted(param1:String) : void
      {
         var scaleFactor01:Number = NaN;
         var completedIconsAnimationHandler:Function = null;
         var scaleFactor02:Number = NaN;
         var imagePath:String = param1;
         this.m_view.completediconsoverlay.width = this.m_view.completediconsoverlay.height = 100;
         scaleFactor01 = this.m_view.completediconsoverlay.scaleX;
         this.m_view.completediconsoverlay.width = this.m_view.completediconsoverlay.height = 23;
         completedIconsAnimationHandler = function():void
         {
            m_view.completediconsoverlay.alpha = 1;
            m_view.completedicons.alpha = 1;
            Animate.to(m_view.completediconsoverlay,0.8,0,{
               "scaleX":scaleFactor01,
               "scaleY":scaleFactor01,
               "alpha":0
            },Animate.ExpoOut);
         };
         if(!ControlsMain.isVrModeActive())
         {
            this.m_view.imageoverlay.width = this.m_view.imageoverlay.height = 240;
            scaleFactor02 = this.m_view.imageoverlay.scaleX;
            this.m_view.imageoverlay.width = this.m_view.imageoverlay.height = 120;
            if(this.m_loader != null)
            {
               this.m_loader.cancel();
               this.m_view.image.removeChild(this.m_loader);
               this.m_loader = null;
            }
            this.m_loader = new ImageLoader();
            this.m_view.image.addChild(this.m_loader);
            this.m_loader.loadImage(imagePath,function():void
            {
               m_loader.height = 120;
               m_loader.scaleX = m_loader.scaleY;
               if(m_loader.width < 120)
               {
                  m_loader.width = 120;
                  m_loader.scaleY = m_loader.scaleX;
               }
               m_loader.x = m_loader.width / -2;
               m_loader.y = m_loader.height / -2;
               Animate.delay(m_view.imageoverlay,0.5,function():void
               {
                  m_view.imageoverlay.alpha = 1;
                  m_view.image.alpha = 1;
                  Animate.to(m_view.imageoverlay,0.8,0,{
                     "scaleX":scaleFactor02,
                     "scaleY":scaleFactor02,
                     "alpha":0
                  },Animate.ExpoOut);
                  Animate.delay(m_view.completediconsoverlay,0.3,completedIconsAnimationHandler);
               });
            });
         }
         else
         {
            Animate.delay(this.m_view.completediconsoverlay,0.3,completedIconsAnimationHandler);
         }
      }
      
      public function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
      
      public function ShowTotalNotification(param1:String, param2:uint, param3:uint, param4:Number) : void
      {
         var scaleFactorX:Number = NaN;
         var overlaySize:Number = NaN;
         var title:String = param1;
         var total:uint = param2;
         var count:uint = param3;
         var timeRemaining:Number = param4;
         Animate.kill(this.m_viewTotal.progressbar.value);
         Animate.kill(this.m_viewTotal.overlay);
         Animate.kill(this.m_viewTotal);
         Animate.to(this.m_view,0.5,0,{"y":33},Animate.ExpoOut);
         this.m_viewTotal.progressbar.alpha = 0;
         this.m_viewTotal.challenge_txt.alpha = 0;
         this.m_viewTotal.progress_txt.alpha = 0;
         this.m_viewTotal.challenge_large_txt.alpha = 0;
         this.m_viewTotal.x = 0;
         this.m_viewTotal.alpha = 1;
         if(total == 1)
         {
            this.m_viewTotal.challenge_large_txt.htmlText = title;
            overlaySize = this.m_viewTotal.challenge_large_txt.textWidth + 50;
            this.m_viewTotal.overlay.alpha = 0;
            this.m_viewTotal.overlay.x = overlaySize / -2 + 5;
            this.m_viewTotal.overlay.width = overlaySize * 2.5;
            scaleFactorX = this.m_viewTotal.overlay.scaleX;
            this.m_viewTotal.overlay.width = overlaySize;
            this.m_viewTotal.overlay.alpha = 1;
            this.m_viewTotal.challenge_large_txt.alpha = 1;
         }
         else
         {
            this.m_viewTotal.overlay.alpha = 0;
            this.m_viewTotal.overlay.x = -216;
            this.m_viewTotal.overlay.width = 632;
            scaleFactorX = this.m_viewTotal.overlay.scaleX;
            this.m_viewTotal.overlay.width = 432;
            this.m_viewTotal.overlay.alpha = 1;
            this.m_viewTotal.challenge_txt.htmlText = title;
            MenuUtils.truncateTextfield(this.m_viewTotal.challenge_txt,1);
            this.m_viewTotal.progress_txt.htmlText = String(count) + "/" + String(total);
            if(count >= 1)
            {
               this.m_viewTotal.progressbar.value.scaleX = (count - 1) / total;
            }
            this.m_viewTotal.challenge_txt.alpha = 1;
            this.m_viewTotal.progress_txt.alpha = 1;
            this.m_viewTotal.progressbar.alpha = 1;
         }
         Animate.delay(this.m_viewTotal,0.1,function():void
         {
            m_viewTotal.visible = true;
            if(total != 1)
            {
               Animate.to(m_viewTotal.progressbar.value,0.6,0,{"scaleX":count / total},Animate.ExpoOut);
            }
            Animate.to(m_viewTotal.overlay,0.8,0,{
               "scaleX":scaleFactorX,
               "alpha":0
            },Animate.ExpoOut);
            playSound("ChallengePartiallyComplete");
            Animate.delay(m_viewTotal,timeRemaining - 0.6,function():void
            {
               Animate.kill(m_viewTotal.progressbar.value);
               Animate.kill(m_viewTotal.overlay);
               Animate.to(m_viewTotal,0.3,0,{
                  "x":400,
                  "alpha":0
               },Animate.ExpoOut);
            });
         });
      }
      
      public function HideNotification() : void
      {
         this.m_view.visible = false;
         this.m_viewTotal.visible = false;
      }
   }
}
