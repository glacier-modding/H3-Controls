package hud.evergreen.misc
{
   import common.menu.MenuUtils;
   import flash.display.Sprite;
   import hud.evergreen.worldmap.IconStackThinSlice;
   
   public class IconStack extends Sprite
   {
       
      
      private var m_icon:iconsAll76x76View;
      
      public function IconStack(param1:String)
      {
         this.m_icon = new iconsAll76x76View();
         super();
         this.m_icon.name = "m_icon";
         MenuUtils.setupIcon(this.m_icon,param1,16777215,false,false,16777215,0,0,true);
         this.m_icon.x = this.m_icon.width / 2;
         this.m_icon.y = this.m_icon.height / 2;
         addChild(this.m_icon);
      }
      
      public function set numItemsInStack(param1:int) : void
      {
         var _loc2_:IconStackThinSlice = null;
         while(numChildren > param1 + 1)
         {
            removeChild(getChildAt(numChildren - 1));
         }
         while(numChildren < param1)
         {
            if(numChildren != 0)
            {
               _loc2_ = new IconStackThinSlice();
               _loc2_.x = this.m_icon.x + this.m_icon.width / 2 + _loc2_.width * 2 * (numChildren - 0.5);
               _loc2_.y = this.m_icon.y;
               addChild(_loc2_);
            }
         }
      }
      
      public function get numItemsInStack() : int
      {
         return numChildren;
      }
   }
}
