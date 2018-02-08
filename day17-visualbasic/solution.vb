Imports System
Imports System.Collections.Generic

Module Solution
    Const TOP1 As Integer = 2017
    Const TOP2 As Integer = 50000000


    Private Function spin(ByVal seed As Integer, 
            ByVal top as Integer) As Integer
        Dim pos As Integer
        Dim res As New ArrayList({0})

        For i As Integer = 1 To (top + 1)
            pos = (pos + seed + 1) Mod res.Count
            res.Insert(pos + 1, i)
        Next

        Return res(res.IndexOf(top) + 1)
    End Function


    Private Function spinNoBuf(ByVal seed As Integer, 
            ByVal top as Integer) As Integer
        Dim res, size, pos As Integer
        
        res = 0
        size = 1
        pos = 0

        For i As Integer = 1 To (top + 1)
            pos = (pos + seed + 1) Mod size
            If pos = 0 Then
                res = i
            End If
            size = size + 1
        Next

        Return res
    End Function


    Sub Main(args As String())
        Dim res1, res2, seed As Integer
        Dim reader As New System.IO.StreamReader("input.txt")

        seed = Integer.Parse(reader.ReadLine())

        res1 = spin(SEED, TOP1)
        Console.WriteLine("Part 1: " + String.Format(res1, "D"))

        res2 = spinNoBuf(SEED, TOP2)
        Console.WriteLine("Part 2: " + String.Format(res2, "D"))
    End Sub
End Module
