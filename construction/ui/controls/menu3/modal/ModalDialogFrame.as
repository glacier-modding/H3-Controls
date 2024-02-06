package menu3.modal
{
   import common.Log;
   import common.menu.MenuConstants;
   
   public class ModalDialogFrame extends ModalDialogContainerBase
   {
       
      
      protected var m_dialogWidth:Number;
      
      protected var m_dialogHeight:Number;
      
      protected var m_selectableElements:Array;
      
      protected var m_buttonCount:int = 0;
      
      protected var m_submitButtonIndex:int = 0;
      
      protected var m_cancelButtonIndex:int = 0;
      
      protected var m_submitValidators:Vector.<ISubmitValidator>;
      
      private var m_submitButton:ModalDialogGenericButton = null;
      
      private var m_fixedHeight:Number = -1;
      
      public function ModalDialogFrame(param1:Object)
      {
         this.m_submitValidators = new Vector.<ISubmitValidator>();
         super(param1);
         this.m_dialogWidth = param1.dialogWidth;
         this.m_dialogHeight = param1.dialogHeight;
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.m_selectableElements = new Array();
         this.m_submitValidators.length = 0;
         if(param1.fixedheight)
         {
            this.m_fixedHeight = param1.fixedheight;
         }
      }
      
      override public function setButtonData(param1:Array) : void
      {
         super.setButtonData(param1);
         var _loc2_:Number = this.m_dialogHeight + MenuConstants.tileBorder + MenuConstants.tileGap * 12;
         var _loc3_:Number = this.placeButtons(param1,_loc2_);
         if(_loc3_ > 0)
         {
            this.m_dialogHeight = _loc3_;
         }
         this.updateSubmitEnabled();
      }
      
      override public function onButtonPressed(param1:Number) : void
      {
         super.onButtonPressed(param1);
         if(this.m_selectableElements.length > param1)
         {
            this.m_selectableElements[param1].onPressed();
         }
      }
      
      protected function onPressed() : void
      {
      }
      
      override public function getModalHeight() : Number
      {
         return this.m_dialogHeight;
      }
      
      override public function getModalWidth() : Number
      {
         return this.m_dialogWidth;
      }
      
      override public function onSetItemSelected(param1:int, param2:Boolean) : void
      {
         super.onSetItemSelected(param1,param2);
         if(this.m_selectableElements.length > param1)
         {
            this.m_selectableElements[param1].setItemSelected(param2);
         }
      }
      
      protected function setItemSelected(param1:Boolean) : void
      {
      }
      
      protected function updateDialogHeight(param1:Number, param2:Number, param3:Number) : Number
      {
         var height:Number = 0;
         if(this.m_fixedHeight >= 0)
         {
            Log.xinfo(Log.ChannelModal,"fixed height: " + this.m_fixedHeight);
            height = this.m_fixedHeight;
         }
         else
         {
            height = Math.ceil(param1);
            height = Math.max(height,param2);
            height = Math.min(height,param3);
            Log.xinfo(Log.ChannelModal,"dialogHeight height: " + height);
         }
         return height;
      }
      
      protected function getSubmitButton() : ModalDialogGenericButton
      {
         return this.m_submitButton;
      }
      
      public function updateSubmitEnabled() : void
      {
         var _loc1_:Boolean = this.checkSubmitValidators();
         this.setSubmitEnabled(_loc1_);
      }
      
      protected function checkSubmitValidators() : Boolean
      {
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_submitValidators.length)
         {
            _loc1_ &&= this.m_submitValidators[_loc2_].isSubmitValid();
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function setSubmitEnabled(param1:Boolean) : void
      {
         var _loc2_:ModalDialogGenericButton = this.getSubmitButton();
         if(_loc2_ != null)
         {
            _loc2_.setPressable(param1);
         }
         else
         {
            Log.xinfo(Log.ChannelModal,"no submit button to update");
         }
         m_callbackSendEventWithValue("onSubmitAllowedChanged",param1);
      }
      
      private function placeButtons(param1:Array, param2:Number) : Number
      {
         var _loc5_:Object = null;
         var _loc6_:ModalDialogGenericButton = null;
         var _loc7_:ModalDialogGenericCheckboxButton = null;
         this.m_buttonCount = 0;
         if(param1 == null || param1.length <= 0)
         {
            Log.xinfo(Log.ChannelModal,"ModalDialogFrame: no button data found");
            return -1;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = param1[_loc3_];
            Log.xinfo(Log.ChannelModal,"ModalDialogFrame: button: " + _loc5_.title);
            _loc5_.dialogWidth = this.m_dialogWidth;
            if(_loc5_.type == "checkbox")
            {
               (_loc7_ = new ModalDialogGenericCheckboxButton(_loc5_)).setModalCallbacks(this.updateSubmitEnabled);
               this.m_submitValidators.push(_loc7_);
               _loc6_ = _loc7_;
            }
            else
            {
               _loc6_ = new ModalDialogGenericButton(_loc5_);
            }
            _loc6_.onSetData(_loc5_);
            _loc6_.x = -MenuConstants.tileBorder;
            _loc6_.y = param2;
            addMouseEventListenersOnButton(_loc6_,_loc3_);
            this.m_selectableElements.push(_loc6_);
            addChild(_loc6_);
            param2 += _loc6_.getView().height + MenuConstants.tileGap * 10;
            if(_loc5_.type)
            {
               if(_loc5_.type == "ok")
               {
                  this.m_submitButtonIndex = _loc3_;
                  this.m_submitButton = _loc6_;
               }
               else if(_loc5_.type == "cancel")
               {
                  this.m_cancelButtonIndex = _loc3_;
               }
            }
            _loc3_++;
         }
         this.m_buttonCount = param1.length;
         var _loc4_:int = this.m_selectableElements.length - this.m_buttonCount;
         while(_loc4_ < this.m_selectableElements.length)
         {
            this.m_selectableElements[_loc4_].onCreationDone();
            _loc4_++;
         }
         return param2;
      }
   }
}
