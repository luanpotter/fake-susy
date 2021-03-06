#!/bin/bash

# usage
# ./fake_susy_16.sh lab16.c mc102xy/16

gcc -std=c99 -pedantic -Wall -o a.out.b $1 -lm
s=1

while true; do

  if (( $s < 10 )); then
    i="0$s"
  else
    i="$s"
  fi

  echo "Running for test $i"
  curl -sk "http://susy-proxy.appspot.com/$2/dados/arq$i.in" -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8,es;q=0.6,pt;q=0.4' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2783.2 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Cookie: _ga=GA1.2.143375560.1435853392; session_id=34555ca2c0777cac6ff9d48c23424dbb5f091e46' -H 'Connection: keep-alive' --compressed -o t.in.b
  curl -sk "http://susy-proxy.appspot.com/$2/dados/arq$i.in.ppm" -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8,es;q=0.6,pt;q=0.4' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2783.2 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Cookie: _ga=GA1.2.143375560.1435853392; session_id=34555ca2c0777cac6ff9d48c23424dbb5f091e46' -H 'Connection: keep-alive' --compressed -o t.in.ppm.b

  mimeType=`file --mime-type t.in.b`
  if [[ $mimeType == "t.in.b: text/html" ]]; then
    echo "Finished"
    exit
  fi

  ./a.out.b "t.in.ppm.b" "r.out.ppm.b" < t.in.b

  curl -sk "http://susy-proxy.appspot.com/$2/dados/arq$i.out.ppm" -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8,es;q=0.6,pt;q=0.4' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2783.2 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Cookie: _ga=GA1.2.143375560.1435853392; session_id=34555ca2c0777cac6ff9d48c23424dbb5f091e46' -H 'Connection: keep-alive' --compressed -o t.out.ppm.b

  if cmp -s t.out.ppm.b r.out.ppm.b ; then
    echo "Test $i success"
  else
    echo "Test $i failed: "
    echo "-------------------"
    diff t.out.ppm.b r.out.ppm.b
    echo "-------------------"
  fi

  printf "\n"
  let "s++"
done

rm a.out.b t.in.b r.out.b t.out.b
