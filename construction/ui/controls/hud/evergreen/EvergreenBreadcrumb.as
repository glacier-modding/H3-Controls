package hud.evergreen
{
   import common.BaseControl;
   
   public class EvergreenBreadcrumb extends BaseControl
   {
       
      
      private var m_view:EvergreenBreadcrumbView;
      
      public function EvergreenBreadcrumb()
      {
         this.m_view = new EvergreenBreadcrumbView();
         super();
         this.m_view.name = "m_view";
         addChild(this.m_view);
      }
      
      [PROPERTY(HELPTEXT="Possible values: mule, safe, stash, supplier, meeting_secret, meeting_business, meeting_handover",CATEGORY="Evergreen Breadcrumb")]
      public function set Icon(param1:String) : void
      {
         switch(param1)
         {
            case "mule":
            case "safe":
            case "stash":
            case "supplier":
            case "meeting_secret":
            case "meeting_business":
            case "meeting_handover":
               this.m_view.gotoAndStop(param1);
               break;
            default:
               this.m_view.gotoAndStop("none");
         }
      }
   }
}
