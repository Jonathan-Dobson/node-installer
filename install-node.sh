#!/bin/bash

NODE=$(wget -O - -o /dev/null https://nodejs.org/dist/latest/  | sed -n '/node-v.*-linux-x64.tar.gz/p' | cut -d '"' -f2 | cut -f 1,2,3 -d '.')

mkdir /usr/local/lib/nodejs

wget -O /tmp/$NODE.tar.gz https://nodejs.org/dist/latest/$NODE.tar.gz && tar xfvz /tmp/$NODE.tar.gz -C /usr/local/lib/nodejs/


cd $(echo /usr/local/lib/nodejs/$NODE | cut -f 1,2,3 -d '.')

rm /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx

ln -s /usr/local/lib/nodejs/node-v15.4.0-linux-x64/bin/node /usr/local/bin/node
ln -s /usr/local/lib/nodejs/node-v15.4.0-linux-x64/bin/npx /usr/local/bin/npx
ln -s /usr/local/lib/nodejs/node-v15.4.0-linux-x64/bin/npm /usr/local/bin/npm

node -v
npm -v
npx -v
