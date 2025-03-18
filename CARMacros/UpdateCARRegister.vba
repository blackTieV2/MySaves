Sub UpdateCARRegister()
    Dim ws As Worksheet
    Dim CARRegisterSheet As Worksheet
    Dim i As Long
    Dim totalActions As Long
    Dim closedActions As Long
    Dim password As String
    
    ' Set password for unprotecting CAR Register
    password = "1802698Mar" ' Change this to your actual password
    
    ' Set CAR Register sheet
    Set CARRegisterSheet = ThisWorkbook.Sheets("CAR Register")
    
    ' Unprotect CAR Register sheet
    CARRegisterSheet.Unprotect password
    
    ' Clear existing content in CAR Register sheet (except headers)
    CARRegisterSheet.Rows("2:" & CARRegisterSheet.Rows.Count).ClearContents

    ' Start populating from row 2
    i = 2

    ' Loop through all worksheets
    For Each ws In ThisWorkbook.Worksheets
        ' Check if the worksheet is visible and matches the name pattern
        If ws.Visible = xlSheetVisible And (ws.Name Like "CAR*" Or ws.Name = "Master CAR") Then
            If ws.Name <> "CAR Register" Then
                ' Populate worksheet name
                CARRegisterSheet.Cells(i, 1).Value = i - 1 ' Row number (starting from 1)
                CARRegisterSheet.Cells(i, 2).Value = ws.Name ' Sheet Name

                ' Populate description from cell I1 of each worksheet
                On Error Resume Next ' Skip error if I1 is empty or invalid
                CARRegisterSheet.Cells(i, 3).Value = ws.Range("I1").Value
                
                ' Populate type from cell J1 of each worksheet
                CARRegisterSheet.Cells(i, 4).Value = ws.Range("J1").Value
                
                ' Calculate # Actions (count rows starting from row 3 in column L)
                totalActions = Application.WorksheetFunction.CountA(ws.Range("L3:L" & ws.Cells(ws.Rows.Count, "L").End(xlUp).Row))
                CARRegisterSheet.Cells(i, 5).Value = totalActions
                
                ' Calculate # Actions Closed (count rows with "Closed" in column L starting from row 3)
                closedActions = Application.WorksheetFunction.CountIf(ws.Range("L3:L" & ws.Cells(ws.Rows.Count, "L").End(xlUp).Row), "Closed")
                CARRegisterSheet.Cells(i, 6).Value = closedActions
                
                ' Calculate % Closed (Column G)
                If totalActions > 0 Then
                    CARRegisterSheet.Cells(i, 7).Value = closedActions / totalActions
                    CARRegisterSheet.Cells(i, 7).NumberFormat = "0.00%" ' Format as percentage
                Else
                    CARRegisterSheet.Cells(i, 7).Value = "0%"
                End If

                i = i + 1
            End If
        End If
    Next ws
    
    ' Reprotect CAR Register sheet
    CARRegisterSheet.Protect password, UserInterfaceOnly:=True
    
    MsgBox "CAR Register updated successfully!", vbInformation
End Sub

