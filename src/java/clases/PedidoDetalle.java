package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PedidoDetalle {
    private String id;
    private String idPedido;
    private String idArticulo;
    private String cantidad;
    private String valorUnitVenta;  // Ajustado a valorUnitVenta, como en la base de datos

    // Constructor vacío
    public PedidoDetalle() {
    }

    // Constructor para cargar un PedidoDetalle específico por su ID
    public PedidoDetalle(String id) {
        String cadenaSQL = "SELECT idPedido, idArticulo, cantidad, valorUnitVenta FROM PedidoDetalle WHERE id = " + id;
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.id = id;
                idPedido = resultado.getString("idPedido");
                idArticulo = resultado.getString("idArticulo");
                cantidad = resultado.getString("cantidad");
                valorUnitVenta = resultado.getString("valorUnitVenta");  // Ajustado a valorUnitVenta
            }
        } catch (SQLException ex) {
            Logger.getLogger(PedidoDetalle.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Getters y Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(String idPedido) {
        this.idPedido = idPedido;
    }

    public String getIdArticulo() {
        return idArticulo;
    }

    public void setIdArticulo(String idArticulo) {
        this.idArticulo = idArticulo;
    }

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public String getValorUnitVenta() {  // Cambiado a valorUnitVenta
        return valorUnitVenta;
    }

    public void setValorUnitVenta(String valorUnitVenta) {  // Cambiado a valorUnitVenta
        this.valorUnitVenta = valorUnitVenta;
    }

    // Método para grabar un nuevo PedidoDetalle
    public boolean grabar() {
        String cadenaSQL = "INSERT INTO PedidoDetalle (idPedido, idArticulo, cantidad, valorUnitVenta) VALUES ('" +
                idPedido + "', '" + idArticulo + "', '" + cantidad + "', '" + valorUnitVenta + "')";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para modificar un PedidoDetalle existente
    public boolean modificar() {
        String cadenaSQL = "UPDATE PedidoDetalle SET idArticulo = '" + idArticulo + "', cantidad = '" + cantidad + 
                "', valorUnitVenta = '" + valorUnitVenta + "' WHERE id = " + id;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para eliminar un PedidoDetalle
    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM PedidoDetalle WHERE id = " + id;
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }
    
    // Método para obtener los detalles de un pedido
    public static List<PedidoDetalle> getDetallesPorPedido(String idPedido) {
        List<PedidoDetalle> lista = new ArrayList<>();
        String cadenaSQL = "SELECT idArticulo, cantidad, valorUnitVenta "
                + "FROM PedidoDetalle WHERE idPedido = '" + idPedido + "'";
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);

        try {
            if (resultado != null) {
                while (resultado.next()) {
                    PedidoDetalle detalle = new PedidoDetalle();
                    detalle.setIdArticulo(resultado.getString("idArticulo"));
                    detalle.setCantidad(resultado.getString("cantidad"));
                    detalle.setValorUnitVenta(resultado.getString("valorUnitVenta"));  // Ajustado a valorUnitVenta

                    lista.add(detalle);
                }
            } else {
                System.out.println("No se encontraron detalles para el pedido con id: " + idPedido);
            }
        } catch (SQLException ex) {
            Logger.getLogger(PedidoDetalle.class.getName()).log(Level.SEVERE, null, ex);
        }

        return lista;
    }
}
