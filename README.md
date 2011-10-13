Mouch
=====

With Mouch and CouchDB you can build powerful web applications
without the need of other software components.

Mouch is for people who love purism. For people who keep complete control over
their bytes. For people who love things speeding fast.

Mouch consist of only three files, with together 125 lines of code.
Your interface is GNU Make.
The makefile controls which parts of your application needs to be updated
and triggers the commands `build` and `push`.

You choose the framework you like - use jQuery, Backbone, Mustache - or not.


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
* read files (`read`) and render `.erb` templates
* map directory structure to objects (`map`)


### h

escape strings


### base64

encode strings base64. Used to insert attachments like images & css.


### read patterns

you can `read` one file:

    <%=h read 'README.md' %>

or `read` all files matching patterns concats them:

    <%=h read '*.js' %>

To have more control over the position you can supply arrays:

    <%=h read ['lib/*.js', 'app/*.js'] %>

Templates are getting build:

    <%=h read 'app.json.erb' %>


### map

maps a directory structure into a JSON object.
Strips extnames from filenames for the key.



Example
-------

A nice way to have each document seperated, as shown in this a little more complex example:

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
          "data": <%=h base64 read 'favicon.ico' %>
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
    │   ├── favicon.ico
    │   ├── filters
    │   │   └── docs.js
    │   ├── index.html.erb
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



Installation
------------

Mouch lives inside your project. You can install it as a git submodule or copy the three plain files around.

Mouch has a few prerequisites:

* make
* ruby
* ruby-json
* curl

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

    jo@TF:~$ cd mouch
    jo@TF:~/mouch$ mkdir projects/hello-world -p
    jo@TF:~/mouch$ make setup DIR=projects/hello-world
    cp build projects/hello-world
    cp push projects/hello-world
    cp makefile projects/hello-world
    cp README.md projects/hello-world
    cp app.json.erb projects/hello-world


Build Process
-------------

The project `app.json` file is build with

    jo@TF:~/mouch/projects/hello-world$ make


Create a database

    jo@TF:~/mouch/projects/hello-world$ make create URL=http://localhost:5984/hello-world


Push the application to the server

    jo@TF:~/mouch/projects/hello-world$ make install URL=http://localhost:5984/hello-world


To build from scatch, one can do

    jo@TF:~/mouch/projects/hello-world$ make all URL=http://localhost:5984/hello-world


You
---

I would love to hear your opinions. Please discuss here: https://github.com/jo/mouch/issues.



(c) Johannes J. Schmidt, 2011
