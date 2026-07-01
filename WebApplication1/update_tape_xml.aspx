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



        int tapeId = 0;
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
UPDATE tape

";


        var set = new List<string>();
        var conditions = new List<string>();

        bool[] vec = { false, false, false, false };
        if (int.TryParse(Request.QueryString["id"], out tapeId))
        {
            vec[0] = true;
            conditions.Add("tape.id = @tape");
            cmd.Parameters.Add("@tape", System.Data.SqlDbType.Int).Value = tapeId;
        }

        if (int.TryParse(Request.QueryString["density"], out densityId))
        {
            vec[1] = true;
            set.Add("density = (SELECT id FROM tape_density WHERE density = @density)");
            cmd.Parameters.Add("@density", System.Data.SqlDbType.SmallInt).Value = densityId;
        }
        if (hasColorId)
        {
            vec[2] = true;
            set.Add("color = @color");
            cmd.Parameters.Add("@color", System.Data.SqlDbType.SmallInt).Value = colorId;
        }
        else if (!string.IsNullOrEmpty(colorText))
        {
            vec[2] = true;
            set.Add("color = (SELECT id FROM color WHERE color = @color)");
            cmd.Parameters.Add("@color", System.Data.SqlDbType.NVarChar).Value = colorText;
        }
        if (hasAdditiveId)
        {
            vec[3] = true;
            set.Add("additive = @additive");
            cmd.Parameters.Add("@additive", System.Data.SqlDbType.SmallInt).Value = additiveId;
        }
        else if (!string.IsNullOrEmpty(additiveText))
        {
            vec[3] = true;
            set.Add("additive = (SELECT id FROM additive WHERE additive = @additive)");
            cmd.Parameters.Add("@additive", System.Data.SqlDbType.NVarChar).Value = additiveText;
        }


        if (set.Count > 0)
        {
            cmd.CommandText += " SET " + string.Join(", ", set);
        }
        if (conditions.Count > 0)
        {
            cmd.CommandText += " where " + string.Join(" AND ", conditions);
        }




        string xml_text = "<txt>Нет данных</txt>";
        int rows = 0;

        if (conditions.Count > 0 && set.Count > 0)
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
