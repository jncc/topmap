/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package uk.gov.defra.jncc.topsat.api.configuration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 *
 * @author felix
 */
//@Component
//@ConfigurationProperties(prefix="api")
//public class ApiConfiguration
//{
//    private String sentinalFilePath;
//    private String landsatFilePath;
//
//    private String GetTerminatedPath(String rawPath)
//    {
//        if (!rawPath.endsWith("/"))
//        {
//            return rawPath + "/";
//        } else {
//            return rawPath;
//        }
//    }
//    
//    /**
//     * @return the sentinalFilePath
//     */
//    public String getSentinalFilePath() {
//        return GetTerminatedPath(sentinalFilePath);
//    }
//
//    /**
//     * @param sentinalFilePath the sentinalFilePath to set
//     */
//    public void setSentinalFilePath(String sentinalFilePath) {
//        this.sentinalFilePath = sentinalFilePath;
//    }
//
//    /**
//     * @return the landsatFilePath
//     */
//    public String getLandsatFilePath() {
//        return GetTerminatedPath(landsatFilePath);
//    }
//
//    /**
//     * @param landsatFilePath the landsatFilePath to set
//     */
//    public void setLandsatFilePath(String landsatFilePath) {
//        this.landsatFilePath = landsatFilePath;
//    }
//}

public class ApiConfiguration {
    public static String getLandsatFilePath() {
        return "/mnt/fileserv-data/landsat/files/";
    }
    
    public static String getSentinalFilePath() {
        return "/mnt/fileserv-data/sentinel/files/";
    }
}