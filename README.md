# TopMap

Lightweight mapper for OGC WMS servers

This project is generated with [yo angular generator](https://github.com/yeoman/generator-angular)
version 0.12.1.

## Build & development

From a fresh machine, I would recomend setting up using NodeJS using [NVM](https://github.com/creationix/nvm) after which you will need to install grunt and bower to build (`npm install grunt-cli -g` / `npm install bower -g`)

You will need to run `npm install` and `bower install` to install dependencies

Run `grunt clean build` for building and `grunt serve` for preview.

### Additional Dependencies

This project uses SASS and you may need to install compass to compile the CSS files during the build process, you will need ruby installed on your system and then you just need to install the compass gem;

`gem install compass`

## Testing

Running `grunt test` will run the unit tests with karma.
