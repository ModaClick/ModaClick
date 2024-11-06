<%@ page import="clases.Inventario" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" type="text/css" href="presentacion/indicadoresJSP.css">

<%
    List<String[]> datos = Inventario.getInventarioPorCategoria(); // Aquí llamas al método que trae el indicador
    String lista = "";
    String datosGraficos = "[";

    for (int i = 0; i < datos.size(); i++) {
        String[] registro = datos.get(i);
        lista += "<tr>";
        lista += "<td>" + registro[0] + "</td>";  // Nombre de la categoría
        lista += "<td>" + registro[1] + "</td>";  // Total de artículos
        lista += "</tr>";

        if (i > 0) datosGraficos += ", ";
        datosGraficos += "{";
        datosGraficos += "category: '" + registro[0] + "',";
        datosGraficos += "value: " + registro[1];
        datosGraficos += "}";
    }
    datosGraficos += "]";
%>

<h3>Indicador de Inventario por Categoría</h3>
<p></p>
<table class="styled-table" border="0">
    <tr>
        <td>
            <table class="styled-table" border="1">
                <tr><th>Categoría</th><th>Total de Artículos</th></tr>
                <%= lista %>
            </table>
        </td>
        <td id="chartdiv" style="width: 400px; height: 300px;"></td>
    </tr>
</table>

<script type="text/javascript">
    am5.ready(function() {
        var root = am5.Root.new("chartdiv");

        root.setThemes([
            am5themes_Animated.new(root)
        ]);

        var chart = root.container.children.push(am5xy.XYChart.new(root, {
            panX: true,
            panY: true,
            wheelX: "panX",
            wheelY: "zoomX",
            pinchZoomX: true,
            paddingLeft: 10,
            paddingRight: 10,
            paddingTop: 20,
            paddingBottom: 20
        }));

        var cursor = chart.set("cursor", am5xy.XYCursor.new(root, {}));
        cursor.lineY.set("visible", false);

        var xRenderer = am5xy.AxisRendererX.new(root, {
            minGridDistance: 20,
            minorGridEnabled: true
        });

        xRenderer.labels.template.setAll({
            rotation: -45,
            centerY: am5.p50,
            centerX: am5.p100,
            paddingRight: 10
        });

        var xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
            maxDeviation: 0.3,
            categoryField: "category",
            renderer: xRenderer,
            tooltip: am5.Tooltip.new(root, {})
        }));

        var yRenderer = am5xy.AxisRendererY.new(root, {
            strokeOpacity: 0.1
        });

        var yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
            maxDeviation: 0.3,
            renderer: yRenderer
        }));

        var series = chart.series.push(am5xy.ColumnSeries.new(root, {
            name: "Series 1",
            xAxis: xAxis,
            yAxis: yAxis,
            valueYField: "value",
            sequencedInterpolation: true,
            categoryXField: "category",
            tooltip: am5.Tooltip.new(root, {
                labelText: "{valueY}"
            })
        }));

        series.columns.template.setAll({
            cornerRadiusTL: 5,
            cornerRadiusTR: 5,
            strokeOpacity: 0,
            fill: am5.color("#67b7dc")
        });

        var data = <%= datosGraficos %>;

        xAxis.data.setAll(data);
        series.data.setAll(data);

        series.appear(1000);
        chart.appear(1000, 100);
    });
</script>
