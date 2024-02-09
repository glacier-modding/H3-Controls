package menu3.modal
{
   import common.CommonUtils;
   import common.InputTextFieldSpecialCharacterHandler;
   import common.Log;
   import common.menu.MenuConstants;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   
   public class ModalDialogFrameEdit extends ModalDialogFrameInformation implements ISubmitValidator
   {
       
      
      protected var m_isValid:Boolean = true;
      
      private var m_originalTitle:String;
      
      private var m_defaultString:String;
      
      private var m_defaultStringUnformatted:String;
      
      private var m_errorMessage:String;
      
      private var m_validator:ModalDialogValidator;
      
      private var m_bUseHTMLText:Boolean;
      
      private var m_inputField:TextField;
      
      private var m_specialCharacterHandler:InputTextFieldSpecialCharacterHandler;
      
      public function ModalDialogFrameEdit(param1:Object)
      {
         super(param1);
         m_dialogInformation.CanSelectContent = true;
         m_dialogInformation.ContentIsTextEdit = true;
      }
      
      public function isSubmitValid() : Boolean
      {
         return this.m_isValid;
      }
      
      protected function setInputTextField(param1:TextField) : void
      {
         this.m_inputField = param1;
         this.m_specialCharacterHandler = new InputTextFieldSpecialCharacterHandler(this.m_inputField);
         this.m_specialCharacterHandler.setActive(true);
         this.m_inputField.addEventListener(KeyboardEvent.KEY_DOWN,this.checkTextInputDone);
         this.m_inputField.addEventListener(MouseEvent.MOUSE_OVER,this.contentMouseEvent);
         this.m_inputField.addEventListener(MouseEvent.MOUSE_DOWN,this.contentMouseEvent);
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         m_selectableElements.push(this);
         m_submitValidators.push(this);
         this.m_bUseHTMLText = param1.usehtmltext;
         this.m_inputField.maxChars = param1.maxChars > 0 ? int(param1.maxChars) : 4000;
         this.m_inputField.restrict = param1.restrict != null ? String(param1.restrict) : null;
         this.m_inputField.multiline = param1.multiline != null ? Boolean(param1.multiline) : true;
         if(param1.subtitle)
         {
            this.m_originalTitle = param1.subtitle;
         }
         else if(param1.title)
         {
            this.m_originalTitle = param1.title;
         }
         if(param1.description)
         {
            this.setDescription(param1.description);
         }
         else if(param1.placeholder)
         {
            this.setDescription(param1.placeholder);
            this.m_defaultString = this.getDescriptionText();
            this.m_defaultStringUnformatted = param1.placeholder;
         }
         else
         {
            this.setDescription("");
         }
         this.m_validator = new ModalDialogValidator(param1.validation);
         this.setErrorMessage(null);
         this.onTextInputChange();
         this.m_inputField.addEventListener(Event.CHANGE,this.textInputChange);
      }
      
      protected function getOriginalTitle() : String
      {
         return this.m_originalTitle;
      }
      
      override public function hide() : void
      {
         var _loc1_:String = "";
         if(this.m_errorMessage == null || this.m_errorMessage.length == 0)
         {
            _loc1_ = this.getDescriptionText() == this.m_defaultString ? this.m_defaultStringUnformatted : this.m_inputField.text;
         }
         ExternalInterface.call("ModalDialogHide",_loc1_);
      }
      
      public function setDescription(param1:String) : void
      {
         this.setInputFieldText(param1);
         CommonUtils.changeFontToGlobalIfNeeded(this.m_inputField);
         this.onTextInputChange();
      }
      
      protected function updateInputField(param1:String) : void
      {
         var _loc2_:int = this.m_inputField.length;
         this.m_inputField.text = param1;
         if(this.m_inputField.caretIndex >= _loc2_)
         {
            this.m_inputField.setSelection(param1.length,param1.length);
         }
      }
      
      override protected function setItemSelected(param1:Boolean) : void
      {
         super.setItemSelected(param1);
         if(param1)
         {
            this.setDescriptionStageFocusDelayed();
            if(this.getDescriptionText() == this.m_defaultString)
            {
               this.m_inputField.setSelection(0,this.m_inputField.text.length);
            }
            else
            {
               this.m_inputField.setSelection(this.m_inputField.text.length,this.m_inputField.text.length);
            }
            ExternalInterface.call("ModalDialogTextFieldSelected",true,this.getDescriptionText(),this.m_defaultStringUnformatted);
         }
         else
         {
            this.removeDescriptionStageFocus();
            ExternalInterface.call("ModalDialogTextFieldSelected",false);
         }
      }
      
      public function onTextFieldEdited(param1:String) : void
      {
         m_callbackSendEvent("onElementDown");
         this.setDescription(param1);
      }
      
      private function textInputChange(param1:Event) : void
      {
         CommonUtils.changeFontToGlobalIfNeeded(this.m_inputField);
         this.onTextInputChange();
      }
      
      protected function onTextInputChange() : void
      {
         this.updateTitle();
         this.validate(this.m_inputField.text);
      }
      
      protected function updateTitle() : void
      {
         this.setTitle(this.m_originalTitle + " " + "[" + this.m_inputField.text.length + "/" + this.m_inputField.maxChars + "]");
      }
      
      protected function getDescriptionText() : String
      {
         return this.m_inputField.text;
      }
      
      private function setDescriptionStageFocusDelayed() : void
      {
         this.m_inputField.addEventListener(Event.ENTER_FRAME,this.onSetDescriptionStageFocus);
      }
      
      private function removeDescriptionStageFocus() : void
      {
         if(this.m_inputField.hasEventListener(Event.ENTER_FRAME))
         {
            this.m_inputField.removeEventListener(Event.ENTER_FRAME,this.onSetDescriptionStageFocus);
         }
         stage.focus = null;
      }
      
      private function onSetDescriptionStageFocus(param1:Event) : void
      {
         this.m_inputField.removeEventListener(Event.ENTER_FRAME,this.onSetDescriptionStageFocus);
         stage.focus = this.m_inputField;
      }
      
      protected function setTitle(param1:String) : void
      {
      }
      
      protected function setInputFieldText(param1:String) : void
      {
      }
      
      protected function setErrorMessage(param1:ModalDialogValidation) : void
      {
         if(param1 == null)
         {
            this.m_errorMessage = "";
         }
         else
         {
            this.m_errorMessage = param1.getMessage();
         }
      }
      
      protected function validate(param1:String) : void
      {
         this.m_isValid = true;
         if(this.m_validator == null)
         {
            return;
         }
         var _loc2_:ModalDialogValidation = this.m_validator.validate(param1);
         this.setErrorMessage(_loc2_);
         this.m_isValid = _loc2_ == null;
         updateSubmitEnabled();
      }
      
      private function checkTextInputDone(param1:KeyboardEvent) : void
      {
         Log.xinfo(Log.ChannelModal,"ModalDialog checkTextInputDone: keyCode=" + param1.keyCode);
         if(m_buttonCount <= 0)
         {
            return;
         }
         if(!this.m_inputField.multiline)
         {
            if(param1.keyCode == MenuConstants.KEYCODE_ENTER)
            {
               param1.stopImmediatePropagation();
               if(this.isSubmitValid())
               {
                  m_callbackSendEvent("onElementDown");
               }
               return;
            }
         }
         if(param1.keyCode == MenuConstants.KEYCODE_RIGHT || param1.keyCode == MenuConstants.KEYCODE_DOWN)
         {
            if(this.m_inputField.caretIndex >= this.m_inputField.length && !param1.shiftKey)
            {
               param1.stopImmediatePropagation();
               m_callbackSendEvent("onElementDown");
            }
         }
         else if(param1.keyCode == MenuConstants.KEYCODE_ESC || CommonUtils.getPlatformString() == CommonUtils.PLATFORM_STADIA && param1.keyCode == MenuConstants.KEYCODE_TAB)
         {
            param1.stopImmediatePropagation();
            m_callbackSendEventWithValue("onElementOver",m_cancelButtonIndex);
         }
      }
      
      private function contentMouseEvent(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         m_callbackSendEventWithValue("onElementOver",-1);
      }
   }
}
