# Sculptor

Tool to create style guides and prototype web apps.

## Installation

node is required to run Bower.

```
$ gem install sculptor
$ npm install -g bower
```

## Usage

Sculptor extends Middleman so all Middleman commands can also be used.

### Initiate new project

Fetches and installs dependencies and creates project skeleton.

```
sculptor init project-name
```

Aliases: `i`, `new`, `n`.

This command will create scaffold for new project and install client dependencies via Bower.
Make sure Bower is installed globally (`npm install -g bower`).

### Create new model

In project root directory run:

```
sculptor create model-name
```

Alias `c`.

Models are sub-project which are contained in directories.
Several similar modules can be created in one directory:

```
sculptor c model-name/variant
```

If no variant is specified the initial variant is created with the same name as directory

An index file is generated for ech directory.

When createing a new model its path is shown and the following questions asked:

- **Title:** (optional)- title for the model created
- **Description:** (optional) - model description
- **Stylesheet:** (optional) - stylesheet file name, created in the model directory and automatically included in the model
- **Use iframe?** (`y`/`n` default `n`) - whether to encapsulate the model in iframe or render directly on page (to prevent style leaking)
- **Include data?** (`y`/`n` default `n`) - whether to include YAML file for model mock data

### Running test server

Runs development server with LiveReload.

```
sculptor server
```

Running `sculptor` without any parameters is aliased to `sculptor server`.

### Building the gallery

Generates static version of project in `build` directory.

```
sculptor build
```

The build can be distributed/viewed in standalone mode.

On OSX running `build/launch.command` afterwards will run Python's SimpleHTTPServer on port 8000 and open browser with project.


## Sculptor template helpers

Sculptor is using Slim templates internally but should work with other templates supported by Middleman in projects.

### Model helpers

* `model`
  - `title`
  - `description`
  - `pretty` {boolean}
    whether to try to reformat the HTML (e.g. if remote HTML is minified)
  - `css` - CSS selector to extract from the remote page. If specific element is required it can be selected by providing `#<0-based index>` at the end of selector separated by space. e.g. `img #0` will select the first image.
  - `data` - local data that can be injected in a local component (partial with `.component.slim` extension)
  - `source_type` {string} default `html`
    type of source code used for code highlighting
* `model_iframe`
* `model_source`

### Resource helpers
* `include_stylesheets`
* `include_stylesheet`
* `include_javascripts`
* `relative_dir`
* `resource_file`
* `resource_dir`
* `resources_for`
* `append_class`

### Data helpers
* `load_data`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
