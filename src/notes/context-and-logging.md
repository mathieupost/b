---
title: 'Context and Logging in Go'
date: 2018-03-08
toc: false
...

It's been a couple of years since I've been neck-deep in Go code, and I'm getting up to speed on
a few patterns that have gained traction since the last time. The most interesting one to me is the
[`context`](https://golang.org/pkg/context/) package. In combination with
[`logrus`](http://github.com/sirupsen/logrus), it enables a logging pattern I've been finding very
useful.

## WithValue

A `context.Context` supports the association of an arbitrary key/value pair, which follows that
context around through your application. It feels apparent that this is meant to track data such as
an HTTP Request ID, URI path, etc.

The basic form of `WithValue` use might look something like:

```go
func ServeHTTP(w http.ResponseWriter, r *http.Request) {
  ctx := r.Context()
  ctx = context.WithValue(ctx, "requestID", newRequestID())
  // ...
}
```

While this would work, the `context` documentation strongly suggests using a non-primitive type for
the key, in order to prevent mixing up conflicting `context.Context` types created by different
components of your application, so we can refactor this to:

```go
type myKey string

var requestIDKey = myKey("requestID")

func ServeHTTP(w http.ResponseWriter, r *http.Request) {
  ctx := r.Context()
  ctx = context.WithValue(ctx, requestIDKey, newRequestID())
  // ...
}
```

## Context and Logrus

Now we have the request ID associated to the `context`. What if we wanted to log this ID?

```go
import log "github.com/sirupsen/logrus"

// ...

log.WithField("requestID", ctx.Value(requestIDKey)).Info("handling request")
```

This obviously gets verbose quickly. What if we also wanted to associate the URI path to the
`context`, and log it as well, along with an error?

```go
if err != nil {
  log.
    WithField("requestID", ctx.Value(requestIDKey)).
    WithField("path", ctx.Value(pathKey)).
    WithField("error", err).
    Warn("bad thing happened!")
}
```

We can build a helper in our `server` package to deal with this:

```go
func serverLog(ctx context.Context, err error) *log.Entry {
  entry := log.WithField("package", "server")
  if err != nil {
    entry = entry.WithField("error", err)
  }
  if requestID := ctx.Value(requestIDKey); requestID != nil {
    entry = entry.WithField("requestID", requestID)
  }
  if path := ctx.Value(pathKey); path != nil {
    entry = entry.WithField("path", path)
  }
  return entry
}
```

Then, from elsewhere in the package, we can do:

```go
func arbitrary(ctx context.Context) {
  serverLog(ctx, nil).Info("attempting flaky operation")
  if err := flakyOperation(ctx); err != nil {
    serverLog(ctx, err).Warn("operation failed")
  }
}
```

This would generate logs something like:

```
INFO[0000] attempting flaky operation  \
  component=server path=/flaky requestID=124814
WARN[0005] operation failed            \
  component=server error="timed out" path=/flaky requestID=124814
```

I've found this to be a great pattern to get nice structured logs without a lot of per-invocation
overhead. Full example over at
[gist.github.com](https://gist.github.com/burke/ed404144c55b97441412dbb17d75ad9a)
