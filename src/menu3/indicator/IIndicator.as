package menu3.indicator
{
   public interface IIndicator
   {
       
      
      function onSetData(param1:*, param2:Object) : void;
      
      function onUnregister() : void;
      
      function callTextTicker(param1:Boolean) : void;
      
      function setVisible(param1:Boolean) : void;
   }
}
