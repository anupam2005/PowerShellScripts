# PIIScanner.ps1

### PROMPT

**TASK**: Act as a coder.
Build a Powershell GUI which will have a text area and a button named "Evaluate"

**CONTEXT**: Whenever the user will paste text in the text area and click on "Evaluate"; It must scan the text in search of the PII regex and print an alert on the same UI.

## Explanation 
1. Add-Type -AssemblyName System.Windows.Forms and Add-Type -AssemblyName System.Drawing: These lines load the necessary .NET assemblies to create GUI elements.
2. region GUI Definition: This section defines the visual elements of the GUI:
A Form named "PII Scanner".
A RichTextBox named $textBox for the user to paste text.
A Button named $evaluateButton to trigger the scan.
A Label named $label to display the scan results

3. region Regular Expressions for PII (United States): This section defines PowerShell regular expressions for the PII types you requested.
 - Important Note: These regex are simplified and might not be exhaustive or perfectly accurate for all possible formats. For production use, you would likely need more robust and specific regex, especially for things like Driver's License numbers which vary greatly by state.
 
4. $piiPatterns: A hashtable is created to store the PII type and its corresponding regex, making it easier to iterate through them.
5. region Event Handler for Button Click: This section defines what happens when the "Evaluate" button is clicked:
- It gets the text from the $textBox.
- It iterates through the $piiPatterns hashtable.
- For each PII type and its regex, it uses [regex]::Matches() to find all occurrences in the text.
- If matches are found, it adds a message to the $foundPII array.
- Finally, it checks if any PII was found:
- If yes, it displays a MessageBox with the detected PII and updates the $label.
- If no, it updates the $label to indicate that no potential PII was found.
5.  Display the Form: This line displays the GUI to the user.

## How to Run:

1. Save the code as a .ps1 file (e.g., PIIScanner.ps1).
2. Open PowerShell.
3. Navigate to the directory where you saved the file.
4. Run the script using the command: .\PIIScanner.ps1
5. This will open the GUI. You can then paste text into the text area and click "Evaluate" to see if any of the defined PII patterns are detected.

