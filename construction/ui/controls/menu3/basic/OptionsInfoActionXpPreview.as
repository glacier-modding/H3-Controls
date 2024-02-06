package menu3.basic
{
   import common.Localization;
   import flash.utils.*;
   import hud.notification.ActionXpBar;
   
   public dynamic class OptionsInfoActionXpPreview extends OptionsInfoPreview
   {
       
      
      private const m_lstrDoorUnlocked:String = Localization.get("UI_CHALLENGES_GLOBAL_DOOR_UNLOCKED_NAME");
      
      private var m_actionXpBar:ActionXpBar;
      
      private var m_idIntervalRefresh:uint = 0;
      
      public function OptionsInfoActionXpPreview(param1:Object)
      {
         var _loc2_:Number = NaN;
         this.m_actionXpBar = new ActionXpBar();
         super(param1);
         this.m_actionXpBar.name = "m_actionXpBar";
         getPreviewContentContainer().addChild(this.m_actionXpBar);
         _loc2_ = PX_PREVIEW_BACKGROUND_WIDTH;
         var _loc3_:Number = _loc2_ / 1920 * 1080;
         this.m_actionXpBar.x = _loc2_ / 2;
         this.m_actionXpBar.y = _loc3_ / 2;
         this.onSetData(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         if(!param1.previewData || !param1.previewData.showXpNotification)
         {
            this.m_actionXpBar.visible = false;
            clearInterval(this.m_idIntervalRefresh);
            this.m_idIntervalRefresh = 0;
         }
         else if(this.m_idIntervalRefresh == 0)
         {
            this.m_actionXpBar.visible = true;
            this.m_idIntervalRefresh = setInterval(this.showNotification,3000);
            this.showNotification();
         }
      }
      
      private function showNotification() : void
      {
         this.m_actionXpBar.ShowNotification("",this.m_lstrDoorUnlocked,{"xpGain":25});
      }
      
      override protected function onPreviewRemovedFromStage() : void
      {
         clearInterval(this.m_idIntervalRefresh);
         this.m_idIntervalRefresh = 0;
         super.onPreviewRemovedFromStage();
      }
   }
}
