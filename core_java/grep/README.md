# Introduction
This project implements a Java-based grep application that searches files in a directory for lines matching a given regular expression and writes the results to an output file. Two implementations are provided: a classic imperative version and a functional version using Java Streams and Lambdas. The app demonstrates recursive file traversal, regex pattern matching, and functional programming concepts using core Java libraries, Java 8 Stream API, and SLF4J for logging. The project was developed using IntelliJ IDEA and can be containerized with Docker for easy deployment.

# Quick Start
1. Compile the project using Maven:
   ```bash
   mvn clean package
   ```
2. Run the application
    ```bash
   java -jar target/grep.jar <regex> <rootDir> <outputFile>
   ```
   Example
    ```bash
   java -jar target/grep.jar "error" ./logs output.txt
    ```
3. The output file will contain all lines that match the given regex.

#Implemenation
## Pseudocode
```java
process():
  files = list all files recursively from root directory
  for each file in files:
    lines = read all lines from file
    for each line in lines:
      if line matches regex:
        store formatted result
  write all matched results to output file
```

## Performance Issue

The application loads entire files and all matched results into memory, which can cause high memory usage when processing large files or directories. This can be improved by streaming file lines one by one and writing matching lines incrementally to the output file instead of storing everything in memory.

# Test
Manual testing was performed by preparing sample directories with multiple text files containing known patterns. Different regex patterns were tested, including edge cases with no matches and large files. The output file was manually verified to ensure only correct lines were included and formatting matched expectations.

# Deployment
The application can be dockerized by creating a Dockerfile that uses an OpenJDK base image, copies the compiled JAR into the container, and defines an entry point to run the application. This allows the app to be executed consistently across environments without requiring local Java installation.

# Improvement
1. Stream file reading and writing to reduce memory consumption.

2. Add unit tests using JUnit and Mockito for better test coverage.

3. Improve error handling and logging for invalid input paths and regex patterns.