---
title: Secure Random Short URLs from Incrementing Numbers in .NET
slug: secure-random-short-urls-from-incrementing-numbers-in-dotnet

categories: Development
tags:
- dotnet

date: 2023-12-24T16:12:25+13:00
---

When developing a web application, perhaps a URL shortener, you often need to store resources in a database and expose them via a URI - usually via some kind of generated identifier used as a primary key by the database. The two most common approaches include using uuids or auto-incrementing numbers.

Random UUIDs like `65ffda0e-c96e-410e-9b78-182b86fc73b1` are a great, secure choice for this purpose, but they tend to be quite long and not very user friendly - making them bad candidates for our toy URL shortener. An auto-incrementing number, on the other hand, is short and easy to remember, but it's not very secure. If you can guess the next number in the sequence, you can access the next resource in the database. This enables an attacker to scrape all the resources in the database, as well as advertise the number of resources in the database which may be sensitive information.

In this post, we'll look at how to generate a secure, random, short URL from an auto-incrementing number in .NET - much like the ones you see on [Imgur](https://imgur.com/gallery/jkZirZz), and [YouTube](https://www.youtube.com/watch?v=8GORd04jemI).

## The Problem

Let's start with our URL shortener's simple database table:

```sql
-- Postgres
CREATE TABLE urls (
    id BIGSERIAL PRIMARY KEY,
    url TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

Our application will create a new row in this table for each URL our visitors want to shorten. The `id` column is an auto-incrementing number, which means that each time we insert a new row, the `id` will be incremented by one. This is great for our application, because it means we don't need to worry about generating a unique identifier for each URL - we can just use the `id` column.

A route in our application will read part of the path, and look up the URL in the database. For example, if we visit `https://example.com/1`, our application will look up the URL with the `id` of `1` in the database, and redirect us to that URL. Adding more URLs to our database will increment the `id` column, so `https://example.com/2` will redirect us to the second URL in the database, and so on.

We can see how this might be a problem. If we can guess the next `id` in the sequence, we can access the next URL in the database. As previously mentioned, this enables an attacker to scrape all the resources in the database. A person using our URL shortener to share a private document, for example, might not want that document to be publicly accessible. Because of the structure of our URLs, our database is essentially an open book.

## Potential Solutions

### UUIDs

The first solution that comes to mind is to use a UUID instead of an auto-incrementing number. UUIDs are globally unique identifiers, which means that they are guaranteed to be unique across all space and (reasonable) time. This means that we can use them as identifiers in our database without worrying about collisions. UUIDs are also quite long, which means that they are very difficult to guess. This would make them a great choice for our URL shortener.

However, the length is both a blessing and a curse. UUIDs are 36 characters long, which is not ideal for a URL shortener. We could use another URL shortener to shorten our URLs, but that would be a bit silly.

The prime use case for URL shorteners these days is for within SMS messages or in printed media, where every character counts. We want to be able to generate the shortest possible URL, while still being secure. A UUID is not a great choice for this.

### Randomly Generated Short URLs

Another solution is to generate a random string of characters for each URL. This would be a great choice for our URL shortener, because it would be very difficult to guess the next URL in the sequence. We could use a random string of characters like `https://example.com/abc123`, which would be very difficult to guess. This would be a great choice for our URL shortener, but it would be difficult to guarantee that the generated string is unique.

We would need to check that the generated string is not already in use, and generate a new one if it is. This has the potential to be a very expensive operation, particularly as the number of URLs in our database increases, and the space of possible URLs decreases.

### Encrypted Auto-Incrementing Numbers

The solution which I prefer, is to encrypt the auto-incrementing identifier from the database.

When using an auto-incrementing number as an identifier, the database guarantees that the identifier is unique. This means that we don't need to worry about collisions in our database. Encryption is, of course, is a reversible process.

By encrypting the number, we are able to generate a unique, non-sequential, short URL for each resource in our database. This is a great choice for our URL shortener, because it is guaranteed to be unique, and it is very difficult to guess the next URL - much like a random string of characters. In our router, we can decrypt the identifier, and directly look up the resource in the database.

## Implementation

### Selecting a Cipher

The first step is to select a cipher. A cipher is an algorithm that is used to encrypt and decrypt data. There are many different ciphers to choose from, but we want to choose one that produces the smallest possible output while still being actively supported and shipped by the framework we are using (.NET) or a trusted library (such as bouncycastle) - we don't want to implement our own cipher code.

