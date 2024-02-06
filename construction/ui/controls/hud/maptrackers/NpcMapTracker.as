package hud.maptrackers
{
   import common.Localization;
   import common.TaskletSequencer;
   
   public class NpcMapTracker extends LevelCheckedMapTracker
   {
       
      
      private var m_view_npc_ambient:minimapBlipNpcAmbientView;
      
      private var m_view_npc_distracted:minimapBlipNpcDistractedView;
      
      private var m_view_npc_unconscious:minimapBlipNpcUnconsciousView;
      
      private var m_view_npc_general_threat:minimapBlipNpcGeneralThreatView;
      
      private var m_view_npc_target:minimapBlipTargetView;
      
      private var m_view_npc_targetName:minimapBlipTextView;
      
      private var m_view_npc_infected:minimapBlipNpcInfectedView;
      
      public function NpcMapTracker()
      {
         super();
         this.setupNpcMapTracker();
      }
      
      private function setupNpcMapTracker() : void
      {
         this.m_view_npc_ambient = new minimapBlipNpcAmbientView();
         this.m_view_npc_distracted = new minimapBlipNpcDistractedView();
         this.m_view_npc_unconscious = new minimapBlipNpcUnconsciousView();
         this.m_view_npc_general_threat = new minimapBlipNpcGeneralThreatView();
         this.m_view_npc_target = new minimapBlipTargetView();
         this.m_view_npc_targetName = new minimapBlipTextView();
         this.m_view_npc_infected = new minimapBlipNpcInfectedView();
      }
      
      override public function onSetData(param1:Object) : void
      {
         var data:Object = param1;
         var funcSetData:Function = function():void
         {
            if(data.isTarget)
            {
               setMainView(m_view_npc_target);
               applyLevelCheckResult(m_mainView,data.levelCheckResult);
            }
            else if(data.isInfected)
            {
               setMainView(m_view_npc_infected);
               applyLevelCheckResult(m_mainView,data.levelCheckResult);
            }
            else
            {
               switch(data.threatLevel)
               {
                  case 0:
                     setMainView(m_view_npc_ambient);
                     break;
                  case 3:
                     setMainView(m_view_npc_distracted);
                     break;
                  case 7:
                     setMainView(m_view_npc_unconscious);
                     break;
                  default:
                     setMainView(m_view_npc_general_threat);
               }
               applyLevelCheckResult(m_mainView,0);
            }
         };
         if(ControlsMain.isVrModeActive())
         {
            TaskletSequencer.getGlobalInstance().addChunk(funcSetData);
         }
         else
         {
            funcSetData();
         }
      }
      
      override public function getTextForLegend() : String
      {
         return Localization.get("UI_MAP_TARGET");
      }
   }
}
