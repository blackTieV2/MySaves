Sub ReprotectSummary()
    Dim ws As Worksheet
    Dim password As String
    
    password = "1802698Mar"
    Set ws = ThisWorkbook.Sheets("Summary")
    
    ' Reprotect the sheet after drill-down
    ws.Protect password:=password, _
               AllowFiltering:=True, _
               AllowSorting:=True, _
               AllowUsingPivotTables:=True, _
               UserInterfaceOnly:=True
End Sub


