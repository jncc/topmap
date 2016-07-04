
package uk.gov.defra.jncc.topsat.api.services;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import org.springframework.stereotype.Service;

public class FileReader {

    public FileReaderResponse Get(String path) throws FileNotFoundException {
        File file = new File(path);
        FileInputStream fis = new FileInputStream(file);
        long fileSize = file.length();
        return new FileReaderResponse(fis, fileSize);
    }
}
