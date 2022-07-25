# watch-ocrmypdf

This image allows you to monitor subfolders of a folder (/consume)
for new files and to run scripts on them. It's been inspired by Manuel Kuhlmanns [docker-watch-ocrmypdf](https://github.com/mkuhlmann/docker-watch-ocrmypdf) and macOS' [Hazel](https://www.noodlesoft.com). The image contains a working installation of ocrmypdf making it a great platform for dealing with pdf files. 

## Installation

Run timkaufmann/watch-ocrmypdf and mount the directory that should be watched to /consume (or customize with $WOCR_CONSUME_PATH). Mount a directory containing your bash scripts to /scripts. Those scripts will
be called by /watch.sh whenever it detects a change in a subfolder of /consume. Files in /consume itself will not be processed. 

## Processing files

/watch.sh will do some housekeeping before it calls your scripts. For one, it will make sure the new file has been saved completely.

It will also pass the following file information to your scripts (in this very order):
- absolute path to the new file
- filename including extension
- file extension
- parent folder name
- inotify action name

## Example

Let's ocr pdfs from a scanner and upload them to a nextcloud folder. 

1. Create a subfolder named "Scanner" in the folder mounted to /consume.
2. Make sure your scanner drops new scans to that folder.
2. Set $WOCR_SCRIPT_Scanner to /scripts/scanner-script.sh
3. Customize the scanner-script.sh provided in this repository according to your needs.

See `docker-compose.yml` for an example that provides for the neccessary nextcloud configuration. For security purposes that data is being stored in a .env file which is not part of this repository. 

## Todo

- [Optimize](https://stackoverflow.com/questions/16938153/how-to-printf-in-bash-with-multiple-arguments) the usage of printf in my own scripts.
- Add [msmpt](https://marlam.de/msmtp/) for sending mail notifications. 

## Contributing

Any pull requests are welcome.

## My own notes

### Building

```shell
docker build -t timkaufmann/watch-ocrmypdf:latest --no-cache --push ./
````

## License

The MIT License (MIT)

Copyright (c) 2022 Tim Kaufmann

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
