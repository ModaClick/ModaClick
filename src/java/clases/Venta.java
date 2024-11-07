package clases;
import clases.Inventario;
import clases.MedioPagoPorVenta;
import clases.Persona;
import clases.VentaDetalle;
import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Venta {
    private String idVenta;
    private String idCliente;
    private String fechaVenta;
    private String nombresCliente;
    private int total;
    private int abonado;

    public Venta() {
        System.out.println("Inicializando objeto Venta vacío.");
    }

    public Venta(String idVenta) {
        this.idVenta = idVenta;
        String cadenaSQL = "SELECT idCliente, fechaVenta, nombre, "
                + "getTotalVenta(idVenta) AS total, getAbonadoVenta(idVenta) AS Abonado "
                + "FROM venta INNER JOIN Persona ON identificacion = idCliente WHERE idVenta = " + idVenta;

        System.out.println("Consulta SQL para cargar venta: " + cadenaSQL);
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                idCliente = resultado.getString("idCliente");
                nombresCliente = resultado.getString("nombre");
                fechaVenta = resultado.getString("fechaVenta");
                total = resultado.getInt("total");
                abonado = resultado.getInt("Abonado");
                System.out.println("Venta cargada: idCliente=" + idCliente + ", nombreCliente=" + nombresCliente + ", total=" + total + ", abonado=" + abonado);
            } else {
                System.out.println("No se encontró la venta con id: " + idVenta);
            }
        } catch (SQLException ex) {
            Logger.getLogger(Venta.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getNombresCompletosCliente() {
        return nombresCliente != null ? nombresCliente : "";
    }

    public List<MedioPagoPorVenta> getMediosDePago() {
        List<MedioPagoPorVenta> lista = MedioPagoPorVenta.getListaEnObjetos("idVentaDetalle='" + idVenta + "'", null);
        System.out.println("Medios de pago obtenidos para la venta " + idVenta + ": " + lista);
        return lista;
    }

    public String getIdVenta() {
        return idVenta != null ? idVenta : "";
    }

    public void setIdVenta(String idVenta) {
        this.idVenta = idVenta;
    }

    public String getIdCliente() {
        return idCliente != null ? idCliente : "";
    }

    public void setIdCliente(String idCliente) {
        this.idCliente = idCliente;
    }

    public Persona getCliente() {
        return new Persona(idCliente);
    }

    public String getFechaVenta() {
        return fechaVenta != null ? fechaVenta : "";
    }

    public void setFechaVenta(String fechaVenta) {
        this.fechaVenta = fechaVenta;
    }

    public String getNombresCliente() {
        return nombresCliente != null ? nombresCliente : "";
    }

    public void setNombresCliente(String nombresCliente) {
        this.nombresCliente = nombresCliente;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getAbonado() {
        return abonado;
    }

    public void setAbonado(int abonado) {
        this.abonado = abonado;
    }

    public int getSaldo() {
        return total - abonado;
    }

 public static ResultSet getLista(String filtro, String orden) {
    if (filtro != null && !filtro.isEmpty()) {
        filtro = " WHERE " + filtro;
    } else {
        filtro = "";
    }
    if (orden != null && !orden.isEmpty()) {
        orden = " ORDER BY " + orden;
    } else {
        orden = "";
    }

    String cadenaSQL = "SELECT v.idVenta, v.idCliente, v.fechaVenta, p.nombre, "
            + "getTotalVenta(v.idVenta) AS Total, getAbonadoVenta(v.idVenta) AS Abonado, "
            + "i.nombreArticulo "
            + "FROM venta v "
            + "INNER JOIN Persona p ON p.identificacion = v.idCliente "
            + "INNER JOIN ventaDetalle vd ON v.idVenta = vd.idVentaDetalle "
            + "INNER JOIN Inventario i ON i.idArticulo = vd.idArticuloInventario " 
            + filtro + orden;

    System.out.println("Cadena productos: " + cadenaSQL);
    return ConectorBD.consultar(cadenaSQL);
}




    public static List<Venta> getListaEnObjetos(String filtro, String orden) {
        List<Venta> lista = new ArrayList<>();
        ResultSet datos = getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    Venta venta = new Venta();
                    venta.setIdVenta(datos.getString("idVenta"));
                    venta.setIdCliente(datos.getString("idCliente"));
                    venta.setFechaVenta(datos.getString("fechaVenta"));
                    venta.setNombresCliente(datos.getString("nombre"));
                    venta.setTotal(datos.getInt("Total"));
                    venta.setAbonado(datos.getInt("Abonado"));
                    lista.add(venta);
                    System.out.println("Venta agregada a la lista: " + venta.getIdVenta());
                }
            } catch (SQLException ex) {
                Logger.getLogger(Venta.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }

    public boolean grabar() {
        String cadenaSQL = "INSERT INTO Venta (idCliente, fechaVenta) VALUES ('" + idCliente + "', NOW())";
        System.out.println("Insertando venta: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }
     public boolean grabarConProcedimientoAlmacenado(String cadenaArticulos, String cadenaMediosPago) {
        String cadenaSQL = "call RegistrarVentaEnModaClick('" + this.idCliente + "','" + cadenaArticulos + "','"
                + cadenaMediosPago + "')";
        return ConectorBD.ejecutarQuery(cadenaSQL);

    }
    public boolean modificar(String idAnterior) {
        String cadenaSQL = "UPDATE Venta SET idCliente = '" + idCliente + "', fechaVenta = NOW() WHERE idVenta = " + idAnterior;
        System.out.println("Modificando venta: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }
    
    

   public List<VentaDetalle> getDetalles() {
        return VentaDetalle.getListaEnObjetos("idVentaDetalle='" + idVenta + "'", null);
    }
    public boolean eliminarConProcedimiento() {
    // Comando SQL para llamar al procedimiento almacenado
    String cadenaSQL = "CALL EliminarVentaConDetalles(" + idVenta + ")";
    System.out.println("Ejecutando eliminación de la venta con el procedimiento almacenado: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }


    @Override
    public String toString() {
        return idVenta + " " + fechaVenta;
    }
    
    public boolean registrarVentaConPedido(String idPedido, String idCliente, String cadenaArticulos, String cadenaMediosPago) {
        boolean resultado = true;
        ConectorBD conector = new ConectorBD();

        // Conectar a la base de datos
        if (!conector.conectar()) {
            System.out.println("Error al conectarse a la base de datos.");
            return false;
        }

        // Dividir y procesar la cadena de artículos para asegurarse de que tiene el formato correcto
        String[] articulos = cadenaArticulos.split("\\|\\|");

        if (articulos.length == 0 || cadenaArticulos.isEmpty()) {
            System.out.println("No hay artículos para procesar.");
            conector.desconectar();
            return false;
        }

        // Construir la cadena SQL para invocar el procedimiento con todos los artículos y medios de pago
        StringBuilder cadenaSQL = new StringBuilder();
        cadenaSQL.append("CALL RegistrarVentaConPedido(")
                .append(idPedido).append(", '") // idPedido
                .append(idCliente).append("', '") // idCliente
                .append(cadenaArticulos).append("', '") // Cadena de artículos
                .append(cadenaMediosPago).append("')");   // Cadena de medios de pago

        // Ejecutar la consulta utilizando el método ejecutarQuery
        System.out.println("Ejecutando SQL: " + cadenaSQL.toString()); // Para depuración
        boolean ejecucionExitosa = conector.ejecutarQuery(cadenaSQL.toString());

        if (!ejecucionExitosa) {
            resultado = false;
            System.out.println("Error al ejecutar la consulta: " + cadenaSQL.toString());
        }

        // Desconectar después de realizar las operaciones
        conector.desconectar();

        return resultado;
    }

  public static List<String[]> getTotalVentas() {
    List<String[]> lista = new ArrayList<>();
    // Corregimos la referencia en la cláusula ON
    String cadenaSQL = "SELECT YEAR(fechaVenta) AS anio, SUM(ventaDetalle.cantidad * ventaDetalle.valorUnitVenta) AS ventas "
            + "FROM venta "
            + "INNER JOIN ventaDetalle ON venta.idVenta = ventaDetalle.idVentaDetalle " // Aquí usamos idVentaDetalle
            + "GROUP BY YEAR(fechaVenta);";
    ResultSet resultado = ConectorBD.consultar(cadenaSQL);
    try {
        while (resultado.next()) {
            String[] registro = new String[2];
            registro[0] = resultado.getString("anio");
            registro[1] = resultado.getString("ventas");
            lista.add(registro);
        }
    } catch (SQLException ex) {
        System.out.println("Error en getTotalVentas de Venta. \nCadenaSQL: " + cadenaSQL + "\nError : " + ex.getMessage());
    }
    return lista;
}


public static List<String[]> getTotalVentasPorMes() {
    List<String[]> lista = new ArrayList<>();
    // Corregimos la referencia en la cláusula ON
    String cadenaSQL = "SELECT DATE_FORMAT(fechaVenta, '%Y-%m') AS anio_mes, SUM(ventaDetalle.cantidad * ventaDetalle.valorUnitVenta) AS ventas "
            + "FROM venta "
            + "INNER JOIN ventaDetalle ON venta.idVenta = ventaDetalle.idVentaDetalle " // Corregido: idVentaDetalle
            + "GROUP BY DATE_FORMAT(fechaVenta, '%Y-%m');";
    ResultSet resultado = ConectorBD.consultar(cadenaSQL);
    try {
        while (resultado.next()) {
            String[] registro = new String[2];
            registro[0] = resultado.getString("anio_mes");
            registro[1] = resultado.getString("ventas");
            lista.add(registro);
        }
    } catch (SQLException ex) {
        System.out.println("Error en getTotalVentasPorMes de Venta. \nCadenaSQL: " + cadenaSQL + "\nError : " + ex.getMessage());
    }
    return lista;
}

public boolean verificarStockAntesDeVender(List<VentaDetalle> detallesVenta) {
    for (VentaDetalle detalle : detallesVenta) {
        // Obtener el artículo desde el inventario
        Inventario inventario = new Inventario(detalle.getIdArticuloInventario());
        int stockDisponible = Integer.parseInt(inventario.getStock());
        int cantidadVendida = Integer.parseInt(detalle.getCantidad());

        // Verificar si la cantidad vendida es mayor al stock disponible
        if (cantidadVendida > stockDisponible) {
            System.out.println("Error: No hay suficiente stock para el artículo " + inventario.getNombreArticulo());
            return false; // No hay suficiente stock, cancelamos la venta
        }
    }
    return true; // Hay suficiente stock para todos los artículos
}


    public static List<String[]> getTotalVentasPorDia() {
    List<String[]> lista = new ArrayList<>();
    // Corregimos la referencia en la cláusula ON
    String cadenaSQL = "SELECT DATE_FORMAT(fechaVenta, '%Y-%m-%d') AS fecha_dia, SUM(ventaDetalle.cantidad * ventaDetalle.valorUnitVenta) AS ventas "
            + "FROM venta "
            + "INNER JOIN ventaDetalle ON venta.idVenta = ventaDetalle.idVentaDetalle " // Corregido: idVentaDetalle
            + "GROUP BY DATE_FORMAT(fechaVenta, '%Y-%m-%d');";
    ResultSet resultado = ConectorBD.consultar(cadenaSQL);
    try {
        while (resultado.next()) {
            String[] registro = new String[2];
            registro[0] = resultado.getString("fecha_dia");
            registro[1] = resultado.getString("ventas");
            lista.add(registro);
        }
    } catch (SQLException ex) {
        System.out.println("Error en getTotalVentasPorDia de Venta. \nCadenaSQL: " + cadenaSQL + "\nError: " + ex.getMessage());
    }
    return lista;
}
    

}