# extract-subtitles
Extract subtitles from a video file and save them as `.srt` file(s)

## Usage
Make sure the script is executable (`chmod +x extract_subtitles.sh`).

Let's assume you have a video file `some_video.mkv` which has the two subtitle streams `Dialogue` and `Signs & Songs` in English.

```shell
./extract_subtitles.sh some_video.mkv
```

This will create the files `some_video.Dialogue.eng.srt` and `some_video.Signs and Songs.eng.srt`

To extract subtitles for all `.mkv` files in the current folder you can use the following `find` command:

```shell
find . -name '*.mkv' -exec ./extract_subtitles.sh {} \;
```

**Note**: 
Ampersands (&) are replaced by the word "and" and non-alphanumeric characters except spaces and `(`, `)`, `[`, `]`,`.`,`-`,`_` are removed. Multiple consecutive whiespaces are replaced by a single space.
The script has to be executed with `bash`.