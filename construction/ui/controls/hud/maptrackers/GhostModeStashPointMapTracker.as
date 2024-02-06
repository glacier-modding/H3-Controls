package hud.maptrackers
{
   import common.Localization;
   
   public class GhostModeStashPointMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view_outfit_crate:minimapBlipStashpointOutfitView;
      
      private var m_view_melee_crate:minimapBlipStashpointMeleeView;
      
      private var m_view_firearm_crate:minimapBlipStashpointFirearmView;
      
      private var m_view_ghost_crate:minimapBlipStashpointGhostView;
      
      private var m_view_special_crate:minimapBlipStashpointSpecialView;
      
      public function GhostModeStashPointMapTracker()
      {
         super();
         this.setupStashPointMapTrackers();
      }
      
      private function setupStashPointMapTrackers() : void
      {
         this.m_view_firearm_crate = new minimapBlipStashpointFirearmView();
         this.m_view_melee_crate = new minimapBlipStashpointMeleeView();
         this.m_view_outfit_crate = new minimapBlipStashpointOutfitView();
         this.m_view_special_crate = new minimapBlipStashpointSpecialView();
         this.m_view_ghost_crate = new minimapBlipStashpointGhostView();
         var _loc1_:minimapBlipStashpointGhostGenericView = new minimapBlipStashpointGhostGenericView();
         setMainView(_loc1_);
      }
      
      override public function onSetData(param1:Object) : void
      {
         switch(param1.iconType)
         {
            case 0:
               setMainView(this.m_view_outfit_crate);
               break;
            case 1:
               setMainView(this.m_view_melee_crate);
               break;
            case 2:
               setMainView(this.m_view_firearm_crate);
               break;
            case 3:
               setMainView(this.m_view_ghost_crate);
               break;
            case 4:
               setMainView(this.m_view_special_crate);
         }
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_LEGEND_LABEL_CRATE");
      }
   }
}
