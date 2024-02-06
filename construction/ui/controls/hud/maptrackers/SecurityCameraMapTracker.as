package hud.maptrackers
{
   import common.Localization;
   
   public class SecurityCameraMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view:minimapBlipCameraView;
      
      public function SecurityCameraMapTracker()
      {
         super();
         this.setupSecurityCameraMapTracker();
      }
      
      private function setupSecurityCameraMapTracker() : void
      {
         this.m_view = new minimapBlipCameraView();
         setMainView(this.m_view);
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_SECURITY_CAMERA");
      }
   }
}
