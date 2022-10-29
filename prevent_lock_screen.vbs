Dim durationHour
durationHour = InputBox("输入防止锁屏时长（小时）","Author", 1)

Dim timeMinutes
timeMinutes = InputBox("输入屏保时长（分钟）","Author", 3)

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

MsgBox "运行结束"