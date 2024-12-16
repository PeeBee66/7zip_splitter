# Windows 7-Zip Large File Splitter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A batch script that helps split large files into smaller chunks using 7-Zip with GUI-equivalent command line settings. Perfect for breaking down large files for easier transfer or storage while maintaining data integrity.

## 📋 Table of Contents
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Logging](#logging)
- [File Reassembly](#file-reassembly)
- [Common Issues](#common-issues)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features
- Automatically detects files larger than 2GB in the current directory
- Uses 7-Zip's tar format with 2000MB chunk size
- Matches 7-Zip GUI settings for consistent results:
  - Zero compression (store mode) for fastest processing
  - GNU compression method
  - 4 CPU threads utilization
  - Relative pathnames
- Detailed logging of all operations
- Error handling and user-friendly prompts
- Creates numbered chunks (.001, .002, etc.) for easy reassembly

## 🔧 Requirements
- Windows operating system
- [7-Zip](https://7-zip.org/) installed in default location (`C:\Program Files\7-Zip`)
- PowerShell (comes pre-installed with Windows)

## 📥 Installation
1. Download the `split_large_files.bat` script
2. Place it in any directory containing files you want to split Or simply copy the script contents and save as a .bat file

## 🚀 Usage
1. Place the script in the folder containing your large file(s)
2. Double-click to run the script
3. Select the file you want to split from the displayed list
4. Confirm the operation
5. Wait for the process to complete

### Example Output
```
Files larger than 2GB:
---------------------
1) largefile.zst (13183150086 bytes)

Enter the number of the file you want to split (1-1) or Q to quit:
```

## ⚙️ Configuration
Default settings (can be modified in the script):
```batch
set "CHUNK_SIZE=2000M"
set "COMPRESSION=0"
set "METHOD=gnu"
set "CPU_THREADS=4"
```

## 📝 Logging
The script creates a detailed log file (`file_splitter.log`) in the same directory, containing:
- Timestamp for all operations
- File detection results
- User selections
- 7-Zip command outputs
- Error messages (if any)

Example log entry:
```
=== Script started at 20240116_143022 ===
Working directory: C:\YourDirectory
Starting file analysis...
Found large file: example.zst (13183150086 bytes)
```

## 🔄 File Reassembly
To recreate the original file:

1. Open 7-Zip
2. Navigate to the folder containing split files
3. Select the first file (*.tar.001)
4. Click Extract

Or use 7-Zip command line:
```cmd
"C:\Program Files\7-Zip\7z.exe" x "yourfile.tar.001"
```

## ❗ Common Issues
1. **Script closes immediately**
   - Run from command prompt to see error messages
   - Check if 7-Zip is installed in the default location

2. **'PowerShell' is not recognized**
   - Ensure PowerShell is installed and in system PATH

3. **Access Denied Errors**
   - Run as administrator
   - Check file permissions

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch:
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. Commit your changes:
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. Push to the branch:
   ```bash
   git push origin feature/AmazingFeature
   ```
5. Open a Pull Request

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments
- [7-Zip](https://7-zip.org/) for the amazing compression tool
- Everyone who contributed to testing and improvements

---
