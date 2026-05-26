import VersoBlog
open Verso Genre Blog
open Verso.Code.External

#doc (Post) "My second post" =>

%%%
authors := ["George"]
date := {year := 2026, month := 5, day := 23}
categories := []
%%%


```leanInit second
```

```lean second
inductive Expr where
  | var : String → Expr
  | nat : Nat → Expr
  | plus : Expr → Expr → Expr
```

```lean second (name := eval)
#eval 10^5
```

```leanOutput eval
100000
```

