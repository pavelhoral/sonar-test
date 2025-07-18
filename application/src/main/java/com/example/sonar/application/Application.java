package com.example.sonar.application;

import java.util.Scanner;

import com.example.sonar.library.AsciiartGenerator;

import picocli.CommandLine;
import picocli.CommandLine.Command;

@Command(
  name = "hello",
  description = "Says hello"
)
public class Application implements Runnable {

  public static void main(String[] args) {
    new CommandLine(new Application()).execute(args);
  }

  public void run() {
    System.out.println(AsciiartGenerator.generate());
    System.out.println("HELLO " + readName());
  }

  public static String readName() {
    Scanner scanner = new Scanner(System.in);
    return scanner.next();
  }

}
