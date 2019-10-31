#!/bin/bash -
git clone https://gist.github.com/f2da4709b636dce11de911975db6c818.git
rm ./test/ProjectSubmission.test.js
mv ./f2da4709b636dce11de911975db6c818/certification-SupplyChain.test.js ./test/ProjectSubmission.test.js
ganache-cli &

