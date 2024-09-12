/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clases;

/**
 *
 * @author SENA
 */
public class TipoGenero {
    private String codigo;

    public TipoGenero(String codigo) {
        this.codigo = codigo;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
    
    
    public String getGenero(){
        String genero = null;
        switch (codigo){
            case "M" : genero = "Masculino"; break;
            case "F" : genero = "Femenino"; break;
            default : genero = "Otro"; break;
        }
        
        return genero;
    }
    
    @Override
    public String toString(){
        return getGenero();
    }
    
    public String getRadioButtons(){
        String lista="";
        if(codigo==null) codigo="";
        switch(codigo){
            case "M":
                lista="<input type='radio' name='genero' value='M' checked>Maculino"
                        +"<input type='radio' name='genero value='F'>Femenino";
                break;
            case "F":
                lista="<input type='radio' name='genero' value='M'>Masculino "
                        + "<input type='radio' name='genero' value='F' checked> Femenino";
                break;
                   
                default:
                lista="<input type='radio' name='genero' value='M' checked>Masculino "
                        + "<input type='radio' name='genero' value='F'> Femenino";
                break;
        }
        return lista;
    }
}
