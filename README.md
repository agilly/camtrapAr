## Dependencies
This package requires R on Linux. It was developed and tested in WSL2. If you have a Windows computer, it is recommended that you install WSL2 as well. Instructions can be found online.

To install R on Linux, follow the instructions here: https://www.digitalocean.com/community/tutorials/how-to-install-r-on-ubuntu-22-04
The above are valid for Ubuntu 22.04, other releases will require tweaking the version name. It is recommended you install Ubuntu 22.04.

The package requires the command line tools `gifsicle`, `ffmpeg` and `ExifTool`. The latter is a dependency of the R library `EXIFr`, and can be installed with (replace version as appropriate):

```bash
wget https://exiftool.org/Image-ExifTool-12.40.tar.gz
tar -xvzf Image-ExifTool-12.40.tar.gz
cd Image-ExifTool-12.40/
perl Makefile.PL
make test
sudo make install
```

It also requires the R libraries `c("data.table",  "shiny", "zoo", "optparse", "EXIFr",  "chron", "DT", "tools", "shinyjs", "shinyFiles")`
