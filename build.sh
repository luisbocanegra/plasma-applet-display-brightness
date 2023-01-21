#!/bin/bash
# Version 1

for name in kreadconfig kreadconfig5
do
  if which $name
  then
    kreadconfigBin=$name
    break
  fi
done

plasmoidName=$(basename "$PWD")
plasmoidVersion=$($kreadconfigBin --file="$PWD/package/metadata.desktop" --group="Desktop Entry" --key="X-KDE-PluginInfo-Version")
rm ${plasmoidName}-v*.plasmoid
cd package
filename=${plasmoidName}-v${plasmoidVersion}.plasmoid
zip -r $filename *
mv $filename ../$filename
cd ..
echo "md5: $(md5sum $filename | awk '{ print $1 }')"
echo "sha256: $(sha256sum $filename | awk '{ print $1 }')"
