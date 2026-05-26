import VersoBlog
import ProofSketches
import ProofSketches.MyTheme

import ProofSketches.Posts.FirstPost
import ProofSketches.Posts.SecondPost

open Verso Genre Blog Site Syntax 

def linkTargets : Code.LinkTargets TraverseContext where
  const n _      := #[ { shortDescription := "doc"
                       , description := s!"Documentation for {n}"
                       , href := s!"http://site.example/constlink/{n}"
                       }
                     ]
  definition d _ := #[ { shortDescription := "def"
                       , description := "Definition"
                       , href := s!"http://site.example/deflink/{d}"
                       }
                     ]

def myblog : Site := site ProofSketches.Posts with
    ProofSketches.Posts.FirstPost
    ProofSketches.Posts.SecondPost

def main := blogMain theme myblog (linkTargets := linkTargets) (options := ["--output", "docs"])

