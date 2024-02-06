package menu3.basic
{
   import common.Localization;
   import common.menu.MenuConstants;
   import flash.display.Shape;
   import menu3.splashhints.SplashHintBackground;
   import menu3.splashhints.SplashHintContent;
   
   public dynamic class OptionsInfoSplashHintPreview extends OptionsInfoPreview
   {
       
      
      private var m_mask:Shape;
      
      private var m_overlay:Shape;
      
      private var m_shBackground:SplashHintBackground;
      
      private var m_shContent:SplashHintContent;
      
      private const m_lstrHeader:String = Localization.get("UI_AID_GLOBAL_HINTS_EXAMPLE_HEADER");
      
      private const m_lstrTitle:String = Localization.get("UI_AID_GLOBAL_HINTS_EXAMPLE_TITLE");
      
      private const m_lstrDescription:String = Localization.get("UI_AID_GLOBAL_HINTS_EXAMPLE_BODY");
      
      public function OptionsInfoSplashHintPreview(param1:Object)
      {
         this.m_mask = new Shape();
         this.m_overlay = new Shape();
         this.m_shBackground = new SplashHintBackground();
         this.m_shContent = new SplashHintContent();
         super(param1);
         this.m_mask.name = "m_mask";
         getPreviewContentContainer().addChild(this.m_mask);
         getPreviewContentContainer().mask = this.m_mask;
         this.m_overlay.name = "m_overlay";
         getPreviewContentContainer().addChild(this.m_overlay);
         this.m_shBackground.name = "m_shBackground";
         getPreviewContentContainer().addChild(this.m_shBackground);
         this.m_shContent.name = "m_shContent";
         getPreviewContentContainer().addChild(this.m_shContent);
         this.m_shBackground.AnimationDelayIn = 0;
         this.m_shContent.AnimationDelayIn = 0;
         this.m_shBackground.AnimationDelayOut = 0;
         this.m_shContent.AnimationDelayOut = 0;
         this.onSetData(param1);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         if(!param1.previewData.showGlobalHints)
         {
            this.m_overlay.visible = false;
            this.m_shBackground.hide();
            this.m_shContent.hide();
         }
         else
         {
            this.m_overlay.visible = true;
            this.m_shBackground.show();
            this.m_shContent.onSetData({
               "header":this.m_lstrHeader,
               "title":this.m_lstrTitle,
               "description":this.m_lstrDescription,
               "imageRID":"",
               "hinttype":MenuConstants.SPLASH_HINT_TYPE_GLOBAL,
               "iconID":"disguise"
            });
            this.m_shContent.show();
         }
      }
      
      override protected function onPreviewBackgroundImageLoaded() : void
      {
         super.onPreviewBackgroundImageLoaded();
         var _loc1_:Number = getPreviewBackgroundImage().width;
         var _loc2_:Number = getPreviewBackgroundImage().height;
         this.m_mask.graphics.clear();
         this.m_mask.graphics.beginFill(0);
         this.m_mask.graphics.drawRect(0,0,_loc1_,_loc2_);
         this.m_overlay.graphics.clear();
         this.m_overlay.graphics.beginFill(991039,0.3);
         this.m_overlay.graphics.drawRect(-5,-5,_loc1_ + 10,_loc2_ + 10);
         this.m_shBackground.onSetSize(_loc1_,_loc2_);
         this.m_shContent.onSetSize(_loc1_,_loc2_);
      }
   }
}
