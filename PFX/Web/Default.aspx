<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Certificate Management Portal</title>
    <meta charset="utf-8" />
    <style>
        body {
            font-family: Segoe UI, Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #f4f6f9, #e9ecef);
        }

        .header {
            background-color: #8c1515;
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 26px;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .container {
            max-width: 600px;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .btn,
        asp\:Button {
            background-color: #8c1515 !important;
            color: white !important;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            margin-right: 10px;
            transition: background-color 0.3s ease;
        }

        .btn:hover,
        asp\:Button:hover {
            background-color: #a61d1d !important;
        }

        .button-group {
            margin-top: 20px;
        }

        .status-toast {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            font-weight: bold;
            padding: 12px 20px;
            border-radius: 6px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            display: none;
        }

        .status-toast.success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }

        .status-toast.error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <!-- Header with Stanford Color -->
    <div class="header">
       Cert Import/Export 
    </div>

    <!-- Toast Notification -->
    <asp:Label ID="StatusLabel" runat="server" CssClass="status-toast" />

    <form id="form1" runat="server">
        <div class="container">
            <h1>Certificate Import & Export</h1>

            <div class="form-group">
                <label for="CertUpload">Upload Certificate (.cer)</label>
                <asp:FileUpload ID="CertUpload" runat="server" />
            </div>

            <div class="button-group">
                <asp:Button ID="ImportButton" runat="server" Text="Import Certificate" CssClass="btn" OnClick="ImportButton_Click" />
            </div>

            <hr />

            <div class="form-group">
                <label for="CommonNameInput">Common Name</label>
                <asp:TextBox ID="CommonNameInput" runat="server" />
            </div>

            <div class="form-group">
                <label for="SerialInput">Serial Number</label>
                <asp:TextBox ID="SerialInput" runat="server" />
            </div>

            <div class="form-group">
                <label for="PasswordInput">Export Password</label>
                <asp:TextBox ID="PasswordInput" runat="server" TextMode="Password" />
            </div>

            <div class="button-group">
                <asp:Button ID="ExportButton" runat="server" Text="Export as .PFX" CssClass="btn" OnClick="ExportButton_Click" />
            </div>
        </div>
    </form>

    <script>
        window.onload = function () {
            var toast = document.querySelector('.status-toast');
            if (toast && toast.style.display === 'block') {
                setTimeout(function () {
                    toast.style.display = 'none';
                }, 3000);
            }
        };
    </script>
</body>
</html>
