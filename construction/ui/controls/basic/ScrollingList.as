package basic
{
   import common.Animate;
   import common.BaseControl;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class ScrollingList extends BaseControl
   {
       
      
      private var m_container:Sprite;
      
      private var m_mask:Shape;
      
      private var m_sizeX:Number;
      
      private var m_sizeY:Number;
      
      public function ScrollingList()
      {
         this.m_container = new Sprite();
         this.m_mask = new Shape();
         super();
      }
      
      override public function onAttached() : void
      {
         addChild(this.m_container);
      }
      
      override public function getContainer() : Sprite
      {
         return this.m_container;
      }
      
      public function onSelectedIndexChanged(param1:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:BaseControl = this.getContainer().getChildAt(param1) as BaseControl;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.x + _loc2_.width / 2;
            _loc4_ = _loc2_.y + _loc2_.height / 2;
            _loc5_ = this.m_container.x;
            _loc6_ = this.m_container.y;
            if(this.m_container.width > this.m_sizeX)
            {
               _loc5_ = this.m_sizeX / 2 - _loc3_;
               _loc5_ = Math.max(_loc5_,this.m_sizeX - this.m_container.width);
               _loc5_ = Math.min(_loc5_,0);
            }
            if(this.m_container.height > this.m_sizeY)
            {
               _loc6_ = this.m_sizeY / 2 - _loc4_;
               _loc6_ = Math.max(_loc6_,this.m_sizeY - this.m_container.height);
               _loc6_ = Math.min(_loc6_,0);
            }
            Animate.legacyTo(this.m_container,0.5,{
               "x":_loc5_,
               "y":_loc6_
            },Animate.ExpoOut);
         }
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         this.m_sizeX = param1;
         this.m_sizeY = param2;
         this.m_mask.x = this.x;
         this.m_mask.y = this.y;
         this.m_mask.graphics.clear();
         this.m_mask.graphics.beginFill(16711680,1);
         this.m_mask.graphics.drawRect(0,0,param1 + 1,param2 + 1);
         this.m_mask.graphics.endFill();
         this.mask = this.m_mask;
      }
   }
}
