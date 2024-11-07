package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CompraDetalle {

    private String id;
    private String idCompraDetalle;
    private String idArticuloInventario;
    private String cantidad;
    private String costoUnitCompra;
    private int impuesto;

    public CompraDetalle() {
        System.out.println("Inicializando objeto CompraDetalle vacío.");
    }

    public CompraDetalle(String id) {
        this.id = id;
        String cadenaSQL = "SELECT idCompraDetalle, idArticuloInventario, cantidad, costoUnitCompra, impuesto "
                + "FROM CompraDetalle WHERE id = " + id;
        System.out.println("Consulta SQL para cargar detalle de compra: " + cadenaSQL);

        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                idCompraDetalle = resultado.getString("idCompraDetalle");
                idArticuloInventario = resultado.getString("idArticuloInventario");
                cantidad = resultado.getString("cantidad");
                costoUnitCompra = resultado.getString("costoUnitCompra");
                impuesto = resultado.getInt("impuesto");
                System.out.println("Detalle de compra cargado: idArticulo=" + idArticuloInventario + ", cantidad=" + cantidad + ", costoUnitCompra=" + costoUnitCompra + ", impuesto=" + impuesto);
            } else {
                System.out.println("No se encontró el detalle de compra con id: " + id);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CompraDetalle.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getId() {
        return id != null ? id : "";
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdCompraDetalle() {
        return idCompraDetalle != null ? idCompraDetalle : "";
    }

    public void setIdCompraDetalle(String idCompraDetalle) {
        this.idCompraDetalle = idCompraDetalle;
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

    public String getCostoUnitCompra() {
        return costoUnitCompra;
    }

    public void setCostoUnitCompra(String costoUnitCompra) {
        this.costoUnitCompra = costoUnitCompra;
    }

    public int getImpuesto() {
        return impuesto;
    }

    public void setImpuesto(int impuesto) {
        this.impuesto = impuesto;
    }

    public int getSubTotal() {
        int subTotal = 0;
        if (cantidad != null && costoUnitCompra != null) {
            subTotal = Integer.parseInt(cantidad) * Integer.parseInt(costoUnitCompra);
            System.out.println("Calculando subtotal: cantidad=" + cantidad + ", costo unitario=" + costoUnitCompra + ", subtotal=" + subTotal);
        } else {
            System.out.println("Error al calcular subtotal: cantidad o costoUnitCompra son nulos.");
        }
        return subTotal;
    }

    public String getNombreYPorcentajeImpuesto() {
        String nombreImpuesto = "";
        String cadenaSQL = "SELECT nombre, porcentaje FROM Impuesto "
                + "INNER JOIN ImpuestoInventario ON Impuesto.idImpuesto = ImpuestoInventario.idImpuesto "
                + "WHERE ImpuestoInventario.idArticulo = " + idArticuloInventario;

        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            while (resultado.next()) {
                String nombre = resultado.getString("nombre");
                int porcentaje = resultado.getInt("porcentaje");
                nombreImpuesto += nombre + " " + porcentaje + "%<br>";
            }
        } catch (SQLException ex) {
            Logger.getLogger(CompraDetalle.class.getName()).log(Level.SEVERE, null, ex);
        }
        return nombreImpuesto.isEmpty() ? "Sin impuesto" : nombreImpuesto;
    }

    public boolean grabar() {
        String cadenaSQLInventario = "SELECT costoUnitCompra FROM inventario WHERE idArticulo = '" + idArticuloInventario + "'";
        System.out.println("Consulta SQL para obtener costo unitario del inventario: " + cadenaSQLInventario);
        
        ResultSet resultadoInventario = ConectorBD.consultar(cadenaSQLInventario);
        try {
            if (resultadoInventario.next()) {
                costoUnitCompra = resultadoInventario.getString("costoUnitCompra");
                System.out.println("Costo unitario obtenido del inventario: " + costoUnitCompra);
            } else {
                System.out.println("No se encontró el artículo en inventario con id: " + idArticuloInventario);
                return false;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CompraDetalle.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }

        String cadenaSQL = "INSERT INTO CompraDetalle (idCompraDetalle, idArticuloInventario, cantidad, costoUnitCompra, impuesto) "
                         + "VALUES ('" + idCompraDetalle + "','" + idArticuloInventario + "','" + cantidad + "','" + costoUnitCompra + "','" + impuesto + "')";
        System.out.println("Insertando detalle de compra con costo unitario del inventario: " + cadenaSQL);
        
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean modificar() {
        String cadenaSQL = "UPDATE CompraDetalle SET idCompraDetalle = '" + idCompraDetalle + "', idArticuloInventario = '" + idArticuloInventario + "', cantidad = '" + cantidad + "', costoUnitCompra = '" + costoUnitCompra + "', impuesto = '" + impuesto + "' WHERE id = " + id;
        System.out.println("Modificando detalle de compra: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM CompraDetalle WHERE id = " + id;
        System.out.println("Eliminando detalle de compra: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
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

        String cadenaSQL = "SELECT CompraDetalle.id, CompraDetalle.idCompraDetalle, CompraDetalle.idArticuloInventario, CompraDetalle.cantidad, CompraDetalle.costoUnitCompra, CompraDetalle.impuesto "
                + "FROM CompraDetalle "
                + "INNER JOIN Inventario ON Inventario.idArticulo = CompraDetalle.idArticuloInventario "
                + "INNER JOIN Compra ON Compra.idCompra = CompraDetalle.idCompraDetalle " + filtro + orden;

        System.out.println("Consulta SQL para obtener lista de detalles de compra: " + cadenaSQL);
        return ConectorBD.consultar(cadenaSQL);
    }

    public static List<CompraDetalle> getListaEnObjetos(String filtro, String orden) {
        List<CompraDetalle> lista = new ArrayList<>();
        ResultSet datos = getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    CompraDetalle detalle = new CompraDetalle();
                    detalle.setId(datos.getString("id"));
                    detalle.setIdCompraDetalle(datos.getString("idCompraDetalle"));
                    detalle.setIdArticuloInventario(datos.getString("idArticuloInventario"));
                    detalle.setCantidad(datos.getString("cantidad"));
                    detalle.setCostoUnitCompra(datos.getString("costoUnitCompra"));
                    detalle.setImpuesto(datos.getInt("impuesto"));
                    lista.add(detalle);
                    System.out.println("Detalle agregado a la lista: " + detalle.getId());
                }
            } catch (SQLException ex) {
                Logger.getLogger(CompraDetalle.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }
}
