param([string]$Path = 'C:\Users\mgmoc\Baner_Fijo\android\gradle\wrapper\gradle-wrapper.properties')
$ErrorActionPreference = 'Stop'
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class LockInspector {
 [StructLayout(LayoutKind.Sequential)] public struct UniqueProcess { public int pid; public System.Runtime.InteropServices.ComTypes.FILETIME start; }
 [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)] public struct ProcessInfo {
  public UniqueProcess process;
  [MarshalAs(UnmanagedType.ByValTStr, SizeConst=256)] public string appName;
  [MarshalAs(UnmanagedType.ByValTStr, SizeConst=64)] public string serviceName;
  public uint appType; public uint status; public uint session;
  [MarshalAs(UnmanagedType.Bool)] public bool restartable;
 }
 [DllImport("rstrtmgr.dll", CharSet=CharSet.Unicode)] public static extern int RmStartSession(out uint handle, int flags, string key);
 [DllImport("rstrtmgr.dll", CharSet=CharSet.Unicode)] public static extern int RmRegisterResources(uint handle, uint files, string[] names, uint apps, IntPtr appList, uint services, string[] serviceNames);
 [DllImport("rstrtmgr.dll")] public static extern int RmGetList(uint handle, out uint needed, ref uint count, [In, Out] ProcessInfo[] infos, ref uint reboot);
 [DllImport("rstrtmgr.dll")] public static extern int RmEndSession(uint handle);
}
'@
[uint32]$handle=0
$r=[LockInspector]::RmStartSession([ref]$handle,0,[Guid]::NewGuid().ToString('N'))
if($r -ne 0){ throw "RmStartSession: $r" }
try {
 $r=[LockInspector]::RmRegisterResources($handle,1,@($Path),0,[IntPtr]::Zero,0,$null)
 if($r -ne 0){throw "RmRegisterResources: $r"}
 [uint32]$needed=0; [uint32]$count=0; [uint32]$reboot=0
 $r=[LockInspector]::RmGetList($handle,[ref]$needed,[ref]$count,$null,[ref]$reboot)
 if($r -eq 234){
  $count=$needed; $infos=New-Object 'LockInspector+ProcessInfo[]' $count
  $r=[LockInspector]::RmGetList($handle,[ref]$needed,[ref]$count,$infos,[ref]$reboot)
  if($r -ne 0){throw "RmGetList: $r"}
  $infos | ForEach-Object { [pscustomobject]@{Pid=$_.process.pid; App=$_.appName; Service=$_.serviceName; Restartable=$_.restartable} }
 } elseif($r -eq 0){Write-Output 'No hay procesos registrados con el archivo abierto.'} else {throw "RmGetList: $r"}
} finally { [void][LockInspector]::RmEndSession($handle) }
