---
title: Docker, gRPC, and REST APIs in .NET
slug: docker-grpc-and-rest-apis-in-dotnet
date: 2023-06-05T11:53:00+12:00

categories: Development
tags:
  - grpc
  - docker
  - azure
  - dotnet
---

In the world of service APIs, gRPC undeniably shines. This high-performance framework, created by Google, provides a remarkable toolkit for building interconnected systems. With features like the high-performance protocol buffer serialization, generated clients and server stubs in many programming languages, and bidirectional streaming, it's a wonderful dance partner for ASP .NET.

However, while gRPC's capabilities are impressive, it isn't universally supported. In some instances, like certain load balancers, gRPC finds its hands tied. Additionally, the appeal of REST endpoints, with their direct browser testing convenience, remains strong. Hence, our solution: a blend of both worlds. Using gRPC JSON transcoding, we generate REST APIs from our protocol buffers.

## Dipping into gRPC JSON Transcoding with Proto

To exemplify gRPC JSON transcoding, let's take a peek at a sample proto code snippet:

```proto
syntax = "proto3";

option csharp_namespace = "GrpcServiceTranscoding";
import "google/api/annotations.proto"; // more config required: read post

package greet;

service GreetingService {
    rpc SayHello (GreetingRequest) returns (GreetingResponse) {
        option (google.api.http) = {
            get: "/v1/greet/{name}"
        };
    }
}

message GreetingRequest {
    string name = 1;
}

message GreetingResponse {
    string message = 1;
}
```

This sample illustrates a basic gRPC service GreetingService with a method SayHello. The google.api.http annotation instructs any configured middleware how to make the method into a RESTful HTTP API.

In the .NET world, integrating this involves adding necessary packages such as Grpc.AspNetCore and Microsoft.AspNetCore.Grpc.JsonTranscoding, and some configuration. For a deeper dive into this configuration, [Microsoft's documentation](https://learn.microsoft.com/en-nz/aspnet/core/grpc/json-transcoding) is an excellent guide.

When deploying onto cloud infrastructure like Azure Container Apps hosted behind Azure Front Door, we're confronted with connection issues for gRPC, like the infamous 'connection refused' error. This is often because load balancers such as Azure Font Door does not support the necessary functionality to service gRPC requests.

## Journey of a Request: HTTP Protocols and Versions

To explain the reasons why we may experience these connection errors, lets visualize the trajectory of an HTTP request from your external gRPC client to the API application hosted in Azure Container Apps behind Azure Front Door:

```
+----------------+
|    Consumer    |
+----------------+
  |
  | [HTTP/2, TLS]
  ↓
+-------------------+
| Azure Front Door  |
+-------------------+
  |
  | [HTTP/1.1, TLS]
  ↓
+----------------------+
| Azure Container App  |
+----------------------+
  |
  | [HTTP/1.1, non-TLS]
  ↓
+-------------------+
|  API Application  |
+-------------------+
```

You'll see that in this chain, the API application receives the request in HTTP/1.1 and without TLS. It's a common practice to delegate TLS termination to the hosting environment, which manages ingress into your applications. Configuring a container to securely serve encrypted requests can often add complexity to the process that is usually not necessary.

Given that gRPC requires HTTP/2, the last layer introduces a challenge. Kestrel, your trusty web host inside the container, **only serves non-TLS HTTP/2 requests on ports explicitly reserved only for HTTP/2**. This would mean that an external gRPC request would fail with some kind of 'socket closed' or 'connection refused' error in our example - it arrives at Kestrel's door both unencrypted and in HTTP/1.1.

This leaves us with a few choices: configure Kestrel to only accept HTTP/2 connections (not feasible with Azure Front Door - which only routes to the origin in HTTP/1.1), set up two hosted ports - one for gRPC (HTTP/2) and another for HTTP/1.1, or bring gRPC-Web into play.

## Configuring Kestrel: Balancing HTTP Protocols and Ports

To configure Kestrel to accept only HTTP/2, your `appsettings.json` should be adjusted to look like this:

```json
{
  "Kestrel": {
    "EndpointDefaults": {
      "Protocols": "Http2"
    }
  }
}
```

However, to configure Kestrel to handle different ports for HTTP/2 and HTTP/1.1, a slightly more elaborate setup is required:

```json
{
  "Kestrel": {
    "Endpoints": {
      "Http1": {
        "Url": "http://*:5000",
        "Protocols": "Http1"
      },
      "Http2": {
        "Url": "http://*:5001",
        "Protocols": "Http2"
      }
    }
  }
}
```

## Embracing gRPC-Web

gRPC-Web is a great ally in situations like these. It allows you to invoke gRPC services from external clients using HTTP/1.1. For more details on configuring gRPC-Web, [Microsoft's documentation](https://learn.microsoft.com/en-nz/aspnet/core/grpc/grpcweb) serves as a comprehensive guide.

In an application that I'm currently developing, I've opted for a twofold approach: using different ports for distinct HTTP protocols and integrating gRPC-Web. Here's how it works: 

Firstly, I'm using Dapr over gRPC within an Azure Container App. This allows me to communicate between applications within the same environment. A bonus here is that Azure Container Apps offers the option to designate a specific port for Dapr alone - which is our HTTP/2 gRPC port.

Secondly, I've opened up some of these gRPC services to the outside world. This is where gRPC-Web comes into play. It offers a way to expose these services to external consumers. 

However, it's important to note that while gRPC-Web smoothly navigates Azure Front Door (thanks to its use of the HTTP/1.1 protocol), it doesn't support client streaming capabilities. Despite this limitation, it has proven to be a valuable component in the setup.

## Concluding Thoughts: Striking the Right Balance

In summary, merging gRPC and REST APIs in .NET involves navigating through a varied landscape. Docker, gRPC, REST APIs, and .NET all have their unique strengths, and drawing the best from each can lead to a powerful, efficient, and flexible solution. This blended approach demonstrates that with the right understanding and a touch of creativity, we can indeed craft a solution that enjoys the best of all worlds.