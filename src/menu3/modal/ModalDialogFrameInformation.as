package menu3.modal
{
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.TextField;
   
   public class ModalDialogFrameInformation extends ModalDialogFrame
   {
       
      
      protected var m_scrollingContainer:ModalScrollingContainer;
      
      protected var m_maxTitleWidth:Number = 0;
      
      public function ModalDialogFrameInformation(param1:Object)
      {
         super(param1);
      }
      
      override public function onScroll(param1:Number, param2:Boolean) : void
      {
         super.onScroll(param1,param2);
         if(this.m_scrollingContainer == null)
         {
            return;
         }
         this.m_scrollingContainer.scroll(param1,param2);
      }
      
      override public function onFadeInFinished() : void
      {
         super.onFadeInFinished();
         if(this.m_scrollingContainer == null)
         {
            return;
         }
         this.m_scrollingContainer.onFadeInFinished();
      }
      
      protected function setupTitle(param1:TextField, param2:Object) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:* = "";
         if(param2.category)
         {
            _loc3_ = String(param2.category);
         }
         if(param2.title)
         {
            if(_loc3_.length > 0)
            {
               _loc3_ += " | ";
            }
            _loc3_ += param2.title;
         }
         if(_loc3_.length > 0)
         {
            if(this.m_maxTitleWidth <= 0)
            {
               this.m_maxTitleWidth = param1.width;
            }
            _loc4_ = -1;
            _loc5_ = 20;
            MenuUtils.setupTextAndShrinkToFitUpper(param1,_loc3_,48,MenuConstants.FONT_TYPE_BOLD,this.m_maxTitleWidth,_loc4_,_loc5_,MenuConstants.FontColorWhite);
            CommonUtils.changeFontToGlobalIfNeeded(param1);
         }
      }
      
      protected function setupDescription(param1:TextField, param2:Object) : void
      {
         if(param2.description)
         {
            this.setupText(param1,param2.description);
         }
      }
      
      protected function setupText(param1:TextField, param2:String) : void
      {
         MenuUtils.setupText(param1,param2,21,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         CommonUtils.changeFontToGlobalIfNeeded(param1);
      }
      
      protected function setupInformation(param1:Object) : void
      {
         if(param1.information)
         {
            ModalContentInformation.createContent(this.m_scrollingContainer,param1.information);
         }
      }
      
      protected function destroyInformation() : void
      {
         var _loc2_:ModalDialogContentInfoElementBase = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_scrollingContainer.numChildren)
         {
            _loc2_ = this.m_scrollingContainer.getChildAt(_loc1_) as ModalDialogContentInfoElementBase;
            if(_loc2_ != null)
            {
               _loc2_.destroy();
            }
            _loc1_++;
         }
         this.m_scrollingContainer.removeChildren();
         this.m_scrollingContainer.onUnregister();
      }
      
      protected function createAndAddScrollContainer(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Boolean = true;
         this.m_scrollingContainer = new ModalScrollingContainer(param3,param4,param5,_loc6_);
         addChild(this.m_scrollingContainer);
         this.m_scrollingContainer.x = param1;
         this.m_scrollingContainer.y = param2;
         addMouseWheelEventListener(this.m_scrollingContainer);
      }
   }
}
