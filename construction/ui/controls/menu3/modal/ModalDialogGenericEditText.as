package menu3.modal
{
   import common.Animate;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class ModalDialogGenericEditText extends ModalDialogFrameEdit
   {
       
      
      private const DISABLED_ALPHA:Number = 0.2;
      
      private var m_viewFrame:Sprite;
      
      private var m_viewTitle:TextField;
      
      private var m_viewInputField:TextField;
      
      private var m_viewTileSelect:Sprite;
      
      private var m_view:ModalDialogGenericView;
      
      private var m_content:ModalDialogContentEditTextView;
      
      public function ModalDialogGenericEditText(param1:Object)
      {
         param1.dialogWidth = ModalDialogGeneric.FRAME_WIDTH;
         param1.dialogHeight = ModalDialogGeneric.FRAME_HEIGHT_MIN;
         super(param1);
         this.createView();
      }
      
      protected function createView() : void
      {
         var _loc1_:ModalDialogGenericView = new ModalDialogGenericView();
         this.m_viewTitle = _loc1_.title;
         m_maxTitleWidth = this.m_viewTitle.width;
         this.m_viewFrame = _loc1_.bg;
         MenuUtils.setColor(this.m_viewFrame,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,true,1);
         this.m_view = _loc1_;
         addChild(this.m_view);
         this.m_content = new ModalDialogContentEditTextView();
         this.m_viewInputField = this.m_content.description;
         this.m_viewTileSelect = this.m_content.tileSelect;
         MenuUtils.setColor(this.m_viewTileSelect,MenuConstants.COLOR_MENU_BUTTON_TILE_DESELECTED,true,1);
         addChild(this.m_content);
         this.m_viewTitle.autoSize = "left";
         var _loc2_:Number = _loc1_.description.x;
         var _loc3_:Number = _loc1_.description.y;
         _loc1_.description.visible = false;
         this.m_content.x = _loc2_;
         this.m_content.y = _loc3_;
         setInputTextField(this.m_viewInputField);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.m_viewTileSelect.alpha = this.DISABLED_ALPHA;
         var _loc2_:Number = Math.ceil(this.m_content.height) + ModalDialogGeneric.FRAME_REST_HEIGHT;
         m_dialogHeight = updateDialogHeight(_loc2_,ModalDialogGeneric.FRAME_HEIGHT_MIN,ModalDialogGeneric.FRAME_HEIGHT_MAX);
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
         MenuUtils.setupTextAndShrinkToFit(this.m_viewTitle,param1,48,MenuConstants.FONT_TYPE_BOLD,m_maxTitleWidth,_loc2_,_loc3_,MenuConstants.FontColorWhite);
      }
      
      override protected function setInputFieldText(param1:String) : void
      {
         super.setInputFieldText(param1);
         param1 = MenuUtils.convertToEscapedHtmlString(param1);
         MenuUtils.setupText(this.m_viewInputField,param1,21,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         CommonUtils.changeFontToGlobalIfNeeded(this.m_viewInputField);
      }
   }
}
