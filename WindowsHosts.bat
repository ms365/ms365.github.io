set converted=y
@echo off
if defined converted goto :converted

set ConverterPath=%temp%\HostsGeter_CodeConverter.vbs
set ConverterOutput=%temp%\HostsGeter_GBK.bat

echo inputpath="%~0" >%ConverterPath%
echo outputpath="%ConverterOutput%" >>%ConverterPath%
echo set stm2=createobject("ADODB.Stream") >>%ConverterPath%
echo stm2.Charset ="utf-8" >>%ConverterPath%
echo stm2.Open >>%ConverterPath%
echo stm2.LoadFromFile inputpath >>%ConverterPath%
echo readfile = stm2.ReadText >>%ConverterPath%
echo stm2.Close >>%ConverterPath%
echo Set Stm1 =CreateObject("ADODB.Stream") >>%ConverterPath%
echo Stm1.Type = 2 >>%ConverterPath%
echo Stm1.Open >>%ConverterPath%
echo Stm1.Charset ="GBK" >>%ConverterPath%
echo Stm1.Position = Stm1.Size >>%ConverterPath%
echo Stm1.WriteText "set converted=y" ^& vbcrlf >>%ConverterPath%
echo Stm1.WriteText readfile >>%ConverterPath%
echo Stm1.SaveToFile outputpath,2 >>%ConverterPath%
echo Stm1.Close >>%ConverterPath%
%ConverterPath% && %ConverterOutput%
goto :eof

:converted

chcp 936
:: ����cmd���ڴ���ҳ�� 936(GBK)

cls
%1 %2
ver|find " 5.">nul &&goto :st
echo ���ڽ��� UAC ��Ȩ...
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :st","","runas",1)(window.close)&goto :eof
:st

cls

@REM HostsGet Version0.4
cd /d %~dp0

set LogFilePath=%temp%\HostsGeter_log.txt
set DLScriptPath=%temp%\downloadhosts.vbs
set DLPath=%windir%\system32\drivers\etc\hosts_downloaded
set BackupDir=%windir%\system32\drivers\etc
set HostsPath=%windir%\system32\drivers\etc\hosts

set LogToFile=^>^>%LogFilePath% 2^>^&1
set EchoAndLog=call :echoandlog
echo. %LogToFile%
echo ==========[%date% %time%]========== %LogToFile%
echo ��־�ļ���
echo %LogFilePath%
echo.

echo iLocal=LCase("%DLPath%") > %DLScriptPath% ||(
 call :error downloadhosts.vbs �ļ�����/д��ʧ��.
)
echo iRemote=LCase("http://rrkee.com/app/hosts.txt") >> %DLScriptPath%
echo Set xPost=createObject("Microsoft.XMLHTTP") 'Set Post = CreateObject("Msxml2.XMLHTTP") >> %DLScriptPath%
echo xPost.Open "GET",iRemote,0 >> %DLScriptPath%
echo xPost.Send() >> %DLScriptPath%
echo set sGet=createObject("ADODB.Stream") >> %DLScriptPath%
echo sGet.Mode=3 >> %DLScriptPath%
echo sGet.Type=1 >> %DLScriptPath%
echo sGet.Open() >> %DLScriptPath%
echo sGet.Write xPost.ResponseBody >> %DLScriptPath%
echo sGet.SaveToFile iLocal,2 >> %DLScriptPath%

%EchoAndLog% �������� hosts �ļ�...
if exist %DLPath% del %DLPath% /s /q %LogToFile%
%DLScriptPath% || call :error hosts �ļ�����ʧ��.
del %DLScriptPath% /s /q %LogToFile%
if not exist %DLPath% call :error hosts �ļ�����ʧ��.
%EchoAndLog% �������.
echo.

if exist %HostsPath% (
  call :backuphosts
) else (
  %EchoAndLog% ��ԭ hosts �ļ������ڣ��������ݣ�
)
%EchoAndLog% �����滻 hosts �ļ�...
move %DLPath% %HostsPath% %LogToFile% || call :error hosts �ļ��滻ʧ��.
%EchoAndLog% hosts �ļ����滻.
echo.

%EchoAndLog% ����ˢ��ϵͳ DNS ����...
ipconfig /flushdns %LogToFile% || call :error DNS ����ˢ��ʧ��.
%EchoAndLog% DNS ������ˢ��.
echo.
%EchoAndLog% ������ȫ����ɣ���
echo.

echo ����������� google.com.hk ���в��ԣ���ȡ������ֱ�ӹرձ�����
pause >nul
start https://www.google.com.hk
echo �Ѿ�������� google.com.hk ����Է������滻�ɹ�.
echo.
goto :end

:backuphosts
%EchoAndLog% ���ڱ���ԭ hosts �ļ�...
set "bakfilename=hosts_%date%_%time:~0,8%.bak"
set bakfilename=%bakfilename:/=-%
set bakfilename=%bakfilename:\=-%
set bakfilename=%bakfilename::=-%
set bakfilename=%bakfilename: =_%
copy %HostsPath% %BackupDir%\%bakfilename% %LogToFile% || call :error hosts �ļ�����ʧ��.
%EchoAndLog% ԭ hosts �ļ��ѱ��ݵ� %BackupDir%\%bakfilename%.
echo.
goto :eof

:error
echo ======================
%EchoAndLog% ����%*
start %LogFilePath%
echo �Ѵ���־�ļ�
goto :end

:echoandlog
echo %*
echo %* %LogToFile%
goto :eof

:end
echo ��������ر�
pause >nul
exit