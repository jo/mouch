Mouch
=====

With Mouch and CouchDB you can build powerful web applications
without the need of other software components.

Mouch is for people who love purism. For people who keep complete control over
their bytes.
For people who love things speeding fast, keeping dependencies as minimal as possible.

Mouch consist of only three files, with together 131 lines of code.
Your interface is GNU Make.
The makefile controls which parts of your application needs to be updated
and triggers the commands `build` and `push`.

You choose the framework you like - use jQuery, Backbone, Mustache - or not.
Install them as Git submodules and include the files you need.


Build Process
-------------

With `build` you compile your project files into one JSON file, called `app.json`.
This JSON document can be deployed to a server via the `push` command.

Every Mouch project has a `app.json.erb` file. This file bundles all documents.

The simplest `app.json.erb` I could imagine is:

    {
      "docs": [
        {
          "_id": "readme",
          "text": <%=h read 'README.md' %>
        }
      ]
    }

As you see this is simply CouchDBs bulk\_doc api.

The `build` script provides routines for

* escape text (`h`)
* base64 encode content (`base64`)
* convert images (`convert`)
* read files (`read`) and render `.erb` templates
* map directory structure to objects (`map`)


### h `content`

escape `content` string.

#### Example

    h '<script>var title = "This is Mouch";</script>'

will produce

    "<script>var title = \"This is Mouch\";<\/script>"


### base64 `content`

encode `content` strings base64. Used to insert attachments like images & css.

### Example

    base64 'My name is Mouch!'

results in

    TXkgbmFtZSBpcyBNb3VjaCE=


### convert `patterns`, [`format`, `options`]

`convert` images using ImageMagicks `convert` program.
The default is to convert the image to png. Specify `format` to any format sting ImageMagick understands.
You may want to specify other `options`, which are passed to ImageMagick.

#### Example:

    convert 'icon.svg', 'ico', '-resize 16x16 -transparent white'

will generate a .ico file and scale it to 16x16 px.

Visit the ImageMagick documentation: http://www.imagemagick.org/script/index.php


### read `patterns`

Read files from filesystem. `patterns` are passed to Ruby `Dir.glob`.

#### Examples

`read` one file:

    read 'README.md'

or `read` all files matching patterns concats them:

    read '*.js'

To have more control over the order you can supply arrays:

    read ['lib/*.js', 'app/*.js']

Templates are getting build:

    read 'app.json.erb'


Read the Ruby `Dir.glob` documentation: http://www.ruby-doc.org/core-1.9.3/Dir.html#method-c-glob


### map `dirname`

Maps the directory `dirname` into into a JSON object.
Strips extnames from filenames for the key.

#### Example

    map 'views'

will transform the the directory

    views
    └── docs
        ├── map.js
        └── reduce.js

into the JSON object

    {
      "docs": {
        "map": "content of map.js"
        "reduce": "content of reduce.js"
      }
    }


Installation
------------

Mouch lives inside your project. You can install it as a git submodule or copy the three plain files around.

Mouch has a few prerequisites:

* make
* ruby
* ruby-json
* curl
* imagemagick (only needed if you use the convert command)

Mouch build and push scripts are plain Ruby. No rubygems. (They are so slow)
I would love to see the ruby json requirement going away. Any help appreciated.


### Getting a Couch

You can install CouchDB via your package manager or manually.
The easyiest way is to setup a free account on
https://cloudant.com/ or http://www.iriscouch.com/

You can use urls with authentication information like
  
    https://username:password@username.cloudant.com/dbname


### Getting Mouch

    jo@TF:~$ git clone git://github.com/jo/mouch.git


### Setup a Project

Simply copy the files into you project:

    jo@TF:~$ cp -r mouch hello-world

Now start with editing `app.json.erb`.


Build Process
-------------

The project `app.json` file is build with

    jo@TF:~/hello-world$ make


Create a database

    jo@TF:~/hello-world$ make create URL=http://localhost:5984/hello-world


Build the application and push to the server

    jo@TF:~/hello-world$ make URL=http://localhost:5984/hello-world


Example
-------

A nice way to have each document seperated, as shown in this example:


### `app.json.erb`

    {
      "docs": [
        <%= read 'hello-world/app.json.erb' %>
      ]
    }


### `hello-world/app.json.erb`

    {
      "_id": "_design/hello-world",
    
      "filters": <%= map 'filters' %>,
      "lists": <%= map 'lists' %>,
      "rewrites": <%= read 'rewrites.json' %>,
      "shows": <%= map 'shows' %>,
      "updates": <%= map 'updates' %>,
      "views": <%= map 'views' %>,
    
      "_attachments": {
        "favicon.ico": {
          "content_type": "image/x-icon; charset=utf-8",
          "data": <%=h base64 convert 'icon.svg', 'ico', '-resize 16x16 -transparent white' %>
        },
        "app.js": {
          "content_type": "application/javascript; charset=utf-8",
          "data": <%=h base64 read 'app/app.js.erb' %>
        },
        "app.css": {
          "content_type": "text/css; charset=utf-8",
          "data": <%=h base64 read ['../lib/style/*.css', 'style/*.css'] %>
        },
        "index.html": {
          "content_type": "text/html; charset=utf-8",
          "data": <%=h base64 read 'index.html.erb' %>
        }
      }
    }


### Example Directory Structure

You can have whatever directory layout you want.
One of my projects has a directory structure like this:

    .
    ├── app.json.erb
    ├── build
    ├── lib
    │   └── style
    │       └── app.css
    ├── makefile
    ├── hello-world
    │   ├── app.json.erb
    │   ├── filters
    │   │   └── docs.js
    │   ├── index.html.erb
    │   ├── icon.svg
    │   ├── lists
    │   │   └── table.js
    │   ├── rewrites.json
    │   ├── shows
    │   │   └── doc.js
    │   ├── style
    │   │   └── app.css
    │   ├── updates
    │   │   └── doc.js
    │   └── views
    │       └── docs
    │           ├── map.js
    │           └── reduce.js
    ├── push
    └── README.md




You
---

I would love to hear your opinions. Please discuss here: https://github.com/jo/mouch/issues.


License
-------

MIT: http://tf.mit-license.org




(c) Johannes J. Schmidt, 2011
