package menu3.map
{
   import common.BaseControl;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.TextFieldAutoSize;
   
   public dynamic class MapReticleLegend extends BaseControl
   {
       
      
      private var m_view:MapReticleLegendView;
      
      public function MapReticleLegend()
      {
         super();
         this.m_view = new MapReticleLegendView();
         this.m_view.visible = false;
         addChild(this.m_view);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.setupTextFields(param1.header,param1.title);
      }
      
      private function setupTextFields(param1:String, param2:String) : void
      {
         if(param1 != null && param2 != null)
         {
            this.setHeadAndTitlesTexts(param1,param2,"");
            this.setBg(Math.max(this.m_view.header.width,this.m_view.title.width) + MenuConstants.tileImageBorder * 3,50);
         }
         else if(param1 != null)
         {
            this.setHeadAndTitlesTexts("","",param1);
            this.setBg(this.m_view.singletitle.width + MenuConstants.tileImageBorder * 3,30);
         }
         else if(param2 != null)
         {
            this.setHeadAndTitlesTexts("","",param2);
            this.setBg(this.m_view.singletitle.width + MenuConstants.tileImageBorder * 3,30);
         }
         this.m_view.visible = !(param1 == null && param2 == null);
      }
      
      private function setHeadAndTitlesTexts(param1:String, param2:String, param3:String) : void
      {
         MenuUtils.setupTextUpper(this.m_view.header,param1,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorGrey);
         MenuUtils.setupTextUpper(this.m_view.title,param2,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.setupTextUpper(this.m_view.singletitle,param3,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header);
         CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title);
         CommonUtils.changeFontToGlobalIfNeeded(this.m_view.singletitle);
         this.m_view.header.autoSize = TextFieldAutoSize.LEFT;
         this.m_view.title.autoSize = TextFieldAutoSize.LEFT;
         this.m_view.singletitle.autoSize = TextFieldAutoSize.LEFT;
      }
      
      private function setBg(param1:Number, param2:Number) : void
      {
         MenuUtils.setColor(this.m_view.tileBg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         this.m_view.tileBg.width = param1;
         this.m_view.tileBg.height = param2;
         this.m_view.tileBg.x = this.m_view.tileBg.width >> 1;
      }
   }
}
