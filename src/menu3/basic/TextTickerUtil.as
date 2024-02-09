package menu3.basic
{
   import common.menu.MenuUtils;
   import common.menu.textTicker;
   import flash.text.TextField;
   
   public class TextTickerUtil
   {
       
      
      private var m_textTickerConfigurations:Array;
      
      public function TextTickerUtil()
      {
         this.m_textTickerConfigurations = new Array();
         super();
      }
      
      public function addTextTicker(param1:TextField, param2:String, param3:String = null, param4:int = -1) : void
      {
         var _loc5_:textTicker = new textTicker();
         this.m_textTickerConfigurations.push({
            "indicatortextfield":param1,
            "title":param2,
            "textticker":_loc5_,
            "fontcolor":param3,
            "textfieldcolor":param4
         });
      }
      
      public function addTextTickerHtmlWithTitle(param1:TextField, param2:String, param3:Number = 0) : void
      {
         var _loc4_:textTicker = new textTicker();
         this.m_textTickerConfigurations.push({
            "indicatortextfield":param1,
            "title":param2,
            "textticker":_loc4_,
            "resetdelay":param3,
            "isHtmlTicker":true
         });
      }
      
      public function addTextTickerHtml(param1:TextField, param2:Number = 0) : void
      {
         var _loc3_:textTicker = new textTicker();
         this.m_textTickerConfigurations.push({
            "indicatortextfield":param1,
            "title":param1.htmlText,
            "textticker":_loc3_,
            "resetdelay":param2,
            "isHtmlTicker":true
         });
      }
      
      public function callTextTicker(param1:Boolean, param2:int = -1) : void
      {
         var _loc4_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_textTickerConfigurations.length)
         {
            if((_loc4_ = this.m_textTickerConfigurations[_loc3_]).isHtmlTicker === true)
            {
               if(param1)
               {
                  _loc4_.textticker.startTextTickerHtml(_loc4_.indicatortextfield,_loc4_.title,null,_loc4_.resetdelay);
               }
               else
               {
                  _loc4_.textticker.stopTextTicker(_loc4_.indicatortextfield,_loc4_.title);
                  MenuUtils.truncateTextfield(_loc4_.indicatortextfield,1);
               }
            }
            else if(param1)
            {
               _loc4_.textticker.startTextTicker(_loc4_.indicatortextfield,_loc4_.title);
               if(Boolean(_loc4_.textfieldcolor) && _loc4_.textfieldcolor != -1)
               {
                  _loc4_.indicatortextfield.textColor = _loc4_.textfieldcolor;
               }
               if(Boolean(param2) && param2 != -1)
               {
                  _loc4_.indicatortextfield.textColor = param2;
               }
            }
            else
            {
               _loc4_.textticker.stopTextTicker(_loc4_.indicatortextfield,_loc4_.title);
               if(_loc4_.fontcolor != null && _loc4_.fontcolor.length > 0)
               {
                  if(Boolean(_loc4_.textfieldcolor) && _loc4_.textfieldcolor != -1)
                  {
                     _loc4_.indicatortextfield.textColor = _loc4_.textfieldcolor;
                  }
                  MenuUtils.truncateTextfield(_loc4_.indicatortextfield,1,_loc4_.fontcolor);
               }
               else if(Boolean(param2) && param2 != -1)
               {
                  _loc4_.indicatortextfield.textColor = param2;
                  MenuUtils.truncateTextfield(_loc4_.indicatortextfield,1,null);
               }
               else
               {
                  MenuUtils.truncateTextfield(_loc4_.indicatortextfield,1);
               }
            }
            _loc3_++;
         }
      }
      
      public function clearOnly() : void
      {
         this.m_textTickerConfigurations = new Array();
      }
      
      public function resetTextTickers() : void
      {
         if(this.m_textTickerConfigurations.length == 0)
         {
            return;
         }
         this.stopTextTickers();
         this.m_textTickerConfigurations = new Array();
      }
      
      public function onUnregister() : void
      {
         this.resetTextTickers();
      }
      
      public function stopTextTickers() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_textTickerConfigurations.length)
         {
            _loc2_ = this.m_textTickerConfigurations[_loc1_];
            _loc2_.textticker.stopTextTicker(_loc2_.indicatortextfield,_loc2_.title);
            _loc1_++;
         }
      }
   }
}
