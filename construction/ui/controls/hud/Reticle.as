package hud
{
   import common.Animate;
   import common.BaseControl;
   import flash.display.MovieClip;
   
   public class Reticle extends BaseControl
   {
       
      
      private var m_view:ReticleView;
      
      private var currentType:Number = 0;
      
      private var baseAlpha:Number = 0.8;
      
      public function Reticle()
      {
         super();
         this.m_view = new ReticleView();
         this.m_view.hitKill_mc.visible = false;
         this.m_view.hit_mc.visible = false;
         addChild(this.m_view);
      }
      
      public function set type(param1:Number) : void
      {
         this.setType(param1);
      }
      
      public function setType(param1:Number) : void
      {
         this.currentType = param1;
         switch(param1)
         {
            case 0:
               this.m_view.gotoAndStop("NONE");
               this.m_view.center_mc.alpha = 0;
               break;
            case 1:
               this.m_view.gotoAndStop("PISTOL");
               this.m_view.center_mc.alpha = 0;
               break;
            case 2:
               this.m_view.gotoAndStop("REVOLVER");
               this.m_view.center_mc.alpha = 0;
               break;
            case 3:
               this.m_view.gotoAndStop("SMG");
               this.m_view.center_mc.alpha = 0;
               break;
            case 4:
               this.m_view.gotoAndStop("RIFLE");
               this.m_view.center_mc.alpha = 0;
               break;
            case 5:
               this.m_view.gotoAndStop("SHOTGUN");
               this.m_view.center_mc.alpha = 0;
               break;
            case 6:
               this.m_view.gotoAndStop("SNIPER");
               this.m_view.center_mc.alpha = 0;
               break;
            case 7:
               this.m_view.gotoAndStop("HARDBALLER");
               this.m_view.center_mc.alpha = 0;
               break;
            case 8:
               this.m_view.gotoAndStop("SPOTTER");
               break;
            case 9:
               this.m_view.gotoAndStop("POINTER");
               this.m_view.center_mc.alpha = 0;
               break;
            case 10:
               this.m_view.gotoAndStop("WORLDMAP");
               break;
            case 11:
               this.m_view.gotoAndStop("BLINDFIRE");
               break;
            case 12:
               this.m_view.gotoAndStop("RANGEDINDICATOR");
               this.m_view.center_mc.alpha = 0;
               break;
            case 13:
               this.m_view.gotoAndStop("NONE");
               this.m_view.center_mc.alpha = 0.5;
               break;
            default:
               this.m_view.gotoAndStop("NONE");
               this.m_view.center_mc.alpha = 0;
         }
      }
      
      public function setAccuracy(param1:Number) : void
      {
         var _loc2_:Number = 960;
         switch(this.currentType)
         {
            case 1:
               this.moveMarkers(param1,0,_loc2_,-1,0,0,1,1,0);
               break;
            case 2:
               this.moveMarkers(param1,0,_loc2_,-1,0,0,1,1,0);
               break;
            case 3:
               this.moveMarkers(param1,0,_loc2_,-1,0,0,1,1,0);
               break;
            case 4:
               this.moveMarkers(param1,0,_loc2_,-1,0,0,1,1,0);
               break;
            case 5:
               this.moveCircle(param1,_loc2_);
               break;
            case 6:
               this.moveMarkers(param1,0,_loc2_,-1,0,0,1,1,0,-0.3,0.3,0.3,0.3,0.3,-0.3,-0.3,-0.3);
               break;
            case 7:
               this.moveMarkers(param1,0,_loc2_,-1,0,0,1,1,0);
               break;
            case 8:
               this.moveMarkers(param1,5,_loc2_,-1,0,0,1,1,0);
               break;
            case 9:
               this.moveMarkers(param1,5,_loc2_);
               break;
            case 10:
               this.moveMarkers(param1,5,0,-1,0,0,1,1,0,0,-1);
               break;
            case 11:
               this.moveMarkers(param1,0,_loc2_,1,0,-1,0);
         }
      }
      
      private function moveMarkers(param1:Number, param2:Number, param3:Number, ... rest) : void
      {
         var _loc6_:MovieClip = null;
         var _loc5_:int = 0;
         while(_loc5_ < rest.length / 2)
         {
            (_loc6_ = this.m_view.getChildByName("marker" + String(_loc5_) + "_mc") as MovieClip).x = param2 * rest[_loc5_ * 2] + param3 * param1 * rest[_loc5_ * 2];
            _loc6_.y = param2 * rest[_loc5_ * 2 + 1] + param3 * param1 * rest[_loc5_ * 2 + 1];
            _loc6_.alpha = this.baseAlpha;
            _loc5_++;
         }
      }
      
      private function moveCircle(param1:Number, param2:Number) : void
      {
         this.m_view.marker0_mc.width = param1 * 2 * param2;
         this.m_view.marker0_mc.height = param1 * 2 * param2;
      }
      
      public function triggerHit() : void
      {
         this.m_view.hit_mc.visible = true;
         this.m_view.hit_mc.alpha = this.baseAlpha;
         this.m_view.hit_mc.scaleX = this.m_view.hit_mc.scaleY = 0.5;
         Animate.delay(this.m_view.hit_mc,0.4,this.hideMarker,this.m_view.hit_mc);
      }
      
      public function triggerKill() : void
      {
         Animate.kill(this.m_view.hitKill_mc);
         this.m_view.hit_mc.visible = false;
         this.m_view.hitKill_mc.alpha = 1;
         if(this.m_view.hitKill_mc.visible)
         {
            this.m_view.hitKill_mc.scaleX = this.m_view.hitKill_mc.scaleY = 1.1;
            Animate.legacyTo(this.m_view.hitKill_mc,0.7,{
               "scaleX":0.75,
               "scaleY":0.75
            },Animate.Linear,this.hideMarker,this.m_view.hitKill_mc);
         }
         else
         {
            this.m_view.hitKill_mc.visible = true;
            this.m_view.hitKill_mc.scaleX = this.m_view.hitKill_mc.scaleY = 0.75;
            Animate.delay(this.m_view.hitKill_mc,0.7,this.hideMarker,this.m_view.hitKill_mc);
         }
      }
      
      private function hideMarker(param1:MovieClip) : void
      {
         param1.visible = false;
      }
   }
}
