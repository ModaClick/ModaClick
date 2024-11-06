<%@ page import="clases.Venta" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" type="text/css" href="presentacion/ventasJSP.css">
<%
    List<String[]> datos = Venta.getTotalVentasPorDia();
    String lista = "";
    String datosGraficos = "[";

    for (int i = 0; i < datos.size(); i++) {
        String[] registro = datos.get(i);
        lista += "<tr>";
        lista += "<td><a href='principal.jsp?CONTENIDO=indicadores/ventasXDia.jsp&anio="+registro[0]+"'>"+registro[0]+"</a></td>";
        lista += "<td>" + registro[1] + "</td>";
        lista += "</tr>";

        if (i > 0) datosGraficos += ", ";
        datosGraficos += "{";
        datosGraficos += "country: '" + registro[0] + "',";
        datosGraficos += "value: " + registro[1];
        datosGraficos += "}";
    }
    datosGraficos += "]";
%>

<h3>INDICADOR DE VENTAS POR DÍA</h3>
<p></p>
<table class="styled-table" border="0">
    <tr>
        <td>
            <table class="styled-table" border="1">
                <tr><th>Día</th><th>Ventas ($)</th></tr>
                <%= lista %>
            </table>
        </td>
        <td id="chartdiv" style="width: 400px; height: 300px;"> <!-- Ajustado el tamaño aquí -->
        </td>
    </tr>
</table>
<p>
    <input type="button" value="Regresar a ventas por mes" title="Desea volver a Ventas por Mes" style="background-color: #007BFF; border: 1px #007BFF; color: white; border-radius: 30px; width: 100%; padding: 15px; font-size: 18px; box-sizing: border-box; cursor: pointer; transition: background-color 0.3s ease;" onClick="window.history.back()">
</p>            

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
            paddingLeft: 10, // Ajustado para un tamaño más compacto
            paddingRight: 10, // Ajustado para un tamaño más compacto
            paddingTop: 20, // Ajustado para un tamaño más compacto
            paddingBottom: 20 // Ajustado para un tamaño más compacto
        }));

        var cursor = chart.set("cursor", am5xy.XYCursor.new(root, {}));
        cursor.lineY.set("visible", false);

        var xRenderer = am5xy.AxisRendererX.new(root, {
            minGridDistance: 20, // Ajustado para mejorar visibilidad en pantallas pequeñas
            minorGridEnabled: true
        });

        xRenderer.labels.template.setAll({
            rotation: -45, // Menor ángulo para mejor visibilidad
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
            strokeOpacity: 0,
            fill: am5.color("#67b7dc") // Ajusta el color de las columnas si es necesario
        });

        var data = <%= datosGraficos %>;

        xAxis.data.setAll(data);
        series.data.setAll(data);

        series.appear(1000);
        chart.appear(1000, 100);

    }); // end am5.ready()
</script>
