import VersoBlog
import ProofSketches
import ProofSketches.MyTheme

import ProofSketches.Posts.REU
import ProofSketches.Posts.Mlml
import ProofSketches.Posts.Week1
import ProofSketches.Posts.Week2

open Verso Genre Blog Site Syntax 

def linkTargets : Code.LinkTargets TraverseContext where
  const _ _      := #[]
  definition _ _ := #[]


-- def linkTargets : Code.LinkTargets TraverseContext where
--   const n _      := #[{ shortDescription := "doc"
--                        , description := s!"Mathlib docs for {n}"
--                        , href := s!"https://leanprover-community.github.io/mathlib4_docs/find/?pattern={n}"
--                        }]
--   definition d _ := #[{ shortDescription := "def"
--                        , description := s!"Mathlib docs for {d}"
--                        , href := s!"https://leanprover-community.github.io/mathlib4_docs/find/?pattern={d}"
--                        }]

def myblog : Site := site ProofSketches.FrontPage /
  static "assets" ← "assets"
  "posts" ProofSketches.Posts with
    ProofSketches.Posts.REU
    ProofSketches.Posts.Mlml
    ProofSketches.Posts.Week1
    ProofSketches.Posts.Week2

def main := blogMain theme myblog (linkTargets := linkTargets) (options := ["--output", "docs"])

