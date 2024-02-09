package menu3.statistics
{
   import common.Animate;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import menu3.MenuElementBase;
   
   public dynamic class ProgressBarView extends MenuElementBase
   {
       
      
      private const ALMOST_ZERO_WIDTH:Number = 1;
      
      private const FRAME_THICKNESS:Number = 2;
      
      private var m_once:Boolean = true;
      
      private var m_textFieldTitle:TextField;
      
      private var m_textFieldProgress:TextField;
      
      private var m_spriteBar:Sprite;
      
      private var m_shapeFill:Shape;
      
      private var m_shapeFrame:Shape;
      
      private var m_xoffset:Number;
      
      private var m_yoffset:Number;
      
      private var m_width:Number;
      
      private var m_height:Number;
      
      private var m_fillcolor:int = 16777215;
      
      private var m_min:Number;
      
      private var m_max:Number;
      
      private var m_current:Number;
      
      private var m_title:String;
      
      private var m_titlefonttype:String;
      
      private var m_titlefontsize:int;
      
      private var m_titlefontcolor:String;
      
      private var m_progresstext:String;
      
      private var m_progresstextfonttype:String;
      
      private var m_progresstextfontsize:int;
      
      private var m_progresstextfontcolor:String;
      
      public function ProgressBarView(param1:Object)
      {
         super(param1);
         this.m_textFieldTitle = new TextField();
         this.m_textFieldTitle.name = "title";
         this.m_textFieldTitle.autoSize = TextFieldAutoSize.LEFT;
         this.m_textFieldTitle.wordWrap = false;
         this.m_textFieldTitle.multiline = false;
         MenuUtils.addDropShadowFilter(this.m_textFieldTitle);
         addChild(this.m_textFieldTitle);
         this.m_textFieldProgress = new TextField();
         this.m_textFieldProgress.name = "progress";
         this.m_textFieldProgress.autoSize = TextFieldAutoSize.LEFT;
         this.m_textFieldProgress.wordWrap = false;
         this.m_textFieldProgress.multiline = false;
         MenuUtils.addDropShadowFilter(this.m_textFieldProgress);
         addChild(this.m_textFieldProgress);
         this.m_spriteBar = new Sprite();
         this.m_spriteBar.name = "bar";
         MenuUtils.addDropShadowFilter(this.m_spriteBar);
         addChild(this.m_spriteBar);
         this.m_shapeFill = new Shape();
         this.m_shapeFill.name = "fill";
         createRectFill1x1(this.m_shapeFill,this.m_fillcolor);
         this.m_spriteBar.addChild(this.m_shapeFill);
         this.m_shapeFrame = new Shape();
         this.m_shapeFrame.name = "frame";
         this.m_spriteBar.addChild(this.m_shapeFrame);
      }
      
      private static function createRectFill1x1(param1:Shape, param2:int) : void
      {
         param1.graphics.clear();
         param1.graphics.beginFill(param2,1);
         param1.graphics.drawRect(0,0,1,1);
         param1.graphics.endFill();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.m_xoffset = param1.xoffset != null ? Number(param1.xoffset) : 0;
         this.m_yoffset = param1.yoffset != null ? Number(param1.yoffset) : 0;
         this.m_width = param1.width != null ? Number(param1.width) : 250;
         this.m_height = param1.height != null ? Number(param1.height) : 20;
         this.m_min = param1.min != null ? Number(param1.min) : 0;
         this.m_max = param1.max != null ? Number(param1.max) : 100;
         this.m_current = param1.current != null ? Number(param1.current) : 0;
         this.m_title = param1.title != null ? String(param1.title) : "";
         this.m_titlefonttype = param1.titlefonttype != null ? String(param1.titlefonttype) : MenuConstants.FONT_TYPE_MEDIUM;
         this.m_titlefontsize = param1.titlefontsize != null ? int(param1.titlefontsize) : 26;
         this.m_titlefontcolor = param1.titlefontcolorname != null ? MenuConstants.ColorString(MenuConstants.GetColorByName(param1.titlefontcolorname)) : MenuConstants.FontColorWhite;
         this.m_progresstext = param1.progresstext != null ? String(param1.progresstext) : null;
         this.m_progresstextfonttype = param1.progresstextfonttype != null ? String(param1.progresstextfonttype) : MenuConstants.FONT_TYPE_NORMAL;
         this.m_progresstextfontsize = param1.progresstextfontsize != null ? int(param1.progresstextfontsize) : 20;
         this.m_progresstextfontcolor = param1.progresstextfontcolorname != null ? MenuConstants.ColorString(MenuConstants.GetColorByName(param1.progresstextfontcolorname)) : MenuConstants.FontColorWhite;
         var _loc2_:Number = (this.m_current - this.m_min) / (this.m_max - this.m_min);
         var _loc3_:String = this.m_progresstext != null ? this.m_progresstext : Math.round(_loc2_ * 100) + "%";
         MenuUtils.setupText(this.m_textFieldTitle,this.m_title,this.m_titlefontsize,this.m_titlefonttype,this.m_titlefontcolor);
         this.m_textFieldTitle.x = this.m_xoffset;
         this.m_textFieldTitle.y = this.m_yoffset;
         MenuUtils.setupText(this.m_textFieldProgress,_loc3_,this.m_progresstextfontsize,this.m_progresstextfonttype,this.m_progresstextfontcolor);
         this.m_textFieldProgress.x = this.m_xoffset + this.m_width - this.m_textFieldProgress.width;
         this.m_textFieldProgress.y = this.m_yoffset;
         var _loc4_:Number = Math.max(this.m_textFieldTitle.height,this.m_textFieldProgress.height);
         this.m_textFieldTitle.y += _loc4_ - this.m_textFieldTitle.height;
         this.m_textFieldProgress.y += _loc4_ - this.m_textFieldProgress.height;
         this.m_shapeFrame.x = this.m_xoffset;
         this.m_shapeFrame.y = this.m_yoffset + _loc4_;
         if(this.m_shapeFrame.width != this.m_width || this.m_shapeFrame.height != this.m_height)
         {
            this.m_shapeFrame.graphics.clear();
            this.m_shapeFrame.graphics.lineStyle(this.FRAME_THICKNESS,16777215,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,1.4142);
            this.m_shapeFrame.graphics.drawRect(this.FRAME_THICKNESS / 2,this.FRAME_THICKNESS / 2,this.m_width - this.FRAME_THICKNESS,this.m_height - this.FRAME_THICKNESS);
         }
         this.m_shapeFill.x = this.m_xoffset + this.FRAME_THICKNESS / 2;
         this.m_shapeFill.y = this.m_yoffset + this.FRAME_THICKNESS / 2 + _loc4_;
         this.m_shapeFill.height = this.m_height - this.FRAME_THICKNESS;
         var _loc6_:Number;
         var _loc5_:Number;
         if((_loc6_ = (_loc5_ = this.m_width - this.FRAME_THICKNESS) * _loc2_) < this.ALMOST_ZERO_WIDTH)
         {
            _loc6_ = this.ALMOST_ZERO_WIDTH;
         }
         if(_loc6_ > _loc5_)
         {
            _loc6_ = _loc5_;
         }
         if(this.m_once)
         {
            this.m_shapeFill.width = _loc6_;
            this.m_once = false;
         }
         else
         {
            Animate.to(this.m_shapeFill,0.2,0,{"width":_loc6_},Animate.Linear);
         }
         var _loc7_:int;
         if((_loc7_ = param1.fillcolorname == null ? this.m_fillcolor : MenuConstants.GetColorByName(param1.fillcolorname)) != this.m_fillcolor)
         {
            this.m_fillcolor = _loc7_;
            createRectFill1x1(this.m_shapeFill,this.m_fillcolor);
         }
      }
      
      override public function onUnregister() : void
      {
         removeChild(this.m_textFieldTitle);
         removeChild(this.m_textFieldProgress);
         this.m_textFieldTitle = null;
         this.m_textFieldProgress = null;
         super.onUnregister();
      }
   }
}
