package hud.evergreen
{
   public interface IMenuOverlayComponent
   {
       
      
      function isLeftAligned() : Boolean;
      
      function onControlLayoutChanged() : void;
      
      function onUsableSizeChanged(param1:Number, param2:Number, param3:Number) : void;
      
      function onSetData(param1:Object) : void;
   }
}
