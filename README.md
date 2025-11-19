# P5S-Translation-Tool

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey)

**An automated tool designed to streamline the translation process for *Persona 5 Strikers*.**

---

## 🌟 Credits & Acknowledgments

Before anything else, huge thanks to the following individuals whose work made this possible:

* **Cethleann**: For the encryption method.
* **Meloman19**: For the inspiration provided by their *P5R-Translation-Tool*.
* **VitaSmith**: For [gust_tools](https://github.com/VitaSmith/gust_tools).
* **Ultimate ASI Loader**: For ASIs and loading files without overwriting them.

---

## 🛠️ Prerequisites

To run this tool successfully, ensure your environment meets the following requirements:

* **Python 3.x**
    * Required Libraries: `pandas`, `openpyxl`
    * *Install via pip:* `pip install pandas openpyxl`
* **PowerShell 6+** (Must support Parallel execution)
* **.NET 10 Runtime/SDK**

---

## 📖 How to Use

### 1. Text Translation (`.XLSX`)
Navigate to the root folder and open the Excel file corresponding to your target platform: `Translation_[PLATFORM].XLSX`.

* **"Main" Sheet:** Only edit the **Translation** row. Do not modify the ID or original text columns.
* **Other Sheets:** The content in these sheets must be **overwritten entirely**.
    * ⚠️ **CRITICAL WARNING:** You must maintain the existing format. **DO NOT add or remove rows.** The structure must remain identical to the original file.

### 2. Texture Replacement (`.DDS`)
Place your edited textures in the following directory structure:
`Main\[PLATFORM]\Textures\G1T\Folder\File.DDS`

* **Format Requirement:** All DDS files must be saved in **BC3** compression format.

### 3. Packing
Once your Excel files and textures are ready:

1.  Open your terminal (ensure you are using the updated PowerShell version).
2.  Run the packing script for your specific platform:
    ```powershell
    .\[PLATFORM]_Pack.PS1
    ```

---

## ⚠️ Observations & Known Issues

### Nintendo Switch Support
Please be aware that the **Switch** implementation is currently experimental.
* It has not been thoroughly tested.
* Some textures may be missing or fail to pack correctly.
* Use with caution and please report bugs if encountered.
