---
title: "Custom JSON Unmarshalling in Go"
date: 2018-03-09
...

I'm working on a consumer for GitHub's Organization Webhooks, and ran into an issue today where the
`repository.pushed_at` field is sent as a UNIX epoch timestamp in one event time, and an RFC 3339
/ ISO 8601 time in another. Naturally, parsing this in Go, both `uint64` and `time.Time` will fail
sometimes.

I solved this by implementing a new type, `UnixOrRFC3339Time`, which implements the `UnmarshalJSON`
method:

```go
// UnixOrRFC3339Time works around an inconsistency in the GitHub API where the
// "pushed_at" field is sent alternately as an integer or RFC3339 (ISO 8601)
// timestamp.
type UnixOrRFC3339Time struct {
	t time.Time
}

// Time returns the parsed time.Time object after loading the JSON.
func (u *UnixOrRFC3339Time) Time() time.Time {
	return u.t
}

// UnmarshalJSON loads either an RFC3339-formatted time (e.g.
// '"2017-11-03T15:15:09Z"') or unix epoch timestamp (e.g. '1498827360').
// Yes, it *is* unfortunate that we need to do this.
func (u *UnixOrRFC3339Time) UnmarshalJSON(data []byte) error {
	if err := u.t.UnmarshalJSON(data); err == nil {
		return nil
	}

	secs, err := strconv.ParseInt(string(data), 10, 64)
	if err != nil {
		return err
	}
	u.t = time.Unix(secs, 0)
	return nil
}
```

When I give this as the type in the struct I feed to `json.Unmarshal`, I get a properly parsed time
with either message format. It would be great to be able to just declare this type as an alias of
`time.Time` with a custom `UnmarshalJSON` implementation, but I don't think I can do that without
access to `time.Time`'s private members.
