package menu3.modal
{
   import common.Log;
   
   public class ModalDialogValidator
   {
       
      
      private var m_validators:Array;
      
      public function ModalDialogValidator(param1:Array)
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:ModalDialogValidation = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         this.m_validators = [];
         super();
         if(param1 == null)
         {
            Log.info(Log.ChannelModal,this,"No validation data - dialog Validation disabled");
            return;
         }
         Log.info(Log.ChannelModal,this,"Found a validation array");
         for each(_loc2_ in param1)
         {
            _loc3_ = String(_loc2_.type);
            if(_loc3_ == null || _loc3_.length == 0)
            {
               _loc3_ = "regex";
            }
            _loc4_ = null;
            switch(_loc3_)
            {
               case "regex":
                  if((_loc5_ = _loc2_.regEx) != null && _loc5_.source != undefined && _loc5_.flags != undefined)
                  {
                     _loc4_ = new ModalDialogRegexValidation(_loc2_,_loc5_);
                  }
                  else
                  {
                     Log.xerror(Log.ChannelModal,"regex validator definition not valid");
                     Log.debugData(this,_loc2_);
                  }
                  break;
               case "platformid":
                  if((_loc6_ = String(_loc2_.platformid)) != null)
                  {
                     _loc4_ = new ModalDialogPlatformIdValidation(_loc2_,_loc6_);
                  }
                  else
                  {
                     Log.xerror(Log.ChannelModal,"platformid validator definition not valid");
                     Log.debugData(this,_loc2_);
                  }
            }
            if(_loc4_ != null)
            {
               this.m_validators.push(_loc4_);
            }
         }
      }
      
      public function validate(param1:String) : ModalDialogValidation
      {
         var _loc3_:ModalDialogValidation = null;
         var _loc2_:ModalDialogValidation = null;
         for each(_loc3_ in this.m_validators)
         {
            if(!_loc3_.validate(param1))
            {
               if(_loc2_ == null || _loc2_.getLevel() < _loc3_.getLevel())
               {
                  _loc2_ = _loc3_;
               }
            }
         }
         if(_loc2_ != null)
         {
            Log.xinfo(Log.ChannelModal,"returning validator that failed on \'" + param1 + "\' level=" + _loc2_.getLevel() + " message=\'" + _loc2_.getMessage() + "\'");
         }
         return _loc2_;
      }
   }
}
