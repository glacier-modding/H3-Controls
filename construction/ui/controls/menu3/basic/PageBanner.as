package menu3.basic
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.TextFormat;
   import menu3.MenuElementBase;
   
   public dynamic class PageBanner extends MenuElementBase
   {
       
      
      private var m_view:PageBannerView;
      
      private var m_originalTitlePosY:Number;
      
      private var m_originalTitleFormat:TextFormat;
      
      public function PageBanner(param1:Object)
      {
         super(param1);
         this.m_view = new PageBannerView();
         addChild(this.m_view);
         this.m_originalTitlePosY = this.m_view.title.y;
         this.m_originalTitleFormat = this.m_view.title.getTextFormat();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.m_view.title.setTextFormat(this.m_originalTitleFormat);
         MenuUtils.setupText(this.m_view.title,param1.title,48,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraLight);
         var _loc2_:Number = this.m_view.title.textHeight;
         MenuUtils.shrinkTextToFit(this.m_view.title,MenuConstants.MenuWidth,_loc2_);
         var _loc3_:Number = _loc2_ - this.m_view.title.textHeight;
         this.m_view.title.y = this.m_originalTitlePosY + _loc3_ / 2;
      }
   }
}
