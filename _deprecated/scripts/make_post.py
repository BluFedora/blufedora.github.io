import sys
import os
import json
from pathlib import Path # Path

if __name__ == "__main__":
  args     = sys.argv
  num_args = len(args)

  if num_args < 2:
    print(f"Usage '{args[0]} \"<name-of-post>\"'")
  else:
    root_dir     = Path("blog") / "source" / args[1]
    content_path = root_dir / "content.md"
    meta_path    = root_dir / "meta.json"

    if not root_dir.exists():
      os.mkdir(root_dir)
      content_path.touch()
      meta_path.touch()

      content_path.write_text("### " + args[1])
      meta_path.write_text(json.dumps({
        "Title": args[1]
      }, indent=2))
    else:
      print(f"'{root_dir}' already exists. Please delete the directory if you are sure you want to start over.")
