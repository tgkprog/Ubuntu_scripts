sudo apt-get install gcc g++ make
#change 12 to current LTS/version needed

curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh


sudo bash ./nodesource_setup.sh 


sudo apt install -y nodejs


sudo apt install build-essential

npm -v




curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -



echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list deb https://dl.yarnpkg.com/debian/ stable main

sudo apt-get update && sudo apt-get install yarn

