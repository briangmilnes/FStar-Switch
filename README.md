# FStar-Swich
An extension to Fstar Mode in Emacs that allows switching between F* installations and working in the compiler

##  Setting up 
 After loading this after loading fstar-mode.el you can
 
 M-x fstar-switch
 installation-type: opam
 installation-path (without ~, path to above FStar): /home/USER/

  to access your fstar installation and have includes for working inside the compiler. 

 or 
 
 M-x fstar-switch
 installation-type: system
 installation-path (without ~, path to above FStar): /home/USER/contrib 
 
  to access your fstar installation and have includes for working inside the compiler
  found in /home/USER/contrib/FStar

## Other benefits

 M-x compile will now recogize and count errors/warnings/infos and jump to many
  but not all file references.


