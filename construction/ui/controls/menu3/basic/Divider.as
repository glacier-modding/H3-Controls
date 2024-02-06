package menu3.basic
{
   import common.menu.MenuConstants;
   import flash.display.Sprite;
   import flash.geom.Point;
   import menu3.MenuElementBase;
   
   public dynamic class Divider extends MenuElementBase
   {
       
      
      private var m_spacer:Sprite;
      
      private var m_line:Sprite;
      
      public function Divider(param1:Object)
      {
         super(param1);
         this.m_spacer = new Sprite();
         addChild(this.m_spacer);
         this.m_line = new Sprite();
         addChild(this.m_line);
         this.createDivider(param1);
      }
      
      override public function onUnregister() : void
      {
         super.onUnregister();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         this.createDivider(param1);
      }
      
      private function createDivider(param1:Object) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         this.m_spacer.graphics.clear();
         this.m_line.graphics.clear();
         var _loc2_:Number = getWidth();
         var _loc3_:Number = getHeight();
         this.m_spacer.graphics.beginFill(16711680,0);
         this.m_spacer.graphics.drawRect(0,0,_loc2_,_loc3_);
         this.m_spacer.graphics.endFill();
         if(param1.showLine !== true)
         {
            return;
         }
         var _loc4_:Number = param1.lineWidth != null ? Number(param1.lineWidth) : 2;
         var _loc5_:String = param1.direction != null ? String(param1.direction) : "vertical";
         var _loc6_:Point = new Point(-1,0);
         if(_loc5_ == "vertical")
         {
            _loc7_ = _loc2_ / 2 - _loc4_ / 2;
            this.m_line.graphics.beginFill(MenuConstants.COLOR_RED,MenuConstants.MenuElementSelectedAlpha);
            this.m_line.graphics.drawRect(_loc6_.x + _loc7_,_loc6_.y,_loc4_,_loc3_);
            this.m_line.graphics.endFill();
         }
         else
         {
            _loc8_ = _loc3_ / 2 - _loc4_ / 2;
            this.m_line.graphics.beginFill(MenuConstants.COLOR_RED,MenuConstants.MenuElementSelectedAlpha);
            this.m_line.graphics.drawRect(_loc6_.x,_loc6_.y + _loc8_,_loc2_,_loc4_);
            this.m_line.graphics.endFill();
         }
      }
   }
}
