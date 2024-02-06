package hud.evergreen
{
   import common.BaseControl;
   import flash.display.Sprite;
   import hud.photomode.PhotoModeWidget;
   
   public class EvergreenSpycameraGridlines extends BaseControl
   {
       
      
      private var m_view:Sprite;
      
      public function EvergreenSpycameraGridlines()
      {
         super();
         this.m_view = new Sprite();
         this.m_view.visible = false;
         addChild(this.m_view);
      }
      
      public function setViewFinderStyle(param1:int) : void
      {
         switch(param1)
         {
            case PhotoModeWidget.VIEWFINDERSTYLE_NONE:
               this.m_view.visible = false;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_CAMERAITEM:
               this.m_view.visible = false;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_PHOTOOPP:
               this.m_view.visible = false;
               break;
            case PhotoModeWidget.VIEWFINDERSTYLE_SPYCAM:
               this.m_view.visible = true;
               break;
            default:
               this.m_view.visible = false;
         }
      }
      
      override public function onSetSize(param1:Number, param2:Number) : void
      {
         var _loc9_:spyCameraGridline = null;
         var _loc10_:spyCameraGridline = null;
         this.m_view.removeChildren();
         var _loc3_:uint = Math.floor(param1 / 47);
         var _loc4_:uint = Math.floor(param2 / 47);
         var _loc5_:Number = (_loc3_ - param1 / 47) * 47 / 2;
         var _loc6_:Number = (_loc4_ - param2 / 47) * 47 / 2;
         var _loc7_:uint = 0;
         while(_loc7_ <= _loc3_)
         {
            (_loc9_ = new spyCameraGridline()).alpha = 0.1;
            _loc9_.width = 1;
            _loc9_.height = param2;
            _loc9_.x = _loc7_ * 47 - _loc5_;
            _loc9_.y = 0;
            this.m_view.addChild(_loc9_);
            _loc7_++;
         }
         var _loc8_:uint = 0;
         while(_loc8_ <= _loc4_)
         {
            (_loc10_ = new spyCameraGridline()).alpha = 0.1;
            _loc10_.width = param1;
            _loc10_.height = 1;
            _loc10_.x = 0;
            _loc10_.y = _loc8_ * 47 - _loc6_;
            this.m_view.addChild(_loc10_);
            _loc8_++;
         }
      }
   }
}
