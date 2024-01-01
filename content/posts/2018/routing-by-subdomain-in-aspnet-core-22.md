---
title: Routing by Subdomain in ASP.NET Core 2.2
date: 2018-09-30T23:14:00+12:00

categories: Engineering
tags:
  - dotnet
---

A long time ago I wanted to do some routing through a project using a wildcard subdomain, something like a simulated multi-tenanted setup for a service.

### Custom router

The way to do this is to create a custom router. Create a class under `/Services/CustomerCouter.cs` with the following content:

```cs
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using Microsoft.AspNetCore.Mvc.Internal;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Logging;

namespace DNSRouting.Services
{
    public class CustomRouter : MvcRouteHandler, IRouter
    {
        private IActionContextAccessor _actionContextAccessor;
        private IActionInvokerFactory _actionInvokerFactory;
        private IActionSelector _actionSelector;
        private ILogger _logger;
        private DiagnosticSource _diagnosticSource;


        public CustomRouter(
            IActionInvokerFactory actionInvokerFactory,
            IActionSelector actionSelector,
            DiagnosticSource diagnosticSource,
            ILoggerFactory loggerFactory)
            : this(actionInvokerFactory, actionSelector, diagnosticSource, loggerFactory, actionContextAccessor: null)
        {
        }

        public CustomRouter(IActionInvokerFactory actionInvokerFactory, IActionSelector actionSelector, DiagnosticSource diagnosticSource,
            ILoggerFactory loggerFactory, IActionContextAccessor actionContextAccessor)
            : base(actionInvokerFactory, actionSelector, diagnosticSource,
            loggerFactory, actionContextAccessor)
        {
            _actionContextAccessor = actionContextAccessor;
            _actionInvokerFactory = actionInvokerFactory;
            _actionSelector = actionSelector;
            _diagnosticSource = diagnosticSource;
            _logger = loggerFactory.CreateLogger<MvcRouteHandler>();
        }

        public new Task RouteAsync(RouteContext context)
        {
            if (context == null)
            {
                throw new ArgumentNullException(nameof(context));
            }

            // *****
            // ⚠️ This is the important part! ⚠️
            // *****
            string Host = context.HttpContext.Request.Host.Host;
            if (Host == "localhost") // Change this the to your usual host
            {
                // Do nothing, normal routing
            }
            else
            {
                // You can do pretty much anything here, but I chose to switch
                // to a different controller. ✅
                context.RouteData.Values["controller"] = "Alternate";
                context.RouteData.Values.Add("Host", Host); // Add a variable for fun
            }

            // All the next code is copied from base class
            var candidates = _actionSelector.SelectCandidates(context);
            if (candidates == null || candidates.Count == 0)
            {
                return Task.CompletedTask;
            }

            var actionDescriptor = _actionSelector.SelectBestCandidate(context, candidates);
            if (actionDescriptor == null)
            {
                return Task.CompletedTask;
            }

            context.Handler = (c) =>
            {
                var routeData = c.GetRouteData();

                var actionContext = new ActionContext(context.HttpContext, routeData, actionDescriptor);
                if (_actionContextAccessor != null)
                {
                    _actionContextAccessor.ActionContext = actionContext;
                }

                var invoker = _actionInvokerFactory.CreateInvoker(actionContext);
                if (invoker == null)
                {
                    throw new InvalidOperationException();
                }

                return invoker.InvokeAsync();
            };

            return Task.CompletedTask;
        }
    }
}
```

### Configure in startup

Then you need to reference it in the `Startup.cs` file! Replace your configure method with the following:

```cs
public void Configure(IApplicationBuilder app, IHostingEnvironment env, CustomRouter customRouter)
{
    if (env.IsDevelopment())
    {
        app.UseDeveloperExceptionPage();
    }

    app.UseStaticFiles();

    app.UseMvc(routes =>
    {
        routes.DefaultHandler = customRouter;
        routes.MapRoute(
            name: "default",
            template: "{controller=Home}/{action=Index}/{id?}");
    });
}
```

### Accessing in the Controller

If you wanna do what I did (with the alternate controller), here's how you can access it:

```cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace DNSRouting.Controllers
{
    public class AlternateController : Controller
    {
        // GET: /<controller>/
        public string Index(string Host) // Host is set in CustomRouter
        {
            return String.Format("Alternate page, host = {0}", Host);
        }
    }
}
```

That's about it! You could do some kind of lookup on the host to get some kind of info from a data connection, and work with it like you would as if it was it's own web app! 🌐

I put everything into a repo as a full web app - you can [find that here](https://github.com/crookm/dnsrouting/tree/c0d4e5700cc7cdf750205d37dc7c319dd241c0d9).