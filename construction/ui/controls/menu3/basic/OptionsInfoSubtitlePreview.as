package menu3.basic
{
   import basic.Subtitle;
   import scaleform.gfx.DisplayObjectEx;
   
   public dynamic class OptionsInfoSubtitlePreview extends OptionsInfoPreview
   {
       
      
      private var m_subtitle:Subtitle;
      
      public function OptionsInfoSubtitlePreview(param1:Object)
      {
         this.m_subtitle = new Subtitle();
         super(param1);
         this.m_subtitle.name = "m_subtitle";
         getPreviewContentContainer().addChild(this.m_subtitle);
         this.m_subtitle.isAntiFreakoutDisabled = true;
         this.onSetData(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         super.onSetData(param1);
         DisplayObjectEx.skipNextMatrixLerp(this.m_subtitle);
         this.m_subtitle.onSetData({
            "text":param1.subtitleText,
            "fontsize":param1.subtitleFontSize,
            "pctBGAlpha":param1.subtitleBGAlpha
         });
         _loc2_ = PX_PREVIEW_BACKGROUND_WIDTH;
         var _loc3_:Number = _loc2_ / 1920 * 1080;
         this.m_subtitle.onSetSize(_loc2_ - 60,30);
         this.m_subtitle.x = 30;
         this.m_subtitle.y = _loc3_ - 80;
      }
   }
}
