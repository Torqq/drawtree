# drawtree
draw tree arborescence from script's folder.

# Execution
_____
Unblock scripts strategy :
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

*Automatically resets when the PowerShell session is closed

_____
Block scripts strategy :
If using a broader policy like -Scope CurrentUser or -Scope LocalMachine, 
you can reset the security to the default (Restricted) with:

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
or
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Restricted

*LocalMachine need admin
