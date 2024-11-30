# Auto Backup System

This script automates the backup process for your MySQL database on Linux systems, ensuring data integrity and facilitating easy restoration when necessary.

## Features

- Automated backups of specified MySQL databases.
- Retention policy to remove backups older than 7 days.
- Configurable backup directories and schedules.

## Prerequisites

- Linux operating system.
- MySQL or MariaDB installed.
- `mysqldump` utility available in the system's PATH.
- `systemd` for managing services and timers.

## Installation

1. **Clone the Repository:**

     ```bash
       git clone https://github.com/hakos47/autobackup_DB.git
       cd autobackup_DB
    ```
   
2. **Run the Auto Install Script:**
   
     - Replace `DB_NAME`, `DB_USER`, and `DB_PASS` with your MySQL database name, username, and password, respectively.

    ```bash
       sudo ./auto_install.sh DB_NAME DB_USER [DB_PASS]
    ```
3. **Enable and Start the Timer:**

    ```bash
       sudo systemctl enable autobackup.timer
       sudo systemctl start autobackup.timer
    ```    

# Acknowledgements
Developed by hakos47.