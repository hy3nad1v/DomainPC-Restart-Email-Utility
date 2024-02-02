
# Domain PC Restart Email Utility

This PowerShell script automates the process of remotely restarting computers on a domain and sending email notifications about the restart status. It is designed to streamline the management of multiple computers and facilitate proactive monitoring of system restarts.

## Features

- **Remote Computer Restart**: The script allows you to specify a list of target computers on a domain and remotely restart them using PowerShell's `Restart-Computer` cmdlet. This simplifies the task of restarting multiple computers simultaneously, saving time and effort.

- **Email Notification**: Upon completion of each restart attempt, the script sends email notifications to designated recipients to inform them about the restart status. Email notifications include details such as the computer name, restart outcome (successful or failed), and timestamp of the restart attempt.

- **Logging Functionality**: The script logs each restart attempt, recording relevant information such as the computer name, timestamp, and restart outcome. This enables administrators to track the history of restart attempts and troubleshoot any issues that may arise.

- **Automation with Task Scheduler**: You can further automate the execution of this script by configuring it to run at scheduled intervals using Windows Task Scheduler. This ensures regular monitoring and maintenance of the target computers without manual intervention.

## Getting Started

To use the script, follow these steps:

1. **Configure Computer List**: Update the `$computerNames` array with the names of the target computers on your domain that you want to restart.

2. **Configure Domain**: Set the `$domain` variable to the domain name of your network.

3. **Configure Email Settings**: Update the `$env:USEREMAIL` and `$env:SMTPSERVER` environment variables with the sender email address and SMTP server details for sending email notifications.

4. **Run the Script**: Execute the script in a PowerShell environment to initiate the remote restart process.

5. **Configure Task Scheduler**: Set up a scheduled task in Windows Task Scheduler to run the script at desired intervals. Follow the steps below to configure the task:
   
   - Open Task Scheduler from the Start menu or search bar.
   - Click on "Create Basic Task" in the right-hand panel and follow the wizard to set up a new task.
   - In the "Action" step of the wizard, choose "Start a Program" and specify the path to PowerShell.exe as the program/script and the path to the script file as the argument.
   - Configure additional settings such as triggers, conditions, and security options based on your requirements.
   - Review and confirm the task settings, then click "Finish" to create the task.

## Requirements

- Windows PowerShell 5.1 or later
- Permission to restart computers remotely on the domain
- Access to an SMTP server for sending email notifications
- Administrative privileges to configure Task Scheduler

## Example Usage

```PowerShell
.\RemoteComputerRestart.ps1
```

## Contributing

Contributions to the script are welcome! If you find any bugs or have suggestions for improvements, please open an issue or submit a pull request on GitHub.

## License

This script is licensed under the [MIT License](LICENSE), which allows for unrestricted use, modification, and distribution.

---
