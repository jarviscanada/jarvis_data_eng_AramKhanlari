package ca.jrvs.apps.grep;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;

public class JavaGrepImp implements JavaGrep{

  private static final Logger logger = LoggerFactory.getLogger(JavaGrepImp.class);

  private String regex;
  private String rootPath;
  private String outFile;

  @Override
  public String getRegex() {
    return regex;
  }

  @Override
  public void setRegex(String regex) {
    this.regex = regex;
  }

  @Override
  public String getRootPath() {
    return rootPath;
  }

  @Override
  public void setRootPath(String rootPath) {
    this.rootPath = rootPath;
  }

  @Override
  public String getOutFile() {
    return outFile;
  }

  @Override
  public void setOutFile(String outFile) {
    this.outFile = outFile;
  }

  @Override
  public void process() throws IOException {
    logger.info("Starting grep process");
    logger.info("Regex: {}", regex);
    logger.info("Root path: {}", rootPath);
    logger.info("Output file: {}", outFile);
    List<String> matchedLines = new LinkedList<>();
    List<File> files = listFiles(rootPath);
    for (File file : files) {
      for (String line : readLines(file)){
        if(containsPattern(line)){
          matchedLines.add(line);
        }
      }
    }
    logger.info("Writing matched lines to: {}", outFile);
    writeToFile(matchedLines);
    logger.info("Grep process completed");
  }

  @Override
  public List<File> listFiles(String rootDir) {
    List<File> result = new LinkedList<>();
    File root = new File(rootDir);

    if (root.isDirectory()) {
      File[] files = root.listFiles();
      if (files != null) {
        for (File file : files) {
          if (file.isDirectory()) {
            result.addAll(listFiles(file.getAbsolutePath()));
          } else {
            result.add(file);
          }
        }
      }
    } else {
      result.add(root);
    }

    return result;
  }

  @Override
  public List<String> readLines(File inputFile) {
    List<String> lines = new LinkedList<>();

    try (BufferedReader br = new BufferedReader(new FileReader(inputFile))) {
      String line;
      while ((line = br.readLine()) != null) {
        lines.add(line);
      }
    } catch (IOException e) {
      logger.error("Failed to read file: {}", inputFile.getAbsolutePath(), e);
    }

    return lines;
  }

  @Override
  public boolean containsPattern(String line) {
    return line.matches(regex);
  }

  @Override
  public void writeToFile(List<String> lines) throws IOException {
    try (
        FileOutputStream fos = new FileOutputStream(outFile);
        OutputStreamWriter osw = new OutputStreamWriter(fos);
        BufferedWriter bw = new BufferedWriter(osw)
    ) {
      for (String line : lines) {
        bw.write(line);
        bw.newLine();
      }
    }
  }


  public static void main(String[] args) {
    if(args.length != 3){
      logger.error("USAGE: JavaGrep regex rootPath outFile");
      System.exit(1);
    }

    JavaGrepImp javaGrepImp = new JavaGrepImp();
    javaGrepImp.setRegex(args[0]);
    javaGrepImp.setRootPath(args[1]);
    javaGrepImp.setOutFile(args[2]);

    try{
      javaGrepImp.process();
    } catch (Exception ex) {javaGrepImp.logger.error("Error: unable to process", ex);}
  }
}
