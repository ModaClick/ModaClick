package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VentaDetalle {

    private String id;
    private String idVentaDetalle;
    private String idArticuloInventario;
    private String cantidad;
    private String valorUnitVenta; // Cambiado a valorUnitVenta
    private int impuesto;  // Guardamos solo el porcentaje del impuesto

    public VentaDetalle() {
        System.out.println("Inicializando objeto VentaDetalle vacío.");
    }

    public VentaDetalle(String id) {
        this.id = id;
        String cadenaSQL = "SELECT idVentaDetalle, idArticuloInventario, cantidad, valorUnitVenta, impuesto "
                + "FROM VentaDetalle WHERE id = " + id;
        System.out.println("Consulta SQL para cargar detalle de venta: " + cadenaSQL);

        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                idVentaDetalle = resultado.getString("idVentaDetalle");
                idArticuloInventario = resultado.getString("idArticuloInventario");
                cantidad = resultado.getString("cantidad");
                valorUnitVenta = resultado.getString("valorUnitVenta");
                impuesto = resultado.getInt("impuesto");  // Solo el porcentaje del impuesto
                System.out.println("Detalle de venta cargado: idArticulo=" + idArticuloInventario + ", cantidad=" + cantidad + ", valorUnitVenta=" + valorUnitVenta + ", impuesto=" + impuesto);
            } else {
                System.out.println("No se encontró el detalle de venta con id: " + id);
            }
        } catch (SQLException ex) {
            Logger.getLogger(VentaDetalle.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Métodos get y set
    public String getId() {
        return id != null ? id : "";
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdVentaDetalle() {
        return idVentaDetalle != null ? idVentaDetalle : "";
    }

    public void setIdVentaDetalle(String idVentaDetalle) {
        this.idVentaDetalle = idVentaDetalle;
    }

    public String getIdArticuloInventario() {
        return idArticuloInventario != null ? idArticuloInventario : "";
    }

    public void setIdArticuloInventario(String idArticuloInventario) {
        this.idArticuloInventario = idArticuloInventario;
    }

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public String getValorUnitVenta() {
        return valorUnitVenta;
    }

    public void setValorUnitVenta(String valorUnitVenta) {
        this.valorUnitVenta = valorUnitVenta;
    }

    public int getImpuesto() {
        return impuesto;
    }

    public void setImpuesto(int impuesto) {
        this.impuesto = impuesto;
    }

    // Método para calcular el subtotal de la venta
    public int getSubTotal() {
        int subTotal = 0;
        if (cantidad != null && valorUnitVenta != null) {
            subTotal = Integer.parseInt(cantidad) * Integer.parseInt(valorUnitVenta);
            System.out.println("Calculando subtotal: cantidad=" + cantidad + ", valor unitario=" + valorUnitVenta + ", subtotal=" + subTotal);
        } else {
            System.out.println("Error al calcular subtotal: cantidad o valorUnitVenta son nulos.");
        }
        return subTotal;
    }

    public String getNombreYPorcentajeImpuesto() {
    String nombreImpuesto = "";  // Iniciar vacío para concatenar los impuestos
    String cadenaSQL = "SELECT nombre, porcentaje FROM Impuesto "
            + "INNER JOIN ImpuestoInventario ON Impuesto.idImpuesto = ImpuestoInventario.idImpuesto "
            + "WHERE ImpuestoInventario.idArticulo = " + idArticuloInventario;

    ResultSet resultado = ConectorBD.consultar(cadenaSQL);
    try {
        while (resultado.next()) {  // Cambiamos a `while` para recorrer todos los impuestos
            String nombre = resultado.getString("nombre");
            int porcentaje = resultado.getInt("porcentaje");  // Obtener también el porcentaje del impuesto
            // Concatenar los impuestos en una sola cadena
            nombreImpuesto += nombre + " " + porcentaje + "%<br>";
        }
    } catch (SQLException ex) {
        Logger.getLogger(VentaDetalle.class.getName()).log(Level.SEVERE, null, ex);
    }
    return nombreImpuesto.isEmpty() ? "Sin impuesto" : nombreImpuesto;  // Si no hay impuestos, mostrar un texto por defecto
}


   public boolean grabar() {
    // Obtener el valorUnitVenta del artículo desde Inventario
    String cadenaSQLInventario = "SELECT valorUnitVenta FROM inventario WHERE idArticulo = '" + idArticuloInventario + "'";
    System.out.println("Consulta SQL para obtener valor unitario del inventario: " + cadenaSQLInventario);
    
    ResultSet resultadoInventario = ConectorBD.consultar(cadenaSQLInventario);
    
    try {
        if (resultadoInventario.next()) {
            // Obtener el valor unitario de venta desde Inventario y asignarlo al campo valorUnitVenta
            valorUnitVenta = resultadoInventario.getString("valorUnitVenta");
            System.out.println("Valor unitario obtenido del inventario: " + valorUnitVenta);
        } else {
            System.out.println("No se encontró el artículo en inventario con id: " + idArticuloInventario);
            return false;  // Si no encuentra el artículo, no continuar
        }
    } catch (SQLException ex) {
        Logger.getLogger(VentaDetalle.class.getName()).log(Level.SEVERE, null, ex);
        return false;  // Si hay un error en la consulta, retornar false
    }
    
    // Luego, insertar el detalle de la venta en VentaDetalle con el valor unitario correcto
    String cadenaSQL = "INSERT INTO VentaDetalle (idVentaDetalle, idArticuloInventario, cantidad, valorUnitVenta, impuesto) "
                     + "VALUES ('" + idVentaDetalle + "','" + idArticuloInventario + "','" + cantidad + "','" + valorUnitVenta + "','" + impuesto + "')";
    System.out.println("Insertando detalle de venta con valor unitario del inventario: " + cadenaSQL);
    
    return ConectorBD.ejecutarQuery(cadenaSQL);
}



    // Método para modificar el detalle de la venta en la base de datos
    public boolean modificar() {
        String cadenaSQL = "UPDATE VentaDetalle SET idVentaDetalle = '" + idVentaDetalle + "', idArticuloInventario = '" + idArticuloInventario + "', cantidad = '" + cantidad + "', valorUnitVenta = '" + valorUnitVenta + "', impuesto = '" + impuesto + "' WHERE id = " + id;
        System.out.println("Modificando detalle de venta: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para eliminar el detalle de la venta en la base de datos
    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM VentaDetalle WHERE id = " + id;
        System.out.println("Eliminando detalle de venta: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para obtener una lista de detalles de venta desde la base de datos
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

        String cadenaSQL = "SELECT VentaDetalle.id, VentaDetalle.idVentaDetalle, VentaDetalle.idArticuloInventario, VentaDetalle.cantidad, VentaDetalle.valorUnitVenta, VentaDetalle.impuesto "
                + "FROM VentaDetalle "
                + "INNER JOIN Inventario ON Inventario.idArticulo = VentaDetalle.idArticuloInventario "
                + "INNER JOIN Venta ON Venta.idVenta = VentaDetalle.idVentaDetalle " + filtro + orden;

        System.out.println("Consulta SQL para obtener lista de detalles de venta: " + cadenaSQL);
        return ConectorBD.consultar(cadenaSQL);
    }

    // Método para obtener una lista de detalles de venta como objetos
    public static List<VentaDetalle> getListaEnObjetos(String filtro, String orden) {
        List<VentaDetalle> lista = new ArrayList<>();
        ResultSet datos = getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    VentaDetalle detalle = new VentaDetalle();
                    detalle.setId(datos.getString("id"));
                    detalle.setIdVentaDetalle(datos.getString("idVentaDetalle"));
                    detalle.setIdArticuloInventario(datos.getString("idArticuloInventario"));
                    detalle.setCantidad(datos.getString("cantidad"));
                    detalle.setValorUnitVenta(datos.getString("valorUnitVenta"));
                    detalle.setImpuesto(datos.getInt("impuesto"));
                    lista.add(detalle);
                    System.out.println("Detalle agregado a la lista: " + detalle.getId());
                }
            } catch (SQLException ex) {
                Logger.getLogger(VentaDetalle.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }
}
