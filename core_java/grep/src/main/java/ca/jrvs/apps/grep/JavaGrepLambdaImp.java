package ca.jrvs.apps.grep;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.BufferedReader;
//import java.io.FileReader;
//import java.io.BufferedWriter;
//import java.io.FileOutputStream;
//import java.io.OutputStreamWriter;

public class JavaGrepLambdaImp extends JavaGrepImp{
  private static final Logger logger = LoggerFactory.getLogger(JavaGrepImp.class);

  public static void main(String[] args) {
    if(args.length != 3){
      logger.error("USAGE: JavaGrep regex rootPath outFile");
      System.exit(1);
    }

    JavaGrepLambdaImp JavaGrepLambdaImp = new JavaGrepLambdaImp();
    JavaGrepLambdaImp.setRegex(args[0]);
    JavaGrepLambdaImp.setRootPath(args[1]);
    JavaGrepLambdaImp.setOutFile(args[2]);

    try{
      JavaGrepLambdaImp.process();
    } catch (Exception ex) {JavaGrepLambdaImp.logger.error("Error: unable to process", ex);}
  }
  @Override
  public List<String> readLines(File inputFile) {
    try (BufferedReader br = new BufferedReader(
        new InputStreamReader(new FileInputStream(inputFile)))) {

      return br.lines().collect(Collectors.toList());

    } catch (IOException e) {
      throw new RuntimeException("Failed to read file " + inputFile, e);
    }
  }

  @Override
  public List<File> listFiles(String rootDir) {
    File root = new File(rootDir);

    if (!root.exists()) {
      return Collections.emptyList();
    }

    if (root.isFile()) {
      return Collections.singletonList(root);
    }

    File[] children = root.listFiles();
    if (children == null) {
      return Collections.emptyList();
    }

    return Arrays.stream(children)
        .flatMap(file -> {
          if (file.isFile()) {
            return Stream.of(file);
          } else {
            return listFiles(file.getAbsolutePath()).stream();
          }
        })
        .collect(Collectors.toList());
  }


}
