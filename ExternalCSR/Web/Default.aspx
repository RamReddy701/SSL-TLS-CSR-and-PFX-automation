<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<!DOCTYPE html>
<html>
<head>
    <title>CSR Generator</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #f4f6f9, #e9ecef);
        }
        .header {
            background-color: #8c1515;
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .container {
            padding: 40px;
            max-width: 600px;
            margin: 40px auto;
            background-color: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        h2 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .btn {
            background-color: #8c1515;
            color: white;
            border: none;
            padding: 10px 20px;
            margin-top: 20px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .btn:hover {
            background-color: #a61d1d;
        }
    </style>
</head>
<body>
    <div class="header">
        External CSR Generator
    </div>

    <div class="container">
        <form id="form1" runat="server">
            <h2>Enter Common Name (CN):</h2>
            <asp:TextBox ID="txtCN" runat="server" Width="100%" />
            <br /><br />
            <asp:Button ID="btnGenerate" runat="server" Text="Generate CSR" CssClass="btn" OnClick="btnGenerate_Click" />
        </form>
    </div>
</body>
</html>
