Sub ConsolidateToMasterCAR()
    Dim ws As Worksheet
    Dim masterSheet As Worksheet
    Dim tbl As ListObject
    Dim pasteRow As Long
    Dim tblRange As Range
    Dim lastRow As Long
    Dim password As String
    
    ' Set password for unprotecting Master CAR
    password = "yourpassword" ' Change this to your actual password
    
    ' Set Master CAR sheet
    Set masterSheet = ThisWorkbook.Sheets("Master CAR")
    
    ' Unprotect Master CAR sheet
    masterSheet.Unprotect password
    
    ' Delete all rows from row 3 to infinity in Master CAR
    If masterSheet.Cells(masterSheet.Rows.Count, 1).End(xlUp).Row > 2 Then
        masterSheet.Rows("3:" & masterSheet.Rows.Count).Delete Shift:=xlUp
    End If
    
    ' Additionally, delete any objects (e.g., images) in Master CAR
    For Each obj In masterSheet.Shapes
        obj.Delete
    Next obj
    
    ' Initialize pasteRow
    pasteRow = 3
    
    ' Loop through all worksheets
    For Each ws In ThisWorkbook.Worksheets
        ' Check if worksheet name matches "CAR" followed by numbers (e.g., CAR1, CAR2, etc.)
        If ws.Visible = xlSheetVisible And ws.Name Like "CAR#" Then
            ' Check if there is a defined table in the worksheet
            If ws.ListObjects.Count > 0 Then
                ' Assume there is only one table per CARx sheet
                Set tbl = ws.ListObjects(1)
                
                ' Calculate the last row of the table
                lastRow = tbl.Range.Row + tbl.Range.Rows.Count
                
                ' Clear any data outside the table range, but only if it's within the valid worksheet range
                If lastRow < ws.Rows.Count Then
                    ws.Rows(lastRow + 1 & ":" & ws.Rows.Count).ClearContents
                End If
                
                ' Get the range of data within the table (excluding headers)
                Set tblRange = tbl.DataBodyRange
                
                ' Check if there are rows to copy
                If Not tblRange Is Nothing Then
                    ' Copy data from table to Master CAR sheet
                    tblRange.Copy
                    masterSheet.Cells(pasteRow, 1).PasteSpecial xlPasteValues
                    Application.CutCopyMode = False
                    
                    ' Update paste row for next set of data
                    pasteRow = masterSheet.Cells(masterSheet.Rows.Count, 1).End(xlUp).Row + 1
                End If
            End If
        End If
    Next ws
    
    ' Apply date formatting to relevant columns
    With masterSheet
        .Range("C3:C" & .Cells(.Rows.Count, 1).End(xlUp).Row).NumberFormat = "dd/mm/yyyy"
        .Range("K3:K" & .Cells(.Rows.Count, 1).End(xlUp).Row).NumberFormat = "dd/mm/yyyy"
        .Range("N3:N" & .Cells(.Rows.Count, 1).End(xlUp).Row).NumberFormat = "dd/mm/yyyy"
    End With
    
    ' Reprotect Master CAR sheet
    masterSheet.Protect password, UserInterfaceOnly:=True
    
    MsgBox "Data consolidated into Master CAR successfully!", vbInformation
End Sub

