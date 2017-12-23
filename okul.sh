#!/bin/bash

dosya_essiz_mi() {
  if [[ $(cut -f 1 -d , $1 | uniq -d) == "" ]]; then
    return 0
  fi
  return 1
}

arguman_kontrol() {
  if [ $# -eq 0 ]; then
    ogrencileri_listele
  elif [ $# -eq 1 ]; then
    if [[ $1 -gt 0 ]] && [[ $1 -lt 5 ]]; then
      devre_numarasina_gore_listele $@
    elif [[ $1 =~ ^[kKeE]$ ]]; then
      cinsiyete_gore_listele $@
    else
      >&2 echo "Hata: tanınmayan argüman $1"
      return 1
    fi
  else
    >&2 echo "Hata: sadece bir argüman girebilirsiniz"
    return 1
  fi
  return 0
}

cinsiyete_gore_listele() {
  while IFS="," read isim soyisim cinsiyet devre
  do
    if [[ $1 =~ ^[kK]$ ]]; then
      if [ $cinsiyet == "K" ]; then
        echo $isim $soyisim $devre
      fi
    else
      if [ $cinsiyet == "E" ]; then
        echo $isim $soyisim $devre
      fi
    fi
  done < okul.csv
  return 0
}

devre_numarasina_gore_listele() {
  while IFS="," read isim soyisim cinsiyet devre
  do
    if [ $1 -eq $devre ]; then
      echo $isim $soyisim $cinsiyet
    fi
  done < okul.csv
  return 0
}

ogrencileri_listele() {
  while IFS="," read isim soyisim cinsiyet devre
  do
    echo $devre $isim $soyisim $cinsiyet
  done < okul.csv | sort
  return 0
}

main() {
  if [ ! -f okul.csv ]; then
    exit 1
  fi
  dosya_essiz_mi okul.csv
  if [ $? -eq 0 ]; then
    arguman_kontrol $@
  else
    >&2 echo "dosya tekrarli..."
    exit 1
  fi
}

main $@
