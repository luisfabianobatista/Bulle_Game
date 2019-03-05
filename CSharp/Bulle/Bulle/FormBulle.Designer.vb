<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FormBulle
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.ShapeContainer1 = New Microsoft.VisualBasic.PowerPacks.ShapeContainer()
        Me.LineShape1 = New Microsoft.VisualBasic.PowerPacks.LineShape()
        Me.CircleBlue = New Microsoft.VisualBasic.PowerPacks.OvalShape()
        Me.CircleGreen = New Microsoft.VisualBasic.PowerPacks.OvalShape()
        Me.CircleRed = New Microsoft.VisualBasic.PowerPacks.OvalShape()
        Me.BtnRestart = New System.Windows.Forms.Button()
        Me.Button1 = New System.Windows.Forms.Button()
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.lblScore = New System.Windows.Forms.Label()
        Me.lblScoreValue = New System.Windows.Forms.Label()
        Me.lblGameOver = New System.Windows.Forms.Label()
        Me.SuspendLayout()
        '
        'ShapeContainer1
        '
        Me.ShapeContainer1.Location = New System.Drawing.Point(0, 0)
        Me.ShapeContainer1.Margin = New System.Windows.Forms.Padding(0)
        Me.ShapeContainer1.Name = "ShapeContainer1"
        Me.ShapeContainer1.Shapes.AddRange(New Microsoft.VisualBasic.PowerPacks.Shape() {Me.LineShape1, Me.CircleBlue, Me.CircleGreen, Me.CircleRed})
        Me.ShapeContainer1.Size = New System.Drawing.Size(914, 530)
        Me.ShapeContainer1.TabIndex = 0
        Me.ShapeContainer1.TabStop = False
        '
        'LineShape1
        '
        Me.LineShape1.Name = "LineShape1"
        Me.LineShape1.X1 = 1
        Me.LineShape1.X2 = 914
        Me.LineShape1.Y1 = 487
        Me.LineShape1.Y2 = 487
        '
        'CircleBlue
        '
        Me.CircleBlue.BackColor = System.Drawing.Color.Blue
        Me.CircleBlue.BackStyle = Microsoft.VisualBasic.PowerPacks.BackStyle.Opaque
        Me.CircleBlue.BorderColor = System.Drawing.Color.Blue
        Me.CircleBlue.FillGradientColor = System.Drawing.Color.Blue
        Me.CircleBlue.FillGradientStyle = Microsoft.VisualBasic.PowerPacks.FillGradientStyle.Central
        Me.CircleBlue.FillStyle = Microsoft.VisualBasic.PowerPacks.FillStyle.Solid
        Me.CircleBlue.Location = New System.Drawing.Point(832, 303)
        Me.CircleBlue.Name = "CircleBlue"
        Me.CircleBlue.Size = New System.Drawing.Size(81, 80)
        '
        'CircleGreen
        '
        Me.CircleGreen.BackColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(192, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.CircleGreen.BackStyle = Microsoft.VisualBasic.PowerPacks.BackStyle.Opaque
        Me.CircleGreen.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(192, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.CircleGreen.FillGradientColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(192, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.CircleGreen.FillGradientStyle = Microsoft.VisualBasic.PowerPacks.FillGradientStyle.Central
        Me.CircleGreen.FillStyle = Microsoft.VisualBasic.PowerPacks.FillStyle.Solid
        Me.CircleGreen.Location = New System.Drawing.Point(139, 323)
        Me.CircleGreen.Name = "CircleGreen"
        Me.CircleGreen.Size = New System.Drawing.Size(81, 80)
        '
        'CircleRed
        '
        Me.CircleRed.BackColor = System.Drawing.Color.Red
        Me.CircleRed.BackStyle = Microsoft.VisualBasic.PowerPacks.BackStyle.Opaque
        Me.CircleRed.BorderColor = System.Drawing.Color.Red
        Me.CircleRed.FillGradientColor = System.Drawing.Color.Red
        Me.CircleRed.FillGradientStyle = Microsoft.VisualBasic.PowerPacks.FillGradientStyle.Central
        Me.CircleRed.FillStyle = Microsoft.VisualBasic.PowerPacks.FillStyle.Solid
        Me.CircleRed.Location = New System.Drawing.Point(307, 318)
        Me.CircleRed.Name = "CircleRed"
        Me.CircleRed.Size = New System.Drawing.Size(81, 80)
        '
        'BtnRestart
        '
        Me.BtnRestart.BackColor = System.Drawing.Color.Silver
        Me.BtnRestart.Location = New System.Drawing.Point(709, 494)
        Me.BtnRestart.Name = "BtnRestart"
        Me.BtnRestart.Size = New System.Drawing.Size(98, 33)
        Me.BtnRestart.TabIndex = 1
        Me.BtnRestart.Text = "Restart"
        Me.BtnRestart.UseVisualStyleBackColor = False
        '
        'Button1
        '
        Me.Button1.BackColor = System.Drawing.Color.Silver
        Me.Button1.Location = New System.Drawing.Point(813, 494)
        Me.Button1.Name = "Button1"
        Me.Button1.Size = New System.Drawing.Size(98, 33)
        Me.Button1.TabIndex = 2
        Me.Button1.Text = "Exit"
        Me.Button1.UseVisualStyleBackColor = False
        '
        'Timer1
        '
        Me.Timer1.Enabled = True
        '
        'lblScore
        '
        Me.lblScore.AutoSize = True
        Me.lblScore.Font = New System.Drawing.Font("Verdana", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblScore.Location = New System.Drawing.Point(3, 489)
        Me.lblScore.Name = "lblScore"
        Me.lblScore.Size = New System.Drawing.Size(131, 38)
        Me.lblScore.TabIndex = 3
        Me.lblScore.Text = "Score:"
        '
        'lblScoreValue
        '
        Me.lblScoreValue.AutoSize = True
        Me.lblScoreValue.Font = New System.Drawing.Font("Verdana", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblScoreValue.Location = New System.Drawing.Point(132, 489)
        Me.lblScoreValue.Name = "lblScoreValue"
        Me.lblScoreValue.Size = New System.Drawing.Size(40, 38)
        Me.lblScoreValue.TabIndex = 4
        Me.lblScoreValue.Text = "0"
        '
        'lblGameOver
        '
        Me.lblGameOver.AutoSize = True
        Me.lblGameOver.Font = New System.Drawing.Font("Verdana", 24.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblGameOver.ForeColor = System.Drawing.Color.Red
        Me.lblGameOver.Location = New System.Drawing.Point(360, 489)
        Me.lblGameOver.Name = "lblGameOver"
        Me.lblGameOver.Size = New System.Drawing.Size(229, 38)
        Me.lblGameOver.TabIndex = 5
        Me.lblGameOver.Text = "GAME OVER"
        Me.lblGameOver.Visible = False
        '
        'FormBulle
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.BackColor = System.Drawing.Color.White
        Me.ClientSize = New System.Drawing.Size(914, 530)
        Me.Controls.Add(Me.lblGameOver)
        Me.Controls.Add(Me.lblScoreValue)
        Me.Controls.Add(Me.lblScore)
        Me.Controls.Add(Me.Button1)
        Me.Controls.Add(Me.BtnRestart)
        Me.Controls.Add(Me.ShapeContainer1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "FormBulle"
        Me.ShowIcon = False
        Me.Text = "Bulle Game"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ShapeContainer1 As Microsoft.VisualBasic.PowerPacks.ShapeContainer
    Friend WithEvents CircleBlue As Microsoft.VisualBasic.PowerPacks.OvalShape
    Friend WithEvents CircleGreen As Microsoft.VisualBasic.PowerPacks.OvalShape
    Friend WithEvents CircleRed As Microsoft.VisualBasic.PowerPacks.OvalShape
    Friend WithEvents LineShape1 As Microsoft.VisualBasic.PowerPacks.LineShape
    Friend WithEvents BtnRestart As System.Windows.Forms.Button
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    Friend WithEvents lblScore As System.Windows.Forms.Label
    Friend WithEvents lblScoreValue As System.Windows.Forms.Label
    Friend WithEvents lblGameOver As System.Windows.Forms.Label

End Class
