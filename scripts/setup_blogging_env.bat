@echo off
rem Python is required to be able to make blog posts.

rem Update Pip
python -m pip install --upgrade pip

rem install common mark to be able to compile markdown
rem [https://pypi.org/project/commonmark/]
pip install commonmark
