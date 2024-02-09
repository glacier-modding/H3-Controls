package menu3.search
{
   import common.CommonUtils;
   import common.InputTextFieldSpecialCharacterHandler;
   import common.Log;
   import common.menu.MenuConstants;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextFieldType;
   import mx.utils.StringUtil;
   
   public dynamic class SearchTagElementCustomInput extends SearchTagElementCustom
   {
       
      
      private var m_currentState:int = 0;
      
      private var m_sendEventWithValue:Function = null;
      
      private var m_allowKeyboardInput:Boolean = false;
      
      private var m_specialCharacterHandler:InputTextFieldSpecialCharacterHandler;
      
      public function SearchTagElementCustomInput(param1:Object)
      {
         super(param1);
         this.m_specialCharacterHandler = new InputTextFieldSpecialCharacterHandler(InputTextField);
      }
      
      private static function isRequiredExplicitTextFocus() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = ControlsMain.getMenuInputCapabilities();
         var _loc2_:Boolean = Boolean(_loc1_ & ControlsMain.MENUINPUTCAPABILITY_TEXTINPUT_VIA_PHYSICAL_KEYBOARD);
         var _loc3_:Boolean = Boolean(_loc1_ & ControlsMain.MENUINPUTCAPABILITY_TEXTINPUT_VIA_VIRTUAL_KEYBOARD);
         return _loc2_ && _loc3_ && ControlsMain.getControllerType() != CommonUtils.CONTROLLER_TYPE_KEY;
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         m_isElementActive = false;
         this.updateState();
      }
      
      override public function onUnregister() : void
      {
         this.m_allowKeyboardInput = false;
         this.removeDescriptionStageFocus();
         this.m_specialCharacterHandler.onUnregister();
         super.onUnregister();
      }
      
      override protected function setupInputTextField(param1:Object) : void
      {
         super.setupInputTextField(param1);
         this.m_allowKeyboardInput = false;
         this.captureKeyboardInput(false);
         if(getNodeProp(this,"pressable") == true)
         {
            trace("SearchTagElementCustomInput INPUT");
            InputTextField.selectable = true;
            InputTextField.type = TextFieldType.INPUT;
            this.m_allowKeyboardInput = true;
         }
         InputTextField.text = "";
         if(param1.maxchars != undefined)
         {
            InputTextField.maxChars = param1.maxchars;
         }
         InputTextField.addEventListener(Event.CHANGE,this.textInputChange);
      }
      
      override protected function setState(param1:int) : void
      {
         if(this.m_currentState != param1)
         {
            this.m_currentState = param1;
            if(isRequiredExplicitTextFocus() || !(param1 == STATE_SELECT || param1 == STATE_ACTIVE_SELECT))
            {
               this.removeDescriptionStageFocus();
            }
            else
            {
               this.setDescriptionStageFocusDelayed();
            }
         }
         super.setState(param1);
      }
      
      override protected function setupTitleTextField(param1:String) : void
      {
      }
      
      override public function setEngineCallbacks(param1:Function, param2:Function) : void
      {
         this.m_sendEventWithValue = param2;
      }
      
      override public function handleMouseUp(param1:Function, param2:MouseEvent) : void
      {
         trace("handleMouseUp InputTextField: " + InputTextField.type);
         if(this.m_currentState == STATE_SELECT || this.m_currentState == STATE_ACTIVE_SELECT)
         {
            stage.focus = InputTextField;
         }
      }
      
      public function doTextFieldAccept() : void
      {
         if(isRequiredExplicitTextFocus() && stage.focus != InputTextField)
         {
            this.setDescriptionStageFocusDelayed();
         }
         else
         {
            this.onTextFieldEdited(InputTextField.text);
         }
      }
      
      public function onTextFieldEdited(param1:String) : void
      {
         var _loc4_:Array = null;
         if(!this.m_allowKeyboardInput)
         {
            return;
         }
         if(!this["_nodedata"])
         {
            return;
         }
         if(this.m_sendEventWithValue == null)
         {
            return;
         }
         var _loc2_:int = this["_nodedata"]["id"] as int;
         var _loc3_:String = StringUtil.trim(param1.replace(/[\r\n\b]+/g,""));
         if(_loc3_.length <= 0)
         {
            this.m_sendEventWithValue("onElementDown",_loc2_);
         }
         else
         {
            _loc4_ = new Array(_loc2_,_loc3_);
            Log.info(Log.ChannelDebug,this,"sending input " + _loc3_);
            this.m_sendEventWithValue("onInputEntered",_loc4_);
         }
         InputTextField.text = "";
      }
      
      override protected function updateState() : void
      {
         if(!this.m_allowKeyboardInput)
         {
            this.setState(STATE_DISABLED);
         }
         else
         {
            super.updateState();
         }
      }
      
      override public function onAcceptPressed() : void
      {
      }
      
      override public function onCancelPressed() : void
      {
      }
      
      private function setDescriptionStageFocusDelayed() : void
      {
         if(InputTextField.hasEventListener(Event.ENTER_FRAME))
         {
            return;
         }
         InputTextField.addEventListener(Event.ENTER_FRAME,this.onSetDescriptionStageFocus);
      }
      
      private function removeDescriptionStageFocus() : void
      {
         if(InputTextField.hasEventListener(Event.ENTER_FRAME))
         {
            InputTextField.removeEventListener(Event.ENTER_FRAME,this.onSetDescriptionStageFocus);
         }
         if(stage)
         {
            stage.focus = null;
         }
         this.captureKeyboardInput(false);
      }
      
      private function onSetDescriptionStageFocus(param1:Event) : void
      {
         InputTextField.removeEventListener(Event.ENTER_FRAME,this.onSetDescriptionStageFocus);
         stage.focus = InputTextField;
         if(this.m_allowKeyboardInput)
         {
            this.captureKeyboardInput(true);
         }
      }
      
      private function textInputChange(param1:Event) : void
      {
         CommonUtils.changeFontToGlobalIfNeeded(InputTextField);
      }
      
      private function onKeyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc3_:Array = null;
         if(!this["_nodedata"])
         {
            return;
         }
         if(this.m_sendEventWithValue == null)
         {
            return;
         }
         var _loc2_:int = this["_nodedata"]["id"] as int;
         if(param1.keyCode == MenuConstants.KEYCODE_ESC)
         {
            this.m_sendEventWithValue("onElementCancel",_loc2_);
            if(isRequiredExplicitTextFocus())
            {
               this.removeDescriptionStageFocus();
            }
            return;
         }
         if(param1.keyCode == MenuConstants.KEYCODE_F1)
         {
            _loc3_ = new Array(_loc2_,"action-select");
            this.m_sendEventWithValue("onTriggerAction",_loc3_);
            return;
         }
         if(param1.keyCode == MenuConstants.KEYCODE_RIGHT || param1.keyCode == MenuConstants.KEYCODE_DOWN)
         {
            if(InputTextField.caretIndex >= InputTextField.length && !param1.shiftKey)
            {
               if(param1.keyCode == MenuConstants.KEYCODE_RIGHT)
               {
                  this.m_sendEventWithValue("onElementNext",_loc2_);
               }
               else
               {
                  this.m_sendEventWithValue("onElementDown",_loc2_);
               }
               return;
            }
         }
         if(param1.keyCode == MenuConstants.KEYCODE_ENTER)
         {
            this.doTextFieldAccept();
         }
      }
      
      private function captureKeyboardInput(param1:Boolean) : void
      {
         this.m_sendEventWithValue("enableKeyboardInput",!param1);
         this.m_specialCharacterHandler.setActive(param1);
         if(param1)
         {
            InputTextField.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         }
         else
         {
            InputTextField.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         }
      }
   }
}
