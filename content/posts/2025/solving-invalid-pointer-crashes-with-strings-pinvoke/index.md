---
title: Solving Invalid Pointer Crashes with Strings in P/Invoke
slug: solving-invalid-pointer-crashes-with-strings-pinvoke

categories: Engineering
tags:
  - dotnet

date: 2025-01-17T01:04:46+13:00
---

As part of a project I'm working on, I wanted to make use of FFmpeg - and I wanted to try interacting with the native libraries directly with P/Invoke instead of just calling the CLI.

Starting with something simple, I wanted to call some of the basic utility functions like getting the FFmpeg version - there's a function in `libavutil` called `av_version_info` with the following signature:

```c
const char *av_version_info(void)
{
    return FFMPEG_VERSION;
}
```

It just returns the string version of FFmpeg, nice and simple. So of course I constructed my native interop method in .NET like so:

```csharp
[LibraryImport("libavutil", EntryPoint = "av_version_info",
    StringMarshalling = StringMarshalling.Utf8)]
internal static partial string GetVersionInfo();
```

I went to run it in a toy console app and, oupe - it crashed! Huh? I thought this was supposed to be a simple starting point :(

{{< figure src="debugger-crash.png" caption="The application crashing with `munmap_chunk(): invalid pointer` when trying to marshal a string from native interop." >}}

And so I tried a bunch of different things to try and get this damn thing working without success, like replacing the `StringMarshalling` of the `LibraryImport` attribute with another attribute `[return: MarshalAs(UnmanagedType.LPWStr)]` (including all the different unmanaged string types) - no dice.

## The solution

I was getting frustrated and decided to just go old-school (?) and return a typical `IntPtr` instead of a string, and marshal it myself:

```csharp
[LibraryImport("libavutil", EntryPoint = "av_version_info")]
internal static partial IntPtr GetVersionInfo();

// ...

IntPtr pointer = Sample.GetVersionInfo();
Console.WriteLine(Marshal.PtrToStringUTF8(pointer));
```

That's great and all, but I didn't actually want to be writing my own marshalling, that's part of what I was hoping the source generator was going to do.

So I went looking at the source generated code from the earlier example, and saw that it was actually doing the same thing as I was doing manually? What gives?

As it turns out, the actual issue here was that it was also trying to __free__ the string as part of a `try/finally` block, and the invalid pointer crash was caused when it was being freed. I guess this has something to do with the native type `const char*`? The library automatically freeing the string?

**The *real* solution then**, is to create a custom marshaller for use with `LibraryImport` which does not expose a `Free` method, I made a simple one like this:

```csharp
[CustomMarshaller(typeof(string), MarshalMode.Default, typeof(Utf8ConstStringMarshaller))]
internal static class Utf8ConstStringMarshaller
{
    internal static unsafe string? ConvertToManaged(byte* unmanaged) => Marshal.PtrToStringUTF8((IntPtr)unmanaged);
    internal static unsafe byte* ConvertToUnmanaged(string managed) => (byte*)Marshal.StringToCoTaskMemUTF8(managed);
}
```

Which must be specified on all interop methods like so:

```csharp
[LibraryImport("libavutil", EntryPoint = "av_version_info",
    StringMarshallingCustomType = typeof(Utf8ConstStringMarshaller))]
internal static partial string GetVersionInfo();
```

{{< figure src="debugger-working.png" caption="Success! So happy :)" >}}

There's an [API proposal](https://github.com/dotnet/runtime/issues/76974) to allow specifying that marshalled strings should not be freed to avoid this error, but it doesn't seem to be going anywhere. Ah well.
