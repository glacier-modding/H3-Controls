package common
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   
   public class ImageLoader extends Loader
   {
       
      
      private var m_callback:Function;
      
      private var m_failedCallback:Function;
      
      private var m_isLoading:Boolean = false;
      
      private var m_loadOnAddedToStage:Boolean = false;
      
      private var m_isAddedToStage:Boolean = false;
      
      private var m_rid:String;
      
      private var m_toLoadUrl:String = null;
      
      public function ImageLoader(param1:Boolean = false)
      {
         super();
         this.m_loadOnAddedToStage = param1;
         this.m_isLoading = false;
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         if(this.m_loadOnAddedToStage)
         {
            this.addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         }
      }
      
      public function isLoading() : Boolean
      {
         return this.m_isLoading;
      }
      
      public function loadImage(param1:String, param2:Function = null, param3:Function = null) : void
      {
         if(this.m_isLoading)
         {
            this.cancel();
         }
         this.ClearImage();
         this.m_isLoading = true;
         this.m_callback = param2;
         this.m_failedCallback = param3;
         if(!this.m_loadOnAddedToStage || this.m_isAddedToStage)
         {
            this.triggerRequestAsyncLoad(param1);
         }
         else
         {
            this.m_rid = param1;
         }
      }
      
      private function triggerRequestAsyncLoad(param1:String) : void
      {
         this.m_toLoadUrl = "img://" + param1;
         ExternalInterface.call("RequestAsyncLoad",this.m_toLoadUrl,this);
      }
      
      public function cancel() : void
      {
         if(this.m_isLoading)
         {
            this.close();
            this.ClearImage();
            this.closeRequest();
            this.m_callback = null;
            if(this.m_failedCallback != null)
            {
               this.m_failedCallback();
               this.m_failedCallback = null;
            }
         }
      }
      
      public function cancelAndClearImage() : void
      {
         if(this.m_isLoading)
         {
            this.cancel();
         }
         else
         {
            this.ClearImage();
         }
      }
      
      public function onResourceReady(param1:String) : void
      {
         if(this.m_toLoadUrl != param1)
         {
            return;
         }
         this.RegisterLoaderListeners();
         var _loc2_:URLRequest = new URLRequest(param1);
         this.load(_loc2_);
      }
      
      public function onResourceFailed(param1:String) : void
      {
         if(this.m_toLoadUrl != param1)
         {
            return;
         }
         this.closeRequest();
         if(this.m_failedCallback != null)
         {
            this.m_failedCallback();
            this.m_failedCallback = null;
         }
      }
      
      private function onLoadingComplete(param1:Event) : void
      {
         this.closeRequest();
         if(this.m_callback != null)
         {
            this.m_callback();
            this.m_callback = null;
         }
      }
      
      private function onLoadFailed(param1:IOErrorEvent) : void
      {
         this.closeRequest();
         if(this.m_failedCallback != null)
         {
            this.m_failedCallback();
            this.m_failedCallback = null;
         }
      }
      
      private function onAdded(param1:Event) : void
      {
         this.m_isAddedToStage = true;
         if(this.m_rid != null)
         {
            this.triggerRequestAsyncLoad(this.m_rid);
            this.m_rid = null;
         }
      }
      
      private function onRemoved(param1:Event) : void
      {
         this.m_isAddedToStage = false;
         if(this.m_isLoading)
         {
            this.cancel();
         }
         this.ClearImage();
      }
      
      private function closeRequest() : void
      {
         this.m_rid = null;
         this.m_toLoadUrl = null;
         this.m_isLoading = false;
         ExternalInterface.call("CloseAsyncRequest",this);
         this.UnregisterLoaderListeners();
      }
      
      private function RegisterLoaderListeners() : void
      {
         this.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailed);
      }
      
      private function UnregisterLoaderListeners() : void
      {
         this.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadFailed);
      }
      
      private function ClearImage() : void
      {
         this.unload();
      }
   }
}
