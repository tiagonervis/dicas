# Converter arquivos de som e video

## Arquivos de som

* Todos os arquivos mp3 para wav

```
$ for i in *.mp3; do mplayer -vo null -vc dummy -af resample=44100 -ao pcm:waveheader:file="${i%.mp3}.wav" "$i" ; done
```

*Todos os arquivos wma para wav

```
$ for i in *.wma; do mplayer -vo null -vc dummy -af resample=44100 -ao pcm:waveheader:file="${i%.wma}.wav" "$i" ; done
```

* Todos os arquivos wav para mp3

```
$for i in *.wav; do lame -b 128 "$i" "${i%.wav}.mp3" ; done
```

## Arquivos de video

* Arquivo rmvb para mpeg

```
mencoder video.rmvb -ovc lavc -oac mp3lame -lavcopts vcodec=mpeg2video:vbitrate=3000 -of mpeg -lameopts cbr:br=384 -o video.mpg -ofps 25
```

* Arquivo rmvb com legenda separada para arquivo mpeg

```
mencoder video.rmvb -sub legenda.srt -subpos 95 -subfont-text-scale 3 -subcp enca:gr:iso-8859-1 -ovc lavc -oac mp3lame -lavcopts vcodec=mpeg2video:vbitrate=1900 -of mpeg -lameopts cbr:br=192 -o video.mpg -ofps 25 
```

* Todos os arquivos wmv para mpeg

```
for i in *.wmv; do mencoder "$i" -ovc lavc -oac mp3lame -lavcopts vcodec=mpeg2video:vbitrate=1900 -of mpeg -lameopts cbr:br=192 -o "${i%.wmv}.mpg" -ofps 25 ; done
```

* Todos os arquivos rmvb para mpeg

```
for i in *.rmvb; do mencoder "$i" -ovc lavc -oac mp3lame -lavcopts vcodec=mpeg2video:vbitrate=1900 -of mpeg -lameopts cbr:br=192 -o "${i%.rmvb}.mpg" -ofps 25 ; done
```

* Arquivo 3pg para avi

```
ffmpeg -i video.3gp -b 1024k -f avi -an video.avi
```

* Arquivo avi para mpeg

```
ffmpeg -i video.avi -b 1024k -f mpeg -acodec libmp3lame -ab 128k video.mpg
```