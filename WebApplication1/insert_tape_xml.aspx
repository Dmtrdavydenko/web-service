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




        int densityId = 0;
        int colorId = 0;
        int additiveId = 0;

        bool hasColorId = false;
        bool hasAdditiveId = false;

        string colorText = null;
        string additiveText = null;

        string rawColor = Request.QueryString["color"];
        string rawAdditive = Request.QueryString["additive"];

        if (!string.IsNullOrEmpty(rawColor))
        {
            if (int.TryParse(rawColor, out colorId))
            {
                hasColorId = true;
            }
            else
            {
                colorText = rawColor;
            }
        }

        if (!string.IsNullOrEmpty(rawAdditive))
        {
            if (int.TryParse(rawAdditive, out additiveId))
            {
                hasAdditiveId = true;
            }
            else
            {
                additiveText = rawAdditive;
            }
        }

        cmd.CommandText = @"
INSERT INTO tape (density, color, additive)
VALUES (
   -- (SELECT id FROM tape_density WHERE tape_density = @density),
   -- (SELECT id FROM color WHERE color = @color),
   -- (SELECT id FROM additive WHERE additive = @additive)
-- );
";


        var conditions = new List<string>();

        bool[] vec = { false, false, false };

        if (int.TryParse(Request.QueryString["density"], out densityId))
        {
            vec[0] = true;
            conditions.Add("(SELECT id FROM tape_density WHERE density = @density),");
            cmd.Parameters.Add("@density", System.Data.SqlDbType.SmallInt).Value = densityId;
        }
        if (hasColorId)
        {
            vec[1] = true;
            conditions.Add("@color,");
            cmd.Parameters.Add("@color", System.Data.SqlDbType.SmallInt).Value = colorId;
        }
        else if (!string.IsNullOrEmpty(colorText))
        {
            vec[1] = true;
            conditions.Add("(SELECT id FROM color WHERE color = @color),");
            cmd.Parameters.Add("@color", System.Data.SqlDbType.NVarChar).Value = colorText;
        }
        if (hasAdditiveId)
        {
            vec[2] = true;
            conditions.Add("@additive");
            cmd.Parameters.Add("@additive", System.Data.SqlDbType.SmallInt).Value = additiveId;
        }
        else if (!string.IsNullOrEmpty(additiveText))
        {
            vec[2] = true;
            conditions.Add("(SELECT id FROM additive WHERE additive = @additive)");
            cmd.Parameters.Add("@additive", System.Data.SqlDbType.NVarChar).Value = additiveText;
        }


        if (conditions.Count > 0)
        {
            cmd.CommandText += string.Join(" ", conditions);
        }

        cmd.CommandText += " ); ";

        string xml_text = "<txt>Нет данных</txt>";
        int rows = 0;

        if (vec[0] && vec[1] && vec[2])
        {
            rows = cmd.ExecuteNonQuery();
        }

        xml_text = "<tapes>";


        if (rows > 0)
            xml_text += "<txt>OK</txt>";
        else
            xml_text += "<txt>NOT INSERTED</txt>";


        xml_text += "</tapes>";


        cnn.Close();

        Response.Clear();
        Response.ContentType = "application/xml";
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
