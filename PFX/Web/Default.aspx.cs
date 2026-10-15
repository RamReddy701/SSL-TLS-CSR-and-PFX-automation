using System;
using System.IO;
using System.Web.UI;

public partial class _Default : Page
{
    protected void ImportButton_Click(object sender, EventArgs e)
    {
        try
        {
            string filePath = @"C:\SSL-TLS-and-PFX-automation\PFX\Web\import\" + CertUpload.FileName;
            CertUpload.SaveAs(filePath);

            string scriptPath = @"C:\SSL-TLS-and-PFX-automation\PFX\scripts\Import-Cert.ps1";
            string output = RunPowerShell(scriptPath, string.Format("-CertPath \"{0}\"", filePath));

            StatusLabel.CssClass = output.Contains("successful") ? "status-toast success" : "status-toast error";
            StatusLabel.Text = output;
            StatusLabel.Style["display"] = "block";
        }
        catch (Exception ex)
        {
            StatusLabel.CssClass = "status-toast error";
            StatusLabel.Text = "Import failed: " + ex.Message;
            StatusLabel.Style["display"] = "block";
        }
    }

    protected void ExportButton_Click(object sender, EventArgs e)
    {
        try
        {
            string commonName = CommonNameInput.Text;
            string serial = SerialInput.Text;
            string password = PasswordInput.Text;
            string exportFolder = @"C:\SSL-TLS-and-PFX-automation\PFX\Web\export";

            string scriptPath = @"C:\SSL-TLS-and-PFX-automation\PFX\scripts\Export-Cert.ps1";
            string args = string.Format("-SerialNumber \"{0}\" -CommonName \"{1}\" -Password \"{2}\" -ExportFolder \"{3}\"",
                                        serial, commonName, password, exportFolder);

            string output = RunPowerShell(scriptPath, args);

            string fileName = null;
            foreach (string line in output.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries))
            {
                if (line.StartsWith("Export successful:"))
                {
                    fileName = line.Substring("Export successful:".Length).Trim();
                    break;
                }
            }

            if (!string.IsNullOrEmpty(fileName) && fileName.IndexOfAny(Path.GetInvalidFileNameChars()) < 0)
            {
                StatusLabel.CssClass = "status-toast success";
                StatusLabel.Text = "Export successful. Downloading file...";
                StatusLabel.Style["display"] = "block";

                string fullPath = Path.Combine(exportFolder, fileName);

                Response.Clear();
                Response.ContentType = "application/x-pkcs12";
                Response.AppendHeader("Content-Disposition", string.Format("attachment; filename={0}", fileName));
                Response.TransmitFile(fullPath);
                Response.End();
            }
            else
            {
                StatusLabel.CssClass = "status-toast error";
                StatusLabel.Text = "Export failed: Invalid filename or export error.<br/>" + output;
                StatusLabel.Style["display"] = "block";
            }
        }
        catch (Exception ex)
        {
            StatusLabel.CssClass = "status-toast error";
            StatusLabel.Text = "Export failed: " + ex.Message;
            StatusLabel.Style["display"] = "block";
        }
    }

    private string RunPowerShell(string scriptPath, string args)
    {
        var psi = new System.Diagnostics.ProcessStartInfo
        {
            FileName = "powershell.exe",
            Arguments = string.Format("-ExecutionPolicy Bypass -File \"{0}\" {1}", scriptPath, args),
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using (var process = System.Diagnostics.Process.Start(psi))
        {
            string output = process.StandardOutput.ReadToEnd();
            process.WaitForExit();
            return output.Trim();
        }
    }
}
