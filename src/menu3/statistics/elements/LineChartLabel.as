package menu3.statistics.elements
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class LineChartLabel extends Sprite
   {
      
      public static const TEXT_ORIENTATION_LEFT:String = "left";
      
      public static const TEXT_ORIENTATION_CENTER:String = "center";
      
      public static const TEXT_ORIENTATION_RIGHT:String = "right";
       
      
      private var m_title:String;
      
      private var m_icon:Sprite;
      
      private var m_useIcon:Boolean;
      
      private var m_iconColor:uint;
      
      private var m_textOrientation:String;
      
      public function LineChartLabel(param1:String, param2:Boolean, param3:uint, param4:String = "left")
      {
         super();
         this.m_title = param1;
         this.m_useIcon = param2;
         this.m_iconColor = param3;
         this.m_textOrientation = param4;
         if(param2)
         {
            this.drawIcon();
         }
         this.setTitle();
      }
      
      private function drawIcon() : void
      {
         this.m_icon = new Sprite();
         this.m_icon.graphics.clear();
         this.m_icon.graphics.beginFill(this.m_iconColor,1);
         this.m_icon.graphics.drawCircle(0,0,6);
         this.m_icon.graphics.endFill();
         addChild(this.m_icon);
      }
      
      private function setTitle() : void
      {
         var _loc1_:TextField = new TextField();
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         MenuUtils.setupTextUpper(_loc1_,this.m_title,14,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         if(this.m_textOrientation == TEXT_ORIENTATION_LEFT)
         {
            if(this.m_useIcon)
            {
               _loc1_.x = this.m_icon.x + this.m_icon.width;
            }
         }
         else if(this.m_textOrientation == TEXT_ORIENTATION_RIGHT)
         {
            if(this.m_useIcon)
            {
               _loc1_.x = this.m_icon.x - this.m_icon.width - _loc1_.width;
            }
            else
            {
               _loc1_.x = -_loc1_.width;
            }
         }
         else if(this.m_textOrientation == TEXT_ORIENTATION_CENTER)
         {
            _loc1_.x = -(_loc1_.width / 2);
         }
         _loc1_.y = -_loc1_.height / 2;
         addChild(_loc1_);
      }
   }
}
