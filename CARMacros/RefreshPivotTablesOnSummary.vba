Sub RefreshPivotTablesOnSummary()
    Dim ws As Worksheet
    Dim pt As PivotTable
    Dim password As String
    
    ' Set password for protecting/unprotecting Summary sheet
    password = "1802698Mar"
    
    ' Set worksheet reference
    Set ws = ThisWorkbook.Sheets("Summary")
    
    ' Unprotect Summary sheet
    ws.Unprotect password
    
    ' Loop through all PivotTables on the Summary sheet and refresh them
    For Each pt In ws.PivotTables
        pt.RefreshTable
    Next pt
    
    ' Reprotect Summary sheet with supported options
    ws.Protect password:=password, _
               AllowFiltering:=True, _
               AllowSorting:=True, _
               AllowUsingPivotTables:=True, _
               UserInterfaceOnly:=True ' Allows VBA macros to modify the sheet
    
    ' Notify user
    MsgBox "Pivot tables on Summary sheet refreshed and updated successfully!", vbInformation
End Sub


