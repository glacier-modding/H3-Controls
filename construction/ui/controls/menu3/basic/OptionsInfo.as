package menu3.basic
{
   import basic.ButtonPromtUtil;
   import basic.IButtonPromptOwner;
   import common.Animate;
   import common.Localization;
   import common.MouseUtil;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import menu3.MenuElementTileBase;
   
   public dynamic class OptionsInfo extends MenuElementTileBase implements IButtonPromptOwner
   {
       
      
      protected var m_view:OptionsInfoView;
      
      private var m_isActiveButtonPromptOwner:Boolean = false;
      
      public function OptionsInfo(param1:Object)
      {
         super(param1);
         m_mouseMode = MouseUtil.MODE_DISABLE;
         this.m_view = new OptionsInfoView();
         addChild(this.m_view);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc4_:Sprite = null;
         super.onSetData(param1);
         MenuUtils.setupText(this.m_view.title,param1.title,28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         var _loc2_:String = String(param1.paragraph);
         if(param1.locaParagraph != null)
         {
            _loc2_ = Localization.get(param1.locaParagraph);
         }
         if(param1.replaceParagraphBreakHeight != null)
         {
            _loc2_ = _loc2_.replace(/<br><br>/gi,"<br><img width=\"1\" height=\"" + param1.replaceParagraphBreakHeight + "\">");
         }
         this.m_view.paragraph.height = 725;
         MenuUtils.setupText(this.m_view.paragraph,_loc2_,20,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         MenuUtils.truncateTextfield(this.m_view.title,1);
         if(param1.useImage)
         {
            if(param1.imageId)
            {
               switch(param1.imageId)
               {
                  case "gamma":
                     (_loc4_ = new GammaImageView()).x = 0;
                     _loc4_.y = this.m_view.paragraph.y + this.m_view.paragraph.textHeight + 15;
                     this.m_view.addChild(_loc4_);
                     break;
                  default:
                     trace("unhandled case in : ");
               }
            }
         }
         var _loc3_:* = param1.updateButtonPrompts === true;
         if(_loc3_ != this.m_isActiveButtonPromptOwner)
         {
            this.m_isActiveButtonPromptOwner = _loc3_;
            if(this.m_isActiveButtonPromptOwner)
            {
               ButtonPromtUtil.registerButtonPromptOwner(this);
            }
            else
            {
               ButtonPromtUtil.unregisterButtonPromptOwner(this);
            }
         }
      }
      
      override public function addChild2(param1:Sprite, param2:int = -1) : void
      {
         super.addChild2(param1,param2);
         if(getNodeProp(param1,"col") === undefined)
         {
            if(this.getData().direction != "horizontal" && this.getData().direction != "horizontalWrap")
            {
               param1.x = 32;
            }
         }
      }
      
      public function updateButtonPrompts() : void
      {
         var _loc1_:Object = getData();
         if(_loc1_ != null)
         {
            this.onSetData(_loc1_);
         }
      }
      
      private function changeTextColor(param1:uint, param2:TextField) : void
      {
         param2.textColor = param1;
      }
      
      override public function onUnregister() : void
      {
         if(this.m_isActiveButtonPromptOwner)
         {
            ButtonPromtUtil.unregisterButtonPromptOwner(this);
         }
         if(this.m_view)
         {
            Animate.kill(this.m_view);
            removeChild(this.m_view);
            this.m_view = null;
         }
         super.onUnregister();
      }
   }
}
