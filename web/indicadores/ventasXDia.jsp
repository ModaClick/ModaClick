<%@ page import="clases.Venta" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src="https://cdn.amcharts.com/lib/5/index.js"></script>
<script src="https://cdn.amcharts.com/lib/5/xy.js"></script>
<script src="https://cdn.amcharts.com/lib/5/themes/Animated.js"></script>

   <style>
        /* Estilo de encabezado centrado */
        .table-container h3 {
            text-align: center;
            color: #333;
            margin: 0;
            padding: 15px 0;
            font-size: 24px;
        }

        /* Expansión de contenedor de la tabla en toda la página */
        .table-container {
            width: 100%;
            padding: 0;
            margin: 20px 0;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        /* Estilo de la tabla */
        table.table {
            width: 100%;
            border-collapse: collapse;
        }

        /* Encabezado de las columnas de la tabla */
        .table thead th {
            background-color: #343a40;
            color: white;
            font-weight: bold;
            text-align: center;
        }

        /* Celdas de la tabla */
        .table tbody td {
            text-align: center;
            vertical-align: middle;
            padding: 10px;
        }

        /* Estilos de botones de acción */
        .btn-action {
            font-size: 14px;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 5px 10px;
            display: inline-flex;
            align-items: center;
            margin: 0 2px;
        }
        .btn-add {
            background-color: #28a745;
        }
        .btn-modify {
            background-color: #ffc107;
        }
        .btn-delete {
            background-color: #dc3545;
        }

        /* Iconos dentro de los botones */
        .icono {
            width: 20px;
            height: 20px;
            margin-right: 5px;
        }

        /* Evitar el desbordamiento en la tabla */
        .table-responsive {
            overflow-x: auto;
        }
    </style>
<%
    List<String[]> datos = Venta.getTotalVentasPorDia(); // Método que obtiene los datos de ventas por día
    String lista = "";
    String datosGraficos = "[";

    for (int i = 0; i < datos.size(); i++) {
        String[] registro = datos.get(i);
        lista += "<tr>";
        lista += "<td><a href='principal.jsp?CONTENIDO=indicadores/ventasXDia.jsp&anio="+registro[0]+"'>"+registro[0]+"</a></td>";
        lista += "<td>" + registro[1] + "</td>";
        lista += "</tr>";

        if (i > 0) {
            datosGraficos += ", ";
        }
        datosGraficos += "{";
        datosGraficos += "country: '" + registro[0] + "',";
        datosGraficos += "value: " + registro[1];
        datosGraficos += "}";
    }
    datosGraficos += "]";
%>

<body class="bg-light">
   
<div class="container-fluid">
    <div class="table-container">
    <h3>Indicador de Ventas por Día</h3>
    <div class="table-responsive">
            <table class="table table-striped table-hover">
                
                <thead>
                <tr>
                    <th>Día</th>
                    <th>Ventas ($)</th>
                </tr>
            </thead>
            <tbody>
                <%= lista %>
            </tbody>
        </table>
        <div id="chartdiv" style="width: 400px; height: 300px;"></div>
    </div>
    <p>
        <input type="button" value="Regresar a ventas por mes" title="Desea volver a Ventas por Mes" style="background-color: #333333; border: 1px #007BFF; color: white; border-radius: 30px; width: 20%; padding: 15px; font-size: 18px; box-sizing: border-box; cursor: pointer; transition: background-color 0.3s ease;" onClick="window.history.back()">
    </p> 
</div>

<script type="text/javascript">
    am5.ready(function() {
        var root = am5.Root.new("chartdiv");

        root.setThemes([am5themes_Animated.new(root)]);

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
            fill: am5.color("#67b7dc")
        });

        var data = <%= datosGraficos %>;

        xAxis.data.setAll(data);
        series.data.setAll(data);

        series.appear(1000);
        chart.appear(1000, 100);
    }); // end am5.ready()
</script>
