## Just a few notes on LINUX/UNIX commands you will need...

- `pwd` - display present working directory
- `cd <dir_name>` - change to the `<dir_name>` directory
- `ls ` - list directory contents

- `ls -al` - list directory contents and file permissions, sizes etc

- `mv <name1> <name2>` 
   - if `<name1>` is a file, and `<name2>` is not a directory, `<name1>` will be renamed to `<name2>`
   - if `<name1>` is a file, and `<name2>` is a directory, `<name1>` will be moved into the directory `<name2>`
   - if `<name1>` is a directory, and `<name2>` is a directory, `<name1>` directory will be moved into directory `<name2>`

- `cp <name1> <name2>` - copy `<name1>` to `<name2>`

- `mkdir <name>` - make a directory named `<name>`

- `scp <source> <destination>` secure copy (between machines) a source file or (with the `-r` flag) directory to a destination directory
  - e.g. `scp <user1>@machine1.domain.com:~/<file1> .` secure copy the file named `<file1>` in the /home directory of the user named `<user1>` on the computer at the DNS address `machine1.domain.com` to the curent directory `.` (period specifies the current directory the command is being issued in)
  
  
