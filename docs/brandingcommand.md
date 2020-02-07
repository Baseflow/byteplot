# Branding command

With the branding command developers are able to add whitelabel functionality to their app. When a developer adds a brand to the branding config with the add command a config will be created if there isn't one yet. In this config the different brands are defined along with a set of parameters to configure the branding process. The most important ones are the path to the assets of the different brands and the path to the destination where to files need to be copied to.

When the apply command is used the content of the specified brand folder will be copied to the destination specified in the config. Besides that things like the bundle_identifier will changed in the project settings according to what is specified in the config.

Brands are specified with an alias.

## Add sub-command

To add a brand to your brandig config.

`byteplot branding add <brand-alias> [options]`

### Options

`-n / --name` to specify the name of the app (required).

`-b / --bundle_identifier` to specify the bundle identifier (on iOS) or application identifier (on Android) (required).

`-d / --development_team` the display the Apple development team identifier (not required).

## Apply sub-command

To apply a brand to your Flutter project.

`byteplot branding apply <brand-alias>`