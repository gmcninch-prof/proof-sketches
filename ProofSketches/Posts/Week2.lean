import VersoBlog
import Mathlib.Tactic

set_option linter.unusedVariables false
open Verso Genre Blog

#doc (Post) "Lean Seminar week 2" =>

%%%
authors := ["George McNinch"]
date    := { year := 2026, month := 9, day := 22 }
%%%

This post contains some comments about the week 2 lecture of the Tufts seminar on 
"Formalization of math and Lean".  

```leanInit week2
```

# Lists (and other things) of a particular type.

Given a type `α` we pointed out that `List α` is the type with terms like 
`[a,b,c]` where `a b c : α`.

There were some questions of the form: "how would I get a list
containing terms of differing types?". I scribbled an answer on the
board, but let me reiterate this and provide another alternative as
well.

- solution one: use `Sum` 

  (In the lecture, I said to use the Haskell name `Either`, but as it turns out,
  Lean actually uses the name `Sum`.)

  Given types `α β : Type`, the new type `Sum α β` (or you can write `α ⊕ β`)
  has two constructors: `Sum.inl : α → Sum α β` and `Sum.inr : β → Sum α β`.

  So a list with natural numbers and strings might look like this:
  
  ```lean week2
  example : List (String ⊕ ℕ) := [ Sum.inr 1, Sum.inr 23, Sum.inl "potato" ]
  ```

- solution two: define your own inductive type.

  ```lean week2
  inductive MyType 
  | N : ℕ → MyType
  | S : String → MyType
  | R : ℚ → MyType
  deriving Repr
  ```

  This type has constructors `N`, `S`, and `R`. Using it,
  you can make a list containing natural numbers, strings, and rationals:
  
  ```lean week2 (name := mytypeOut)
  open MyType 
  def l : List MyType := [ N 1, S "potato", R (1/2), N 23 ]

  
  #eval l  
  ```
  
  ``` leanOutput mytypeOut
  [MyType.N 1, MyType.S "potato", MyType.R (1 : Rat)/2, MyType.N 23]
  ```

Like `List`, `Set` depends on a type: `Set α` is sets of things of type α. So the "one type 
per collection" constraint applies here too. 

Writing the set `{1, 2, "potato"}` fails for the same reason 
`[1, 2, "potato"]` does, and the fixes are the same: use `Set (String ⊕ ℕ)` or your own inductive type.

Here is one way that `Set α` differs from `List α`, though:

```lean week2

-- repetition produces different lists
example : ¬ ([1,2,3] : List ℕ) = ([1,2,3,3] : List ℕ) := by decide

-- sets defined by listing elements aren't affected by repetition
example : ({1,2,3} : Set ℕ) = ({1,2,3,3} : Set ℕ) := by 
  ext x -- sets are equal iff they have the same elements
  simp
```
 
# Using names in binders

In the lecture, I had originally written

```lean week2
theorem modus_ponens {p q : Prop} : (f : p → q) → (h : p)  → q := by
  intro f h
  exact f h
```

The signature of this refers to the type of the parameters together with 
the type that is being produced. In this case, the resulting type is 
```
(f : p → q) → (h : p)  → q
```

In this case, there is no real reason for introducing names for the terms in the signature.

Thus, we could have written

```lean week2
theorem modus_ponens_shorter {p q : Prop} : (p → q) → p  → q := by
  intro f h
  exact f h
```

Note that sometimes it is useful to give binders in the signature. In the following
example, `List.Vector α n` is the type of vectors of length `n` with entries of type `α`:

```lean week2
open List.Vector in
def rept {α : Type} : α  → (n : ℕ) → List.Vector α n := by
  intro a n
  match n with 
  | 0 => exact nil
  | Nat.succ n => exact cons a (rept a n)
```

```lean week2 (name := reptOut)
#check rept "aaa" 4 -- List.Vector String 4
#eval rept "aaa" 4
```

```leanOutput reptOut
["aaa", "aaa", "aaa", "aaa"]
```

```lean week2 (name := reptOut2)
#check rept [1,2] 3 -- List.Vector (List ℕ) 3
#eval rept [1,2] 3
```

```leanOutput reptOut2
[[1, 2], [1, 2], [1, 2]]
```

Here in the definition of `rept` we needed to name the natural number argument 
(in this case, `n : ℕ`) in the signature, because
it is used later in the signature (`List.Vector α n`).
