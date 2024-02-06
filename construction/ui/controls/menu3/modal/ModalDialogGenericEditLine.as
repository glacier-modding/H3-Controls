package menu3.modal
{
   import common.Animate;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class ModalDialogGenericEditLine extends ModalDialogFrameEdit
   {
       
      
      private const DISABLED_ALPHA:Number = 0.2;
      
      private var m_viewFrame:Sprite;
      
      private var m_viewTitle:TextField;
      
      private var m_viewDescription:TextField;
      
      private var m_viewSubTitle:TextField;
      
      private var m_viewInputField:TextField;
      
      private var m_viewErrorMsg:TextField;
      
      private var m_viewTileSelect:Sprite;
      
      private var m_view:ModalDialogGenericView;
      
      private var m_content:ModalDialogContentEditLineView;
      
      private var m_useSubTitle:Boolean = false;
      
      public function ModalDialogGenericEditLine(param1:Object)
      {
         if(!param1.hasOwnProperty("dialogWidth"))
         {
            param1.dialogWidth = ModalDialogGeneric.FRAME_WIDTH;
         }
         param1.dialogHeight = ModalDialogGeneric.FRAME_HEIGHT_MIN;
         super(param1);
         this.createView();
      }
      
      protected function createView() : void
      {
         var _loc1_:ModalDialogGenericView = new ModalDialogGenericView();
         this.m_viewTitle = _loc1_.title;
         m_maxTitleWidth = this.m_viewTitle.width;
         this.m_viewDescription = _loc1_.description;
         this.m_viewFrame = _loc1_.bg;
         MenuUtils.setColor(this.m_viewFrame,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,true,1);
         this.m_view = _loc1_;
         addChild(this.m_view);
         this.m_content = new ModalDialogContentEditLineView();
         this.m_viewInputField = this.m_content.description;
         this.m_viewErrorMsg = this.m_content.errormsg;
         this.m_viewTileSelect = this.m_content.tileSelect;
         this.m_viewSubTitle = this.m_content.title;
         MenuUtils.setColor(this.m_viewTileSelect,MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED,true,1);
         this.m_viewTitle.autoSize = "left";
         this.m_viewErrorMsg.autoSize = "left";
         this.m_viewSubTitle.autoSize = "left";
         this.m_viewDescription.autoSize = "left";
         this.m_viewDescription.text = "";
         setInputTextField(this.m_viewInputField);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc11_:Number = NaN;
         this.m_useSubTitle = param1.subtitle != null;
         if(param1.hint)
         {
            MenuUtils.setupText(this.m_viewDescription,param1.hint,21,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         }
         var _loc2_:Number = param1.hasOwnProperty("frameheightmax") ? Number(param1.frameheightmax) : ModalDialogGeneric.FRAME_HEIGHT_MAX;
         var _loc3_:Number = param1.hasOwnProperty("frameheightmin") ? Number(param1.frameheightmin) : ModalDialogGeneric.FRAME_HEIGHT_MIN;
         m_dialogWidth = param1.hasOwnProperty("dialogWidth") ? Number(param1.dialogWidth) : ModalDialogGeneric.FRAME_WIDTH;
         this.m_viewFrame.width = m_dialogWidth;
         var _loc4_:Number = this.m_viewDescription.x;
         var _loc5_:Number = this.m_viewDescription.y;
         var _loc6_:Number = _loc4_;
         var _loc7_:Number = ModalDialogGeneric.FRAME_REST_HEIGHT;
         setupTitle(this.m_viewTitle,param1);
         if(this.m_viewTitle.text.length == 0)
         {
            _loc7_ -= _loc5_ - this.m_viewTitle.y;
            _loc5_ = this.m_viewTitle.y;
         }
         createAndAddScrollContainer(_loc4_,_loc5_,m_dialogWidth - _loc4_,_loc2_ - _loc7_,_loc6_);
         param1.multiline = false;
         super.onSetData(param1);
         this.m_viewTileSelect.alpha = this.DISABLED_ALPHA;
         if(this.m_viewDescription.text.length > 0)
         {
            this.m_viewDescription.x = 0;
            this.m_viewDescription.y = 0;
            m_scrollingContainer.append(this.m_viewDescription,false,this.m_viewDescription.height,false);
         }
         setupInformation(param1);
         if(m_scrollingContainer.getContentHeight() > 0)
         {
            _loc11_ = m_scrollingContainer.getScrollDist();
            m_scrollingContainer.addGap(_loc11_);
         }
         var _loc8_:Boolean = false;
         if(this.m_viewErrorMsg.text.length == 0)
         {
            this.m_viewErrorMsg.text = "ForSizeCheck";
            _loc8_ = true;
         }
         var _loc9_:Number = param1.compacterrorline === true ? 30 : 0;
         m_scrollingContainer.append(this.m_content,false,this.m_content.height - _loc9_,false);
         if(_loc8_)
         {
            this.m_viewErrorMsg.text = "";
         }
         var _loc10_:Number = Math.ceil(m_scrollingContainer.getContentHeight()) + _loc7_;
         m_dialogHeight = updateDialogHeight(_loc10_,_loc3_,_loc2_);
         this.m_viewFrame.height = m_dialogHeight;
      }
      
      override protected function setItemSelected(param1:Boolean) : void
      {
         super.setItemSelected(param1);
         Animate.kill(this.m_viewTileSelect);
         if(param1)
         {
            Animate.legacyTo(this.m_viewTileSelect,MenuConstants.HiliteTime,{"alpha":1},Animate.Linear);
         }
         else
         {
            this.m_viewTileSelect.alpha = this.DISABLED_ALPHA;
         }
      }
      
      override protected function setTitle(param1:String) : void
      {
         super.setTitle(param1);
         var _loc2_:Number = -1;
         var _loc3_:Number = 20;
         var _loc4_:Number = 12;
         if(this.m_useSubTitle)
         {
            MenuUtils.setupTextAndShrinkToFit(this.m_viewSubTitle,param1,20,MenuConstants.FONT_TYPE_BOLD,m_maxTitleWidth,_loc2_,_loc4_,MenuConstants.FontColorWhite);
         }
         else
         {
            MenuUtils.setupTextAndShrinkToFit(this.m_viewTitle,param1,48,MenuConstants.FONT_TYPE_BOLD,m_maxTitleWidth,_loc2_,_loc3_,MenuConstants.FontColorWhite);
         }
      }
      
      override protected function setInputFieldText(param1:String) : void
      {
         super.setInputFieldText(param1);
         param1 = MenuUtils.convertToEscapedHtmlString(param1);
         MenuUtils.setupText(this.m_viewInputField,param1,21,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         CommonUtils.changeFontToGlobalIfNeeded(this.m_viewInputField);
      }
      
      override protected function setErrorMessage(param1:ModalDialogValidation) : void
      {
         super.setErrorMessage(param1);
         if(param1 == null)
         {
            this.m_viewErrorMsg.text = "";
            return;
         }
         var _loc2_:String = param1.getMessage();
         if(_loc2_ == null || _loc2_.length <= 0)
         {
            this.m_viewErrorMsg.text = "";
            return;
         }
         switch(param1.getLevel())
         {
            case 1:
               MenuUtils.setupText(this.m_viewErrorMsg,_loc2_,21,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorRed);
               break;
            default:
               MenuUtils.setupText(this.m_viewErrorMsg,_loc2_,21,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         }
      }
   }
}
