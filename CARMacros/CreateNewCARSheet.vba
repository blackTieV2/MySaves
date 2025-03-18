Sub CreateNewCARSheet()
    Dim ws As Worksheet
    Dim newSheet As Worksheet
    Dim CARRegisterSheet As Worksheet
    Dim nextSequence As Integer
    Dim CARName As String
    Dim auditType As String
    Dim sourceSheet As Worksheet
    
    ' Set CAR Register sheet
    Set CARRegisterSheet = ThisWorkbook.Sheets("CAR Register")
    
    ' Determine the next sequence number
    nextSequence = 0
    For Each ws In ThisWorkbook.Worksheets
        If ws.Name Like "CAR*" Then
            Dim seq As Integer
            If Len(ws.Name) > 3 Then
                Dim strSeq As String
                strSeq = Right(ws.Name, Len(ws.Name) - 3)
                If IsNumeric(strSeq) Then
                    seq = CInt(strSeq)
                    If seq > nextSequence Then nextSequence = seq
                End If
            End If
        End If
    Next ws
    nextSequence = nextSequence + 1
    
    ' Prompt user for CAR name and audit type
    CARName = InputBox("Enter the Name of the CAR:", "CAR Name")
    auditType = InputBox("Enter the Type of Audit:", "Audit Type")
    
    ' Create a new sheet
    Set newSheet = ThisWorkbook.Worksheets.Add(After:=ThisWorkbook.Worksheets(ThisWorkbook.Worksheets.Count))
    newSheet.Name = "CAR" & nextSequence
    
    ' Copy header rows from an existing CARxx sheet
    Set sourceSheet = ThisWorkbook.Worksheets("CAR1") ' Use CAR1 as a template
    sourceSheet.Rows("1:2").Copy Destination:=newSheet.Rows("1:2")
    
    ' Copy column widths
    sourceSheet.Cells.Copy
    newSheet.Cells.PasteSpecial Paste:=xlPasteColumnWidths
    Application.CutCopyMode = False
    
    ' Set up table structure
    With newSheet
        .Range("A3").Select
        .ListObjects.Add(xlSrcRange, .Range("A2:P2"), , xlYes).Name = "tCAR" & nextSequence
        .Range("I1").Value = CARName
        .Range("J1").Value = auditType
        
        ' ?? Copy Data Validation only for Row 3 (D3, H3, J3, L3)
        CopyValidation sourceSheet.Range("D3"), newSheet.Range("D3")
        CopyValidation sourceSheet.Range("H3"), newSheet.Range("H3")
        CopyValidation sourceSheet.Range("J3"), newSheet.Range("J3")
        CopyValidation sourceSheet.Range("L3"), newSheet.Range("L3")
        
        ' ?? Apply Date Validation for C3 only
        .Range("C3").Validation.Delete
        .Range("C3").Validation.Add Type:=xlValidateDate, AlertStyle:=xlValidAlertStop, _
            Operator:=xlBetween, Formula1:="=TODAY()-365", Formula2:="=TODAY()+365"
    End With
    
    MsgBox "New CAR sheet created successfully!", vbInformation
End Sub


