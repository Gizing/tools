Dim durationHour
durationHour = InputBox("�����ֹ����ʱ����Сʱ��","Author", 1)

Dim timeMinutes
timeMinutes = InputBox("��������ʱ�������ӣ�","Author", 3)

Dim durationLoops
durationLoops = CInt(CDbl(durationHour) * (60 / CInt(timeMinutes))) + 1

Dim interval
interval = timeMinutes * 60 * 1000 - 1000

Set wshShell = WScript.CreateObject("WScript.Shell")

for i = 0 to durationLoops
wshShell.SendKeys "{NUMLOCK}"
Wscript.sleep 500
wshShell.SendKeys "{NUMLOCK}"
Wscript.sleep interval
next

MsgBox "���н���"