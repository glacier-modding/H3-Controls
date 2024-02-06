package menu3.indicator
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   
   public class FreeDlcIndicator extends IndicatorBase
   {
       
      
      public function FreeDlcIndicator(param1:String)
      {
         super();
         switch(param1)
         {
            case "large":
               m_indicatorView = new NewIndicatorLargeView();
               break;
            default:
               m_indicatorView = new NewIndicatorSmallView();
         }
         MenuUtils.setColor(m_indicatorView.bg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         MenuUtils.setColor(m_indicatorView.extraInfoBg,MenuConstants.COLOR_MENU_TABS_BACKGROUND,true,MenuConstants.MenuElementBackgroundAlpha);
         m_indicatorView.y = MenuConstants.NewIndicatorYOffset;
      }
      
      override public function onSetData(param1:*, param2:Object) : void
      {
         var _loc6_:String = null;
         if(param2.freedlc_header == null || param2.freedlc_header.length == 0)
         {
            return;
         }
         super.onSetData(param1,param2);
         var _loc3_:String = String(param2.freedlc_header);
         MenuUtils.setupText(m_indicatorView.titlelarge,_loc3_,38,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.truncateTextfield(m_indicatorView.titlelarge,1,MenuConstants.ColorString(MenuConstants.COLOR_WHITE));
         m_textTickerUtil.addTextTicker(m_indicatorView.titlelarge,_loc3_,MenuConstants.ColorString(MenuConstants.COLOR_WHITE));
         var _loc4_:String;
         var _loc5_:String = _loc4_ = "livetilenews";
         if(param2.freedlc_icon != undefined)
         {
            _loc5_ = String(param2.freedlc_icon);
         }
         MenuUtils.setupIcon(m_indicatorView.icon,_loc5_,MenuConstants.COLOR_WHITE,true,false);
         m_indicatorView.bigIcon.visible = false;
         if(param2.freedlc_extrainfo != null && param2.freedlc_extrainfo.length > 0)
         {
            _loc6_ = String(param2.freedlc_extrainfo);
            m_indicatorView.extraInfo.visible = true;
            m_indicatorView.extraInfoBg.visible = true;
            MenuUtils.setupText(m_indicatorView.extraInfo,_loc6_,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
            MenuUtils.truncateTextfield(m_indicatorView.extraInfo,1);
            m_textTickerUtil.addTextTicker(m_indicatorView.extraInfo,_loc6_);
         }
         else
         {
            m_indicatorView.extraInfo.visible = false;
            m_indicatorView.extraInfoBg.visible = false;
         }
      }
   }
}
