<%@page import="java.util.List"%>
<%@page import="clases.Venta"%>
<link rel="stylesheet" type="text/css" href="presentacion/ventasJSP.css">

<%
    List<String[]> datos = Venta.getTotalVentas();
    String lista = "";
    String datosGrafico = "[";

    for (int i = 0; i < datos.size(); i++) {
        String[] registro = datos.get(i);
        lista += "<tr>";
        lista += "<td><a href='principal.jsp?CONTENIDO=indicadores/ventasXMes.jsp&anio=" + registro[0] + "'>" + registro[0] + "</a></td>";
        lista += "<td>" + registro[1] + "</td>";
        lista += "</tr>";

        if (i > 0) {
            datosGrafico += ", ";
        }
        datosGrafico += "{";
        datosGrafico += "country: '" + registro[0] + "',";
        datosGrafico += "value: " + registro[1];
        datosGrafico += "}";
    }

    datosGrafico += "]";
%>


<h3>INDICADOR DE VENTAS POR AÑO </h3>
<p></p>
<table class="styled-table" border="1">
    <tr>
        <td>
            <table class="styled-table" border="1">
                <tr><th>Año</th><th>Ventas ($)</th><th>%</th></tr>
                        <%=lista%>
            </table>
        </td>
        <td id="chartdiv" style="width: 400px; height: 300px;"> <!-- Ajusta el tamaño aquí -->
        </td>                   
    </tr>
</table>

<script type="text/javascript">
    am5.ready(function () {
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
            paddingLeft: 0,
            paddingRight: 0,  // Ajusta el padding para un tamaño más compacto
            paddingTop: 10,
            paddingBottom: 10
        }));
        var cursor = chart.set("cursor", am5xy.XYCursor.new(root, {}));
        cursor.lineY.set("visible", false);
        var xRenderer = am5xy.AxisRendererX.new(root, {
            minGridDistance: 20, // Ajusta la distancia mínima entre etiquetas
            minorGridEnabled: true
        });

        xRenderer.labels.template.setAll({
            rotation: -45,  // Reduce el ángulo para mejor visibilidad en pantallas pequeñas
            centerY: am5.p50,
            centerX: am5.p100,
            paddingRight: 10
        });

        xRenderer.grid.template.setAll({
            location: 1
        });

        var xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
            maxDeviation: 0.3,
            categoryField: "country",
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

        // Create series
        var series = chart.series.push(am5xy.ColumnSeries.new(root, {
            name: "Series 1",
            xAxis: xAxis,
            yAxis: yAxis,
            valueYField: "value",
            sequencedInterpolation: true,
            categoryXField: "country",
            tooltip: am5.Tooltip.new(root, {
                labelText: "{valueY}"
            })
        }));

        series.columns.template.setAll({
            cornerRadiusTL: 5,
            cornerRadiusTR: 5,
            strokeOpacity: 0
        });
        series.columns.template.adapters.add("fill", function (fill, target) {
            return chart.get("colors").getIndex(series.columns.indexOf(target));
        });

        series.columns.template.adapters.add("stroke", function (stroke, target) {
            return chart.get("colors").getIndex(series.columns.indexOf(target));
        });

        // Set data
        var data = <%=datosGrafico%>;

        xAxis.data.setAll(data);
        series.data.setAll(data);

        // Make stuff animate on load
        series.appear(1000);
        chart.appear(1000, 100);
    });
</script>
