<%@ Page Language="C#" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        System.Data.SqlClient.SqlConnection cnn = new System.Data.SqlClient.SqlConnection();
        string cnn_text = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["db2309z"].ConnectionString;
        cnn.ConnectionString = cnn_text;
        cnn.Open();

        System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand();
        cmd.CommandType = System.Data.CommandType.Text;
        cmd.Connection = cnn;
        int x = 0;
        if (Request.QueryString.Count > 0)
            int.TryParse(Request.QueryString[0].ToString(), out x);
        cmd.Parameters.AddWithValue("@color", x);
        cmd.CommandText = @"select rtrim(color) as color from tape 
join tape_density td on tape.density = td.id 
join color c on tape.color = c.id 
join additive ad on tape.additive = ad.id 
where tape.color = @color for json auto";       
        System.Data.SqlClient.SqlDataReader rdr = cmd.ExecuteReader();

        string xml_text = "<txt>Нет данных</txt>";

        if (rdr.Read())
            xml_text = rdr[0].ToString();

        cnn.Close();

        Response.Clear();
        Response.ContentType = "text/plain";
        Response.ContentEncoding = System.Text.Encoding.UTF8;
        Response.Write(xml_text);
        Response.End();
    }

    protected void Button1_Click(object sender, EventArgs e)
    {

    }
</script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
            <br />
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Button" />
        </div>
    </form>
</body>
</html>
