---
title: YAML Schema Validation
date: 2018-11-09
toc: false
...

Take this YAML document as an example:

```yaml
name: my-app
type: rails

server:
  port: 3301

commands:
  server: bin/rails s
  console: bin/rails c
  test:
    run: bin/test
    desc: "run tests"

open:
  "application": "https://localhost:3301"
```

I want to validate the schema being used here, without writing a bunch of manual checks. I'd like to
be able to define the schema in a declarative format and then run it against the document.

There are a small handful of tools that implement schema validation for YAML in this way—notably
[Kwalify](http://www.kuwata-lab.com/kwalify/)—but I think they all miss a really great opportunity:

YAML has a feature called
[Tags](http://blogs.perl.org/users/tinita/2018/01/introduction-to-yaml-schemas-and-tags.html). YAML
tags allow you to attach a piece of metadata to any node (keys, values... anything). We could build
a schema that looked a lot more like the actual document than, for example, a Kwalify schema, if we
would use tags to annotate nodes:

```yaml
%TAG ! tag:yaml-schema.example.com,2018:
---
!req name: !pat '/\w[\w-]{1,62}/'

!opt type: !oneof [ !lit "rails", !lit "ios" ]

!opt server:
  !opt port: !range 1..65535

!opt commands:
  !pat '/\w+/': !oneof
    - !type String
    - !req run:       !type String
      !opt desc:      !type String
      !opt long_desc: !type String

!opt open:
  !pat '//': !pat '/^https?:\/\//'
```

This is hard to read at first, but I think more clear in the end than a more expanded schema format.
A few reading aids:

* A tag precedes the node that it annotates. In this case, tags are everything that starts with
  a '!'.
* `!req` should be read "required";
* `!opt` should be read "optional";
* `!oneof` implies that the node in its place must be one of the array members;
* `!lit` implies that the node in this place must be the literal object that follows;
* `!pat` implies that the node in this place must be a string matching the provided pattern.

`Psych` in ruby makes it relatively straightforward to register handlers for custom tags:

```ruby
class Req
  yaml_tag "tag:yamlsl.io,2018:req"

  def init_with(coder)
    initialize(coder.scalar)
  end

  def encode_with(coder)
    coder.scalar = @key
  end

  def initialize(scalar)
    @key = scalar
  end
end
```

With all of these, the document above parses something like:

```
{#<Req:0x00007f9e11936cd0 @key="name">=>
  #<Pat:0x00007f9e11936aa0 @re=/\/\w[\w-]{1,62}\//>,
 #<Opt:0x00007f9e11936898 @key="type">=>
  #<Oneof:0x00007f9e11936668
   @choices=
    [#<Lit:0x00007f9e11936578 @key="rails">,
     #<Lit:0x00007f9e11936438 @key="ios">]>,
 #<Opt:0x00007f9e119362d0 @key="up">=>nil,
 #<Opt:0x00007f9e11935d58 @key="server">=>
  {#<Opt:0x00007f9e11935970 @key="port">=>"1..65535"},
 #<Opt:0x00007f9e119356f0 @key="commands">=>
  {#<Pat:0x00007f9e119354c0 @re=/\/\w+\//>=>
    #<Oneof:0x00007f9e119352b8
     @choices=
      [#<Type:0x00007f9e11935178 @key="String">,
       {#<Req:0x00007f9e1192f548 @key="run">=>
         #<Type:0x00007f9e1192d4a0 @key="String">,
        #<Opt:0x00007f9e1192cde8 @key="desc">=>
         #<Type:0x00007f9e1192cc30 @key="String">,
        #<Opt:0x00007f9e1192ca78 @key="long_desc">=>
         #<Type:0x00007f9e1192c2d0 @key="String">}]>},
 #<Opt:0x00007f9e1190fe78 @key="open">=>
  {#<Pat:0x00007f9e1190fbf8 @re=/\/\//>=>
    #<Pat:0x00007f9e1190f9f0 @re=/\/^https?:\/\/\//>}}
```

It's not too hard to imagine giving these types behaviour that, when passed a parsed YAML document,
would recurse both trees in parallel and return a set of validation errors.
