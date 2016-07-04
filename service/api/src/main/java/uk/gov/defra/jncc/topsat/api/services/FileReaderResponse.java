/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uk.gov.defra.jncc.topsat.api.services;

import java.io.FileInputStream;

/**
 *
 * @author felix
 */
public class FileReaderResponse {
    public FileInputStream fileStream;
    public Long fileSize;  
    
    public FileReaderResponse (FileInputStream fileStream, long fileSize)
    {
        this.fileStream = fileStream;
        this.fileSize = fileSize;
    }

}
