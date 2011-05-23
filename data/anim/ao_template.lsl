default {
 
  touch_start(integer inum) { 
    llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
  }

  run_time_permissions(integer perm) {
    if(perm & PERMISSION_TRIGGER_ANIMATION) {
      list anims = llGetAnimationList(llGetPermissionsKey()); // get list of animations
      integer len = llGetListLength(anims);
      integer i;

      llSay(0, "Stopping " + (string)len + llGetSubString(" animations",0,-1 - (len == 1)));//strip the "s" when there is only 1 to stop.
      for (i = 0; i < len; ++i) llStopAnimation(llList2Key(anims, i));
      llSay(0, "Done");
      llSetTimerEvent(0.75);
    }
  }

  timer() {
    list anims = llGetAnimationList(llGetPermissionsKey()); // get list of animations
    integer len = llGetListLength(anims);
    integer i;

    //llSay(0,llList2String(anims,0));
    if(llList2String(anims,0) == "6ed24bd8-91aa-4b12-ccc7-c97c857ab4e0") {
      llStartAnimation("Femwalkstiletto");
      llStopAnimation("waiting");
    }
    else if(llList2String(anims,0) == "2408fe9e-df1d-1d7d-f4ff-1384fa7b350f") {
      llStartAnimation("waiting");
      llStopAnimation("Femwalkstiletto");
    }
  }

}