/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uk.gov.defra.jncc.topsat.api.resources;

import java.util.List;

/**
 *
 * @author felix
 */
public class ParameterValueList {
    public ParameterValueList (String parameter, List<String> values)
    {
        this.parameter = parameter;
        this.values = values;
    }
    
    public String parameter;
    public List<String> values;
}
