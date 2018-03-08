Attribute VB_Name = "Formula"
' E10.4��ʼ
Public Mono As String
Public Str0 As String
Public Str1 As String
Public Str2 As String
Dim L As Long
Public FuncLast As String
Function NumR(n As Integer) As String
    NumR = Application.WorksheetFunction.Roman(n)
End Function
Function NumC(n As Integer) As String
    Dim Str As Variant
    Str = Array("һ", "һ", "��", "��", "��", "��", "��", "��", "��", "��", "ʮ")
    If n < 11 Then
        NumC = Str(n)
    ElseIf n < 20 Then
        NumC = Str(10) & Str(n - 10)
    Else
        NumC = Str(n / 10) & Str(10) & Str(n Mod 10)
    End If
End Function
Sub Str_Div(Str As String, Div1 As String, Div2 As String)
    Str = Replace(Str, "//", "\")
    If Mono = "~" Then
        Div1 = Str
        Div2 = ""
    ElseIf Mono = "`" Then
        Div1 = ""
        Div2 = Str
    ElseIf InStr(Str, "/") > 0 Then
        Div1 = Left(Str, InStr(Str, "/") - 1)
        Div2 = Mid(Str, InStr(Str, "/") + 1)
    Else
        MsgBox ("ȱ�١�/��")
    End If
    Str = Replace(Str, "\", "//")
    Div1 = Replace(Div1, "\", "//")
    Div2 = Replace(Div2, "\", "//")
End Sub
Function Str_Comb(Div1 As String, Div2 As String) As String
    If Mono = "~" Then
        Str_Comb = Div1
    ElseIf Mono = "`" Then
        Str_Comb = Div2
    Else
        Str_Comb = Div1 & "/" & Div2
    End If
End Function
Function Form_Conv(FuncName As String, ArgN As Long, Arg() As String) As String
    Dim Conv1 As String
    Dim Conv2 As String
    Dim Tmp1 As String
    Dim Tmp2 As String
    Dim i As Long
    Select Case FuncName
    Case "st"
        If ArgN > 8 Then
            Form_Conv = "st(����|����)" & vbCrLf & "����/set"
            Exit Function
        End If
        Str_Div Arg(1), Conv1, Conv2
        Conv1 = Arg(0) & " " & Conv1
        Conv2 = Arg(0) & "��" & Conv2
    Case "ke"
        If ArgN > 8 Then
            Select Case ArgN
            Case 9
                Form_Conv = "ke(����|[��ʽ]|[����])" & vbCrLf & "����/key"
            Case 10
                Form_Conv = "ke������|[��ʽ]|[����])" & vbCrLf & "����/key"
            Case 11
                Form_Conv = "ke(������[��ʽ]|[����])" & vbCrLf & "1=�����0=С������=��"
            Case 12
                Form_Conv = "ke(����|[��ʽ]��[����])" & vbCrLf & "����/key"
            End Select
            Exit Function
        End If
        If Len(Arg(0)) = 2 Then
            If Right(Arg(0), 1) = "#" Then
                Conv1 = "-sharp"
                Conv2 = "��"
            Else
                Conv1 = "-flat"
                Conv2 = "��"
            End If
        End If
        If Arg(1) = "1" Then
            Conv1 = UCase(Left(Arg(0), 1)) & Conv1 & " major"
            Conv2 = Conv2 & UCase(Left(Arg(0), 1)) & "���"
        ElseIf Arg(1) = "0" Then
            Conv1 = UCase(Left(Arg(0), 1)) & Conv1 & " minor"
            Conv2 = Conv2 & LCase(Left(Arg(0), 1)) & "С��"
        Else
            Conv1 = UCase(Left(Arg(0), 1)) & Conv1
            Conv2 = Conv2 & UCase(Left(Arg(0), 1)) & "��"
        End If
        Str_Div Arg(2), Tmp1, Tmp2
        Conv1 = Tmp1 & " in " & Conv1
        Conv2 = Conv2 & Tmp2
    Case "no"
        If ArgN > 8 Then
            Form_Conv = "no(����|[���]|[�����ú���=0])" & vbCrLf & "���/number"
            Exit Function
        End If
        If ArgN = 0 Then
            Conv1 = "No. " & Arg(0)
            Conv2 = "��" & Arg(0) & "��"
        Else
            Str_Div Arg(1), Conv1, Conv2
            Conv1 = Conv1 & " No. " & Arg(0)
            If ArgN = 1 Then
                Conv2 = "��" & Arg(0) & "��" & Conv2
            Else
                Conv2 = "��" & NumC(Val(Arg(0))) & Conv2
            End If
        End If
    Case "na"
        If ArgN > 8 Then
            Form_Conv = "na(����)" & vbCrLf & "����/name"
            Exit Function
        End If
        Str_Div Arg(0), Conv1, Conv2
    Case "op"
        If ArgN > 8 Then
            Form_Conv = "op(����|[��Ʒ����]|[����Ʒ��])" & vbCrLf & "��Ʒ��/opus"
            Exit Function
        End If
        If ArgN = 0 Or Arg(1) = "" Then Arg(1) = "Op."
        Conv1 = ", " & Arg(1) & " " & Arg(0)
        Conv2 = Arg(1) & " " & Arg(0)
        If FuncLast = "op" Then Conv2 = "��" & Conv2 ' G10.21
        If ArgN = 2 Then
            If Arg(1) = "Op." Then
                Conv1 = Conv1 & " No. " & Arg(2)
                Conv2 = Conv2 & "��" & Arg(2) & "��"
            Else
                Conv1 = Conv1 & "//" & Arg(2)
                Conv2 = Conv2 & "//" & Arg(2)
            End If
        End If
    Case "ti"
        If ArgN > 8 Then
            Select Case ArgN
            Case 9
                Form_Conv = "ti(����|[����])" & vbCrLf & "����/title"
            Case 10
                Form_Conv = "ti������|[����])" & vbCrLf & "����/title"
            Case 11
                Form_Conv = "ti(���ƣ�[����])" & vbCrLf & "ti=���� al=���� ly=��� ex=���� tp=�ٶ�"
                Select Case Mid(FormEditor.TextBox1, FormEditor.TextBox1.SelStart - 1, 2)
                Case "ti"
                    Form_Conv = "ti(���ƣ�[����])" & vbCrLf & "����/title������ ���ڹŵ���Ʒ"
                Case "al"
                    Form_Conv = "ti(���ƣ�[����])" & vbCrLf & "����/alternative������ ���ڸ��Ƭ��"
                Case "ly"
                    Form_Conv = "ti(���ƣ�[����])" & vbCrLf & "���/lyrics��ð�� ���ڸ�糪��"
                Case "ex"
                    Form_Conv = "ti(���ƣ�[����])" & vbCrLf & "����/explain��ð�� ���ڸ�糡��"
                Case "tp"
                    Form_Conv = "ti(���ƣ�[����])" & vbCrLf & "�ٶȱ���/tempo���� �������·���"
                End Select
            End Select
            Exit Function
        End If
        If ArgN = 0 Then Arg(1) = "ti"
        Str_Div Arg(0), Conv1, Conv2
        Select Case Arg(1)
        Case "ti"
            Conv1 = " '" & Conv1 & "'"
            Conv2 = "��" & Conv2 & "��"
            If FuncLast <> "op" Then Conv1 = "," & Conv1
        Case "al"
            Conv1 = " (" & Conv1 & ")"
            Conv2 = "��" & Conv2 & "��"
        Case "ly"
            Conv1 = ": " & Conv1
            Conv2 = "��" & Conv2
        Case "ex"
            Conv1 = ": " & Conv1
            Conv2 = "��" & Conv2
        Case "tp"
            Conv1 = ". " & Conv1
            Conv2 = "��" & Conv2
        End Select
    Case "sp"
        If ArgN > 8 Then
            Select Case ArgN
            Case 9
                Form_Conv = "sp([����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/separate"
            Case 10
                Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "ac/pt=Ļ bk=�� sc=�� mv=���� su=���� st=���� op=�� ����"
                Select Case Mid(FormEditor.TextBox1, FormEditor.TextBox1.SelStart - 1, 2)
                Case "ac"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "Ļ/Act�����ţ�����"
                Case "pt"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/Part�����ţ�����"
                Case "bk"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "��/Book�����ţ�������"
                Case "sc"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "��/Scene��ð�ţ��������������ú��֣���sca��sct��scr��"
                Case "ca"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "��/Scene��ð�ţ�������������������"
                Case "ct"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "��/Scene��ð�ţ�������"
                Case "cr" ' E12.31
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "��/Scene��ð�ţ�����"
                Case "mv"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/Movement������ ���ڽ�������Э��������������"
                Case "su"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/Suite������ ���������⡢��ʽ��������������suc��suu��"
                Case "uc"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/Suite������ �����нṹ����˼����������������������"
                Case "uu"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/Suite�������� �����޹�����������ͼ��չ���ᣩ"
                Case "st"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/Set������������stn��"
                Case "tn"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/Set��No.�������������ס�����"
                Case "op"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "�����/Opera��No.������������stn��"
                Case "pa"
                    Form_Conv = "sp��[����]|[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "�����/Opera����������Cantata�ȣ�"
                End Select
            Case 11
                Form_Conv = "sp([����]��[����]|[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/separate"
            Case 12
                Form_Conv = "sp([����]|[����]��[����]|[ʹ�����ӷ�=1])" & vbCrLf & "����/separate"
            Case 13
                Form_Conv = "sp([����]|[����]|[����]��[ʹ�����ӷ�=1])" & vbCrLf & "����/separate"
            End Select
            Exit Function
        End If
        Select Case Arg(0)
        Case "ac"
            If ArgN = 1 Then Arg(2) = "Act/Ļ"
            Str_Div Arg(2), Conv1, Conv2
            Conv1 = ", " & Conv1 & " " & NumR(Val(Arg(1)))
            Conv2 = "����" & NumC(Val(Arg(1))) & Conv2
        Case "pt"
            If ArgN = 1 Then Arg(2) = "Part/����"
            Str_Div Arg(2), Conv1, Conv2
            Conv1 = ", " & Conv1 & " " & NumR(Val(Arg(1)))
            Conv2 = "����" & NumC(Val(Arg(1))) & Conv2
        Case "bk"
            If ArgN = 1 Then Arg(2) = "Book/��"
            Str_Div Arg(2), Conv1, Conv2
            Conv1 = ", " & Conv1 & " " & Arg(1)
            Conv2 = "����" & Arg(1) & Conv2
        Case "sc"
            If ArgN = 1 Then Arg(2) = "Scene/��" ' E12.31
            Str_Div Arg(2), Conv1, Conv2
            Conv1 = ": " & Conv1 & " " & Arg(1)
            Conv2 = "����" & NumC(Val(Arg(1))) & Conv2
        Case "sca"
            If ArgN = 1 Then Arg(2) = "Scene/��" ' F4.1
            Str_Div Arg(2), Conv1, Conv2
            Conv1 = ": " & Conv1 & " " & Arg(1)
            Conv2 = "����" & Arg(1) & Conv2
        Case "sct"
            Conv1 = ": Scene " & Arg(1)
            Conv2 = "����" & NumC(Val(Arg(1))) & "��"
        Case "scr" ' E12.31
            Str_Div Arg(2), Conv1, Conv2
            Conv1 = ": " & Conv1 & " " & NumR(Val(Arg(1)))
            Conv2 = "����" & NumC(Val(Arg(1))) & Conv2
        Case "mv"
            Conv1 = ": " & NumR(Val(Arg(1))) & ". "
            Conv2 = "��" & NumC(Val(Arg(1))) & "��"
        Case "su"
            If Arg(3) = "0" Then
                Conv1 = NumR(Val(Arg(1))) & ". "
                Conv2 = NumC(Val(Arg(1))) & "��"
            Else
                Conv1 = ": " & NumR(Val(Arg(1))) & ". "
                Conv2 = "��" & NumC(Val(Arg(1))) & "��"
            End If
        Case "suc"
            Conv1 = ": " & NumR(Val(Arg(1))) & ". "
            Conv2 = "��" & NumC(Val(Arg(1))) & "��"
        Case "suu"
            If ArgN = 1 Then
                Conv1 = ": " & Arg(1) & ". "
                Conv2 = "��" & Arg(1) & "��"
            Else
                Str_Div Arg(2), Conv1, Conv2
                Conv1 = ": " & Conv1 & " " & Arg(1) & ". "
                Conv2 = "��" & Conv2 & Arg(1) & "��"
            End If
        Case "st"
            Conv1 = ": " & Arg(1) & ". "
            Conv2 = "��" & Arg(1) & "��"
        Case "stn"
            Conv1 = ": No. " & Arg(1) & " "
            Conv2 = "��" & Arg(1) & "��"
        Case "op"
            Conv1 = ": No. " & Arg(1) & " "
            Conv2 = "��" & Arg(1) & "��"
        Case "opa"
            Conv1 = ": " & Arg(1) & ". "
            Conv2 = "��" & Arg(1) & "��"
        Case ""
            Conv1 = ": "
            Conv2 = "��"
        Case ","
            Conv1 = ", "
            Conv2 = "��"
        Case " "
            Conv1 = " "
            Conv2 = ""
        End Select
        If Arg(3) = "0" And (Left(Conv1, 1) = ":" Or Left(Conv1, 1) = ":") Then ' revised from above at E11.7
            Conv1 = Mid(Conv1, 3)
            Conv2 = Mid(Conv2, 2)
        End If
    Case "jc"
        If ArgN > 8 Then
            Select Case ArgN
            Case 9
                Form_Conv = "jc([ģʽ=0])" & vbCrLf & "����/junction"
            Case 10
                Form_Conv = "jc��[ģʽ=0])" & vbCrLf & "0=Ƭ�Σ�1=���£�2=����"
            End Select
            Exit Function
        End If
        If Arg(0) = "" Or Arg(0) = "0" Then
            Conv1 = " �C "
            Conv2 = "��"
        ElseIf Arg(0) = "1" Then
            Conv1 = " & "
            Conv2 = "��"
        Else
            Conv1 = " ... "
            Conv2 = "����"
        End If
    Case "tp"
        If ArgN > 8 Then
            Form_Conv = "tp(�ٶ�|[ǰ�ӵ�=0])" & vbCrLf & "�ٶ�/tempo"
            Exit Function
        End If
        Str_Div Arg(0), Conv1, Conv2
        If Arg(1) = "1" Then
            Conv1 = ". " & Conv1
            Conv2 = "��" & Conv2
        End If
    Case "ar"
        If ArgN > 8 Then
            Form_Conv = "ar([�ı���])" & vbCrLf & "�ı�/arrange����or��"
            Exit Function
        End If
        If Arg(0) = "" Then
            Conv1 = " (arr.)"
            Conv2 = "���ıࣩ"
        Else
            Str_Div Arg(0), Conv1, Conv2
            Conv1 = " (arr. " & Conv1 & ")"
            Conv2 = "��" & Conv2 & "�ıࣩ"
        End If
    Case "or"
        If ArgN > 8 Then
            Form_Conv = "or([�ı���])" & vbCrLf & "�����ְ�/orchestrate����ar��"
            Exit Function
        End If
        If Arg(0) = "" Then
            Conv1 = " (orch.)"
            Conv2 = "�������ְ棩"
        Else
            Str_Div Arg(0), Conv1, Conv2
            Conv1 = " (orch. " & Conv1 & ")"
            Conv2 = "��" & Conv2 & "�����ְ棩"
        End If
    Case "nt"
        If ArgN > 8 Then
            Form_Conv = "nt(����|[ǰ�пո�=1])" & vbCrLf & "ע��/note"
            Exit Function
        End If
        If ArgN = 0 Then Arg(1) = 1 ' F4.23 ����
        Str_Div Arg(0), Conv1, Conv2
        If Left(Conv1, 2) = ", " Then Conv1 = Mid(Conv1, 3) ' E12.15 (v2.2) ����
        If Left(Conv2, 1) = "��" Then Conv2 = Mid(Conv2, 2) ' E12.15 (v2.2) ����
        Conv1 = "(" & Conv1 & ")"
        Conv2 = "��" & Conv2 & "��"
        If Arg(1) = 1 Then Conv1 = " " & Conv1 ' F4.23 ����
    ' ����Ϊ2.1(2.0)�����еĺ���
    Case "cb"
        If ArgN > 8 Then
            Form_Conv = "cb(Ƭ��0|Ƭ��1|[Ƭ��2]|[Ƭ��3])" & vbCrLf & "�ַ���ƴ��/combine"
            Exit Function
        End If
        Str_Div Arg(0), Conv1, Conv2
        For i = 1 To ArgN
            Str_Div Arg(i), Tmp1, Tmp2
            Conv1 = Conv1 & Tmp1
            Conv2 = Conv2 & Tmp2
        Next i
    Case "rv" ' E12.15 (v2.2)
        If ArgN > 8 Then
            Form_Conv = "rv(Ƭ��0|Ƭ��1)" & vbCrLf & "�ַ����ߵ�/reverse"
            Exit Function
        End If
        Str_Div Arg(0), Conv1, Conv2
        Str_Div Arg(1), Tmp1, Tmp2
        Conv1 = Tmp1 & Conv1
        Conv2 = Tmp2 & Conv2
    Case "fo" ' F3.24 (v2.3)��F8.30����Arg(2)=2
        If ArgN > 8 Then
            If ArgN = 12 Then
                Form_Conv = "fo(��ʽ|������[�ִ�ʽ=0])" & vbCrLf & "0=�����ķ��룬1=Ϊ���������ģ�2=��for"
            Else
                Form_Conv = "fo(��ʽ|����|[�ִ�ʽ=0])" & vbCrLf & "Ϊ����������/for"
            End If
            Exit Function
        End If
        Str_Div Arg(0), Conv1, Conv2
        Str_Div Arg(1), Tmp1, Tmp2
        If ArgN = 1 Then Arg(2) = 0
        If Arg(2) = 0 Then
            Conv1 = Conv1 & " for " & Tmp1
            Conv2 = Tmp2 & Conv2
        ElseIf Arg(2) = 1 Then
            Conv1 = Conv1 & " for " & Tmp1
            Conv2 = "Ϊ" & Tmp2 & "������" & Conv2
        Else
            If Left(Tmp1, 1) = " " Then
                Conv1 = Conv1 & Tmp1
            Else
                Conv1 = Conv1 & " " & Tmp1
            End If
            Conv2 = Tmp2 & Conv2
        End If
    End Select
    Form_Conv = Str_Comb(Conv1, Conv2)
    FuncLast = FuncName
End Function
Function Form_Read(Start As Long, Optional SubFunc As Boolean = False, Optional Conv As String) As Long
    Dim FuncName As String
    Dim StrTmp As String
    Dim StrTmp1 As String
    Dim StrTmp2 As String
    Dim Arg(3) As String
    Dim ArgN As Long
    Dim i As Long
    
    FuncName = Mid(Str0, Start, 2)
    Start = Start + 3
    ArgN = 0
    For i = Start To L
        StrTmp = Mid(Str0, i, 1)
        If StrTmp = ")" Then
            Arg(ArgN) = Mid(Str0, Start, i - Start)
            Exit For
        ElseIf StrTmp = "|" Then
            Arg(ArgN) = Mid(Str0, Start, i - Start)
            ArgN = ArgN + 1
            Start = i + 1
        ElseIf StrTmp = "(" Then
            i = Form_Read(i - 2, True, Arg(ArgN))
            If Mid(Str0, i, 1) = ")" Then
                Exit For
            ElseIf Mid(Str0, i, 1) = "|" Then
                ArgN = ArgN + 1
                Start = i + 1 ' E12.15 (v2.2) ���Ӵ˾䡣����������ǰһ�������Ǻ�������һ���������ַ���ʱ��start�жϾͳ���
            End If
        End If
    Next i
    
    If False Then ' ���������� E12.15 ���
        Dim TempStr1 As String
        Dim j As Long
        TempStr1 = FuncName & "(" & ArgN & ")"
        For j = 0 To 3
            TempStr1 = TempStr1 & vbCrLf & "[" & j & "] " & Arg(j)
        Next j
        MsgBox TempStr1
    End If
    
    If SubFunc Then
        Conv = Form_Conv(FuncName, ArgN, Arg)
    Else
        Str_Div Form_Conv(FuncName, ArgN, Arg), StrTmp1, StrTmp2
        Str1 = Str1 & Replace(StrTmp1, "//", "/")
        Str2 = Str2 & Replace(StrTmp2, "//", "/")
    End If
    Form_Read = i + 1
End Function
Public Sub Form_ReadAll(Optional FormStr)
    Dim Start As Long
    If IsMissing(FormStr) Then
        Str0 = Cells(ActiveCell.Row, ColumnForm)
    Else
        Str0 = FormStr
    End If
    Str1 = ""
    Str2 = ""
    L = Len(Str0)
    FuncLast = ""
    
    If Left(Str0, 1) = "~" Then
        Mono = "~"
        Start = 2
    ElseIf Left(Str0, 1) = "`" Then
        Mono = "`"
        Start = 2
    Else
        Mono = ""
        Start = 1
    End If
    Do While Start < L
        Start = Form_Read(Start)
    Loop
End Sub
Sub Form_Test()
    Form_ReadAll
    If Mono = "~" Then
        If (Str1 = Cells(ActiveCell.Row, ColumnName)) Then
            MsgBox (Str1 & vbCrLf & "ƥ��")
        Else
            MsgBox (Str1 & vbCrLf & "��ƥ��")
        End If
    ElseIf Mono = "`" Then
        If (Str2 = Cells(ActiveCell.Row, ColumnName)) Then
            MsgBox (Str1 & vbCrLf & "ƥ��")
        Else
            MsgBox (Str1 & vbCrLf & "��ƥ��")
        End If
    Else
        If (Str1 & Chr(10) & Str2 = Cells(ActiveCell.Row, ColumnName)) Then
            MsgBox (Str1 & vbCrLf & Str2 & vbCrLf & "ƥ��")
        Else
            MsgBox (Str1 & vbCrLf & Str2 & vbCrLf & "��ƥ��")
        End If
    End If
End Sub
Sub Form_Produce()
    Form_ReadAll
    If Mono = "~" Then
        Cells(ActiveCell.Row, ColumnName) = Str1
    ElseIf Mono = "~" Then
        Cells(ActiveCell.Row, ColumnName) = Str2
    Else
        Cells(ActiveCell.Row, ColumnName) = Str1 & Chr(10) & Str2
    End If
End Sub
Sub Form_Box()
    FormEditor.Show (vbModeless)
End Sub ' E9.20
