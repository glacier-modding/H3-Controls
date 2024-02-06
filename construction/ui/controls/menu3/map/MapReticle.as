package menu3.map
{
   import common.BaseControl;
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MapReticle extends BaseControl
   {
       
      
      private var m_view:MapReticleView;
      
      private var m_found:Boolean;
      
      public function MapReticle()
      {
         super();
         this.m_view = new MapReticleView();
         MenuUtils.addDropShadowFilter(this.m_view.reticle);
         MenuUtils.addDropShadowFilter(this.m_view.finder);
         addChild(this.m_view);
      }
      
      public function scaledHitTest(param1:Object) : int
      {
         var _loc14_:Sprite = null;
         var _loc15_:Rectangle = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc2_:Sprite = this.m_view.reticle as Sprite;
         var _loc3_:Number = param1.hitTestSize as Number;
         var _loc4_:Boolean = param1.isUsingMouse as Boolean;
         var _loc5_:Boolean = Boolean(param1.isMapHandlingInput);
         var _loc6_:Rectangle = _loc2_.getBounds(this);
         var _loc7_:Point = new Point();
         if(!_loc4_)
         {
            _loc7_.x = _loc6_.x + _loc6_.width / 2;
            _loc7_.y = _loc6_.y + _loc6_.height / 2;
         }
         else
         {
            _loc7_.x = _loc6_.x + _loc6_.width / 2 + _loc2_.mouseX;
            _loc7_.y = _loc6_.y + _loc6_.height / 2 + _loc2_.mouseY;
         }
         var _loc8_:int = -1;
         var _loc9_:Number = 1000000000;
         var _loc10_:Number = 1000000000;
         var _loc11_:Number = this.m_view.finder.x;
         var _loc12_:Number = this.m_view.finder.y;
         var _loc13_:int = 0;
         while(_loc13_ < param1.subjects.length)
         {
            if(param1.subjects[_loc13_] != null)
            {
               if((_loc14_ = param1.subjects[_loc13_].getBoundsView() as Sprite) != null)
               {
                  _loc15_ = _loc14_.getBounds(this);
                  if((_loc16_ = this.distancePointRect(_loc7_,_loc15_)) < _loc3_)
                  {
                     if((_loc17_ = this.distancePointRectCenter(_loc7_,_loc15_)) < _loc10_)
                     {
                        _loc9_ = _loc16_;
                        _loc10_ = _loc17_;
                        _loc8_ = _loc13_;
                        _loc11_ = this.m_view.finder.x - (_loc15_.x + _loc15_.width / 2);
                        _loc12_ = this.m_view.finder.y - (_loc15_.y + _loc15_.height / 2);
                     }
                  }
               }
            }
            _loc13_++;
         }
         if(_loc8_ == -1)
         {
            if(this.m_found)
            {
               this.m_view.finder.gotoAndStop(1);
               this.m_found = false;
            }
            if(_loc4_ && Boolean(param1.isMapHandlingInput))
            {
               this.m_view.finder.x += this.m_view.finder.mouseX;
               this.m_view.finder.y += this.m_view.finder.mouseY;
            }
            else
            {
               this.m_view.finder.x -= this.m_view.finder.x / 5;
               this.m_view.finder.y -= this.m_view.finder.y / 5;
            }
         }
         else
         {
            if(!this.m_found)
            {
               this.m_view.finder.gotoAndPlay(2);
               this.m_found = true;
            }
            if(_loc4_)
            {
               this.m_view.finder.x -= _loc11_;
               this.m_view.finder.y -= _loc12_;
            }
            else
            {
               this.m_view.finder.x -= _loc11_ / 3;
               this.m_view.finder.y -= _loc12_ / 3;
            }
         }
         if(_loc4_)
         {
            this.m_view.finder.visible = this.m_found || !_loc5_;
            this.m_view.reticle.visible = !_loc5_;
         }
         else
         {
            this.m_view.finder.visible = true;
            this.m_view.reticle.visible = true;
         }
         return _loc8_;
      }
      
      private function distancePointRectCenter(param1:Point, param2:Rectangle) : Number
      {
         var _loc3_:Point = new Point();
         _loc3_.x = param2.x + param2.width / 2;
         _loc3_.y = param2.y + param2.height / 2;
         return this.distanceFromPointToRectCenter(param1,_loc3_);
      }
      
      private function distanceFromPointToRectCenter(param1:Point, param2:Point) : Number
      {
         return Math.sqrt(Math.pow(param1.x - param2.x,2) + Math.pow(param1.y - param2.y,2));
      }
      
      private function distancePointRect(param1:Point, param2:Rectangle) : Number
      {
         return this.distanceFromPointToRect(param1.x,param1.y,param2.x,param2.y,param2.width,param2.height);
      }
      
      private function distanceFromPointToRect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         var _loc7_:Number = Math.max(Math.min(param1,param3 + param5),param3);
         var _loc8_:Number = Math.max(Math.min(param2,param4 + param6),param4);
         return Math.sqrt((param1 - _loc7_) * (param1 - _loc7_) + (param2 - _loc8_) * (param2 - _loc8_));
      }
   }
}
