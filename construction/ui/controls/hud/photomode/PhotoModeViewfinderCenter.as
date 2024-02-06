package hud.photomode
{
   import common.Animate;
   import common.BaseControl;
   
   public class PhotoModeViewfinderCenter extends BaseControl
   {
       
      
      private var m_view:PhotoModeViewfinderCenterView;
      
      private var m_maxCount:Number = 10;
      
      private var m_previousScanVal:Number = 0;
      
      private var m_isScanning:Boolean;
      
      public function PhotoModeViewfinderCenter()
      {
         super();
         this.m_view = new PhotoModeViewfinderCenterView();
         this.m_view.alpha = 0.4;
         this.m_view.reticle_mc.inner_mc.ring_mc.alpha = 0;
         this.m_view.reticle_mc.outer_mc.ring_mc.alpha = 0;
         this.m_view.visible = false;
         addChild(this.m_view);
      }
      
      public function setScanValue(param1:Number) : void
      {
         if(!this.m_isScanning)
         {
            if(param1 >= this.m_previousScanVal)
            {
               this.m_isScanning = true;
               Animate.to(this.m_view,0.4,0,{"alpha":0.7},Animate.ExpoOut);
               Animate.to(this.m_view.reticle_mc.inner_mc.crosshair_mc,0.4,0,{"frames":100},Animate.SineIn);
               Animate.to(this.m_view.reticle_mc.outer_mc.crosshair_mc,0.4,0,{"frames":100},Animate.SineIn,this.fadeInRings);
               Animate.to(this.m_view.reticle_mc.inner_mc,0.8,0.4,{"rotation":180},Animate.SineIn,this.rotateReticle);
               Animate.to(this.m_view.reticle_mc.outer_mc,0.8,0.4,{"rotation":-180},Animate.SineIn);
            }
         }
         if(this.m_isScanning)
         {
            if(param1 == this.m_maxCount || param1 <= this.m_previousScanVal)
            {
               this.m_isScanning = false;
               this.killAllAnims();
               Animate.to(this.m_view.reticle_mc.inner_mc.crosshair_mc,0.2,0,{"frames":0},Animate.ExpoOut);
               Animate.to(this.m_view.reticle_mc.outer_mc.crosshair_mc,0.2,0,{"frames":0},Animate.ExpoOut);
               Animate.to(this.m_view.reticle_mc.inner_mc.ring_mc,0.2,0,{"alpha":0},Animate.ExpoOut);
               Animate.to(this.m_view.reticle_mc.outer_mc.ring_mc,0.2,0,{"alpha":0},Animate.ExpoOut);
               Animate.to(this.m_view.reticle_mc.inner_mc,0.2,0,{"rotation":0},Animate.ExpoOut);
               Animate.to(this.m_view.reticle_mc.outer_mc,0.2,0,{"rotation":0},Animate.ExpoOut);
               Animate.to(this.m_view,0.2,0,{"alpha":0.4},Animate.ExpoOut);
            }
         }
         this.m_previousScanVal = param1;
      }
      
      private function rotateReticle() : void
      {
         this.m_view.reticle_mc.inner_mc.rotation = 0;
         this.m_view.reticle_mc.outer_mc.rotation = 0;
         Animate.to(this.m_view.reticle_mc.inner_mc,1,0,{"rotation":180},Animate.Linear,this.rotateReticle);
         Animate.to(this.m_view.reticle_mc.outer_mc,1,0,{"rotation":-180},Animate.Linear);
      }
      
      private function fadeInRings() : void
      {
         Animate.to(this.m_view.reticle_mc.inner_mc.ring_mc,0.6,0,{"alpha":0.7},Animate.ExpoOut);
         Animate.to(this.m_view.reticle_mc.outer_mc.ring_mc,0.6,0,{"alpha":0.7},Animate.ExpoOut);
      }
      
      public function setViewFinderStyle(param1:int) : void
      {
         switch(param1)
         {
            case PhotoModeWidget.VIEWFINDERSTYLE_NONE:
               this.killAllAnims();
               this.resetScanning();
               this.m_view.visible = false;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_CAMERAITEM:
               this.m_view.visible = true;
               this.m_view.alpha = 0.4;
               this.m_view.reticle_mc.scaleX = this.m_view.reticle_mc.scaleY = 1;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_PHOTOOPP:
               this.killAllAnims();
               this.resetScanning();
               this.m_view.visible = true;
               this.m_view.alpha = 0.2;
               this.m_view.reticle_mc.scaleX = this.m_view.reticle_mc.scaleY = 1;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_SPYCAM:
               this.m_view.visible = true;
               this.m_view.alpha = 0.4;
               this.m_view.reticle_mc.scaleX = this.m_view.reticle_mc.scaleY = 0.535;
               break;
            default:
               this.m_view.visible = true;
               this.m_view.alpha = 0.4;
               this.m_view.reticle_mc.scaleX = this.m_view.reticle_mc.scaleY = 1;
         }
      }
      
      private function resetScanning() : void
      {
         this.m_view.reticle_mc.inner_mc.crosshair_mc.gotoAndStop(0);
         this.m_view.reticle_mc.outer_mc.crosshair_mc.gotoAndStop(0);
         this.m_view.reticle_mc.inner_mc.ring_mc.alpha = 0;
         this.m_view.reticle_mc.outer_mc.ring_mc.alpha = 0;
         this.m_view.reticle_mc.inner_mc.rotation = 0;
         this.m_view.reticle_mc.outer_mc.rotation = 0;
         this.m_isScanning = false;
      }
      
      private function killAllAnims() : void
      {
         Animate.kill(this.m_view);
         Animate.kill(this.m_view.reticle_mc.inner_mc);
         Animate.kill(this.m_view.reticle_mc.outer_mc);
         Animate.kill(this.m_view.reticle_mc.inner_mc.crosshair_mc);
         Animate.kill(this.m_view.reticle_mc.outer_mc.crosshair_mc);
         Animate.kill(this.m_view.reticle_mc.inner_mc.ring_mc);
         Animate.kill(this.m_view.reticle_mc.outer_mc.ring_mc);
      }
   }
}
