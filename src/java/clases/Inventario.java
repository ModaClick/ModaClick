package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Clase Inventario que maneja los datos de inventario en la base de datos.
 * 
 */
public class Inventario {
    private String idArticulo;
    private String nombreArticulo;
    private String descripcion;
    private String costoUnitarioCompra;
    private String valorUnitarioVenta;
    private String stock;
    private String stockMinimo;
    private String stockMaximo;
    private String tipoTela;
    private String colorArticulo;
    private String talla;
    private String impuesto;
    private String foto;
    private String idCategoria;

    public Inventario() {
    }

    public Inventario(String idArticulo) {
        String cadenaSQL = "SELECT nombreArticulo, descripcion, costoUnitarioCompra, valorUnitarioVenta,stock, stockMinimo, stockMaximo, tipoTela, colorArticulo, talla, impuesto, foto, idCategoria FROM inventario WHERE idArticulo=" + idArticulo;
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.idArticulo = idArticulo;
                this.nombreArticulo = resultado.getString("nombreArticulo");
                this.descripcion = resultado.getString("descripcion");
                this.costoUnitarioCompra = resultado.getString("costoUnitarioCompra");
                this.valorUnitarioVenta = resultado.getString("valorUnitarioVenta");
                this.stock = resultado.getString("stock");
                this.stockMinimo = resultado.getString("stockMinimo");
                this.stockMaximo = resultado.getString("stockMaximo");
                this.tipoTela = resultado.getString("tipoTela");
                this.colorArticulo = resultado.getString("colorArticulo");
                this.talla = resultado.getString("talla");
                this.impuesto = resultado.getString("impuesto");
                this.foto = resultado.getString("foto");
                this.idCategoria = resultado.getString("idCategoria");
            }
        } catch (SQLException ex) {
            Logger.getLogger(Inventario.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Getters y Setters
    public String getIdArticulo() {
        return idArticulo != null ? idArticulo : "";
    }

    public void setIdArticulo(String idArticulo) {
        this.idArticulo = idArticulo;
    }

    public String getNombreArticulo() {
        return nombreArticulo != null ? nombreArticulo : "";
    }

    public void setNombreArticulo(String nombreArticulo) {
        this.nombreArticulo = nombreArticulo;
    }

    public String getDescripcion() {
        return descripcion != null ? descripcion : "";
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getCostoUnitarioCompra() {
        return costoUnitarioCompra != null ? costoUnitarioCompra : "";
    }

    public void setCostoUnitarioCompra(String costoUnitarioCompra) {
        this.costoUnitarioCompra = costoUnitarioCompra;
    }

    public String getValorUnitarioVenta() {
        return valorUnitarioVenta != null ? valorUnitarioVenta : "";
    }

    public void setValorUnitarioVenta(String valorUnitarioVenta) {
        this.valorUnitarioVenta = valorUnitarioVenta;
    }

    public String getStockMinimo() {
        return stockMinimo != null ? stockMinimo : "";
    }

    public void setStockMinimo(String stockMinimo) {
        this.stockMinimo = stockMinimo;
    }

    public String getStockMaximo() {
        return stockMaximo != null ? stockMaximo : "";
    }

    public void setStockMaximo(String stockMaximo) {
        this.stockMaximo = stockMaximo;
    }

    public String getTipoTela() {
        return tipoTela != null ? tipoTela : "";
    }

    public void setTipoTela(String tipoTela) {
        this.tipoTela = tipoTela;
    }

    public String getColorArticulo() {
        return colorArticulo != null ? colorArticulo : "";
    }

    public void setColorArticulo(String colorArticulo) {
        this.colorArticulo = colorArticulo;
    }

    public String getTalla() {
        return talla != null ? talla : "";
    }

    public void setTalla(String talla) {
        this.talla = talla;
    }

    public String getFoto() {
        return foto != null ? foto : "";
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public String getIdCategoria() {
        return idCategoria != null ? idCategoria : "";
    }

    public void setIdCategoria(String idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getStock() {
        return stock;
    }

    public void setStock(String stock) {
        this.stock = stock;
    }

    public String getImpuesto() {
        String resultado=impuesto;
        if (impuesto==null){
            resultado= "";
        }
        return resultado;
    }

    public void setImpuesto(String impuesto) {
        this.impuesto = impuesto;
    }
    
    

    @Override
    public String toString() {
        return nombreArticulo;
    }

    // Método para guardar un nuevo registro en la base de datos
    public boolean grabar() {
        String cadenaSQL = "INSERT INTO inventario (nombreArticulo, descripcion, costoUnitarioCompra, valorUnitarioVenta, stock, stockMinimo, stockMaximo, tipoTela, colorArticulo, talla, impuesto, foto, idCategoria) " +
                           "VALUES ('" + nombreArticulo + "','" + descripcion + "','" + costoUnitarioCompra + "','" + valorUnitarioVenta + "','" + stock + "','" + stockMinimo + "','" + stockMaximo + "','" + tipoTela + "','" + colorArticulo + "','" + talla + "','" + impuesto + "','" + foto + "','" + idCategoria + "')";
        System.out.println(cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para modificar un registro existente en la base de datos
    public boolean modificar() {
        String cadenaSQL = "UPDATE inventario SET nombreArticulo='" + nombreArticulo + "', descripcion='" + descripcion + "', costoUnitarioCompra='" + costoUnitarioCompra + "', valorUnitarioVenta='" + valorUnitarioVenta + "', stock='" + stock + "', stockMinimo='" + stockMinimo + "', stockMaximo='" + stockMaximo + "', tipoTela='" + tipoTela + "', colorArticulo='" + colorArticulo + "', talla='" + talla + "', impuesto='" + impuesto + "', foto='" + foto + "', idCategoria='" + idCategoria + "' WHERE idArticulo=" + idArticulo;
        System.out.println(cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para eliminar un registro de la base de datos
    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM inventario WHERE idArticulo=" + idArticulo;
        System.out.println(cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para obtener una lista de registros con filtro y orden opcional
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
        String cadenaSQL = "SELECT idArticulo, nombreArticulo, descripcion, costoUnitarioCompra, valorUnitarioVenta, stock, stockMinimo, stockMaximo, tipoTela, colorArticulo, talla, impuesto, foto, idCategoria FROM inventario" + filtro + orden;
        return ConectorBD.consultar(cadenaSQL);
    }

    // Método para obtener una lista de objetos Inventario con filtro y orden opcional
    public static List<Inventario> getListaEnObjetos(String filtro, String orden) {
        List<Inventario> lista = new ArrayList<>();
        ResultSet datos = Inventario.getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    Inventario inventario = new Inventario();
                    inventario.setIdArticulo(datos.getString("idArticulo"));
                    inventario.setNombreArticulo(datos.getString("nombreArticulo"));
                    inventario.setDescripcion(datos.getString("descripcion"));
                    inventario.setCostoUnitarioCompra(datos.getString("costoUnitarioCompra"));
                    inventario.setValorUnitarioVenta(datos.getString("valorUnitarioVenta"));
                    inventario.setStock(datos.getString("stock"));
                    inventario.setStockMinimo(datos.getString("stockMinimo"));
                    inventario.setStockMaximo(datos.getString("stockMaximo"));
                    inventario.setTipoTela(datos.getString("tipoTela"));
                    inventario.setColorArticulo(datos.getString("colorArticulo"));
                    inventario.setTalla(datos.getString("talla"));
                    inventario.setImpuesto(datos.getString("impuesto"));
                    inventario.setFoto(datos.getString("foto"));
                    inventario.setIdCategoria(datos.getString("idCategoria"));
                    lista.add(inventario);
                }
            } catch (SQLException ex) {
                Logger.getLogger(Inventario.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }
}
