import VersoBlog
import ProofSketches
import ProofSketches.MyTheme

import ProofSketches.Posts.REU

open Verso Genre Blog Site Syntax 

def linkTargets : Code.LinkTargets TraverseContext where
  const n _      := #[{ shortDescription := "doc"
                       , description := s!"Mathlib docs for {n}"
                       , href := s!"https://leanprover-community.github.io/mathlib4_docs/find/?pattern={n}"
                       }]
  definition d _ := #[{ shortDescription := "def"
                       , description := s!"Mathlib docs for {d}"
                       , href := s!"https://leanprover-community.github.io/mathlib4_docs/find/?pattern={d}"
                       }]

-- def linkTargets : Code.LinkTargets TraverseContext where
--   const n _      := #[ { shortDescription := "doc"
--                        , description := s!"Documentation for {n}"
--                        , href := s!"http://site.example/constlink/{n}"
--                        }
--                      ]
--   definition d _ := #[ { shortDescription := "def"
--                        , description := "Definition"
--                        , href := s!"http://site.example/deflink/{d}"
--                        }
--                      ]

def myblog : Site := site ProofSketches.FrontPage /
  static "assets" ← "assets"
  "posts" ProofSketches.Posts with
    ProofSketches.Posts.REU

def main := blogMain theme myblog (linkTargets := linkTargets) (options := ["--output", "docs"])

