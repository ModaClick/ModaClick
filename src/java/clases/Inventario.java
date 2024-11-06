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
    }

    public Inventario(String idArticulo) {
        String cadenaSQL = "SELECT nombreArticulo, descripcion, costoUnitCompra, valorUnitVenta, stock, stockMinimo, stockMaximo, tipoTela, colorArticulo, talla, foto, idCategoria FROM inventario WHERE idArticulo=" + idArticulo;
        System.out.println(cadenaSQL + " se imprimió");
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);
        try {
            if (resultado.next()) {
                this.idArticulo = idArticulo;
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

    public String getCostoUnitCompra() {
        return costoUnitCompra != null ? costoUnitCompra : "";
    }

    public void setCostoUnitCompra(String costoUnitCompra) {
        this.costoUnitCompra = costoUnitCompra;
    }

    public String getValorUnitVenta() {
        return valorUnitVenta != null ? valorUnitVenta : "";
    }

    public void setValorUnitVenta(String valorUnitVenta) {
        this.valorUnitVenta = valorUnitVenta;
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
        return stock != null ? stock : "";
    }

    public void setStock(String stock) {
        this.stock = stock;
    }

    @Override
    public String toString() {
        return nombreArticulo;
    }

    // Método para guardar un nuevo registro en la base de datos
    public boolean grabar() {
        String cadenaSQL = "INSERT INTO inventario (nombreArticulo, descripcion, costoUnitCompra, valorUnitVenta, stock, stockMinimo, stockMaximo, tipoTela, colorArticulo, talla, foto, idCategoria) " +
                "VALUES ('" + nombreArticulo + "', '" 
                + (descripcion != null ? descripcion.replace("'", "''") : "") + "', '"  // Manejo de nulos y comillas
                + (costoUnitCompra != null ? costoUnitCompra : "null") + "', '"
                + (valorUnitVenta != null ? valorUnitVenta : "null") + "', '"
                + (stock != null ? stock : "null") + "', '"
                + (stockMinimo != null ? stockMinimo : "null") + "', '"
                + (stockMaximo != null ? stockMaximo : "null") + "', '"
                + (tipoTela != null ? tipoTela : "") + "', '"
                + (colorArticulo != null ? colorArticulo : "") + "', '"
                + (talla != null ? talla : "") + "', '"
                + (foto != null ? foto : "") + "', '"
                + (idCategoria != null ? idCategoria : "null") + "')";

        System.out.println(cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    public boolean agregarImpuestoAInventario(int idArticulo, int idImpuesto) {
        String cadenaSQL = "INSERT INTO ImpuestoInventario (idArticulo, idImpuesto) VALUES (" + idArticulo + ", " + idImpuesto + ")";
        System.out.println(cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para modificar un registro existente en la base de datos
    public boolean modificar() {
        String cadenaSQL = "UPDATE inventario SET nombreArticulo='" + nombreArticulo + "', descripcion='" + (descripcion != null ? descripcion.replace("'", "''") : "") + "', costoUnitCompra='" + costoUnitCompra + "', valorUnitVenta='" + valorUnitVenta + "', stock='" + stock + "', stockMinimo='" + stockMinimo + "', stockMaximo='" + stockMaximo + "', tipoTela='" + tipoTela + "', colorArticulo='" + colorArticulo + "', talla='" + talla + "', foto='" + foto + "', idCategoria='" + idCategoria + "' WHERE idArticulo=" + idArticulo;
        System.out.println(cadenaSQL);
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para eliminar un registro de la base de datos
    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM inventario WHERE idArticulo=" + idArticulo;
        System.out.println(cadenaSQL);
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

        String cadenaSQL = "SELECT i.idArticulo, i.nombreArticulo, i.descripcion, i.costoUnitCompra, i.valorUnitVenta, " +
                "i.stock, i.stockMinimo, i.stockMaximo, i.tipoTela, i.colorArticulo, i.talla, i.foto, i.idCategoria, " +
                "GROUP_CONCAT(imp.nombre, ' (', imp.porcentaje, '%)') AS impuestos " +
                "FROM inventario i " +
                "LEFT JOIN ImpuestoInventario ii ON i.idArticulo = ii.idArticulo " +
                "LEFT JOIN Impuesto imp ON ii.idImpuesto = imp.idImpuesto " +
                filtro + 
                " GROUP BY i.idArticulo" + 
                orden;

        System.out.println("Consulta ejecutada: " + cadenaSQL); // Depuración
        return ConectorBD.consultar(cadenaSQL);
    }

    // ... (resto de métodos)


    
    public List<Impuesto> obtenerImpuestos() {
    List<Impuesto> impuestos = new ArrayList<>();
    String sql = "SELECT imp.nombre, imp.porcentaje " +
                 "FROM ImpuestoInventario ii " +
                 "JOIN Impuesto imp ON ii.idImpuesto = imp.idImpuesto " +
                 "WHERE ii.idArticulo = " + this.idArticulo;
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
    String sql = "SELECT imp.idImpuesto " +
                 "FROM ImpuestoInventario ii " +
                 "JOIN Impuesto imp ON ii.idImpuesto = imp.idImpuesto " +
                 "WHERE ii.idArticulo = " + this.idArticulo;
    ResultSet resultado = ConectorBD.consultar(sql);
    try {
        while (resultado.next()) {
            idsImpuestos.add(resultado.getInt("idImpuesto")); // Aquí solo obtienes el idImpuesto
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return idsImpuestos;
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
