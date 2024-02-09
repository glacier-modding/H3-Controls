package menu3.statistics.elements
{
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import menu3.statistics.shapes.Trapezoid;
   
   public class RadarChartLabel extends Sprite
   {
       
      
      private var tf:TextField;
      
      private var tfContainer:Sprite;
      
      private var tfm:TextFormat;
      
      private var m_bgShape:Trapezoid;
      
      private var m_bgColor:uint = 16384014;
      
      private var m_title:String;
      
      private var m_titleRotation:Number;
      
      private var m_labelHeight:Number;
      
      private var m_labelSpacing:Number = 0;
      
      private var m_isPlayerValue:Boolean;
      
      private var m_baseLength:Number;
      
      private var m_apothem:Number;
      
      private var m_centralAngle:Number;
      
      public function RadarChartLabel(param1:String, param2:Number, param3:Number, param4:Boolean, param5:Number, param6:Number, param7:Number)
      {
         super();
         this.m_title = param1;
         this.m_titleRotation = param2;
         this.m_labelHeight = param3;
         this.m_isPlayerValue = param4;
         this.m_baseLength = param5;
         this.m_apothem = param6;
         this.m_centralAngle = param7;
         if(param4)
         {
            this.drawBackground();
         }
         this.setTitle();
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Point = new Point();
         _loc1_.x = -(this.m_baseLength / 2) + this.m_labelSpacing;
         _loc1_.y = -(this.m_apothem + 2);
         var _loc2_:Point = new Point();
         _loc2_.x = this.m_baseLength / 2 - this.m_labelSpacing;
         _loc2_.y = _loc1_.y;
         var _loc3_:Point = new Point();
         _loc3_.x = _loc1_.x - this.m_labelHeight * Math.tan(MenuUtils.toRadians(this.m_centralAngle / 2)) + this.m_labelSpacing;
         _loc3_.y = _loc1_.y - this.m_labelHeight;
         var _loc4_:Point;
         (_loc4_ = new Point()).x = _loc2_.x + this.m_labelHeight * Math.tan(MenuUtils.toRadians(this.m_centralAngle / 2)) - this.m_labelSpacing;
         _loc4_.y = _loc2_.y - this.m_labelHeight;
         this.m_bgShape = new Trapezoid(_loc1_,_loc3_,_loc4_,_loc2_,this.m_bgColor);
         addChild(this.m_bgShape);
      }
      
      private function setTitle() : void
      {
         this.tf = new TextField();
         this.tf.autoSize = TextFieldAutoSize.LEFT;
         MenuUtils.setupTextUpper(this.tf,this.m_title,16,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         this.tf.x = -this.tf.width / 2;
         this.tf.y = -this.tf.height / 2;
         this.tfContainer = new Sprite();
         this.tfContainer.x = 0;
         this.tfContainer.y = -(this.m_apothem + this.m_labelHeight / 2 + 2);
         var _loc1_:Boolean = MenuUtils.actualDegrees(this.m_titleRotation) > 90 && MenuUtils.actualDegrees(this.m_titleRotation) < 270 ? true : false;
         if(_loc1_)
         {
            this.tfContainer.rotation = 180;
         }
         this.tfContainer.addChild(this.tf);
         addChild(this.tfContainer);
      }
   }
}
