package menu3.modal
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import menu3.MenuElementBase;
   
   public class ModalDialogContainerBase extends MenuElementBase
   {
       
      
      protected var m_callbackSendEvent:Function;
      
      protected var m_callbackSendEventWithValue:Function;
      
      protected var m_dialogInformation:DialogInformation;
      
      protected var m_taskManagerEnqueue:Function = null;
      
      public function ModalDialogContainerBase(param1:Object)
      {
         this.m_dialogInformation = new DialogInformation();
         super(param1);
      }
      
      override public function setEngineCallbacks(param1:Function, param2:Function) : void
      {
         super.setEngineCallbacks(param1,param2);
         this.m_callbackSendEvent = param1;
         this.m_callbackSendEventWithValue = param2;
      }
      
      public function setTaskManagerEnqueue(param1:Function) : void
      {
         this.m_taskManagerEnqueue = param1;
      }
      
      public function getDialogInformation() : Object
      {
         return this.m_dialogInformation;
      }
      
      public function setButtonData(param1:Array) : void
      {
      }
      
      public function getModalHeight() : Number
      {
         return 0;
      }
      
      public function getModalWidth() : Number
      {
         return 0;
      }
      
      public function onSetItemSelected(param1:int, param2:Boolean) : void
      {
      }
      
      public function onScroll(param1:Number, param2:Boolean) : void
      {
      }
      
      public function onButtonPressed(param1:Number) : void
      {
      }
      
      public function updateButtonPrompts() : void
      {
      }
      
      public function hide() : void
      {
      }
      
      public function onFadeInFinished() : void
      {
      }
      
      protected function addMouseEventListenersOnButton(param1:ModalDialogGenericButton, param2:int) : void
      {
         var button:ModalDialogGenericButton = param1;
         var i:int = param2;
         button.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):void
         {
            param1.stopImmediatePropagation();
            if(button.isPressable())
            {
               m_callbackSendEventWithValue("onElementClick",i);
            }
         });
         button.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            param1.stopImmediatePropagation();
            if(button.isPressable())
            {
               m_callbackSendEventWithValue("onElementOver",i);
            }
         });
      }
      
      protected function addMouseEventListeners(param1:Sprite, param2:int) : void
      {
         var element:Sprite = param1;
         var i:int = param2;
         element.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):void
         {
            param1.stopImmediatePropagation();
            m_callbackSendEventWithValue("onElementClick",i);
         });
         element.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            param1.stopImmediatePropagation();
            m_callbackSendEventWithValue("onElementOver",i);
         });
      }
      
      protected function addMouseWheelEventListener(param1:Sprite) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelModal,false,0,false);
      }
      
      private function handleMouseWheelModal(param1:MouseEvent) : void
      {
         trace("ModalDialog mouseEvent: " + param1.type);
         var _loc2_:Number = param1.delta;
         var _loc3_:Array = new Array(-1,_loc2_);
         this.m_callbackSendEventWithValue("onElementScrollVertical",_loc3_);
      }
   }
}

class DialogInformation
{
    
   
   public var CanSelectContent:Boolean = false;
   
   public var ContentIsTextEdit:Boolean = false;
   
   public var IsButtonSelectionEnabled:Boolean = true;
   
   public var AllButtonsClose:Boolean = true;
   
   public function DialogInformation()
   {
      super();
   }
}
