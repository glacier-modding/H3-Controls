package hud.versus.markers
{
   import common.Animate;
   import flash.display.Sprite;
   
   public class StashMarkerElement extends BaseMarkerElement
   {
       
      
      private var m_isCounting:Boolean = false;
      
      public function StashMarkerElement()
      {
         super();
         m_view = new StashMarkerElementView();
         this.pulsateOverlays(m_view.pointerOverlay,false);
         this.pulsateBlurs(m_view.pointerBlur,false);
         this.pulsateOverlays(m_view.stashbarOverlay,false);
         this.pulsateBlurs(m_view.stashbarBlur,false);
         this.pulsateIcons(m_view.pointer,false);
         m_view.stashbar.bar.scaleX = 1;
         m_view.stashbarOverlay.scaleX = 1;
         m_view.stashbar.y = m_view.stashbarBlur.y = m_view.stashbarOverlay.y = 0;
         addChild(m_view);
      }
      
      public function onSetData(param1:Object) : void
      {
      }
      
      public function setIconType(param1:int, param2:Boolean) : void
      {
         m_view.pointer.visible = param2 ? true : false;
         m_view.iconMc.visible = param2 ? true : false;
         m_view.iconMc.gotoAndStop(param1 + 1);
         m_view.stashbar.bar.visible = param2 ? false : true;
      }
      
      public function setTimeLeft(param1:Number, param2:Boolean) : void
      {
         m_view.stashbar.bar.gotoAndStop(2);
         m_view.stashbar.bar.scaleX = param1;
         m_view.stashbarOverlay.scaleX = param1;
         if(!this.m_isCounting)
         {
            if(param2)
            {
               m_view.pointer.gotoAndStop(2);
               this.pulsateOverlays(m_view.pointerOverlay,true);
               this.pulsateBlurs(m_view.pointerBlur,true);
               this.pulsateIcons(m_view.pointer,true);
            }
            else
            {
               this.pulsateOverlays(m_view.stashbarOverlay,true);
               this.pulsateBlurs(m_view.stashbarBlur,true);
            }
            this.m_isCounting = true;
         }
         if(param1 <= 0)
         {
            this.m_isCounting = false;
            m_view.stashbar.bar.gotoAndStop(1);
            m_view.pointer.gotoAndStop(1);
            if(param2)
            {
               this.pulsateOverlays(m_view.pointerOverlay,true,true);
               this.pulsateBlurs(m_view.pointerBlur,true,true);
               this.pulsateIcons(m_view.pointer,true,true);
            }
            else
            {
               this.pulsateOverlays(m_view.stashbarOverlay,true,true);
               this.pulsateBlurs(m_view.stashbarBlur,true,true);
            }
         }
      }
      
      private function pulsateBlurs(param1:Sprite, param2:Boolean, param3:Boolean = false) : void
      {
         Animate.kill(param1);
         param1.alpha = 0;
         if(param2)
         {
            this.pulsateBlursIn({
               "clip":param1,
               "singlePulseThenKill":param3
            });
         }
      }
      
      private function pulsateBlursIn(param1:Object) : void
      {
         param1.clip.scaleX = param1.clip.scaleY = 1;
         param1.clip.alpha = 0.3;
         Animate.to(param1.clip,0.2,0,{
            "alpha":1,
            "scaleX":1.4,
            "scaleY":1
         },Animate.ExpoIn,this.pulsateBlursOut,param1);
      }
      
      private function pulsateBlursOut(param1:Object) : void
      {
         var clipObject:Object = param1;
         Animate.to(clipObject.clip,0.5,0,{
            "alpha":0,
            "scaleX":2,
            "scaleY":1
         },Animate.ExpoOut,function():void
         {
            if(clipObject.singlePulseThenKill)
            {
               pulsateBlurs(clipObject.clip,false);
            }
            else
            {
               pulsateBlursIn(clipObject);
            }
         });
      }
      
      private function pulsateOverlays(param1:Sprite, param2:Boolean, param3:Boolean = false) : void
      {
         Animate.kill(param1);
         param1.alpha = 0;
         if(param2)
         {
            this.pulsateOverlaysIn({
               "clip":param1,
               "singlePulseThenKill":param3
            });
         }
      }
      
      private function pulsateOverlaysIn(param1:Object) : void
      {
         param1.clip.alpha = 0.6;
         Animate.to(param1.clip,0.5,0.2,{"alpha":0},Animate.ExpoOut,this.pulsateOverlaysOut,param1);
      }
      
      private function pulsateOverlaysOut(param1:Object) : void
      {
         if(param1.singlePulseThenKill)
         {
            this.pulsateOverlays(param1.clip,false);
         }
         else
         {
            this.pulsateOverlaysIn(param1);
         }
      }
      
      private function pulsateIcons(param1:Sprite, param2:Boolean, param3:Boolean = false) : void
      {
         Animate.kill(param1);
         param1.scaleX = param1.scaleY = 1;
         param1.alpha = 1;
         if(param2)
         {
            this.pulsateIconsIn({
               "clip":param1,
               "singlePulseThenKill":param3
            });
         }
      }
      
      private function pulsateIconsIn(param1:Object) : void
      {
         param1.clip.scaleX = param1.clip.scaleY = 0.9;
         Animate.to(param1.clip,0.5,0.1,{
            "scaleX":1,
            "scaleY":1
         },Animate.BackInOut,this.pulsateIconsOut,param1);
      }
      
      private function pulsateIconsOut(param1:Object) : void
      {
         var clipObject:Object = param1;
         Animate.delay(clipObject.clip,0.1,function():void
         {
            if(clipObject.singlePulseThenKill)
            {
               pulsateIcons(clipObject.clip,false);
            }
            else
            {
               pulsateIconsIn(clipObject);
            }
         });
      }
   }
}
