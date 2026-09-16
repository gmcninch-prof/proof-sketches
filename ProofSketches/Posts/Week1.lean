import VersoBlog
import Mathlib.Tactic

set_option linter.unusedVariables false
open Verso Genre Blog

#doc (Post) "Lean Seminar week 1" =>

%%%
authors := ["George McNinch"]
date    := { year := 2026, month := 9, day := 15 }
%%%

This post contains some comments about the week 1 lecture of the Tufts seminar on "Formalization of math and Lean".  Posts here are just going to be about Lean -- I plan to keep seminar logistics on the [seminar page](https://gmcninch.math.tufts.edu/pages/2026-Fall---lean-seminar.html).


```leanInit week1
```

# About `match`

Someone asked how to think about `match` in the definition

```lean week1
def append {α : Type} (xs ys : List α) : List α :=
  match xs with
  | []      => ys
  | z :: zs => z :: append zs ys
```

I pushed back a little at reading the branches of the `match` statement as   "if xs =\[\], then ..."
and "if xs = (z :: zs), then ..." 
From the point of view of explanation or comprehension, my push-back is probably a bit off-base; indeed, those branches fire precisely when the indicated condition holds.

There are some reasons for my hesitation to use this language, though. 

Saying "if `xs = []`" suggests we've evaluated a *proposition* — checked
`xs = []`, gotten `true` or `false`, and branched on that.
But that's not really what `match` is doing.

`List α` is an inductive type with two constructors, `nil` and `cons`.
Every closed term `xs : List α` computes to one of them — that's a property known in type theory as
*canonicity*, a fact about the type theory's computation rules. `match` is just notation for
something called the `recursor` for the inductive type, and it essentially just asks:
"which constructor built this term?"
and dispatches accordingly. That's a judgment-level fact (how `xs` was
built), settled by elaboration, not a proposition you're evaluating.

So: the two branches are not determined by "two truth-values of a claim about `xs`" —
but rather, "the two shapes the list `xs` can have," which is a fact about the
type.

What this is really getting at in the end is the difference between `judgments` and 
`propositions` in Lean. A judgment is something like the statement `a : ℕ` that `a` is a natural number.
This is a judgment in the sense that it does not "have a truth value" - it is simple something that  
is determined from typing rules. It is not legal to negate such a statement -- `¬(a:ℕ)` is just nonsense in Lean (or in type theory). On the other hand, a proposition is something that might have a proof. For
example 

```lean week1
example (a b : ℕ) : Prop := a <= b
```
is the proposition that the natural number `a` is less than or equal to the natural number `b`; it may or may not be true.

Careful: this `example ... := ...` shape looks like the usual pattern where you supply a proof of some proposition. Here it's doing something different — `Prop` itself is the stated type, and `a ≤ b` is the term we're supplying, so this is just saying "`a ≤ b` is a proposition," not proving it. The shape `example : X := t` always means "here's a term t of type X" — you should only think of `t` as a proof when  `X` itself happens to be a `Prop`.

To summarize: in the `match` statement, which branch fires is settled by which constructor was actually used to build xs — a fact the kernel reads off directly, by computation, not by evaluating a proposition about xs.


# Multiple inequalities

When I presented the "squeeze theorem" 

```lean week1
-- "u tends to ℓ"
def seq_limit (u : ℕ → ℝ) (ℓ : ℝ) :=
  ∀ ε > 0, ∃ N, ∀ n ≥ N, |u n - ℓ| ≤ ε

theorem squeeze (hu : seq_limit u ℓ) (hw : seq_limit w ℓ)
    (h : ∀ n, u n ≤ v n) (h' : ∀ n, v n ≤ w n) :
    seq_limit v ℓ := by
  sorry
```

I was asked if one could combine `h` and `h'`. I said "no" but I should have shown how it 
is easy enough to just make a single hypothesis using a logical `and` symbol, as follows:

```lean week1

theorem squeeze' (u v w : ℕ → ℝ) (ℓ : ℝ) 
    (hu : seq_limit u ℓ) (hw : seq_limit w ℓ)
    (h : ∀ n, (u n ≤ v n) ∧ (v n ≤ w n)) :
  seq_limit v ℓ := by
  sorry
```


Unlike some languages -- Python, for instance, where `a <= b <= c` really does mean `a <= b` and 
`b <= c` -- Lean has no chaining notation for `≤` at all. Thus, `a ≤ b ≤ c` is parsed the same way 
any nested binary operator would be — there's nothing relation-specific going on.

In general,
`a ≤ b ≤ c` doesn't even parse in Lean. You could try to view it as "left associative" by writing 
`(a ≤ b) ≤ c`. Try it!:

```
example (a b c : ℝ) : Prop := (a ≤ b) ≤ c
```

You'll get an error:

```
Expected type:
a b c : ℝ
⊢ ℝ
Messages here:
99:40:
Type mismatch
  c
has type
  ℝ
but is expected to have type
  Prop
```

The expression `a ≤ b` is a term of type `Prop`, and Lean is trying to compare this term with the 
real number `c`, which is an error.

Note that in some sense long inequality chains are idiomatic in Lean — but through the `calc` tactic, 
which handles transitivity explicitly via the `Trans` typeclass, not through parser syntactic 
sugar on the relation `≤` itself.

Here is an example:

```lean week1
example (a b c d : ℝ) (h1 : a ≤ b) (h2 : b < c) (h3 : c ≤ d) : a < d := by
  calc a ≤ b := h1
    _ < c := h2
    _ ≤ d := h3
```    

How to read this: we have the real numbers `a b c d` and we have some hypotheses. We want to prove `a < d`, and we incrementally do this using the `calc` tactic. In each line of the calc tactic, the `_` means "the right hand side of the previous line".

The final relation symbol (`<`) isn't just copied from the goal — `calc` works it out from the individual steps: chaining `≤`, `<`, `≤` together yields `<`, since one strict step is enough to make the whole chain strict. This composition is handled automatically via Lean's [`Trans` typeclass](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Trans). 

Eventually we'll talk about `typeclass`es!!
