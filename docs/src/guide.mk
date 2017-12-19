---
title: Guide
---

:insert toc


## Command Line Interface

To initialize a new site, create a site directory, `cd` into it, and run the `init` command:

    $ ivy init

To build an existing site, run the `build` command from the site directory or any of its subdirectories:

    $ ivy build

Use the `ivy --help` flag to view the full command-line help text:

    Usage: ivy [FLAGS] [COMMAND]

      Ivy is a static website generator. It transforms a directory of text
      files into a self-contained website.

    Flags:
      --help              Print the application's help text and exit.
      --version           Print the application's version number and exit.

    Commands:
      build               Build the site.
      clear               Clear the output directory.
      init                Initialize a new site directory.
      serve               Run a web server on the site's output directory.
      tree                Print the site's node tree.
      watch               Monitor the site directory and rebuild on changes.

    Command Help:
      help <command>      Print the specified command's help text and exit.

Run `ivy help <command>` to view the help text for a specific command.



## Site Structure

Initializing a new site creates the following directory structure:

    site/
        config.py    # site configuration file
        ext/         # extensions directory for plugins
        inc/         # includes directory for menus, etc.
        lib/         # library directory for themes
        out/         # output directory for html files
        res/         # resources directory for static assets
        src/         # source directory for text files

The site configuration file can be deleted if the site does not require custom settings; unused directories can likewise be deleted. (Note however that Ivy requires the presence of either a `config.py` file or both `src` and `out` directories to identify a site's home directory.)

Static assets such as image files should be placed in the site's resources directory, `res`. The content of this directory is copied to the output directory when the site is built.



## Nodes

A node is a text file or directory stored in a site's `src` directory. Ivy parses the `src` directory into a tree of nodes which it then renders into a website, generating a single HTML page in the `out` directory for each node in the tree.

A node file can begin with a [YAML][] header specifying metadata for the node:

    ---
    title: My Important Document
    author: John Doe
    date: 1901-07-21
    ---

    Content begins here.

Node content can be written in [Markdown][] or [Monk][]. Files with a `.md` extension are rendered as Markdown, files with a `.mk` extension are rendered as Monk. (Ivy can be extended via plugins to support other formats and extensions.)

Note that the file

    src/foo/bar.md

and the directory

    src/foo/bar/

correspond to a single node in the parse tree. Node files provide content and metadata for a node; node directories store child nodes.

Files named `index` are special-cased and correspond to the same node as their parent directory.

[Markdown]: http://daringfireball.net/projects/markdown/
[Monk]: http://mulholland.xyz/docs/monk/
[YAML]: http://en.wikipedia.org/wiki/YAML



## Node Meta

Ivy has builtin support for node metadata in [YAML][] format; support for additional formats can be added via extensions. Note that a node file's metadata keys are converted to lowercase and spaces are replaced by underscores so the YAML attribute

    ---
    Date of Birth: 1901-02-28
    ---

would be accessible in template files as `node.date_of_birth`.

All nodes have the following default attributes:

|| `html` ||

    The node's text content rendered into html.


|| `text` ||

    The node's raw text content.


|| `url` ||

    The node's url.



## Links

Ivy generates page-relative urls and files with a `.html` extension by default, but you can customize this behaviour to suit your needs.

First, you can specify a root url in your site configuration file. Specify an explicit domain for absolute urls or a single forward slash `"/"` for site-relative urls.

::: python

    root = "http://example.com/"

Second, you can specify a file extension in your site configuration file. You can choose an arbitrary file extension or specify a single forward slash `"/"` to generate directory-style urls.

::: python

    extension = ".html"

To link to files within your site from nodes or templates use site-relative urls prefixed by `@root/`, e.g.

    @root/scripts/jquery.js

Ivy will automatically rewrite these urls in the appropriate format.

Use two trailing slashes when linking to pages generated by Ivy itself --- this tells Ivy to rewrite the ending to suit your extension settings.

    @root/posts/my-post//

Linking to the homepage is a special case --- a simple `@root/` will always suffice.



## Includes

The *includes* directory, `inc`, is intended for snippets of content that can be reused on multiple pages throughout the site, e.g. menus or footer links. Source files placed in this folder will be parsed as Markdown or Monk depending on their extension and the resulting HTML made available for inclusion in template files via the `inc.<name>` attribute.

For example, a menu can be constructed in Markdown using nested lists:

    * [Home](@root/)
    * [About](@root/about//)
    * [Pets](@root/pets//)
        * [Cats](@root/pets/cats//)
        * [Dogs](@root/pets/dogs//)

If this menu was contained in a file named `menu.md` then the rendered HTML would be available in templates via the `inc.menu` attribute. (Note that filenames are converted to lower case and spaces and hyphens are converted to underscores.)

Files with a `.html`/`.js`/`.css`/`.txt` extension will have their contents preserved as-is.



## Extension Options


### Markdown

Ivy uses the [Markdown][mddocs] package to render record files with a `.md` extension. You can add a dictionary of keyword arguments for the Markdown renderer to your site configuration file via a `markdown` attribute, e.g.

::: python

    markdown = { 'extensions': ['markdown.extensions.extra'] }

See the package's [documentation][mddocs] for details of its available options.

[mddocs]: https://pythonhosted.org/Markdown/



### Jinja

Ivy uses the [Jinja2][jinja] package to render template files with a `.jinja` extension. You can add a dictionary of keyword arguments for the Jinja environment to your site configuration file via a `jinja` attribute.

[jinja]: http://jinja.pocoo.org



### Shortcodes

Ivy uses the [Shortcodes][shortcodes] package to process shortcodes in record files. You can add a dictionary of keyword arguments for the shortcode parser to your site configuration file via a `shortcodes` attribute.

[shortcodes]: https://github.com/dmulholland/shortcodes



### Automenu

The bundled Automenu extension automatically generates a menu containing links to every node in the site. The menu can be accessed in templates via an `automenu` attribute. This menu can be customized in two ways:

* If a node has a `menu_title` attribute, its value will be used in the menu in place of the node's title.

* By default entries are ordered alphabetically by filename. Entry order can be customized by giving nodes an integer `menu_order` attribute with lower numbers coming first. The default order value is 0. (Note that the homepage is an exception and will always be the first entry in the menu.)



## Dependencies

Installing Ivy via `pip` automatically installs the following required dependencies:

* [Janus](https://pypi.python.org/pypi/libjanus)

Installing via `pip` also automatically installs the following optional dependencies:

* [Ibis](https://pypi.python.org/pypi/ibis)
* [Jinja](https://pypi.python.org/pypi/Jinja2)
* [Markdown](https://pypi.python.org/pypi/Markdown)
* [Pygments](https://pypi.python.org/pypi/Pygments)
* [PyYAML](https://pypi.python.org/pypi/PyYAML)
* [Shortcodes](https://pypi.python.org/pypi/shortcodes)
* [Monk](https://pypi.python.org/pypi/libmonk)

Ivy will run without any of these optional dependencies installed but the associated functionality will not be available.
