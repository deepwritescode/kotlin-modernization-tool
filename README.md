# kotlin-modernization-tool
Tool used to modernize codebases with kotlin

## Running the benchmarking tool
To use this tool to get a benchmark of java files, first clone this repo. Then run this command

``
./baseline.sh path/to/repo
``

The output will be to a text file in the `out` directory look for `out/baseline.txt`. This will contain all the java files that are in the project.
