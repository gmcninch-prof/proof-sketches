import VersoBlog

set_option linter.unusedVariables false
open Verso Genre Blog

#doc (Post) "MLML" =>

%%%
authors := ["George McNinch"]
date    := { year := 2026, month := 5, day := 30 }
%%%

This post supplements the [post here](https://gmcninch.math.tufts.edu/posts/2026-05---Tools.html).

I thought it might be a useful exercise to describe some of what goes into the tools described 
in that earlier post.

Mainly, I want to describe how the "markup language" `MLML` is implemented.

# Tokenizer

```leanInit mlml
```

```lean mlml
inductive Token
  | ident (s : String)   
  | strLit (s : String)  
  | natLit (n : Nat)
  | boolLit (b : Bool)
  | lbrace | rbrace      
  | lbracket | rbracket  
  | comma | colon | equals
  | eof
  | comment (s : String)
deriving Repr, BEq
```

The function `tokenize` then has signature
`def tokenize (input : String) : List Token`.
