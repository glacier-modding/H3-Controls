package menu3.missionend
{
   public class LevelInfo
   {
       
      
      private var m_levelPointsAccum:Array;
      
      private var m_levelPointsOffset:int = 0;
      
      public function LevelInfo()
      {
         super();
      }
      
      public function init(param1:Array, param2:int) : void
      {
         if(param1 != null)
         {
            this.m_levelPointsAccum = param1;
            this.m_levelPointsOffset = param2;
         }
      }
      
      public function getLevelFromList(param1:Number) : Number
      {
         if(!this.m_levelPointsAccum)
         {
            return 1;
         }
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_levelPointsAccum.length)
         {
            if(param1 <= this.m_levelPointsAccum[_loc3_])
            {
               break;
            }
            _loc2_ = _loc3_ + this.m_levelPointsOffset;
            _loc3_++;
         }
         var _loc4_:int = this.m_levelPointsOffset + this.m_levelPointsAccum.length;
         var _loc5_:int = _loc2_ - this.m_levelPointsOffset;
         var _loc6_:Number = param1 - this.m_levelPointsAccum[_loc5_];
         var _loc7_:Number = 0;
         if(_loc2_ < _loc4_ - 1)
         {
            _loc7_ = _loc6_ / (this.m_levelPointsAccum[_loc5_ + 1] - this.m_levelPointsAccum[_loc5_]);
         }
         return _loc2_ + 1 + _loc7_;
      }
      
      public function isLevelMaxed(param1:Number) : Boolean
      {
         var _loc2_:int = int(this.m_levelPointsAccum.length - 1);
         if(param1 >= this.m_levelPointsAccum[_loc2_])
         {
            return true;
         }
         return false;
      }
      
      public function getMaxLevel() : int
      {
         return this.m_levelPointsAccum.length;
      }
   }
}
