package com.example;

import org.apache.camel.builder.RouteBuilder;

public class HelloRouteBuilder extends RouteBuilder {

    @Override
    public void configure() throws Exception {

        // Print happy greeting every five seconds.
        // To who depends on Camel Properties with key 'friend'.
        from("timer://mytimer?period=5s")
        .log("Hello, {{friend}}!");
    }
}
