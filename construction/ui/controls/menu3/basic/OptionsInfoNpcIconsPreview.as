package menu3.basic
{
   public dynamic class OptionsInfoNpcIconsPreview extends OptionsInfoPreview
   {
       
      
      private var m_indicator1:AIIndicatorView;
      
      private var m_indicator2:AIIndicatorView;
      
      private var m_indicator3:AIIndicatorView;
      
      private var m_indicator4:AIIndicatorView;
      
      public function OptionsInfoNpcIconsPreview(param1:Object)
      {
         this.m_indicator1 = new AIIndicatorView();
         this.m_indicator2 = new AIIndicatorView();
         this.m_indicator3 = new AIIndicatorView();
         this.m_indicator4 = new AIIndicatorView();
         super(param1);
         this.m_indicator1.name = "m_indicator1";
         this.m_indicator2.name = "m_indicator2";
         this.m_indicator3.name = "m_indicator3";
         this.m_indicator4.name = "m_indicator4";
         getPreviewContentContainer().addChild(this.m_indicator1);
         getPreviewContentContainer().addChild(this.m_indicator2);
         getPreviewContentContainer().addChild(this.m_indicator3);
         getPreviewContentContainer().addChild(this.m_indicator4);
         this.onSetData(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc2_:AIIndicatorView = null;
         super.onSetData(param1);
         if(!param1.previewData.showNpcIcons)
         {
            this.m_indicator1.visible = false;
            this.m_indicator2.visible = false;
            this.m_indicator3.visible = false;
            this.m_indicator4.visible = false;
         }
         else
         {
            for each(_loc2_ in [this.m_indicator1,this.m_indicator2,this.m_indicator3,this.m_indicator4])
            {
               _loc2_.visible = true;
               _loc2_.gotoAndStop("attentive");
               _loc2_.witnessIcon.visible = false;
            }
            this.m_indicator1.x = 395;
            this.m_indicator1.y = 204;
            this.m_indicator2.x = 119;
            this.m_indicator2.y = 202;
            this.m_indicator3.x = 50;
            this.m_indicator3.y = 209;
            this.m_indicator4.x = 400;
            this.m_indicator4.y = 14;
            this.m_indicator1.anim_mc.alpha = 0.75;
         }
      }
   }
}
