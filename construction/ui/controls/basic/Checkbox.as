package basic
{
   import common.BaseControl;
   import common.CommonUtils;
   
   public class Checkbox extends BaseControl
   {
       
      
      private var m_view:CheckboxView;
      
      public function Checkbox()
      {
         super();
         this.m_view = new CheckboxView();
         addChild(this.m_view);
      }
      
      public function onSetData(param1:Boolean) : void
      {
         this.SetValue(param1);
      }
      
      public function SetValue(param1:Boolean) : void
      {
         CommonUtils.gotoFrameLabelAndStop(this.m_view,param1 ? "checked" : "unchecked");
      }
      
      public function SetTrue() : void
      {
         this.SetValue(true);
      }
      
      public function SetFalse() : void
      {
         this.SetValue(false);
      }
   }
}
