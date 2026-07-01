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

        bool hasTape = false;
        bool hasDensity = false;
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
select
tape.id as tape_id,
rtrim(td.density) as tape_density,
rtrim(c.color) as tape_color,
rtrim(ad.additive) as tape_additive
from tape 
join tape_density td on tape.density = td.id 
join color c on tape.color = c.id 
join additive ad on tape.additive = ad.id 
";


        var conditions = new List<string>();

        if (int.TryParse(Request.QueryString["tape"], out tapeId))
        {
            hasTape = true;
            conditions.Add("tape.id = @tape");
            cmd.Parameters.Add("@tape", System.Data.SqlDbType.Int).Value = tapeId;
        }
        if (int.TryParse(Request.QueryString["density"], out densityId))
        {
            hasDensity = true;
            conditions.Add("td.density = @density");
            cmd.Parameters.Add("@density", System.Data.SqlDbType.SmallInt).Value = densityId;
        }
        if (hasColorId)
        {
            conditions.Add("tape.color = @color");
            cmd.Parameters.Add("@color", System.Data.SqlDbType.SmallInt).Value = colorId;
        }
        else if (!string.IsNullOrEmpty(colorText))
        {
            conditions.Add("c.color = @stcolor");
            cmd.Parameters.Add("@stcolor", System.Data.SqlDbType.NVarChar).Value = colorText;
        }
        if (hasAdditiveId)
        {
            conditions.Add("tape.additive = @additive");
            cmd.Parameters.Add("@additive", System.Data.SqlDbType.SmallInt).Value = additiveId;
        }
        else if (!string.IsNullOrEmpty(additiveText))
        {
            conditions.Add("ad.additive = @stadditive");
            cmd.Parameters.Add("@stadditive", System.Data.SqlDbType.NVarChar).Value = additiveText;
        }


        if (conditions.Count > 0)
        {
            cmd.CommandText += " where " + string.Join(" and ", conditions);
        }

        cmd.CommandText += " for xml auto ";

        System.Data.SqlClient.SqlDataReader rdr = cmd.ExecuteReader();

        string xml_text = "<txt>Нет данных</txt>";

        xml_text = "<tapes>";
        //xml_text = ""; 
        while (rdr.Read())
            xml_text += rdr[0].ToString();

        xml_text += "</tapes>";


        cnn.Close();

        //Response.Clear();
        //Response.ContentType = "text/plain";
        //Response.ContentEncoding = System.Text.Encoding.UTF8;
        //Response.Write(xml_text);
        //Response.End();
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
