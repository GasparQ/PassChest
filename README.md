# PasswordChest

Save your passwords and never forget them.

This application allows you to save your passwords into a safe encrypted chest.

Manage a list of passwords with only one password.

## Features

### Manage passwords

This application provides you a simple way to manage your passwords.

Add, edit or remove passwords very easily with our user-friendly interface.

Want to use a password ? Simply click on the `copy` button and paste it in the website of your choice.

### Save passwords

When you're done with managing your passwords, you can save them in a secured file encrypted in aes-256, one of the best encryption method known.

### Open passwords

Several to use the application ? Don't worry you can load your passwords by entering the passwords you used to save them.

## Deployment

In order to deploy the app, you'll first have to compile and install it in release mode.

In order to do that, just select the release compilation mode in QtCreator and add a `make install` compilation step after the `build` step.

Recompile the project and you will normally see a new directory created in `package/com.vendor.product` called `data` and containing the application `PasswordChest.exe` with the `botan-cli.exe` and `botan.dll`.

At this time, you can execute the `intall.bat` script provided in the repository.

This script will ask you where the `windeployqt.exe`, Qt qml directory and `binarycreator.exe` are.

Generally, `windeployqt.exe` and the Qt qml directory are in your Qt version directory (`[QtRoot]\[Version]\[Compiler]\`) : ex : `E:\Qt\5.10.1\msvc2017_64`.

The binary `windeployqt.exe` is in the `bin` directory, and the Qt qml directory corresponds to the `qml` directory.

For the `binarycreator.exe`, its generally installed in the Qt Tools, in the Qt installer framework directory : ex : `E:\Qt\Tools\QtInstallerFramework\3.0\bin`

If you don't have the `QtInstallFramework`, you can install it with the `Qt Maintenance Tool.exe` by addind the package from `Tools`.

If you provide all the path correctly, you'll normally see the `PassChestInstall.exe` created in the repository which will allow you to install the application in the computer.

## Credits

Thanks to [Botan library](https://github.com/randombit/botan) for providing the secure encryption system that I use.

Icons (`ressources/icons`):
-  `add.png`: Icon made by [David Gandy](https://www.flaticon.com/authors/dave-gandy) from [Flaticon](www.flaticon.com)
-  `copytoclipboard.png`: Icon made by [Freepik](https://www.flaticon.com/authors/freepik) from [Flaticon](www.flaticon.com)
-  `edit.png`: Icon made by [Freepik](https://www.flaticon.com/authors/freepik) from [Flaticon](www.flaticon.com)
-  `load.png`: Icon made by [David Gandy](https://www.flaticon.com/authors/dave-gandy) from [Flaticon](www.flaticon.com)
-  `remove.png`: Icon made by [Freepik](https://www.flaticon.com/authors/freepik) from [Flaticon](www.flaticon.com)
-  `save.png`: Icon made by [Smashicons](https://www.flaticon.com/authors/smashicons) from [Flaticon](www.flaticon.com)

Application icon `app.ico`: Icon made by [Smashicons](https://www.flaticon.com/authors/smashicons) from [Flaticon](www.flaticon.com)
