#!/bin/bash

function usage {
    echo "$0 [alias name] [dir]"
    exit 1
}


if [ $# -ne 2 ]; then
    echo "Please supply the name and path for the alias to make"
    usage
fi

if [ ! -d $2 ]; then
    echo "$1 is not a directory!"
    usage
fi

echo "Creating $1 alias to cd $2"
echo "alias $1=\"cd $2\"" >> ~/.bash_aliases

echo "Use \"source ~/.bash_aliases\" to add to your shell"
