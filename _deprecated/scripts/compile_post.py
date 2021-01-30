#!/usr/bin/python

# Requires Python 3.4 (pathlib)

import sys                    # argv, exit
import os                     # path.isdir
from pathlib  import Path     # Path
from datetime import datetime # datetime
import commonmark             # Parser
import json

ERR_PATH_NOT_DIR   = 1
ERR_PATH_NOT_EXIST = 2

# text, 
# softbreak, 
# linebreak, 
# emph, 
# strong, 
# html_inline, 
# link, 
# image, 
# code, 
# document, 
# paragraph, 
# block_quote, 
# item, 
# list, 
# heading, 
# code_block, 
# html_block, 
# thematic_break

k_NodeTypeToHTML = {
  "emph"   : "em",
  "strong" : "b",
  "link" : "a",
  "paragraph" : "p",
  "item" : "li",
  "image" : "img",
}

def convertNodeType(node):
  if node.t in k_NodeTypeToHTML:
    return k_NodeTypeToHTML[node.t]
  if node.t == "list":
    return "ul" if node.list_data["type"] == "bullet" else "ol"

  return node.t

def walkAst(ast_node):
  md_ast_walker = ast_node.walker()
  md_evt        = md_ast_walker.nxt()

  document = {
    "Content" : []
  }
  object_stack = []

  while md_evt is not None:
    node        = md_evt['node']
    node_type   = node.t
    
    current_obj = None
    entering    = md_evt['entering']

    if entering:
      if node_type == "text":
        parent_obj = object_stack[-1] if object_stack else None
        object_stack[-1]["Content"].append(node.literal)
      elif node_type == "heading":
        current_obj = {}
        current_obj["Type"] = "h" + str(node.level)
        current_obj["Content"] = []

        object_stack.append(current_obj)
      elif node_type == "document":
          object_stack.append(document)
      elif node_type == "image":
        object_stack[-1]["Content"].append({
          "Type" : convertNodeType(node),
          "Source" : node.destination,
        })
      elif node_type == "link":
        current_obj = {
          "Type" : convertNodeType(node),
          "Content": [],
          "Source" : node.destination,
        }
        object_stack.append(current_obj)
      elif node_type == "html_block":
        object_stack[-1]["Content"].append({
          "Type" : "div",
          "Content" : node.literal,
        })
      elif node_type == "thematic_break":
        object_stack[-1]["Content"].append({
          "Type" : "hr",
        })
      elif node_type == "softbreak":
        object_stack[-1]["Content"].append({
          "Type" : "wbr",
        })
      else:
        current_obj = {
          "Type"    : convertNodeType(node),
          "Content" : [],
        }

        object_stack.append(current_obj)
    else:
      last_obj = object_stack[-1] if object_stack else None

      object_stack.pop()

      parent_obj = object_stack[-1] if object_stack else None

      if parent_obj and last_obj:
        parent_obj["Content"].append(last_obj)
      #else:
      #  print(f"Failed to add {last_obj} to {parent_obj}")

    md_evt = md_ast_walker.nxt()

  return document["Content"]

def defaultMeta(json_data, key, default_value):
  if not key in json_data:
    print(f"Warning meta file missing \"{key}\", defaulting to \"{default_value}\"")
    json_data[key] = default_value

def ordinal(n):
  return str(n) + ("th" if 4<=n%100<=20 else {1:"st",2:"nd",3:"rd"}.get(n%10, "th"))

def todaysDateAsStr():
  today = datetime.today()

  return today.strftime('%B __, %Y').replace("__", ordinal(today.day))

def main(args):
  post_dir = Path(args[1])

  if not post_dir.exists():
    print(f"'{post_dir}' does not exist.")
    return ERR_PATH_NOT_EXIST

  if not os.path.isdir(post_dir):
    print(f"'{post_dir}' is not a directory.")
    return ERR_PATH_NOT_DIR

  content_path = post_dir / "content.md"

  if not content_path.exists():
    print(f"'{content_path}' does not exist.")
    return ERR_PATH_NOT_EXIST

  meta_path = post_dir / "meta.json"

  if not meta_path.exists():
    print(f"'{meta_path}' does not exist.")
    return ERR_PATH_NOT_EXIST

  content_string = content_path.read_text()
  meta_string    = meta_path.read_text()

  md_parser = commonmark.Parser()
  md_ast    = md_parser.parse(content_string)
  
  json_meta = json.loads(meta_string)

  if not "Title" in json_meta:
    print("Warning meta file missing \"Title\", defaulting to Shareef Raheem")
    json_meta["Title"] = "By: Shareef Raheem"
  
  defaultMeta(json_meta, "Title", "Untitled Post")
  defaultMeta(json_meta, "CoverImage", "url(images/cover_image.jpg)")
  defaultMeta(json_meta, "Author", "By: Shareef Raheem")
  defaultMeta(json_meta, "Date", todaysDateAsStr())

  meta_path.write_text(json.dumps(json_meta, indent=2))

  json_output                  = {}
  json_output_header           = {}
  json_output["Title"]         = json_meta["Title"]
  json_output_header["Image"]  = json_meta["CoverImage"]
  json_output_header["Author"] = json_meta["Author"]
  json_output_header["Date"]   = json_meta["Date"]
  json_output["Header"]        = json_output_header
  json_output["Content"]       = walkAst(md_ast)

  json_output_str = json.dumps(json_output, indent=2)

  json_output_path = "blog" / Path(args[2] + ".json") 
  json_output_path.touch()

  json_output_path.write_text(json_output_str)

  return 0

if __name__ == "__main__":
  args     = sys.argv
  num_args = len(args)

  print(f"--- Post Generator running from '{args[0]}' ---\n");

  if num_args < 3:
    print(f"Invalid number of arguments. {args}")
    print(f"Usage: make_post.py <post-directory> <output-blog-post-file>")
    sys.exit(2)
  else:
    sys.exit(main(args))
