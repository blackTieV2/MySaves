Private Sub Workbook_SheetActivate(ByVal Sh As Object)
    Dim protectedSheets As Variant
    Dim sheetName As String
    Dim i As Integer
    
    ' Define sheets that should not be renamed
    protectedSheets = Array("CAR Register", "Summary", "MASTER") ' Add more if needed
    
    ' Check if the active sheet is one of the protected sheets
    For i = LBound(protectedSheets) To UBound(protectedSheets)
        If Sh.Name Like "CAR*" Or Sh.Name = protectedSheets(i) Then
            sheetName = Sh.Name
            Application.EnableEvents = False
            Sh.Name = sheetName ' Reset the name if changed
            Application.EnableEvents = True
        End If
    Next i
End Sub

Private Sub Workbook_SheetBeforeRightClick(ByVal Sh As Object, ByVal Target As Range, Cancel As Boolean)
    Dim protectedSheets As Variant
    Dim i As Integer
    
    ' Define protected sheets that cannot be deleted
    protectedSheets = Array("CAR Register", "Summary", "MASTER")
    
    ' Prevent deletion of CAR sheets or specific named sheets
    If Sh.Name Like "CAR*" Then
        MsgBox "You cannot delete CAR sheets!", vbExclamation, "Protected Sheet"
        Cancel = True
    End If
    
    ' Prevent deletion of specific sheets
    For i = LBound(protectedSheets) To UBound(protectedSheets)
        If Sh.Name = protectedSheets(i) Then
            MsgBox "The sheet '" & Sh.Name & "' is protected and cannot be deleted.", vbExclamation, "Protected Sheet"
            Cancel = True
        End If
    Next i
End Sub

Private Sub Workbook_SheetBeforeDoubleClick(ByVal Sh As Object, ByVal Target As Range, Cancel As Boolean)
    Dim password As String
    password = "1802698Mar" ' Use the same password as in your macro

    ' Check if the active sheet is "Summary"
    If Sh.Name = "Summary" Then
        ' Temporarily unprotect the sheet
        Sh.Unprotect password
        
        ' Allow Excel to process the double-click (drill-down)
        Cancel = False ' Ensures the normal double-click behavior works

        ' Re-protect the sheet after a short delay (1 second)
        Application.OnTime Now + TimeValue("00:00:01"), "ReprotectSummary"
    End If
End Sub

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


