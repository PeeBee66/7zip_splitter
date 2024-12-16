A batch script that helps split large files into smaller chunks using 7-Zip with GUI-equivalent command line settings. Perfect for breaking down large files for easier transfer or storage while maintaining data integrity.
Features

Automatically detects files larger than 2GB in the current directory
Uses 7-Zip's tar format with 2000MB chunk size
Matches 7-Zip GUI settings for consistent results
Zero compression (store mode) for fastest processing
Detailed logging of all operations
Error handling and user-friendly prompts
GNU compression method with 4 CPU threads
Creates numbered chunks (.001, .002, etc.) for easy reassembly

Requirements

Windows
7-Zip installed in default location
PowerShell (comes with Windows)

Usage

Place script in folder with large file(s)
Run script
Select file to split
Confirm operation
Splits will be created as .tar.001, .tar.002, etc.

Reassembly
To recreate the original file:

Open 7-Zip
Navigate to split files
Select first file (.001)
Click Extract

Note
Created for situations where you need to break down large files (e.g., 12GB+) into manageable chunks while maintaining exact file integrity.
