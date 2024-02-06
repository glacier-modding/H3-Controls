package menu3.modal
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public dynamic class ModalDialogGeneric extends ModalDialogFrameInformation
   {
      
      public static const FRAME_REST_HEIGHT:Number = 160;
      
      public static const FRAME_HEIGHT_MIN:Number = 260;
      
      public static const FRAME_HEIGHT_MAX:Number = 768.223;
      
      public static const FRAME_WIDTH:Number = 750;
       
      
      protected var m_viewTitle:TextField;
      
      protected var m_viewDescription:TextField;
      
      protected var m_viewFrame:Sprite;
      
      private var m_view:ModalDialogGenericView;
      
      public function ModalDialogGeneric(param1:Object)
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
         this.m_viewDescription = _loc1_.description;
         this.m_viewFrame = _loc1_.bg;
         MenuUtils.setColor(this.m_viewFrame,MenuConstants.COLOR_MENU_SOLID_BACKGROUND,true,1);
         this.m_viewDescription.autoSize = "left";
         this.m_viewDescription.text = "";
         this.m_view = _loc1_;
         addChild(this.m_view);
      }
      
      override public function getView() : Sprite
      {
         return this.m_view;
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc2_:Number = param1.hasOwnProperty("frameheightmax") ? Number(param1.frameheightmax) : FRAME_HEIGHT_MAX;
         var _loc3_:Number = param1.hasOwnProperty("frameheightmin") ? Number(param1.frameheightmin) : FRAME_HEIGHT_MIN;
         m_dialogWidth = param1.hasOwnProperty("dialogWidth") ? Number(param1.dialogWidth) : FRAME_WIDTH;
         this.m_viewFrame.width = m_dialogWidth;
         var _loc4_:Number = this.m_viewDescription.x;
         var _loc5_:Number = this.m_viewDescription.y;
         var _loc6_:Number = _loc4_;
         var _loc7_:Number = FRAME_REST_HEIGHT;
         setupTitle(this.m_viewTitle,param1);
         if(this.m_viewTitle.text.length == 0)
         {
            _loc7_ -= _loc5_ - this.m_viewTitle.y;
            _loc5_ = this.m_viewTitle.y;
         }
         createAndAddScrollContainer(_loc4_,_loc5_,m_dialogWidth - _loc4_,_loc2_ - _loc7_,_loc6_);
         super.onSetData(param1);
         setupDescription(this.m_viewDescription,param1);
         if(this.m_viewDescription.text.length > 0)
         {
            this.m_viewDescription.x = 0;
            this.m_viewDescription.y = 0;
            m_scrollingContainer.append(this.m_viewDescription,false,this.m_viewDescription.height,false);
         }
         setupInformation(param1);
         var _loc8_:Number = Math.ceil(m_scrollingContainer.getContentHeight()) + _loc7_;
         m_dialogHeight = updateDialogHeight(_loc8_,_loc3_,_loc2_);
         this.m_viewFrame.height = m_dialogHeight;
      }
      
      override public function hide() : void
      {
         destroyInformation();
         super.hide();
      }
   }
}
