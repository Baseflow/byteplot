# BytePlot CLI

A Dart command-line tool for Flutter to make your life easier.

## Features

- Create a brand new Flutter project.
- Apply a template to your Flutter project.
- Generate code snippets.
- Add support for internationalization (i10n).
- Manage whitelabel brands in your app.

## Installation

First install the Dart SDK:

`https://dart.dev/get-dart`

Then, install Flutter:

`https://flutter.dev/docs/get-started/install`

To run executables from the command-line add the .pub-cache to your path:

`export PATH="$PATH":"$HOME/.pub-cache/bin"`

### Local installation

Clone the repository:

`git clone https://github.com/baseflow/byteplot.git`

To make the tool available from the command-line:

`pub global activate --source path ~/path/to/local/byteplot/package`

### Pub installation

`pub global activate byteplot`

## Available commands

**help** | Display help information.

**create** | Create a brand new Flutter project.

**template** | Apply a template to your Flutter project.

**generate** | Generate a code snippet.

**intl** | Add support for internationalization (i10n).

**branding** | Manage whitelabel brands in your app.

## Usage

### Help

Run `byteplot help` to see global options.

Run`byteplot help <command>` for more information about a command.

Run`byteplot help <command> <subcommand>` for more information about a sub-command.

### Create command

Create a brand new Flutter project:

`byteplot create`

Run `byteplot create` for more information.

### Template command

#### Apply

To apply a template to your Flutter project.

`byteplot template apply <template-name> [options]`

##### Available templates

- **blank** | A clean Flutter project, without the counter.
- **bloc**  | A starter project with BLoC setup.

##### Options

`-i / --internationalization` to include support for localization.

#### List

To list the available templates.

`byteplot template list`

### Generate command

#### Bloc

Generate a bloc.

`byteplot generate bloc [options]`

##### Options

`-p / --path` to generate at a specified path (defaults to current directory).

### Internationalization command

#### Add

To add internationalization functionality to your Flutter project.

`byteplot intl add`

### Branding command

With the branding command developers are able to add whitelabel functionality to their app. When a developer adds a brand to the branding config with the add command a config will be created if there isn't one yet. In this config the different brands are defined along with a set of parameters to configure the branding process. The most important ones are the path to the assets of the different brands and the path to the destination where to files need to be copied to.

When the apply command is used the content of the specified brand folder will be copied to the destination specified in the config. Besides that things like the bundle_identifier will changed in the project settings according to what is specified in the config.

Brands are specified with an alias.

#### Add

To add a brand to your brandig config.

`byteplot branding add <brand-alias> [options]`

##### Options

`-n / --name` to specify the name of the app (required).

`-b / --bundle_identifier` to specify the bundle identifier (on iOS) or application identifier (on Android) (required).

`-d / --development_team` the display the Apple development team identifier (not required).

#### Apply

To apply a brand to your Flutter project.

`byteplot branding apply <brand-alias>`

### Upgrade

To upgrade to the latest version of the BytePlot CLI.

`byteplot upgrade`