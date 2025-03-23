'Very Fast Noise Function Library, by Aaditya Parashar (aadityap0901 @ qb64.boards.net)
'This code is optimised as much as I could

'$Dynamic
Dim As _Unsigned _Integer64 X, Y
Dim O As _Unsigned _Bit * 3: O = 7
Dim Shared perm(0 To 15, 0 To 15, 0 To 15) As Single
Const Smoothness = 64
Const W = 128
Const H = 128
Screen _NewImage(W, H, 32)
_FullScreen _SquarePixels
Dim Shared SEED As _Unsigned Integer
Dim As _Unsigned _Bit R: R = 1
Dim Time!
RePERM 'Initialize the perm(utation) array
'A simple Demo
Do
    Cls
    ST! = Timer(0.01)
    For X = 0 To W - 1
        For Y = 0 To H - 1
            If R Then
                PSet (X, Y), _RGB32(255 * fractal3!(X, Y, Time!, O, Smoothness), 255 * fractal3!(X - H, Y - H, Time!, O, Smoothness), 255 * fractal3!(X + H, Y + H, Time!, O, Smoothness))
            Else
                PSet (X, Y), _RGB32(255 * fractal3!(X, Y, Time!, O, Smoothness))
            End If
    Next Y, X
    Time! = Time! + 1
    T! = Timer(0.01) - ST!
    _Title "O=" + _Trim$(Str$(O)) + ",T:" + _Trim$(Str$(Int(T! * 100)))
    _Display
    'Controls:
    'T -> New Seed
    'O -> Increase Octaves, values range from 0 to 7
    'C -> Copy Screen Image to Clipboard
    'Esc -> Exit
    _Limit 60
    If _KeyDown(84) Or _KeyDown(116) Then RePERM
    If _KeyDown(79) Or _KeyDown(111) Then O = O + 1
    If _KeyDown(82) Or _KeyDown(114) Then R = 1 - R
    If _KeyDown(67) Or _KeyDown(99) Then _ClipboardImage = 0
    If _KeyDown(27) Then System
Loop Until Inp(&H60) = 1
System
'-------

Sub RePERM 'To reset the perm(utation) array with floating-point numbers between 0 and 1
    SEED = Timer
    Randomize SEED
    For I = 0 To 15
        For J = 0 To 15
            For K = 0 To 15
                perm(I, J, K) = Rnd
    Next K, J, I
End Sub

'X, Y, Z, W -> Coordinates
'O          -> Octaves
'S          -> Smoothness (should be more than 1 and an integer if possible, putting 1 gives random numbers)
Function fractal3! (X As Integer, Y As Integer, Z As Integer, O As _Unsigned _Byte, S As _Unsigned Long) Static 'noise function 3d with octaves
    Dim As Single a, t, d, I
    a = 1: t = 0: d = 0
    For I = 0 To O
        tX = X / a / S: tY = Y / a / S: tZ = Z / a / S
        fX& = Int(tX): fY& = Int(tY): fZ& = Int(tZ)
        dX! = tX - fX&: dY! = tY - fY&: dZ! = tZ - fZ&
        dX! = dX! * dX! * (3 - 2 * dX!)
        dY! = dY! * dY! * (3 - 2 * dY!)
        dZ! = dZ! * dZ! * (3 - 2 * dZ!)
        fX~`4 = fX& And 15: fY~`4 = fY& And 15: fZ~`4 = fZ& And 15
        fX1~`4 = fX~`4 + 1: fY1~`4 = fY~`4 + 1: fZ1~`4 = fZ~`4 + 1
        p000! = perm(fX~`4, fY~`4, fZ~`4): p010! = perm(fX1~`4, fY~`4, fZ~`4)
        p001! = perm(fX~`4, fY1~`4, fZ~`4): p011! = perm(fX1~`4, fY1~`4, fZ~`4)
        p100! = perm(fX~`4, fY~`4, fZ1~`4): p110! = perm(fX1~`4, fY~`4, fZ1~`4)
        p101! = perm(fX~`4, fY1~`4, fZ1~`4): p111! = perm(fX1~`4, fY1~`4, fZ1~`4)
        n00! = p000! + (p010! - p000!) * dX!: n01! = p001! + (p011! - p001!) * dX!
        n10! = p100! + (p110! - p100!) * dX!: n11! = p101! + (p111! - p101!) * dX!
        n0! = n00! + (n01! - n00!) * dY!
        n1! = n10! + (n11! - n10!) * dY!
        n! = n0! + (n1! - n0!) * dZ!
        t = t + a * n!: d = d + a: a = a / 2
    Next I
    fractal3! = t / d
End Function
