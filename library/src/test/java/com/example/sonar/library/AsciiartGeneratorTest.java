package com.example.sonar.library;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

public class AsciiartGeneratorTest {
  
  @Test
  public void testGenerate() {
    assertEquals("(╯°□°)╯︵ ┻━┻", AsciiartGenerator.generate());
  }

}
