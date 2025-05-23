# drawtree
Draw tree arborescence from script's folder, ideal for organization.

# Execution -> Linux
sudo ./drawtree.sh

# Execution -> Windows
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
