Sub CopyValidation(srcRange As Range, destRange As Range)
    Dim cell As Range
    Dim destCell As Range
    
    ' Loop through each cell in the source range (only row 3)
    For Each cell In srcRange.Cells
        On Error Resume Next ' Prevent error if validation does not exist
        If Not cell.Validation Is Nothing Then
            If cell.Validation.Type <> 0 Then ' 0 = xlNone
                On Error GoTo 0 ' Reset error handling
                Set destCell = destRange.Cells(1, cell.Column - srcRange.Column + 1) ' Adjust column offset
                cell.Copy
                destCell.PasteSpecial Paste:=xlPasteValidation
                Application.CutCopyMode = False
            End If
        End If
        On Error GoTo 0 ' Reset error handling
    Next cell
End Sub

