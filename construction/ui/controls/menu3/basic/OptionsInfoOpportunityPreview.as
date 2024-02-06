package menu3.basic
{
   import common.Animate;
   import common.CommonUtils;
   import hud.Breadcrumb;
   import hud.OpportunityPreview;
   
   public dynamic class OptionsInfoOpportunityPreview extends OptionsInfoPreview
   {
      
      private static const UIOPTION_OPPORTUNITIES_OFF:Number = 0;
      
      private static const UIOPTION_OPPORTUNITIES_MINIMAL:Number = 1;
      
      private static const UIOPTION_OPPORTUNITIES_FULL:Number = 2;
       
      
      private var m_oppPreview:OpportunityPreview;
      
      private var m_breadcrumb:Breadcrumb;
      
      public function OptionsInfoOpportunityPreview(param1:Object)
      {
         var _loc2_:Number = NaN;
         this.m_oppPreview = new OpportunityPreview();
         this.m_breadcrumb = new Breadcrumb();
         super(param1);
         this.m_oppPreview.name = "m_oppPreview";
         getPreviewContentContainer().addChild(this.m_oppPreview);
         this.m_breadcrumb.name = "m_breadcrumb";
         getPreviewContentContainer().addChild(this.m_breadcrumb);
         _loc2_ = PX_PREVIEW_BACKGROUND_WIDTH;
         var _loc3_:Number = _loc2_ / 1920 * 1080;
         this.m_oppPreview.x = _loc2_ / 2;
         this.m_oppPreview.y = 12;
         this.m_breadcrumb.x = _loc2_ * 436 / 620;
         this.m_breadcrumb.y = _loc3_ * 137 / 352;
         this.m_breadcrumb.noResolutionScale = true;
         this.onSetData(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         var _loc2_:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_OPPORTUNITIES");
         if(_loc2_ != UIOPTION_OPPORTUNITIES_FULL)
         {
            this.m_breadcrumb.visible = false;
         }
         else
         {
            this.m_breadcrumb.ChangeIconType("opdiscovered");
            this.m_breadcrumb.showAttentionOutline();
            this.m_breadcrumb.onSetData({
               "id":"distance",
               "distance":12
            });
            this.m_breadcrumb.visible = true;
            this.m_breadcrumb.scaleX = 0;
            this.m_breadcrumb.scaleY = 0;
            Animate.to(this.m_breadcrumb,0.125,0.5,{
               "scaleX":1,
               "scaleY":1
            },Animate.SineOut);
         }
         if(_loc2_ == UIOPTION_OPPORTUNITIES_OFF)
         {
            this.m_oppPreview.onSetData({"state":OpportunityPreview.STATE_DEFAULT});
         }
         else
         {
            this.m_oppPreview.onSetData({"state":OpportunityPreview.STATE_FAR});
         }
      }
      
      override protected function onPreviewRemovedFromStage() : void
      {
         this.m_breadcrumb.hideAttentionOutline();
         super.onPreviewRemovedFromStage();
      }
   }
}
