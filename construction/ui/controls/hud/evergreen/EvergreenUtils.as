package hud.evergreen
{
   import common.Localization;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class EvergreenUtils
   {
      
      public static const LABELPURPOSE_NONE:int = 0;
      
      public static const LABELPURPOSE_ACTION_KILL_TYPE:int = 1;
      
      public static const LABELPURPOSE_POISON_LETHAL:int = 2;
      
      public static const LABELPURPOSE_POISON_EMETIC:int = 3;
      
      public static const LABELPURPOSE_POISON_SEDATIVE:int = 4;
      
      public static const LABELPURPOSE_ITEMRARITY_COMMON:int = 5;
      
      public static const LABELPURPOSE_ITEMRARITY_RARE:int = 6;
      
      public static const LABELPURPOSE_ITEMRARITY_EPIC:int = 7;
      
      public static const LABELPURPOSE_ITEMRARITY_LEGENDARY:int = 8;
      
      public static const LABELPURPOSE_LOSE_ON_WOUNDED:int = 9;
      
      public static const ITEMRARITY_SAFEHOUSEONLY:int = -1;
      
      public static const ITEMRARITY_NONE:int = 0;
      
      public static const ITEMRARITY_COMMON:int = 1;
      
      public static const ITEMRARITY_RARE:int = 2;
      
      public static const ITEMRARITY_EPIC:int = 3;
      
      public static const ITEMRARITY_LEGENDARY:int = 4;
      
      public static const LABELBGCOLOR:Vector.<uint> = new <uint>[16777215,4210754,16711740,8036144,10428060,3237406,1122670,7280494,15629830];
      
      public static const CRIMESECTOR_ARMSTRAFFICKING:int = 0;
      
      public static const CRIMESECTOR_ASSASSINATION:int = 1;
      
      public static const CRIMESECTOR_ORGANTRAFFICKING:int = 2;
      
      public static const CRIMESECTOR_BIGPHARMA:int = 3;
      
      public static const CRIMESECTOR_ECOCRIME:int = 4;
      
      public static const CRIMESECTOR_PSYOPS:int = 5;
      
      public static const CRIMESECTOR_ESPIONAGE:int = 6;
      
      public static const CRIMESECTOR_SICKGAMES:int = 7;
       
      
      public function EvergreenUtils()
      {
         super();
      }
      
      public static function disableMaskingInTextFields(param1:DisplayObjectContainer) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:TextField = null;
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:TextFormat = null;
         var _loc2_:int = param1.numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc5_ = (_loc4_ = param1.getChildAt(_loc3_)) as TextField) == null)
            {
               continue;
            }
            _loc7_ = _loc5_.defaultTextFormat;
            switch(_loc7_.align)
            {
               case TextFormatAlign.CENTER:
                  _loc5_.autoSize = TextFieldAutoSize.CENTER;
                  break;
               case TextFormatAlign.RIGHT:
               case TextFormatAlign.END:
                  _loc5_.autoSize = TextFieldAutoSize.RIGHT;
                  break;
               case TextFormatAlign.LEFT:
               case TextFormatAlign.START:
               case TextFormatAlign.JUSTIFY:
                  _loc5_.autoSize = TextFieldAutoSize.LEFT;
                  break;
            }
            if((_loc6_ = _loc4_ as DisplayObjectContainer) != null)
            {
               disableMaskingInTextFields(_loc6_);
            }
            _loc3_++;
         }
      }
      
      public static function isValidRarityLabel(param1:int) : Boolean
      {
         switch(param1)
         {
            case ITEMRARITY_COMMON:
            case ITEMRARITY_RARE:
            case ITEMRARITY_EPIC:
            case ITEMRARITY_LEGENDARY:
               return true;
            default:
               return false;
         }
      }
      
      public static function createRarityLabel(param1:int, param2:Boolean = true) : DisplayObject
      {
         var _loc3_:Shape = new Shape();
         var _loc4_:TextField = new TextField();
         _loc3_.name = "background";
         _loc4_.name = "txt";
         MenuUtils.setupText(_loc4_,"",30,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         switch(param1)
         {
            case ITEMRARITY_COMMON:
               _loc4_.text = Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_COMMON").toUpperCase();
               break;
            case ITEMRARITY_RARE:
               _loc4_.text = Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_RARE").toUpperCase();
               break;
            case ITEMRARITY_EPIC:
               _loc4_.text = Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_EPIC").toUpperCase();
               break;
            case ITEMRARITY_LEGENDARY:
               _loc4_.text = Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_LEGENDARY").toUpperCase();
               break;
            default:
               _loc4_.text = "???";
         }
         _loc4_.x = -_loc4_.width / 2;
         _loc4_.y = -_loc4_.height / 2 + 1;
         var _loc5_:uint = 0;
         switch(param1)
         {
            case ITEMRARITY_COMMON:
               _loc5_ = LABELBGCOLOR[LABELPURPOSE_ITEMRARITY_COMMON];
               break;
            case ITEMRARITY_RARE:
               _loc5_ = LABELBGCOLOR[LABELPURPOSE_ITEMRARITY_RARE];
               break;
            case ITEMRARITY_EPIC:
               _loc5_ = LABELBGCOLOR[LABELPURPOSE_ITEMRARITY_EPIC];
               break;
            case ITEMRARITY_LEGENDARY:
               _loc5_ = LABELBGCOLOR[LABELPURPOSE_ITEMRARITY_LEGENDARY];
         }
         var _loc6_:Number = 25;
         _loc3_.graphics.beginFill(_loc5_);
         _loc3_.graphics.drawRoundRect(-(_loc4_.width + _loc6_) / 2,-52 / 2,_loc4_.width + _loc6_,52,param2 ? 10 : 0);
         _loc3_.graphics.endFill();
         var _loc7_:Sprite;
         (_loc7_ = new Sprite()).addChild(_loc3_);
         _loc7_.addChild(_loc4_);
         return _loc7_;
      }
   }
}
