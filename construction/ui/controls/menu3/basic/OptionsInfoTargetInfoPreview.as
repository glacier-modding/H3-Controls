package menu3.basic
{
   import common.Localization;
   import hud.ObjectiveConditions;
   
   public dynamic class OptionsInfoTargetInfoPreview extends OptionsInfoPreview
   {
       
      
      private var m_objConditions:ObjectiveConditions;
      
      private const m_lstrEliminateUsing:String = Localization.get("UI_BRIEFING_CONDITION_ELIMINATE_WITH");
      
      private const m_lstrInjectedPoison:String = Localization.get("UI_KILL_METHOD_INJECTED_POISON");
      
      private const m_lstrWearDisguise:String = Localization.get("UI_BRIEFING_CONDITION_DISGUISE");
      
      private const m_lstrMechanic:String = Localization.get("Outfits_Greenland_Worker_Engineer_M_HPA1958_Name_e222cc14-8d48-42de-9af6-1b745dbb3614");
      
      public function OptionsInfoTargetInfoPreview(param1:Object)
      {
         this.m_objConditions = new ObjectiveConditions();
         super(param1);
         this.m_objConditions.name = "m_objConditions";
         getPreviewContentContainer().addChild(this.m_objConditions);
         this.onSetData(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         if(!param1.previewData.showTargetInfo)
         {
            this.m_objConditions.visible = false;
         }
         else
         {
            this.m_objConditions.visible = true;
            this.m_objConditions.onSetData([{
               "fX":250,
               "fY":111,
               "fAlpha":1,
               "bIsTarget":true,
               "disguiseName":"Terry Norfolk",
               "npcName":"Terry Norfolk",
               "objectiveConditions":[{
                  "icon":"kill",
                  "hardCondition":true,
                  "header":this.m_lstrEliminateUsing,
                  "title":this.m_lstrInjectedPoison
               },{
                  "icon":"disguise",
                  "hardCondition":true,
                  "header":this.m_lstrWearDisguise,
                  "title":this.m_lstrMechanic
               }]
            }]);
         }
      }
   }
}
