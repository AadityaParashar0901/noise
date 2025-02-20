'Very Fast Noise Function Library, by Aaditya Parashar (aadityap0901 @ qb64.boards.net)
'This code is optimised as much as I could

'$Dynamic
Dim As _Unsigned _Integer64 X, Y
Dim O As _Unsigned _Bit * 3: O = 7
Dim Shared perm(0 To 255, 0 To 255) As Single
Const Smoothness = 64
Const W = 640
Const H = 480
Screen _NewImage(W, H, 32)
Dim Shared SEED As _Unsigned Integer
RePERM 'Initialize the perm(utation) array
'A simple Demo
Dim R As _Unsigned _Bit: R = 0 'RGB
Do
    Cls
    If F Then _Title "Rendering: Octaves =" + Str$(O) + " Fade" Else _Title "Rendering: Octaves =" + Str$(O)
    ST! = Timer(0.01)
    For X = 0 To W - 1
        For Y = 0 To H - 1
            If R Then
                PSet (X, Y), _RGB32(255 * fractal2!(X, Y, O, Smoothness), 255 * fractal2!(X - W, Y - H, O, Smoothness), 255 * fractal2!(X + W, Y + H, O, Smoothness))
            Else
                PSet (X, Y), _RGB32(255 * fractal2!(X, Y, O, Smoothness))
            End If
    Next Y, X
    ST! = Timer(0.01) - ST!
    _Title "Octaves =" + Str$(O) + " Time:" + Str$(ST!)
    _Display
    Do
        'Controls:
        'R -> Toggle B&W, RGB
        'T -> New Seed
        'O -> Increase Octaves, values range from 0 to 7
        'C -> Copy Screen Image to Clipboard
        'Esc -> Exit
        _Limit 60
        If _KeyDown(70) Or _KeyDown(102) Then F = Not F: Exit Do
        If _KeyDown(82) Or _KeyDown(114) Then R = Not R: Exit Do
        If _KeyDown(84) Or _KeyDown(116) Then RePERM: Exit Do
        If _KeyDown(79) Or _KeyDown(111) Then O = O + 1: Exit Do
        If _KeyDown(67) Or _KeyDown(99) Then _ClipboardImage = 0
        If _KeyDown(27) Then System
    Loop
Loop Until Inp(&H60) = 1
System
'-------

Sub RePERM 'To reset the perm(utation) array with floating-point numbers between 0 and 1
    SEED = Timer
    Randomize SEED
    For I = 0 To 255
        For J = 0 To 255
            perm(I, J) = Rnd
    Next J, I
End Sub

'X, Y, Z, W -> Coordinates
'O          -> Octaves
'S          -> Smoothness (should be more than 1 and an integer if possible, putting 1 gives random numbers)
Function fractal2! (X As Integer, Y As Integer, O As _Unsigned _Byte, S As _Unsigned Long) Static 'noise function 2d with octaves
    Dim As Single a, t, d, I
    a = 1: t = 0: d = 0
    For I = 0 To O
        tX = X / a / S: tY = Y / a / S
        fX& = Int(tX): fY& = Int(tY)
        dX! = tX - fX&: dY! = tY - fY&
        dX! = ((6 * dX! - 15) * dX! + 10) * dX! * dX! * dX!: dY! = ((6 * dY! - 15) * dY! + 10) * dY! * dY! * dY!
        fX~%% = fX& And 255: fY~%% = fY& And 255
        fX1~%% = fX~%% + 1: fY1~%% = fY~%% + 1
        p00! = perm(fX~%%, fY~%%): p10! = perm(fX1~%%, fY~%%)
        p01! = perm(fX~%%, fY1~%%): p11! = perm(fX1~%%, fY1~%%)
        n0! = p00! + (p10! - p00!) * dX!: n1! = p01! + (p11! - p01!) * dX!
        n! = n0! + (n1! - n0!) * dY!
        t = t + a * n!: d = d + a: a = a / 2
    Next I
    fractal2! = t / d
End Function
