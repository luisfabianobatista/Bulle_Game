'#####################################################################
'BULLE GAME
'UQAM - EMB7020-Codesign - Winter 2013
'Luis Fabiano Batista - BATL240773
'#####################################################################

Public Class FormBulle


    Dim intInitSizeX, intInitSizeY, intWindowSizeX, intWindowSizeY As Integer
    'intInitSizeX, intInitSizeY: used to store the initial ball size
    'intwindowSizeX, intWindowSizeY: used to store the initial window size
    Dim intScore As Integer
    Dim bolGameOver As Boolean

    'Oject used to generate the random ball position
    Dim objRandom As New System.Random( _
  CType(System.DateTime.Now.Ticks Mod System.Int32.MaxValue, Integer))

    'All game action passes in this section (the tick of the clock)
    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        Dim intSizeStep As Integer
        intSizeStep = 2 'this number must be even, and it represents the ball size increment for every clock tick
        Dim bolFirstArgIsBigger As Boolean
        bolFirstArgIsBigger = False


        If Not bolGameOver Then

            'Checking if any ball intersects with each other
            If IsOverlapped(CircleBlue, CircleGreen, bolFirstArgIsBigger) Then

                If bolFirstArgIsBigger Then
                    SetRandomPosition(Me, CircleBlue)
                Else
                    SetRandomPosition(Me, CircleGreen)
                End If
            End If

            bolFirstArgIsBigger = False
            If IsOverlapped(CircleBlue, CircleRed, bolFirstArgIsBigger) Then

                If bolFirstArgIsBigger Then
                    SetRandomPosition(Me, CircleBlue)
                Else
                    SetRandomPosition(Me, CircleRed)
                End If
            End If

            bolFirstArgIsBigger = False
            If IsOverlapped(CircleGreen, CircleRed, bolFirstArgIsBigger) Then

                If bolFirstArgIsBigger Then
                    SetRandomPosition(Me, CircleGreen)
                Else
                    SetRandomPosition(Me, CircleRed)
                End If
            End If

            'Check if ball reaches the window border
            If IsBorderExceeded(intWindowSizeX, intWindowSizeY, CircleBlue) Or IsBorderExceeded(intWindowSizeX, intWindowSizeY, CircleRed) Or IsBorderExceeded(intWindowSizeX, intWindowSizeY, CircleGreen) Then
                lblGameOver.Visible = True
                bolGameOver = True

            End If

            'Updating ball size
            UpdateSize(CircleBlue, intSizeStep)
            UpdateSize(CircleRed, intSizeStep)
            UpdateSize(CircleGreen, intSizeStep)
        End If

    End Sub

    Private Sub FormBulle_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        InitializeGame()

    End Sub
    'Game initialization (initial parameters)
    Private Sub InitializeGame()
        intInitSizeX = 10
        intInitSizeY = 10
        intScore = 0
        lblScoreValue.Text = intScore.ToString
        intWindowSizeX = 914
        intWindowSizeY = 487
        bolGameOver = False
        lblGameOver.Visible = False
        Timer1.Interval = 100
        SetRandomPosition(Me, CircleBlue)
        SetRandomPosition(Me, CircleRed)
        SetRandomPosition(Me, CircleGreen)
    End Sub

    'Sub to generate a random position
    Private Sub SetRandomPosition(ByRef frmForm As Object, ByRef Circle As Object)

        Dim intMinMarging, intInitialSize, XY(2) As Integer
        intMinMarging = 50
        intInitialSize = 30

        Circle.Height = intInitialSize
        Circle.Width = intInitialSize

        Dim intMaxX, intMaxY As Integer

        intMaxX = frmForm.Width - intMinMarging - Circle.Width
        intMaxY = frmForm.Height - intMinMarging - Circle.Height - 70

        XY = GetRandomPosition(intMinMarging, intMaxX, intMinMarging, intMaxY)

        Circle.Left = XY(0)
        Circle.Top = XY(1)

    End Sub
    'Sub to increment the size of balls
    Private Sub UpdateSize(ByRef Circle As Object, ByVal intStep As Integer)
        Dim intHeight, intWidth As Integer

        intHeight = Circle.Height + intStep
        Circle.Height = intHeight

        intWidth = Circle.Width + intStep
        Circle.Width = intWidth

        Circle.Top = Circle.Top - intStep / 2
        Circle.Left = Circle.Left - intStep / 2
    End Sub

    'Exit button action
    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Me.Close()

    End Sub

    'Function that generate a random X and Y to set the random position of a ball
    Public Function GetRandomPosition(ByVal intLowX As Integer, ByVal intHighX As Integer, ByVal intLowY As Integer, ByVal intHighY As Integer) As Integer()
        Dim intXY(2) As Integer

        'Returns a random number,
        'between the optional Low and High parameters
        intXY(0) = objRandom.Next(intLowX, intHighX + 1)
        intXY(1) = objRandom.Next(intLowY, intHighY + 1)

        Return intXY

    End Function

    'Reinitialize button action
    Private Sub BtnRestart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtnRestart.Click

        InitializeGame()


    End Sub

    'Function to check if 2 balls are overlapped
    Private Function IsOverlapped(ByRef Circle1 As Object, ByRef Circle2 As Object, ByRef bolFirstArgIsBigger As Boolean) As Boolean
        Dim intDistPwrTwo, X1, X2, Y1, Y2 As Integer

        X1 = Circle1.Left + Int(Circle1.Width / 2)
        X2 = Circle2.Left + Int(Circle2.Width / 2)

        Y1 = Circle1.Top + Int(Circle1.Width / 2)
        Y2 = Circle2.Top + Int(Circle2.Width / 2)

        'Notice here that it was not necessary to calculate the SQRT
        intDistPwrTwo = (X1 - X2) ^ 2 + (Y1 - Y2) ^ 2
        If Circle1.Height > Circle2.Height Then
            bolFirstArgIsBigger = True
        Else
            bolFirstArgIsBigger = False

        End If
        If intDistPwrTwo <= (Circle1.Height / 2 + Circle2.Height / 2) ^ 2 Then
            Return True
        Else
            Return False

        End If


    End Function

    'Determines the action when mouse passes over the Green ball
    Private Sub CircleGreen_MouseClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CircleGreen.MouseClick
        'Enter the Update Score function call here
        Dim intCircleHeight As Integer
        intCircleHeight = CircleGreen.Height

        If Not bolGameOver Then
            SetRandomPosition(Me, CircleGreen)

            UpdateScore(intCircleHeight, intScore)

            lblScoreValue.Text = intScore.ToString
        End If

    End Sub
    'Determines the action when mouse passes over the Red ball
    Private Sub CircleRed_MouseClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CircleRed.MouseClick
        'Enter the Update Score function call here
        Dim intCircleHeight As Integer
        intCircleHeight = CircleRed.Height

        If Not bolGameOver Then
            SetRandomPosition(Me, CircleRed)

            UpdateScore(intCircleHeight, intScore)

            lblScoreValue.Text = intScore.ToString
        End If

    End Sub
    'Determines the action when mouse passes over the Blue ball
    Private Sub CircleBlue_MouseClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CircleBlue.MouseClick
        'Enter the Update Score function call here
        Dim intCircleHeight As Integer
        intCircleHeight = CircleBlue.Height

        If Not bolGameOver Then
            SetRandomPosition(Me, CircleBlue)

            UpdateScore(intCircleHeight, intScore)

            lblScoreValue.Text = intScore.ToString
        End If

    End Sub

    'This function is used to update the score variable acording tot he current dimension of the circle
    Private Sub UpdateScore(ByVal intCircleHeight As Integer, ByRef intScore As Integer)

        Dim intScoreFactor As Integer

        intScoreFactor = 10000

        intScore = intScore + (intScoreFactor / intCircleHeight)

        'Logic to dynamically change the speed of ball growth
        If (intScore > 1000 And intScore <= 2000) Then
            Timer1.Interval = 90
        ElseIf (intScore > 2000 And intScore <= 3000) Then
            Timer1.Interval = 70
        ElseIf (intScore > 3000 And intScore <= 4000) Then
            Timer1.Interval = 50
        ElseIf intScore > 4000 And intScore <= 5000 Then
            Timer1.Interval = 30
        ElseIf intScore > 5000 And intScore <= 6000 Then
            Timer1.Interval = 20
        ElseIf intScore > 6000 And intScore <= 7000 Then
            Timer1.Interval = 10
        ElseIf intScore > 7000 Then
            Timer1.Interval = 2
        End If

    End Sub

    ' This function is used to check of the ball touches the window border
    Private Function IsBorderExceeded(ByVal intWindowWidth As Integer, ByVal intWindowHeight As Integer, ByVal Circle As Object) As Boolean

        ' If Circle.Left <= 0 Or Circle.Top <= 0 Or (Circle.Left + Circle.Width) >= intWindowWidth Or (Circle.Top + Circle.Height + 70) >= intWindowHeight Then
        If Circle.Left <= 0 Or Circle.Top <= 0 Or (Circle.Left + Circle.Width) >= intWindowWidth Or (Circle.Top + Circle.Height) >= intWindowHeight Then
            Return True
        Else
            Return False

        End If

    End Function
End Class
