# TopMap

Lightweight mapper for OGC WMS servers

This project is generated with [yo angular generator](https://github.com/yeoman/generator-angular)
version 0.12.1.

## Build & development

From a fresh machine, I would recomend setting up using NodeJS using [NVM](https://github.com/creationix/nvm) after which you will need to install grunt and bower to build (`npm install gulp-cli -g` / `npm install bower -g`)

You will need to run `npm install` and `bower install` to install dependencies

You will also need to have a working ruby / compass install on the machine to compile the SASS files during the build to do this install ruby (I would recommend using [RVM](https://rvm.io/) to control ruby installs and then you just need to install the compass gem;

NOTE: On windows you probably want to use a windows installer i.e. [rubyinstaller](http://rubyinstaller.org/)

`gem install compass` 

After everything is set up run `gulp clean dist` for building and `grunt serve` for preview.

