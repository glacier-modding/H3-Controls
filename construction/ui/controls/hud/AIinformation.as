package hud
{
   import common.BaseControl;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.TextFormat;
   
   public class AIinformation extends BaseControl
   {
       
      
      private var m_view:AIInformationBarView;
      
      private var m_labelTxtTextFormat:TextFormat;
      
      public function AIinformation()
      {
         super();
         this.m_view = new AIInformationBarView();
         addChild(this.m_view);
         this.m_view.visible = false;
         this.m_labelTxtTextFormat = new TextFormat();
         this.m_labelTxtTextFormat.leading = -3.5;
         this.m_view.labelTxt.autoSize = "left";
         this.m_view.labelTxt.multiline = true;
         this.m_view.labelTxt.wordWrap = true;
         this.m_view.labelTxt.width = 186;
         this.m_view.labelTxt.text = "";
         this.m_view.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
         this.m_view.blinkMc.stop();
         this.m_view.blinkMc.height = 23;
         this.m_view.y = 0;
      }
      
      public function onSetData(param1:Object) : void
      {
         this.showAIinformation(param1.info);
      }
      
      public function showAIinformation(param1:String) : void
      {
         this.m_view.visible = false;
         MenuUtils.setupTextUpper(this.m_view.labelTxt,param1,18,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorGreyUltraDark);
         this.m_view.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
         this.m_view.blinkMc.height = 23 + (this.m_view.labelTxt.numLines - 1) * 19;
         this.m_view.y = (this.m_view.labelTxt.numLines - 1) * -19;
         this.m_view.blinkMc.gotoAndPlay(1);
         this.m_view.visible = true;
      }
      
      public function showTestString() : void
      {
         var _loc1_:String = MenuUtils.getRandomInRange(0,1,true) == 1 ? "One Line AIinformation" : "This is a test string displaying multiline AIinformation";
         this.showAIinformation(_loc1_);
      }
      
      override public function onSetVisible(param1:Boolean) : void
      {
         super.onSetVisible(param1);
         this.visible = param1;
      }
   }
}
