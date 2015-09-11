package com.example;

import org.apache.camel.spring.Main;

public class MainApp {
    public static void main(String... args) throws Exception {
        Main main = new Main();
        main.enableHangupSupport();
        main.run(args);
    }
}
