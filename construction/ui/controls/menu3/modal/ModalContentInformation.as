package menu3.modal
{
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import menu3.MenuImageLoader;
   
   public class ModalContentInformation
   {
       
      
      public function ModalContentInformation()
      {
         super();
      }
      
      public static function createContent(param1:ModalScrollingContainer, param2:Array) : void
      {
         var _loc7_:ModalDialogContentImageView = null;
         var _loc8_:MenuImageLoader = null;
         var _loc9_:TextField = null;
         var _loc10_:Number = NaN;
         var _loc11_:TextFormat = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:ModalDialogContractElement = null;
         var _loc15_:ModalDialogDlcMissingElement = null;
         var _loc16_:ModalDialogImageTextElement = null;
         var _loc3_:Number = param1.getContentWidth();
         var _loc4_:Number = param1.getScrollDist();
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         while(_loc6_ < param2.length)
         {
            if(param2[_loc6_].image)
            {
               if(_loc5_ > 0)
               {
                  param1.addGap(_loc5_);
                  _loc5_ = 0;
               }
               _loc7_ = new ModalDialogContentImageView();
               (_loc8_ = new MenuImageLoader()).center = false;
               _loc7_.image.addChild(_loc8_);
               _loc8_.loadImage(param2[_loc6_].image);
               param1.appendEntry(_loc7_,false,param2[_loc6_].imageheight,"image");
               _loc5_ = _loc4_;
            }
            if(param2[_loc6_].description)
            {
               if(_loc5_ > 0)
               {
                  param1.addGap(_loc5_);
                  _loc5_ = 0;
               }
               (_loc9_ = new TextField()).autoSize = "left";
               _loc9_.antiAliasType = AntiAliasType.NORMAL;
               _loc10_ = 16;
               _loc9_.width = _loc3_ - _loc10_;
               _loc9_.multiline = true;
               _loc9_.wordWrap = true;
               _loc9_.selectable = false;
               MenuUtils.setupText(_loc9_,param2[_loc6_].description,21,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               CommonUtils.changeFontToGlobalIfNeeded(_loc9_);
               (_loc11_ = new TextFormat()).leading = 5;
               _loc11_.letterSpacing = 0.3;
               _loc9_.setTextFormat(_loc11_);
               _loc12_ = Math.ceil(_loc9_.numLines * param1.getScrollDist());
               if(_loc9_.height > _loc12_)
               {
                  _loc13_ = (_loc9_.height - _loc12_) / _loc9_.numLines;
                  _loc11_.leading = 5 - _loc13_;
                  _loc11_.letterSpacing = 0.3;
                  _loc9_.setTextFormat(_loc11_);
               }
               param1.appendEntry(_loc9_,false,_loc9_.height);
               _loc5_ = _loc4_;
            }
            if(param2[_loc6_].contract)
            {
               if(_loc5_ > 0)
               {
                  param1.addGap(_loc5_);
                  _loc5_ = 0;
               }
               (_loc14_ = new ModalDialogContractElement()).setData(param2[_loc6_].contract);
               param1.appendEntry(_loc14_,false,0,"contract");
               _loc5_ = _loc4_;
            }
            if(param2[_loc6_].dlcmissing)
            {
               if(_loc5_ > 0)
               {
                  param1.addGap(_loc5_);
                  _loc5_ = 0;
               }
               (_loc15_ = new ModalDialogDlcMissingElement()).setData(param2[_loc6_].dlcmissing);
               param1.appendEntry(_loc15_,false,0,"dlcmissing");
               _loc5_ = _loc4_;
            }
            if(param2[_loc6_].imagetext)
            {
               if(_loc5_ > 0)
               {
                  param1.addGap(_loc5_);
                  _loc5_ = 0;
               }
               (_loc16_ = new ModalDialogImageTextElement()).setData(param2[_loc6_].imagetext);
               param1.appendEntry(_loc16_,false,0,"imagetext");
               _loc5_ = _loc4_;
            }
            _loc6_++;
         }
      }
   }
}