The best cipher I could find which fits these requirements is the [Blowfish](https://en.wikipedia.org/wiki/Blowfish_(cipher)) cipher.

### Code Implementation

In our code, we want to have at least two methods: one for encrypting, and one for decrypting. We also want to be able to specify an encryption key (which should be kept secret, and constant), as well as an alphabet of characters to use in the resulting string - which will be something like our own version of base64 encoding, custom so we can remove characters which look similar, as well as vowels to avoid generating offensive words.

For our implementation, we will make use of the [bouncycastle](https://www.bouncycastle.org/) library, which is a popular cryptography library for .NET. This library is available through the [BouncyCastle.Cryptography NuGet package](https://www.nuget.org/packages/BouncyCastle.Cryptography/). Be sure to add this package in your project before continuing.

```csharp
public static class SecureIdGenerator
{
    // TODO: move secrets to config to keep out of your repository
    private const string SecretEncryptionKey = "<replace me with something secure>"; // between 4 and 56 characters (inclusive)
    private static readonly char[] BaseChars = "0123456789BCDFGHJKMNPQRSTVWXYZbcdfghjkmnpqrstvwxyz".ToCharArray();

    public static string GenerateLink(long input)
    {
        var inputBytes = BitConverter.GetBytes(input);

        var cipher = new BlowfishEngine();
        cipher.Init(true, new KeyParameter(Encoding.ASCII.GetBytes(SecretEncryptionKey)));

        var outputBytes = new byte[inputBytes.Length];

        for (var i = 0; i < inputBytes.Length; i += cipher.GetBlockSize())
        {
            cipher.ProcessBlock(inputBytes, i, outputBytes, i);
        }

        var encryptedValue = BitConverter.ToUInt64(outputBytes, 0);
        return EncodeToBaseN(encryptedValue);
    }

    public static long DecodeLink(string link)
    {
        var encryptedValue = DecodeFromBaseN(link);

        var inputBytes = BitConverter.GetBytes(encryptedValue);
        var outputBytes = new byte[inputBytes.Length];

        var cipher = new BlowfishEngine();
        cipher.Init(false, new KeyParameter(Encoding.ASCII.GetBytes(SecretEncryptionKey)));

        for (var i = 0; i < inputBytes.Length; i += cipher.GetBlockSize())
        {
            cipher.ProcessBlock(inputBytes, i, outputBytes, i);
        }

        return BitConverter.ToInt64(outputBytes, 0);
    }

    private static string EncodeToBaseN(ulong input)
    {
        var result = new StringBuilder();
        var value = input;

        while (value > 0)
        {
            var remainder = value % (ulong)BaseChars.Length;
            result.Insert(0, BaseChars[remainder]);
            value /= (ulong)BaseChars.Length;
        }

        return result.ToString();
    }

    private static long DecodeFromBaseN(string link)
    {
        long result = 0;

        foreach (var c in link)
        {
            result *= BaseChars.Length;
            result += Array.IndexOf(BaseChars, c);
        }

        return result;
    }
}
```

### Testing

We can test our implementation by encoding a few IDs, and then decoding them back to their original values. We can do this by running the following code:

```csharp
foreach (var input in new[] { 1, 2, 3, 10, 9223372036854775807 })
{
    var encoded = SecureIdGenerator.GenerateLink(input);
    var decoded = SecureIdGenerator.DecodeLink(encoded);
    Console.WriteLine($"input: {input}, encoded: {encoded}, decoded: {decoded}");
}
```

Which produces the following output:

```
input: 1, encoded: 11GwcJS6fHn0, decoded: 1
input: 2, encoded: 2PK5h9B8b52S, decoded: 2
input: 3, encoded: 29Vvt9rk4Tvq, decoded: 3
input: 10, encoded: pSh7vYh83B8, decoded: 10
input: 9223372036854775807, encoded: 1WN2ZVK8Nn3S, decoded: 9223372036854775807
```

As you can see, the encoded values are quite short (between 11 and 12 characters), and they are not sequential. This is exactly what we want.

### An Exercise for the Reader

The code above is a good starting point, but it is not production ready. There are a few things that you should do before using this code in production:

* Move the encryption key to a configuration system (maybe an env var), so it is not stored in your repository
* Improve performance - can the cipher instances be cached and reused?
* Consider deleting old records from the database after a certain amount of time and inactivity
* Consider a plan for rotating the encryption key, and how you will handle old links (changing the key or alphabet will break existing links)

## Conclusion

In this post, we looked at how to generate a secure, random, short URL from an auto-incrementing number in .NET. We looked at the problem of auto-incrementing numbers, and how they can be used to scrape resources from a database. We looked at some potential solutions, including using UUIDs, randomly generated short URLs, and my preferred solution of encrypted auto-incrementing numbers. We then implemented this solution using the Blowfish cipher. Finally, we looked at some things you should do before using this code in production.

Hopefully, this post has given you some ideas on how to implement a secure, random, short URL generator in your own application - be it a URL shortener, payment links, or something else entirely.
