package menu3.basic
{
   import common.CommonUtils;
   import hud.AttentionIndicator;
   
   public dynamic class OptionsInfoAttentionGainPreview extends OptionsInfoPreview
   {
       
      
      private var m_indicator:AIIndicatorView;
      
      private var m_attention:AttentionIndicator;
      
      public function OptionsInfoAttentionGainPreview(param1:Object)
      {
         this.m_indicator = new AIIndicatorView();
         this.m_attention = new AttentionIndicator();
         super(param1);
         this.m_indicator.name = "m_indicator";
         getPreviewContentContainer().addChild(this.m_indicator);
         getPreviewContentContainer().addChild(this.m_attention);
         this.m_indicator.x = 502;
         this.m_indicator.y = 32;
         this.m_indicator.scaleX = 0.75;
         this.m_indicator.scaleY = 0.75;
         this.m_indicator.gotoAndStop("attentive");
         this.m_indicator.witnessIcon.visible = false;
         this.m_indicator.anim_mc.alpha = 0.5;
         this.m_attention.x = 173;
         this.m_attention.y = 254;
         this.m_attention.scaleX = 0.62;
         this.m_attention.scaleY = 0.25;
         this.m_attention.ensureWedgesCount(1);
         var _loc2_:AttentionWedge = this.m_attention.getWedges()[0];
         _loc2_.visible = true;
         _loc2_.rotation = 66;
         _loc2_.wedgeMc.spike.gotoAndStop(50);
         _loc2_.wedgeMc.spike2.gotoAndStop(50);
         this.onSetData(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         var _loc2_:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_NPC_ICONS");
         var _loc3_:Number = CommonUtils.getUIOptionValueNumber("UI_OPTION_GAME_AID_ATTENTION");
         this.m_indicator.visible = !!_loc2_ ? true : false;
         this.m_attention.visible = !!_loc3_ ? true : false;
      }
      
      override public function onUnregister() : void
      {
         getPreviewContentContainer().removeChild(this.m_attention);
         getPreviewContentContainer().removeChild(this.m_indicator);
         this.m_attention = null;
         this.m_indicator = null;
         super.onUnregister();
      }
   }
}
