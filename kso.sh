#/bin/bash

export tile_row_start=$1
export tile_col_start=$2
export nrOfTiles=$3
export start=0
export tiles=$4
export combine;
export tiling;
while [ "$start" -lt "$nrOfTiles" ] 
do
  start=$(($start+1))
  echo $start
  #cols = uppifrån och ner.
  #rows = rad, vågrätt.
  
  for i in {1..$nrOfTiles}
  do
      curl 'http://kso.lantmateriet.se/karta/topowebb/v1/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=topowebb&STYLE=default&TILEMATRIXSET=3006&TILEMATRIX=12&TILEROW='$tile_row_start'&TILECOL='$tile_col_start'&FORMAT=image%2Fpng' -H 'Host: kso.lantmateriet.se' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0' -H 'Accept: image/png,image/*;q=0.8,*/*;q=0.5' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'Referer: http://kso2.lantmateriet.se/' -H 'Cookie: WebTrends=109.228.158.215.1412589810348609' -H 'Connection: keep-alive' > $tile_col_start'.png'
  done
  
  if [ $tiles -gt 0 ]; then
    tile_row_start=$(($tile_row_start+1))
    tile_col_start=$(($tile_col_start+1))

    tiling="-tile "$nrOfTiles"x"$nrOfTiles" "
  else
    tiling="-tile "$nrOfTiles"x"$nrOfTiles" "
    tile_col_start=$(($tile_col_start+1))
  fi
  
  curl 'http://kso.lantmateriet.se/karta/topowebb/v1/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=topowebb&STYLE=default&TILEMATRIXSET=3006&TILEMATRIX=12&TILEROW='$tile_row_start'&TILECOL='$tile_col_start'&FORMAT=image%2Fpng' -H 'Host: kso.lantmateriet.se' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:32.0) Gecko/20100101 Firefox/32.0' -H 'Accept: image/png,image/*;q=0.8,*/*;q=0.5' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'Referer: http://kso2.lantmateriet.se/' -H 'Cookie: WebTrends=109.228.158.215.1412589810348609' -H 'Connection: keep-alive' > $tile_col_start'.png'
  
  
  combine+=$tile_col_start".png "
done
combine+=$tiling;
echo $combine;
montage $combine -geometry +0+0 -background none file.png
