package menu3.missionend
{
   import common.Animate;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   
   public class MissionEndGhostFlare extends Sprite
   {
       
      
      private var m_view:MissionEndGhostFlareView;
      
      public function MissionEndGhostFlare()
      {
         super();
         this.m_view = new MissionEndGhostFlareView();
         addChild(this.m_view);
         this.pulsateClip(this.m_view.up,true,20,0.7,0.3,0.3,false);
         this.pulsateClip(this.m_view.mid,true,15,0.6,0.5,0.3,false);
         this.pulsateClip(this.m_view.low,true,10,1,0.6,0,true);
         this.rotateClipForEver(this.m_view.up.inner);
      }
      
      private function pulsateClip(param1:Sprite, param2:Boolean, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 0, param7:Boolean = false) : void
      {
         Animate.kill(param1);
         param1.alpha = 0;
         if(param2)
         {
            Animate.delay(param1,param6,this.pulsateClipInitialIn,{
               "clip":param1,
               "speed":param3,
               "scaleMax":param4,
               "alphaMax":param5,
               "speedyInit":param7
            });
         }
      }
      
      private function pulsateClipInitialIn(param1:Object) : void
      {
         if(param1.speedyInit)
         {
            Animate.to(param1.clip,0.6,0,{"alpha":0.4},Animate.Linear,this.pulsateClipOut,param1);
         }
         else
         {
            Animate.to(param1.clip,(Math.random() + 1) * param1.speed,0,{"alpha":0.4},Animate.Linear,this.pulsateClipOut,param1);
         }
      }
      
      private function pulsateClipOut(param1:Object) : void
      {
         Animate.to(param1.clip,(Math.random() + 1) * param1.speed,0,{
            "alpha":param1.alphaMax / 4,
            "scaleX":this.getRandomScale(param1.scaleMax),
            "scaleY":this.getRandomScale(param1.scaleMax)
         },Animate.Linear,this.pulsateClipIn,param1);
      }
      
      private function pulsateClipIn(param1:Object) : void
      {
         Animate.to(param1.clip,(Math.random() + 1) * param1.speed,0,{
            "alpha":param1.alphaMax,
            "scaleX":this.getRandomScale(param1.scaleMax),
            "scaleY":this.getRandomScale(param1.scaleMax)
         },Animate.Linear,this.pulsateClipOut,param1);
      }
      
      private function rotateClipForEver(param1:Sprite) : void
      {
         Animate.offset(param1,30,0,{"rotation":30},Animate.Linear,this.rotateClipForEver,param1);
      }
      
      private function getRandomScale(param1:Number) : Number
      {
         if(param1 == 1)
         {
            return 1;
         }
         return param1 + MenuUtils.getRandomInRange(-20,20) / 100;
      }
      
      public function stopAllAnimations() : void
      {
         this.pulsateClip(this.m_view.up,false);
         this.pulsateClip(this.m_view.mid,false);
         this.pulsateClip(this.m_view.low,false);
         this.pulsateClip(this.m_view.up.inner,false);
      }
   }
}
