package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Inventario {
    private String idArticulo;
    private String nombreArticulo;
    private String descripcion;
    private String costoUnitCompra;
    private String valorUnitVenta;
    private String stock;
    private String stockMinimo;
    private String stockMaximo;
    private String tipoTela;
    private String colorArticulo;
    private String talla;
    private String foto;
    private String idCategoria;

    public Inventario() {
        System.out.println("Inicializando objeto Inventario vacío.");
    }

    public Inventario(String idArticulo) {
        this.idArticulo = idArticulo;
        String cadenaSQL = "SELECT nombreArticulo, descripcion, costoUnitCompra, valorUnitVenta, stock, stockMinimo, stockMaximo, tipoTela, colorArticulo, talla, foto, idCategoria FROM inventario WHERE idArticulo=" + idArticulo;
        System.out.println("Consulta SQL para cargar inventario: " + cadenaSQL);
        
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.nombreArticulo = resultado.getString("nombreArticulo");
                this.descripcion = resultado.getString("descripcion");
                this.costoUnitCompra = resultado.getString("costoUnitCompra");
                this.valorUnitVenta = resultado.getString("valorUnitVenta");
                this.stock = resultado.getString("stock");
                this.stockMinimo = resultado.getString("stockMinimo");
                this.stockMaximo = resultado.getString("stockMaximo");
                this.tipoTela = resultado.getString("tipoTela");
                this.colorArticulo = resultado.getString("colorArticulo");
                this.talla = resultado.getString("talla");
                this.foto = resultado.getString("foto");
                this.idCategoria = resultado.getString("idCategoria");
                System.out.println("Inventario cargado: " + this.toString());
            }
        } catch (SQLException ex) {
            Logger.getLogger(Inventario.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getIdArticulo() {
        return idArticulo;
    }

    public void setIdArticulo(String idArticulo) {
        this.idArticulo = idArticulo;
    }

    public String getNombreArticulo() {
        return nombreArticulo;
    }

    public void setNombreArticulo(String nombreArticulo) {
        this.nombreArticulo = nombreArticulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getCostoUnitCompra() {
        return costoUnitCompra;
    }

    public void setCostoUnitCompra(String costoUnitCompra) {
        this.costoUnitCompra = costoUnitCompra;
    }

    public String getValorUnitVenta() {
        return valorUnitVenta;
    }

    public void setValorUnitVenta(String valorUnitVenta) {
        this.valorUnitVenta = valorUnitVenta;
    }

    public String getStock() {
        return stock;
    }

    public void setStock(String stock) {
        this.stock = stock;
    }

    public String getStockMinimo() {
        return stockMinimo;
    }

    public void setStockMinimo(String stockMinimo) {
        this.stockMinimo = stockMinimo;
    }

    public String getStockMaximo() {
        return stockMaximo;
    }

    public void setStockMaximo(String stockMaximo) {
        this.stockMaximo = stockMaximo;
    }

    public String getTipoTela() {
        return tipoTela;
    }

    public void setTipoTela(String tipoTela) {
        this.tipoTela = tipoTela;
    }

    public String getColorArticulo() {
        return colorArticulo;
    }

    public void setColorArticulo(String colorArticulo) {
        this.colorArticulo = colorArticulo;
    }

    public String getTalla() {
        return talla;
    }

    public void setTalla(String talla) {
        this.talla = talla;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public String getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(String idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombreCategoria() {
        Categoria categoria = new Categoria(idCategoria);
        return categoria.getNombre();
    }

    @Override
    public String toString() {
        return "Inventario{" +
                "idArticulo='" + idArticulo + '\'' +
                ", nombreArticulo='" + nombreArticulo + '\'' +
                ", descripcion='" + descripcion + '\'' +
                ", costoUnitCompra='" + costoUnitCompra + '\'' +
                ", valorUnitVenta='" + valorUnitVenta + '\'' +
                ", stock='" + stock + '\'' +
                ", stockMinimo='" + stockMinimo + '\'' +
                ", stockMaximo='" + stockMaximo + '\'' +
                ", tipoTela='" + tipoTela + '\'' +
                ", colorArticulo='" + colorArticulo + '\'' +
                ", talla='" + talla + '\'' +
                ", foto='" + foto + '\'' +
                ", idCategoria='" + idCategoria + '\'' +
                '}';
    }

    public boolean grabar() {
        String cadenaSQL = "INSERT INTO inventario (nombreArticulo, descripcion, costoUnitCompra, valorUnitVenta, stock, stockMinimo, stockMaximo, tipoTela, colorArticulo, talla, foto, idCategoria) "
                + "VALUES ('" + nombreArticulo + "','" + descripcion + "','" + costoUnitCompra + "','" + valorUnitVenta + "','" + stock + "','" + stockMinimo + "','" + stockMaximo + "','" + tipoTela + "','" + colorArticulo + "','" + talla + "','" + foto + "','" + idCategoria + "')";
        System.out.println("Insertando inventario: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean modificar() {
        String cadenaSQL = "UPDATE inventario SET nombreArticulo='" + nombreArticulo + "', descripcion='" + descripcion + "', costoUnitCompra='" + costoUnitCompra + "', valorUnitVenta='" + valorUnitVenta + "', stock='" + stock + "', stockMinimo='" + stockMinimo + "', stockMaximo='" + stockMaximo + "', tipoTela='" + tipoTela + "', colorArticulo='" + colorArticulo + "', talla='" + talla + "', foto='" + foto + "', idCategoria='" + idCategoria + "' WHERE idArticulo=" + idArticulo;
        System.out.println("Modificando inventario: " + cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM inventario WHERE idArticulo=" + idArticulo;
        System.out.println("Eliminando inventario: " + cadenaSQL);
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

        String cadenaSQL = "SELECT i.idArticulo, i.nombreArticulo, i.descripcion, i.costoUnitCompra, i.valorUnitVenta, "
                + "i.stock, i.stockMinimo, i.stockMaximo, i.tipoTela, i.colorArticulo, i.talla, i.foto, i.idCategoria, "
                + "GROUP_CONCAT(imp.nombre, ' (', imp.porcentaje, '%)') AS impuestos "
                + "FROM Inventario i "
                + "LEFT JOIN ImpuestoInventario ii ON i.idArticulo = ii.idArticulo "
                + "LEFT JOIN Impuesto imp ON ii.idImpuesto = imp.idImpuesto "
                + filtro
                + " GROUP BY i.idArticulo"
                + orden;

        System.out.println("Consulta ejecutada: " + cadenaSQL);
        return ConectorBD.consultar(cadenaSQL);
    }

    public List<Impuesto> obtenerImpuestos() {
        List<Impuesto> impuestos = new ArrayList<>();
        String sql = "SELECT imp.nombre, imp.porcentaje "
                + "FROM ImpuestoInventario ii "
                + "JOIN Impuesto imp ON ii.idImpuesto = imp.idImpuesto "
                + "WHERE ii.idArticulo = " + this.idArticulo;
        ResultSet resultado = ConectorBD.consultar(sql);
        try {
            while (resultado.next()) {
                Impuesto impuesto = new Impuesto();
                impuesto.setNombre(resultado.getString("nombre"));
                impuesto.setPorcentaje(resultado.getString("porcentaje"));
                impuestos.add(impuesto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return impuestos;
    }

    public List<Integer> obtenerIdImpuestosAsociados() {
        List<Integer> idsImpuestos = new ArrayList<>();
        String sql = "SELECT imp.idImpuesto "
                + "FROM ImpuestoInventario ii "
                + "JOIN Impuesto imp ON ii.idImpuesto = imp.idImpuesto "
                + "WHERE ii.idArticulo = " + this.idArticulo;
        ResultSet resultado = ConectorBD.consultar(sql);
        try {
            while (resultado.next()) {
                idsImpuestos.add(resultado.getInt("idImpuesto"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return idsImpuestos;
    }

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
                    inventario.setCostoUnitCompra(datos.getString("costoUnitCompra"));
                    inventario.setValorUnitVenta(datos.getString("valorUnitVenta"));
                    inventario.setStock(datos.getString("stock"));
                    inventario.setStockMinimo(datos.getString("stockMinimo"));
                    inventario.setStockMaximo(datos.getString("stockMaximo"));
                    inventario.setTipoTela(datos.getString("tipoTela"));
                    inventario.setColorArticulo(datos.getString("colorArticulo"));
                    inventario.setTalla(datos.getString("talla"));
                    inventario.setFoto(datos.getString("foto"));
                    inventario.setIdCategoria(datos.getString("idCategoria"));
                    lista.add(inventario);
                    System.out.println("Inventario agregado a la lista: " + inventario.getIdArticulo());
                }
            } catch (SQLException ex) {
                Logger.getLogger(Inventario.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }

    public static String getListaCompletaEnArregloJS(String filtro, String orden) {
        String lista = "[";
        List<Inventario> datos = Inventario.getListaEnObjetos(filtro, orden);
        for (int i = 0; i < datos.size(); i++) {
            Inventario inventario = datos.get(i);
            if (i > 0) lista += ",";
            lista += "[";
            lista += "'" + inventario.getIdArticulo() + "',";            
            lista += "'" + inventario.getNombreArticulo()+ "',";            
            lista += "'" + inventario.getValorUnitVenta() + "',";
            lista += "'" + inventario.getTipoTela() + "',";
            lista += "'" + inventario.getColorArticulo() + "',";
            lista += "'" + inventario.getTalla() + "'";
            lista += "]";
        }
        lista += "];";
        return lista;
    }
    public static List<String[]> getInventarioPorCategoria() {
    List<String[]> lista = new ArrayList<>();
    // Consulta SQL que obtiene el total de artículos agrupado por categoría
    String cadenaSQL = "SELECT c.nombre AS categoria, SUM(i.stock) AS total_articulos "
                     + "FROM inventario i "
                     + "INNER JOIN categoria c ON i.idCategoria = c.idCategoria "
                     + "GROUP BY c.nombre;";
    
    ResultSet resultado = ConectorBD.consultar(cadenaSQL);
    
    try {
        while (resultado.next()) {
            String[] registro = new String[2];
            registro[0] = resultado.getString("categoria"); // Nombre de la categoría
            registro[1] = resultado.getString("total_articulos"); // Total de artículos en esa categoría
            lista.add(registro);
        }
    } catch (SQLException ex) {
        System.out.println("Error en getInventarioPorCategoria de Inventario. \nCadenaSQL: " + cadenaSQL + "\nError : " + ex.getMessage());
    }
    return lista;
}

}
