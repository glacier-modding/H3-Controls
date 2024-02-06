package menu3.modal
{
   import common.Animate;
   import common.BaseControl;
   import common.Log;
   import common.TaskletSequencer;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   
   public class ModalDialog extends BaseControl
   {
       
      
      private var m_child:ModalDialogContainerBase;
      
      private var m_modalContainer:Sprite;
      
      private var m_dialogContainer:Sprite;
      
      private var m_bgTile:blackBgTileView;
      
      private var m_scaleRatio:Number = 1;
      
      private var m_taskletSequencer:TaskletSequencer;
      
      private var m_isEnterFrameActive:Boolean = false;
      
      public function ModalDialog()
      {
         this.m_taskletSequencer = new TaskletSequencer();
         super();
         this.m_bgTile = new blackBgTileView();
         this.m_bgTile.visible = false;
         this.m_bgTile.alpha = 0;
         this.m_bgTile.visible = false;
         addChild(this.m_bgTile);
         this.m_modalContainer = new Sprite();
         this.m_modalContainer.visible = false;
         this.m_modalContainer.alpha = 0;
         this.m_modalContainer.visible = false;
         addChild(this.m_modalContainer);
         this.m_dialogContainer = new Sprite();
         this.m_modalContainer.addChild(this.m_dialogContainer);
      }
      
      public function onSetData(param1:Object) : void
      {
         this.showDialog(param1);
      }
      
      public function showDialog(param1:Object) : Object
      {
         Log.xinfo(Log.ChannelModal,"ModalDialog showDialog type:" + param1.type);
         if(param1.view == undefined || param1.view.length <= 0)
         {
            if(param1.type == "lineedit")
            {
               param1.view = "menu3.modal.ModalDialogGenericEditLine";
            }
            else if(param1.type == "textedit")
            {
               param1.view = "menu3.modal.ModalDialogGenericEditText";
            }
            else if(param1.type == "publicid")
            {
               param1.view = "menu3.modal.ModalDialogEditLinePublicId";
            }
            else
            {
               param1.view = "menu3.modal.ModalDialogGeneric";
            }
         }
         return this.openDialog(param1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.m_taskletSequencer.processingTime_ms = ControlsMain.isVrModeActive() ? 2 : 20;
         this.m_taskletSequencer.update();
      }
      
      private function openDialog(param1:Object) : Object
      {
         var dynamicChildType:Class;
         var dialogInformation:Object;
         var funcOnSetData:Function;
         var funcSetButtonData:Function;
         var funcAdd:Function;
         var funcAnimation:Function;
         var data:Object = param1;
         this.m_taskletSequencer.clear();
         if(!this.m_isEnterFrameActive)
         {
            this.m_isEnterFrameActive = true;
            this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         Animate.kill(this.m_modalContainer);
         Animate.kill(this.m_bgTile);
         if(this.m_child != null)
         {
            this.m_dialogContainer.removeChild(this.m_child);
            this.m_child = null;
         }
         this.m_bgTile.alpha = 0;
         this.m_bgTile.visible = true;
         this.m_bgTile.width = parent.width;
         this.m_bgTile.height = parent.height;
         this.m_bgTile.x = parent.width / -2;
         this.m_bgTile.y = parent.height / -2;
         dynamicChildType = getDefinitionByName(data.view) as Class;
         this.m_child = new dynamicChildType(data.data);
         this.m_child.setEngineCallbacks(sendEvent,sendEventWithValue);
         this.m_child.setTaskManagerEnqueue(this.m_taskletSequencer.addChunk);
         dialogInformation = this.m_child.getDialogInformation();
         funcOnSetData = function():void
         {
            m_child.onSetData(data.data);
         };
         this.m_taskletSequencer.addChunk(funcOnSetData);
         funcSetButtonData = function():void
         {
            m_child.setButtonData(data.buttons);
         };
         this.m_taskletSequencer.addChunk(funcSetButtonData);
         funcAdd = function():void
         {
            m_dialogContainer.addChild(m_child);
         };
         this.m_taskletSequencer.addChunk(funcAdd);
         funcAnimation = function():void
         {
            var _loc1_:Number = m_child.getModalWidth();
            var _loc2_:Number = m_child.getModalHeight();
            m_dialogContainer.x = _loc1_ / -2;
            m_dialogContainer.y = _loc2_ / -2;
            m_modalContainer.alpha = 0;
            m_modalContainer.visible = true;
            m_modalContainer.scaleX = m_scaleRatio * 3;
            m_modalContainer.scaleY = m_scaleRatio * 3;
            Animate.legacyTo(m_modalContainer,0.2,{
               "scaleX":m_scaleRatio,
               "scaleY":m_scaleRatio,
               "alpha":1
            },Animate.ExpoOut,onFadeInFinished);
            Animate.legacyTo(m_bgTile,0.2,{"alpha":1},Animate.ExpoOut);
            if(ControlsMain.isVrModeActive())
            {
               m_modalContainer.z = MenuUtils.toPixel(-0.4);
            }
            else
            {
               m_modalContainer.z = 0;
               m_modalContainer.transform.matrix3D = null;
            }
         };
         this.m_taskletSequencer.addChunk(funcAnimation);
         return dialogInformation;
      }
      
      private function onFadeInFinished() : void
      {
         var func:Function = null;
         if(this.m_child != null)
         {
            func = function():void
            {
               m_child.onFadeInFinished();
            };
            this.m_taskletSequencer.addChunk(func);
         }
      }
      
      public function buttonPressed(param1:Object) : void
      {
         var func:Function = null;
         var data:Object = param1;
         if(this.m_child != null)
         {
            func = function():void
            {
               m_child.onButtonPressed(data.button);
            };
            this.m_taskletSequencer.addChunk(func);
         }
      }
      
      public function onScroll(param1:Number, param2:Boolean) : void
      {
         var func:Function = null;
         var delta:Number = param1;
         var animate:Boolean = param2;
         if(this.m_child != null)
         {
            func = function():void
            {
               m_child.onScroll(delta,animate);
            };
            this.m_taskletSequencer.addChunk(func);
         }
      }
      
      public function updateButtonPrompts() : void
      {
         var func:Function = null;
         if(this.m_child != null)
         {
            func = function():void
            {
               m_child.updateButtonPrompts();
            };
            this.m_taskletSequencer.addChunk(func);
         }
      }
      
      public function hideDialog() : void
      {
         Animate.complete(this.m_modalContainer);
         Animate.legacyTo(this.m_modalContainer,0.2,{
            "scaleX":this.m_scaleRatio * 0.4,
            "scaleY":this.m_scaleRatio * 0.4,
            "alpha":0
         },Animate.ExpoIn,function():void
         {
            m_modalContainer.visible = false;
         });
         Animate.complete(this.m_bgTile);
         Animate.legacyTo(this.m_bgTile,0.2,{"alpha":0},Animate.ExpoOut,function():void
         {
            m_bgTile.visible = false;
         });
         if(this.m_child != null)
         {
            this.m_child.hide();
            this.m_dialogContainer.removeChild(this.m_child);
            this.m_child = null;
         }
         this.m_taskletSequencer.clear();
         if(this.m_isEnterFrameActive)
         {
            this.m_isEnterFrameActive = false;
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      public function onSetItemSelected(param1:int, param2:Boolean) : void
      {
         var func:Function = null;
         var index:int = param1;
         var selected:Boolean = param2;
         if(this.m_child != null)
         {
            func = function():void
            {
               m_child.onSetItemSelected(index,selected);
            };
            this.m_taskletSequencer.addChunk(func);
         }
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         Log.xinfo(Log.ChannelModal,"ModalDialog size: " + param1 + "x" + param2);
         Log.xinfo(Log.ChannelModal,"ModalDialog parent: " + parent.width + "x" + parent.height);
         if(this.m_bgTile != null)
         {
            this.m_bgTile.width = parent.width;
            this.m_bgTile.height = parent.height;
            this.m_bgTile.x = parent.width / -2;
            this.m_bgTile.y = parent.height / -2;
         }
      }
      
      override public function onSetViewport(param1:Number, param2:Number, param3:Number) : void
      {
         this.m_scaleRatio = Math.min(param1,param2) * param3;
         if(this.m_modalContainer != null)
         {
            this.m_modalContainer.scaleX = this.m_scaleRatio;
            this.m_modalContainer.scaleY = this.m_scaleRatio;
         }
      }
      
      public function onTextFieldEdited(param1:String) : void
      {
         var func:Function = null;
         var value:String = param1;
         if(this.m_child != null)
         {
            func = function():void
            {
               var _loc1_:ModalDialogFrameEdit = m_child as ModalDialogFrameEdit;
               if(_loc1_ != null)
               {
                  _loc1_.onTextFieldEdited(value);
               }
            };
            this.m_taskletSequencer.addChunk(func);
         }
      }
   }
}
