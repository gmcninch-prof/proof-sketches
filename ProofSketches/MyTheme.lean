import VersoBlog

open Verso.Genre.Blog Template
open Verso Doc Output Html

def fontAwesome (tag: String) : Html :=
  {{ <i class = {{tag}}> </i> }}

def defaultCss : String × String  :=
  ( "default.css",  include_str "default.css" ) 


def archiveEntry : Template := do
  let post : BlogPost ← param "post"
  --let summary ← param "summary"
  let target ← if let some p := (← param? "path") then
      pure <| p ++ "/" ++ (← post.postName')
    else post.postName'
    
  -- let catAddr ← do
  --   if let some p := (← param? "path") then
  --     pure <| fun slug => p ++ "/" ++ slug
  --   else pure <| fun slug => slug

  let dateh : Html := match post.contents.metadata with
         | none => Html.empty
         | some md => {{
            <span class="date">{{md.date.toIso8601String}}  </span>
           }}

  -- let catsh : Html := match post.contents.metadata with
  --       | none => Html.empty
  --       | some md =>
  --           let catlist : List Html :=
  --             md.categories.map (fun cat => {{<li><a href=s!"{catAddr cat.slug}">{{cat.name}}</a></li>}} )
  --           catlist.toArray |> Html.seq |> 
  --             fun x => {{ <ul class="categories"> {{x}} </ul> }}

  let title : Html := {{<a href={{target}} class="title">
         <span class="name">{{post.contents.titleString}}</span>
       </a>}}
       
  return #[{{<li> {{dateh}} {{title}} </li>}} ] 

--------------------------------------------------------------------------------

    -- let catList :=
    --   match (← param? (α := Post.Categories) "categories") with
    --   | none => Html.empty
    --   | some ⟨cats⟩ => {{
    --       <div class="category-directory">
    --         <h2> "Categories" </h2>
    --         <ul>
    --         {{ cats.map fun (target, cat) =>
    --           {{<li><a href={{target}}>{{Post.Category.name cat}}</a></li>}}
    --         }}
    --         </ul>
    --       </div>
    --     }}


def primary : Template := do
    let postList :=
      match (← param? "posts") with
      | none => Html.empty
      | some html => html -- {{ <h2> "Posts" </h2> {{ html }} }}
    return {{
      <html>
        <head>
          <meta charset="utf-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1"/>
          <meta name="color-scheme" content="light dark"/>
          <!-- Stop favicon requests -->
          <link rel="icon" href="data:," />
          <title> {{ (← param (α := String) "title") }} </title>
          {{← builtinHeader }}
          <link href="https://use.fontawesome.com/releases/v6.7.2/css/fontawesome.css" rel="stylesheet" />
          <link href="https://use.fontawesome.com/releases/v6.7.2/css/solid.css" rel="stylesheet" />
          <link href="https://use.fontawesome.com/releases/v6.7.2/css/brands.css" rel="stylesheet" />
        </head>
        <body>
          <header>
            <div class="inner-wrap">
              <nav class="top" role="navigation">
                <ol>
                  <li class="home"><a href="."> {{fontAwesome "fas fa-diagram-project"}} {{"Proof Sketches"}} </a></li>
                  <li>{{fontAwesome "fa-solid fa-chalkboard-teacher"}} <a href="https://gmcninch.math.tufts.edu"> {{"George McNinch"}} </a></li>
                </ol>
              </nav>            
            </div>
          </header>
          <main>
            <div class="wrap">
              {{ (← param "content") }}
              {{ postList }}
            </div>
          </main>
        </body>
        <footer>
          <nav>
          <ol>
            <li>
            <a href="http://math.tufts.edu">
              {{fontAwesome "fas fa-chalkboard"}}
              {{"Tufts Math"}}
            </a>
            </li>
            <li>
            <a href="https://gmcninch.gitlab.io/"
               title="Personal page">
              {{fontAwesome "fa-solid fa-pen-nib"}}
            </a>
            </li>
            <li>
            <a href="https://mathoverflow.net/users/4653/george-mcninch"
               title="math overflow">
              {{fontAwesome "fab fa-stack-overflow"}}
            </a>
            </li>
            <li>
            <a href="https://mathstodon.xyz/@stencilv"
               rel="me"
               title="mastodon">
              {{fontAwesome "fab fa-mastodon"}}
            </a>
            </li>
            <li>
            <a href="https://gitlab.com/gmcninch"
               title="gitlab">
              {{fontAwesome "fab fa-gitlab"}}
            </a>
            </li>
            <li>
            <a href="https://github.com/gmcninch"
               title="github">
              {{fontAwesome "fab fa-github"}}
            </a>
            </li>
          </ol>
          </nav>      
        </footer>    
        
      </html>
    }}


def landing : Template.Override := 
  ⟨do return {{<div class="frontpage"><h1>{{← param "title"}}</h1> {{← param "content"}}</div>}}, id⟩



def theme : Theme := { Theme.default with
  archiveEntryTemplate := archiveEntry,
  primaryTemplate := primary
  cssFiles := #[ defaultCss ] 
  }
  |>.override #[] landing


