package basic
{
   import common.Log;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class VideoBoxInfo extends Sprite
   {
      
      public static var STATE_NONE:String = "stateNone";
      
      public static var STATE_LOADING:String = "loading";
      
      public static var STATE_SKIPPABLE:String = "skippable";
       
      
      private var m_progress:Number;
      
      public var m_platformString:String;
      
      private var m_skipString:String;
      
      private var m_loadingString:String;
      
      private var m_currentState:String;
      
      private var m_stateDisplayObjects:Dictionary;
      
      private var m_loadIndicator:GlobalLoadindicator;
      
      private var m_promptsContainer:Sprite;
      
      private var m_skipPromptObjPrevious:Object = null;
      
      public function VideoBoxInfo(param1:Object)
      {
         this.m_stateDisplayObjects = new Dictionary();
         super();
         this.m_loadIndicator = new GlobalLoadindicator();
         addChild(this.m_loadIndicator);
         this.m_promptsContainer = new Sprite();
         addChild(this.m_promptsContainer);
         this.m_stateDisplayObjects[VideoBoxInfo.STATE_LOADING] = this.m_loadIndicator;
         this.m_stateDisplayObjects[VideoBoxInfo.STATE_SKIPPABLE] = this.m_promptsContainer;
         this.setData(param1);
         this.setInfoState(STATE_NONE);
      }
      
      public function startIndicatorAnim() : void
      {
         this.m_loadIndicator.ShowLoadindicator({
            "discrete":false,
            "icon":"load",
            "header":this.m_loadingString,
            "showbarcodes":true
         });
         this.m_loadIndicator.x = -158;
         this.m_loadIndicator.y = -73;
      }
      
      public function stopIndicatorAnim() : void
      {
         this.m_loadIndicator.HideLoadindicator();
      }
      
      public function setData(param1:Object) : void
      {
         this.m_skipString = param1.skipString;
         this.m_loadingString = param1.loadingString;
         this.m_platformString = param1.platformString;
         this.configureSkipPrompt();
      }
      
      private function configureSkipPrompt() : void
      {
         Log.info(Log.ChannelVideo,this,"Add Prompt " + this.m_skipString + " platform:" + this.m_platformString);
         var _loc1_:Object = new Object();
         _loc1_.buttonprompts = new Array({
            "actiontype":"cancel",
            "actionlabel":this.m_skipString,
            "hideIndicator":true,
            "platform":this.m_platformString
         });
         this.m_skipPromptObjPrevious = MenuUtils.parsePrompts(_loc1_,this.m_skipPromptObjPrevious,this.m_promptsContainer);
         this.m_promptsContainer.x = -this.m_promptsContainer.width - 70;
         this.m_promptsContainer.y = -65;
      }
      
      public function setLoadProgress(param1:Number) : void
      {
         this.m_progress = param1;
         var _loc2_:int = this.m_progress * 100;
         this.m_loadIndicator.setProgress(this.m_progress);
      }
      
      public function setInfoState(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         Log.info(Log.ChannelVideo,this,"setInfoState " + param1);
         if(this.m_currentState == param1 && !param2)
         {
            return;
         }
         this.m_currentState = param1;
         this.visible = this.m_currentState != STATE_NONE;
         for(_loc3_ in this.m_stateDisplayObjects)
         {
            this.m_stateDisplayObjects[_loc3_].visible = _loc3_ == this.m_currentState;
         }
         this.setLoadProgress(this.m_progress);
      }
   }
}
