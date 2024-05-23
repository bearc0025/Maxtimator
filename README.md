#  Data file handling

## Version

1.0

## Configuring the Project

Replace the workoutData.txt file in the project to use other data.

Or...

Change the file being loaded by name in DataFileLoader.swift line 10:

let FILENAME = "workoutData.txt"

## Memory

Change the file size limit in DataFileLoader.swift line 11:

let FileSizeSm = 3*1024*1024 // 3MB

Less than this size will be loaded into memory, parsed and discarded.
That size or larger, the file will be read in line-by-line.

The code could easily be changed to cache the lines for further processing later. 

## Error/Logging

There is no error handling nor logging in the app. Only some placeholder code where errors/exceptions may occur.

