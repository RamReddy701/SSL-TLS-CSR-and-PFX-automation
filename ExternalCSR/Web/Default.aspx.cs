using System;
using System.Diagnostics;
using System.Text;
using System.Text.RegularExpressions;

public partial class _Default : System.Web.UI.Page
{
    protected void btnGenerate_Click(object sender, EventArgs e)
    {
        string cn = txtCN.Text.Trim();

        if (string.IsNullOrEmpty(cn))
        {
            Response.Write("Common Name (CN) cannot be empty.");
            return;
        }

        cn = Regex.Replace(cn, @"[<>:\""/\\|?*]", "");

        string scriptPath = @"C:\SSL-TLS-CSR-and-PFX-automation\ExternalCSR\Scripts\Generate-CSR.ps1";
        string args = string.Format("-ExecutionPolicy Bypass -File \"{0}\" -CN \"{1}\"", scriptPath, cn);

        try
        {
            var psi = new ProcessStartInfo
            {
                FileName = "powershell.exe",
                Arguments = args,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
                StandardOutputEncoding = Encoding.UTF8
            };

            string csrContent;
            using (var ps = Process.Start(psi))
            {
                csrContent = ps.StandardOutput.ReadToEnd();
                string error = ps.StandardError.ReadToEnd();
                ps.WaitForExit();

                if (ps.ExitCode != 0 || string.IsNullOrEmpty(csrContent))
                {
                    Response.Write("PowerShell script failed: " + error);
                    return;
                }
            }

            byte[] fileBytes = Encoding.UTF8.GetBytes(csrContent);
            string fileName = cn + ".csr";

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", string.Format("attachment; filename={0}", fileName));
            Response.AddHeader("Content-Length", fileBytes.Length.ToString());
            Response.BinaryWrite(fileBytes);
            Response.Flush();
            Response.End();
        }
        catch (Exception ex)
        {
            Response.Write("An unexpected error occurred: " + ex.Message);
        }
    }
}
