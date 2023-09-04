{ config, pkgs, inputs, lib, ...}:
{
  nixpkgs.overlays = [
    (self: super: {  
     qtile = super.qtile.overrideAttrs(oldAttrs: {  
         pythonPath = oldAttrs.pythonPath ++ (with self.python310Packages; [  
             iwlib
         ]);
       });  
     })  
  ];
}
