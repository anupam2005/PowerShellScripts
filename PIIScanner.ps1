Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#region GUI Definition
$form = New-Object System.Windows.Forms.Form
$form.Text = "PII Scanner"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

$textBox = New-Object System.Windows.Forms.RichTextBox
$textBox.Location = New-Object System.Drawing.Point(10, 10)
$textBox.Size = New-Object System.Drawing.Size(560, 300)
$form.Controls.Add($textBox)

$evaluateButton = New-Object System.Windows.Forms.Button
$evaluateButton.Location = New-Object System.Drawing.Point(250, 320)
$evaluateButton.Size = New-Object System.Drawing.Size(100, 30)
$evaluateButton.Text = "Evaluate"
$form.Controls.Add($evaluateButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 355)
$label.Size = New-Object System.Drawing.Size(560, 20)
$form.Controls.Add($label)
#endregion

#region Regular Expressions for PII (United States)
# Note: These regex are simplified and might not catch all valid formats or avoid all false positives.
$ssnRegex = '\b\d{3}-\d{2}-\d{4}\b'
# Driver's License - This is highly state-specific and hard to create a universal regex.
# This is a very basic example and likely needs refinement based on target states.
$driversLicenseRegex = '\b[A-Z]\d{7,8}\b|\b\d{9}\b'
# Passport Number (US format - may vary)
$passportRegex = '\b[A-Z]{2}\d{7}\b'
# Basic check for digits, adjust based on expected length/patterns
$financialAccountRegex = '\b\d{8,19}\b'
# TIN (SSN or EIN format)
$tinRegex = '\b\d{3}-\d{2}-\d{4}\b|\b\d{2}-\d{7}\b'
$emailRegex = '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b'
$phoneRegex = '\b(?:\d{3}-\d{3}-\d{4}|\(\d{3}\) \d{3}-\d{4}|\d{10})\b'
$ipAddressRegex = '\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'

$piiPatterns = @{
    "Social Security Number" = $ssnRegex
    "Driver's License Number" = $driversLicenseRegex
    "Passport Number" = $passportRegex
    "Financial Account Number" = $financialAccountRegex
    "Taxpayer Identification Number" = $tinRegex
    "Email Address" = $emailRegex
    "Telephone Number" = $phoneRegex
    "IP Address" = $ipAddressRegex
}
#endregion

#region Event Handler for Button Click
$evaluateButton.Add_Click({
    $text = $textBox.Text
    $foundPII = @()

    foreach ($piiType in $piiPatterns.Keys) {
        $regex = $piiPatterns[$piiType]
        $matches = [regex]::Matches($text, $regex)
        if ($matches.Count -gt 0) {
            foreach ($match in $matches) {
                $foundPII += "$piiType found: $($match.Value)"
            }
        }
    }

    if ($foundPII.Count -gt 0) {
        $alertMessage = "Potential PII Found:\n" + ($foundPII -join "`n")
        [System.Windows.Forms.MessageBox]::Show($alertMessage, "PII Alert", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        $label.Text = "Potential PII detected. See alert."
    } else {
        $label.Text = "No potential PII detected."
    }
})
#endregion

# Display the Form
$form.ShowDialog() | Out-Null
